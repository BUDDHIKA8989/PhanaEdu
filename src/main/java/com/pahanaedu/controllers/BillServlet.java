// File: src/main/java/com/pahanaedu/controllers/BillServlet.java
package com.pahanaedu.controllers;

import com.pahanaedu.dao.BillDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.models.Bill;
import com.pahanaedu.models.BillItem;
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
import java.util.ArrayList;
import java.util.List;
import java.text.DecimalFormat;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {

    private BillDAO billDAO;
    private CustomerDAO customerDAO;
    private ItemDAO itemDAO;

    @Override
    public void init() throws ServletException {
        billDAO = new BillDAO();
        customerDAO = new CustomerDAO();
        itemDAO = new ItemDAO();
    }

    // Handle GET request - Show billing page
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

        String action = request.getParameter("action");

        if ("new".equals(action)) {
            // Show new bill creation form
            showNewBillForm(request, response);

        } else if ("view".equals(action)) {
            // View specific bill
            viewBill(request, response);

        } else if ("print".equals(action)) {
            // Print bill
            printBill(request, response);

        } else if ("list".equals(action)) {
            // List all bills
            listBills(request, response);


        }
        // In BillServlet doGet method, add this case:
        else if ("downloadTxt".equals(action)) {
            downloadTxtBill(request, response);
        }
        else {
            // Default - Show billing dashboard
            showBillingDashboard(request, response);

        }
    }

    // Handle POST request - Process billing operations
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createBill(request, response, user);
        } else if ("updatePayment".equals(action)) {
            updatePaymentStatus(request, response);
        } else if ("delete".equals(action) && user.isAdmin()) {
            deleteBill(request, response);
        } else {
            response.sendRedirect("bill");
        }
    }

    // Show new bill creation form
    private void showNewBillForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all customers and items for dropdowns
        List<Customer> customers = customerDAO.getAllCustomers();
        List<Item> items = itemDAO.getAllItems();

        // Filter only items with stock
        List<Item> availableItems = new ArrayList<>();
        for (Item item : items) {
            if (item.getStockQuantity() > 0) {
                availableItems.add(item);
            }
        }

        request.setAttribute("customers", customers);
        request.setAttribute("items", availableItems);
        request.setAttribute("newBill", true);

        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }

    // View specific bill
    private void viewBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billIdStr = request.getParameter("billId");

        if (billIdStr != null) {
            try {
                int billId = Integer.parseInt(billIdStr);
                Bill bill = billDAO.getBillById(billId);

                if (bill != null) {
                    request.setAttribute("bill", bill);
                    request.setAttribute("viewMode", true);
                    request.getRequestDispatcher("bill-view.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid bill ID
            }
        }

        request.setAttribute("errorMessage", "Bill not found");
        response.sendRedirect("bill?action=list");
    }

    // Print bill
    private void printBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billIdStr = request.getParameter("billId");

        if (billIdStr != null) {
            try {
                int billId = Integer.parseInt(billIdStr);
                Bill bill = billDAO.getBillById(billId);

                if (bill != null) {
                    request.setAttribute("bill", bill);
                    request.setAttribute("printMode", true);
                    request.getRequestDispatcher("bill-print.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid bill ID
            }
        }

        request.setAttribute("errorMessage", "Bill not found");
        response.sendRedirect("bill?action=list");
    }

    // List all bills
    private void listBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Bill> bills = billDAO.getAllBills();
        request.setAttribute("bills", bills);
        request.setAttribute("listMode", true);

        request.getRequestDispatcher("bill-list.jsp").forward(request, response);
    }

    // Show billing dashboard
    private void showBillingDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get recent bills
        List<Bill> recentBills = billDAO.getAllBills();
        if (recentBills.size() > 10) {
            recentBills = recentBills.subList(0, 10); // Show only last 10
        }

        // Get today's statistics
        int todayBillsCount = billDAO.getTodayBillsCount();
        double todayTotalSales = billDAO.getTodayTotalSales();

        request.setAttribute("recentBills", recentBills);
        request.setAttribute("todayBillsCount", todayBillsCount);
        request.setAttribute("todayTotalSales", todayTotalSales);

        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }

    // Create new bill
    private void createBill(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            // Get form data
            String customerIdStr = request.getParameter("customerId");
            String discountPercentageStr = request.getParameter("discountPercentage");
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");

            // Get item data arrays
            String[] itemIds = request.getParameterValues("itemId");
            String[] quantities = request.getParameterValues("quantity");

            // Validation
            if (customerIdStr == null || itemIds == null || quantities == null) {
                request.setAttribute("errorMessage", "Missing required fields");
                showNewBillForm(request, response);
                return;
            }

            int customerId = Integer.parseInt(customerIdStr);
            double discountPercentage = 0.0;

            if (discountPercentageStr != null && !discountPercentageStr.trim().isEmpty()) {
                discountPercentage = Double.parseDouble(discountPercentageStr);
                if (discountPercentage < 0 || discountPercentage > 100) {
                    request.setAttribute("errorMessage", "Discount percentage must be between 0 and 100");
                    showNewBillForm(request, response);
                    return;
                }
            }

            // Validate customer exists
            Customer customer = customerDAO.getCustomerById(customerId);
            if (customer == null) {
                request.setAttribute("errorMessage", "Invalid customer selected");
                showNewBillForm(request, response);
                return;
            }

            // Create bill object
            String billNumber = billDAO.generateBillNumber();
            Bill bill = new Bill(billNumber, customerId, user.getUserId());
            bill.setDiscountPercentage(discountPercentage);
            bill.setPaymentMethod(paymentMethod != null ? paymentMethod : "Cash");
            bill.setPaymentStatus("Paid"); // Assume immediate payment
            bill.setNotes(notes);

            // Process bill items
            List<BillItem> billItems = new ArrayList<>();

            for (int i = 0; i < itemIds.length; i++) {
                if (itemIds[i] != null && !itemIds[i].trim().isEmpty() &&
                        quantities[i] != null && !quantities[i].trim().isEmpty()) {

                    int itemId = Integer.parseInt(itemIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    if (quantity <= 0) {
                        request.setAttribute("errorMessage", "Quantity must be greater than 0");
                        showNewBillForm(request, response);
                        return;
                    }

                    // Get item details
                    Item item = itemDAO.getItemById(itemId);
                    if (item == null) {
                        request.setAttribute("errorMessage", "Invalid item selected");
                        showNewBillForm(request, response);
                        return;
                    }

                    // Check stock availability
                    if (item.getStockQuantity() < quantity) {
                        request.setAttribute("errorMessage",
                                "Insufficient stock for " + item.getItemName() +
                                        ". Available: " + item.getStockQuantity());
                        showNewBillForm(request, response);
                        return;
                    }

                    // Create bill item
                    BillItem billItem = new BillItem(itemId, item.getItemName(), quantity, item.getPrice());
                    billItems.add(billItem);
                }
            }

            if (billItems.isEmpty()) {
                request.setAttribute("errorMessage", "At least one item is required");
                showNewBillForm(request, response);
                return;
            }

            // Add items to bill
            bill.setBillItems(billItems);
            bill.calculateTotals();

            // Save bill to database
            boolean success = billDAO.createBill(bill);

            if (success) {
                // Redirect to view the created bill
                response.sendRedirect("bill?action=view&billId=" + bill.getBillId());
            } else {
                request.setAttribute("errorMessage", "Failed to create bill. Please try again.");
                showNewBillForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format in form data");
            showNewBillForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while creating the bill");
            showNewBillForm(request, response);
        }
    }

    // Update payment status
    private void updatePaymentStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billIdStr = request.getParameter("billId");
        String paymentStatus = request.getParameter("paymentStatus");

        try {
            int billId = Integer.parseInt(billIdStr);
            boolean success = billDAO.updatePaymentStatus(billId, paymentStatus);

            if (success) {
                request.setAttribute("successMessage", "Payment status updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update payment status");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid bill ID");
        }

        response.sendRedirect("bill?action=list");
    }

    // Delete bill (Admin only)
    private void deleteBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billIdStr = request.getParameter("billId");

        try {
            int billId = Integer.parseInt(billIdStr);
            boolean success = billDAO.deleteBill(billId);

            if (success) {
                request.setAttribute("successMessage", "Bill deleted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to delete bill");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid bill ID");
        }

        response.sendRedirect("bill?action=list");
    }

    // Add this method to BillServlet.java

    // Handle TXT file download
    private void downloadTxtBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String billIdStr = request.getParameter("billId");

        if (billIdStr != null) {
            try {
                int billId = Integer.parseInt(billIdStr);
                Bill bill = billDAO.getBillById(billId);

                if (bill != null) {
                    // Set response headers for file download
                    response.setContentType("text/plain");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + bill.getBillNumber() + ".txt\"");

                    // Generate TXT content
                    String txtContent = generateTxtBill(bill);

                    // Write to response
                    response.getWriter().write(txtContent);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid bill ID
            }
        }

        response.sendRedirect("bill?action=list");
    }

    // Helper method to generate TXT format
    private String generateTxtBill(Bill bill) {
        StringBuilder txt = new StringBuilder();
        DecimalFormat df = new DecimalFormat("#,##0.00");

        txt.append("=====================================\n");
        txt.append("    PAHANA EDU BOOKSHOP\n");
        txt.append("    Complete Bookshop Management System\n");
        txt.append("    Colombo, Sri Lanka\n");
        txt.append("=====================================\n\n");

        txt.append("SALES INVOICE\n\n");

        txt.append("Bill Number: ").append(bill.getBillNumber()).append("\n");
        txt.append("Date: ").append(bill.getBillDate()).append("\n");
        txt.append("Customer: ").append(bill.getCustomerName()).append("\n");
        txt.append("Account: ").append(bill.getCustomerAccountNumber()).append("\n");
        txt.append("Payment Method: ").append(bill.getPaymentMethod()).append("\n");
        txt.append("Status: ").append(bill.getPaymentStatus()).append("\n\n");

        txt.append("-------------------------------------\n");
        txt.append("ITEMS:\n");
        txt.append("-------------------------------------\n");

        if (bill.getBillItems() != null && !bill.getBillItems().isEmpty()) {
            for (BillItem item : bill.getBillItems()) {
                txt.append(item.getItemName()).append("\n");
                txt.append("  Qty: ").append(item.getQuantity());
                txt.append(" x Rs.").append(df.format(item.getUnitPrice()));
                txt.append(" = Rs.").append(df.format(item.getLineTotal())).append("\n\n");
            }
        }

        txt.append("-------------------------------------\n");
        txt.append("TOTALS:\n");
        txt.append("-------------------------------------\n");
        txt.append("Subtotal:     Rs.").append(df.format(bill.getSubtotal())).append("\n");

        if (bill.getDiscountPercentage() > 0) {
            txt.append("Discount (").append(bill.getDiscountPercentage()).append("%): Rs.");
            txt.append(df.format(bill.getDiscountAmount())).append("\n");
        }

        txt.append("FINAL TOTAL:  Rs.").append(df.format(bill.getFinalAmount())).append("\n\n");

        if (bill.getNotes() != null && !bill.getNotes().trim().isEmpty()) {
            txt.append("Notes: ").append(bill.getNotes()).append("\n\n");
        }

        txt.append("-------------------------------------\n");
        txt.append("Thank you for your business!\n");
        txt.append("Generated: ").append(new java.util.Date()).append("\n");
        txt.append("=====================================\n");

        return txt.toString();
    }
}