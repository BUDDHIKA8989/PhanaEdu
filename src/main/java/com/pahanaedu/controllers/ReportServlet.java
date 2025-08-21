// File: src/main/java/com/pahanaedu/controllers/ReportServlet.java
package com.pahanaedu.controllers;

import com.pahanaedu.dao.BillDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.models.Bill;
import com.pahanaedu.models.Customer;
import com.pahanaedu.models.Item;
import com.pahanaedu.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private BillDAO billDAO;
    private CustomerDAO customerDAO;
    private ItemDAO itemDAO;

    @Override
    public void init() throws ServletException {
        billDAO = new BillDAO();
        customerDAO = new CustomerDAO();
        itemDAO = new ItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Check user role - only Admin and Manager can access reports
        if (!"Admin".equals(user.getRole()) && !"Manager".equals(user.getRole())) {
            request.setAttribute("errorMessage", "Access denied. Only Admin and Manager can view reports.");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        }

        String reportType = request.getParameter("type");

        if ("daily-sales".equals(reportType)) {
            generateDailySalesReport(request, response);
        } else if ("customer-summary".equals(reportType)) {
            generateCustomerSummaryReport(request, response);
        } else if ("inventory".equals(reportType)) {
            generateInventoryReport(request, response);
        } else if ("low-stock".equals(reportType)) {
            generateLowStockReport(request, response);
        } else if ("download".equals(reportType)) {
            downloadReport(request, response);
        } else {
            // Default - Show reports dashboard
            showReportsDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("custom-date-range".equals(action)) {
            generateCustomDateRangeReport(request, response);
        } else {
            response.sendRedirect("reports");
        }
    }

    // Show reports dashboard
    private void showReportsDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get summary statistics
        Map<String, Object> stats = new HashMap<>();

        // Today's statistics
        int todayBills = billDAO.getTodayBillsCount();
        double todaySales = billDAO.getTodayTotalSales();

        // Customer statistics
        List<Customer> allCustomers = customerDAO.getAllCustomers();
        int totalCustomers = allCustomers.size();

        // Item statistics
        List<Item> allItems = itemDAO.getAllItems();
        int totalItems = allItems.size();
        int lowStockItems = 0;
        double totalInventoryValue = 0;

        for (Item item : allItems) {
            if (item.isLowStock()) {
                lowStockItems++;
            }
            totalInventoryValue += item.getTotalValue();
        }

        // Recent bills for quick overview
        List<Bill> recentBills = billDAO.getAllBills();
        if (recentBills.size() > 5) {
            recentBills = recentBills.subList(0, 5);
        }

        stats.put("todayBills", todayBills);
        stats.put("todaySales", todaySales);
        stats.put("totalCustomers", totalCustomers);
        stats.put("totalItems", totalItems);
        stats.put("lowStockItems", lowStockItems);
        stats.put("totalInventoryValue", totalInventoryValue);

        request.setAttribute("stats", stats);
        request.setAttribute("recentBills", recentBills);
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }

    // Generate daily sales report
    private void generateDailySalesReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Bill> allBills = billDAO.getAllBills();
        Map<String, SalesData> dailySales = new HashMap<>();

        for (Bill bill : allBills) {
            String date = bill.getBillDate();
            if (date != null) {
                dailySales.computeIfAbsent(date, k -> new SalesData()).addBill(bill);
            }
        }

        request.setAttribute("dailySales", dailySales);
        request.setAttribute("reportType", "daily-sales");
        request.setAttribute("reportTitle", "Daily Sales Report");
        request.getRequestDispatcher("report-view.jsp").forward(request, response);
    }

    // Generate customer summary report
    private void generateCustomerSummaryReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Customer> customers = customerDAO.getAllCustomers();
        List<CustomerSummary> customerSummaries = new ArrayList<>();

        for (Customer customer : customers) {
            List<Bill> customerBills = billDAO.getBillsByCustomer(customer.getCustomerId());

            double totalSpent = 0;
            int totalBills = customerBills.size();
            String lastPurchaseDate = "Never";

            for (Bill bill : customerBills) {
                totalSpent += bill.getFinalAmount();
                if ("Never".equals(lastPurchaseDate) ||
                        (bill.getBillDate() != null && bill.getBillDate().compareTo(lastPurchaseDate) > 0)) {
                    lastPurchaseDate = bill.getBillDate();
                }
            }

            CustomerSummary summary = new CustomerSummary();
            summary.setCustomer(customer);
            summary.setTotalBills(totalBills);
            summary.setTotalSpent(totalSpent);
            summary.setLastPurchaseDate(lastPurchaseDate);

            customerSummaries.add(summary);
        }

        request.setAttribute("customerSummaries", customerSummaries);
        request.setAttribute("reportType", "customer-summary");
        request.setAttribute("reportTitle", "Customer Summary Report");
        request.getRequestDispatcher("report-view.jsp").forward(request, response);
    }

    // Generate inventory report
    private void generateInventoryReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Item> items = itemDAO.getAllItems();

        request.setAttribute("items", items);
        request.setAttribute("reportType", "inventory");
        request.setAttribute("reportTitle", "Inventory Report");
        request.getRequestDispatcher("report-view.jsp").forward(request, response);
    }

    // Generate low stock report
    private void generateLowStockReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Item> allItems = itemDAO.getAllItems();
        List<Item> lowStockItems = new ArrayList<>();

        for (Item item : allItems) {
            if (item.isLowStock() || item.isOutOfStock()) {
                lowStockItems.add(item);
            }
        }

        request.setAttribute("lowStockItems", lowStockItems);
        request.setAttribute("reportType", "low-stock");
        request.setAttribute("reportTitle", "Low Stock Alert Report");
        request.getRequestDispatcher("report-view.jsp").forward(request, response);
    }

    // Custom date range report
    private void generateCustomDateRangeReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (startDate == null || endDate == null) {
            request.setAttribute("errorMessage", "Please select both start and end dates");
            showReportsDashboard(request, response);
            return;
        }

        List<Bill> allBills = billDAO.getAllBills();
        List<Bill> filteredBills = new ArrayList<>();

        for (Bill bill : allBills) {
            String billDate = bill.getBillDate();
            if (billDate != null && billDate.compareTo(startDate) >= 0 && billDate.compareTo(endDate) <= 0) {
                filteredBills.add(bill);
            }
        }

        // Calculate summary
        double totalSales = 0;
        int totalBills = filteredBills.size();

        for (Bill bill : filteredBills) {
            totalSales += bill.getFinalAmount();
        }

        request.setAttribute("filteredBills", filteredBills);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalBills", totalBills);
        request.setAttribute("reportType", "date-range");
        request.setAttribute("reportTitle", "Sales Report (" + startDate + " to " + endDate + ")");
        request.getRequestDispatcher("report-view.jsp").forward(request, response);
    }

    // Download report as TXT
    private void downloadReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reportType = request.getParameter("reportType");

        response.setContentType("text/plain");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + reportType + "_report.txt\"");

        StringBuilder txt = new StringBuilder();
        txt.append("=====================================\n");
        txt.append("    PAHANA EDU BOOKSHOP\n");
        txt.append("    MANAGEMENT REPORT\n");
        txt.append("=====================================\n\n");

        if ("daily-sales".equals(reportType)) {
            generateDailySalesTxt(txt);
        } else if ("inventory".equals(reportType)) {
            generateInventoryTxt(txt);
        } else if ("low-stock".equals(reportType)) {
            generateLowStockTxt(txt);
        }

        txt.append("\nGenerated: ").append(LocalDate.now()).append("\n");
        txt.append("=====================================\n");

        response.getWriter().write(txt.toString());
    }

    // Helper methods for TXT generation
    private void generateDailySalesTxt(StringBuilder txt) {
        txt.append("DAILY SALES REPORT\n");
        txt.append("-------------------------------------\n");

        List<Bill> bills = billDAO.getAllBills();
        Map<String, Double> dailyTotals = new HashMap<>();

        for (Bill bill : bills) {
            String date = bill.getBillDate();
            dailyTotals.put(date, dailyTotals.getOrDefault(date, 0.0) + bill.getFinalAmount());
        }

        for (Map.Entry<String, Double> entry : dailyTotals.entrySet()) {
            txt.append(entry.getKey()).append(": Rs.").append(String.format("%.2f", entry.getValue())).append("\n");
        }
    }

    private void generateInventoryTxt(StringBuilder txt) {
        txt.append("INVENTORY REPORT\n");
        txt.append("-------------------------------------\n");

        List<Item> items = itemDAO.getAllItems();
        for (Item item : items) {
            txt.append(item.getItemName()).append("\n");
            txt.append("  Stock: ").append(item.getStockQuantity());
            txt.append(" | Price: Rs.").append(String.format("%.2f", item.getPrice()));
            txt.append(" | Value: Rs.").append(String.format("%.2f", item.getTotalValue())).append("\n\n");
        }
    }

    private void generateLowStockTxt(StringBuilder txt) {
        txt.append("LOW STOCK ALERT REPORT\n");
        txt.append("-------------------------------------\n");

        List<Item> items = itemDAO.getAllItems();
        for (Item item : items) {
            if (item.isLowStock() || item.isOutOfStock()) {
                txt.append(item.getItemName()).append(" - Stock: ").append(item.getStockQuantity());
                txt.append(" (").append(item.getStockStatus()).append(")\n");
            }
        }
    }

    // Helper classes
    public static class SalesData {
        private int billCount = 0;
        private double totalSales = 0.0;

        public void addBill(Bill bill) {
            billCount++;
            totalSales += bill.getFinalAmount();
        }

        public int getBillCount() { return billCount; }
        public double getTotalSales() { return totalSales; }
    }

    public static class CustomerSummary {
        private Customer customer;
        private int totalBills;
        private double totalSpent;
        private String lastPurchaseDate;

        // Getters and setters
        public Customer getCustomer() { return customer; }
        public void setCustomer(Customer customer) { this.customer = customer; }

        public int getTotalBills() { return totalBills; }
        public void setTotalBills(int totalBills) { this.totalBills = totalBills; }

        public double getTotalSpent() { return totalSpent; }
        public void setTotalSpent(double totalSpent) { this.totalSpent = totalSpent; }

        public String getLastPurchaseDate() { return lastPurchaseDate; }
        public void setLastPurchaseDate(String lastPurchaseDate) { this.lastPurchaseDate = lastPurchaseDate; }
    }
}