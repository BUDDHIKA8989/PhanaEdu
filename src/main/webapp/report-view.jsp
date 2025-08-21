<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 5:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/report-view.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%@ page import="com.pahanaedu.models.Bill" %>
<%@ page import="com.pahanaedu.models.Item" %>
<%@ page import="com.pahanaedu.controllers.ReportServlet.SalesData" %>
<%@ page import="com.pahanaedu.controllers.ReportServlet.CustomerSummary" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String reportType = (String) request.getAttribute("reportType");
    String reportTitle = (String) request.getAttribute("reportTitle");

    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= reportTitle %> - Pahana Edu</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: #3498db;
            color: white;
            border-radius: 5px;
        }

        .report-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .report-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #3498db;
        }

        .report-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .summary-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border-left: 4px solid #3498db;
        }

        .summary-value {
            font-size: 1.8rem;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .summary-label {
            color: #7f8c8d;
            font-size: 0.9rem;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .data-table th,
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .data-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #2c3e50;
            border-top: 2px solid #3498db;
        }

        .data-table tr:nth-child(even) {
            background: #f8f9fa;
        }

        .data-table tr:hover {
            background: #e3f2fd;
        }

        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin-right: 10px;
            margin-bottom: 10px;
        }

        .btn-primary { background: #3498db; color: white; }
        .btn-success { background: #27ae60; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-info { background: #17a2b8; color: white; }

        .btn:hover { opacity: 0.9; }

        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-in-stock { background: #d4edda; color: #155724; }
        .status-low-stock { background: #fff3cd; color: #856404; }
        .status-out-of-stock { background: #f8d7da; color: #721c24; }

        .no-data {
            text-align: center;
            color: #7f8c8d;
            padding: 40px;
            font-style: italic;
        }

        .chart-placeholder {
            background: #f8f9fa;
            border: 2px dashed #bdc3c7;
            border-radius: 5px;
            padding: 40px;
            text-align: center;
            color: #7f8c8d;
            margin: 20px 0;
        }

        @media print {
            .header, .action-buttons { display: none; }
            .container { margin: 0; padding: 0; }
            .report-container { box-shadow: none; }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1><%= reportTitle %></h1>
            <p>Generated by: <%= user.getFullName() %></p>
        </div>
        <div class="action-buttons">
            <button onclick="window.print()" class="btn btn-warning">🖨️ Print Report</button>
            <a href="reports?type=download&reportType=<%= reportType %>" class="btn btn-success">📄 Download TXT</a>
            <a href="reports" class="btn btn-secondary">📊 Back to Reports</a>
        </div>
    </div>

    <!-- Report Container -->
    <div class="report-container">
        <!-- Report Header -->
        <div class="report-header">
            <h2><%= reportTitle %></h2>
            <div class="report-meta">
                <div><strong>Generated:</strong> <%= new java.util.Date() %></div>
                <div><strong>Report Type:</strong> <%= reportType.replace("-", " ").toUpperCase() %></div>
                <div><strong>Generated By:</strong> <%= user.getFullName() %></div>
            </div>
        </div>

        <% if ("daily-sales".equals(reportType)) { %>
        <!-- Daily Sales Report -->
        <%
            Map<String, SalesData> dailySales = (Map<String, SalesData>) request.getAttribute("dailySales");
            if (dailySales != null && !dailySales.isEmpty()) {
                double totalSales = 0;
                int totalBills = 0;
                for (SalesData data : dailySales.values()) {
                    totalSales += data.getTotalSales();
                    totalBills += data.getBillCount();
                }
        %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-value"><%= dailySales.size() %></div>
                <div class="summary-label">Days with Sales</div>
            </div>
            <div class="summary-card">
                <div class="summary-value"><%= totalBills %></div>
                <div class="summary-label">Total Bills</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(totalSales) %></div>
                <div class="summary-label">Total Sales</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(totalSales / dailySales.size()) %></div>
                <div class="summary-label">Average Daily Sales</div>
            </div>
        </div>

        <table class="data-table">
            <thead>
            <tr>
                <th>Date</th>
                <th class="text-center">Number of Bills</th>
                <th class="text-right">Total Sales</th>
                <th class="text-right">Average Bill</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map.Entry<String, SalesData> entry : dailySales.entrySet()) {
                SalesData data = entry.getValue();
                double avgBill = data.getBillCount() > 0 ? data.getTotalSales() / data.getBillCount() : 0;
            %>
            <tr>
                <td><%= entry.getKey() %></td>
                <td class="text-center"><%= data.getBillCount() %></td>
                <td class="text-right">Rs. <%= df.format(data.getTotalSales()) %></td>
                <td class="text-right">Rs. <%= df.format(avgBill) %></td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <% } else { %>
        <div class="no-data">No sales data available for the selected period.</div>
        <% } %>

        <% } else if ("customer-summary".equals(reportType)) { %>
        <!-- Customer Summary Report -->
        <%
            List<CustomerSummary> customerSummaries = (List<CustomerSummary>) request.getAttribute("customerSummaries");
            if (customerSummaries != null && !customerSummaries.isEmpty()) {
                double totalRevenue = 0;
                int totalBills = 0;
                int activeCustomers = 0;

                for (CustomerSummary summary : customerSummaries) {
                    totalRevenue += summary.getTotalSpent();
                    totalBills += summary.getTotalBills();
                    if (summary.getTotalBills() > 0) activeCustomers++;
                }
        %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-value"><%= customerSummaries.size() %></div>
                <div class="summary-label">Total Customers</div>
            </div>
            <div class="summary-card">
                <div class="summary-value"><%= activeCustomers %></div>
                <div class="summary-label">Active Customers</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(totalRevenue) %></div>
                <div class="summary-label">Total Revenue</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(activeCustomers > 0 ? totalRevenue / activeCustomers : 0) %></div>
                <div class="summary-label">Avg. per Customer</div>
            </div>
        </div>

        <table class="data-table">
            <thead>
            <tr>
                <th>Customer Name</th>
                <th>Account Number</th>
                <th class="text-center">Total Bills</th>
                <th class="text-right">Total Spent</th>
                <th>Last Purchase</th>
            </tr>
            </thead>
            <tbody>
            <% for (CustomerSummary summary : customerSummaries) { %>
            <tr>
                <td><%= summary.getCustomer().getCustomerName() %></td>
                <td><%= summary.getCustomer().getAccountNumber() %></td>
                <td class="text-center"><%= summary.getTotalBills() %></td>
                <td class="text-right">Rs. <%= df.format(summary.getTotalSpent()) %></td>
                <td><%= summary.getLastPurchaseDate() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <% } else { %>
        <div class="no-data">No customer data available.</div>
        <% } %>

        <% } else if ("inventory".equals(reportType)) { %>
        <!-- Inventory Report -->
        <%
            List<Item> items = (List<Item>) request.getAttribute("items");
            if (items != null && !items.isEmpty()) {
                int totalItems = items.size();
                int lowStockItems = 0;
                int outOfStockItems = 0;
                double totalValue = 0;
                int totalStock = 0;

                for (Item item : items) {
                    if (item.isOutOfStock()) outOfStockItems++;
                    else if (item.isLowStock()) lowStockItems++;
                    totalValue += item.getTotalValue();
                    totalStock += item.getStockQuantity();
                }
        %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-value"><%= totalItems %></div>
                <div class="summary-label">Total Items</div>
            </div>
            <div class="summary-card">
                <div class="summary-value"><%= totalStock %></div>
                <div class="summary-label">Total Stock Units</div>
            </div>
            <div class="summary-card">
                <div class="summary-value"><%= lowStockItems %></div>
                <div class="summary-label">Low Stock Items</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(totalValue) %></div>
                <div class="summary-label">Total Inventory Value</div>
            </div>
        </div>

        <table class="data-table">
            <thead>
            <tr>
                <th>Item Name</th>
                <th>Category</th>
                <th class="text-right">Unit Price</th>
                <th class="text-center">Stock Quantity</th>
                <th class="text-center">Status</th>
                <th class="text-right">Total Value</th>
            </tr>
            </thead>
            <tbody>
            <% for (Item item : items) { %>
            <tr>
                <td>
                    <strong><%= item.getItemName() %></strong>
                    <% if (item.getDescription() != null && !item.getDescription().isEmpty()) { %>
                    <br><small style="color: #7f8c8d;"><%= item.getDescription() %></small>
                    <% } %>
                </td>
                <td><%= item.getCategory() != null ? item.getCategory() : "-" %></td>
                <td class="text-right">Rs. <%= df.format(item.getPrice()) %></td>
                <td class="text-center"><%= item.getStockQuantity() %></td>
                <td class="text-center">
                                    <span class="status-badge status-<%= item.isOutOfStock() ? "out-of-stock" : (item.isLowStock() ? "low-stock" : "in-stock") %>">
                                        <%= item.getStockStatus() %>
                                    </span>
                </td>
                <td class="text-right">Rs. <%= df.format(item.getTotalValue()) %></td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <% } else { %>
        <div class="no-data">No inventory data available.</div>
        <% } %>

        <% } else if ("low-stock".equals(reportType)) { %>
        <!-- Low Stock Report -->
        <%
            List<Item> lowStockItems = (List<Item>) request.getAttribute("lowStockItems");
            if (lowStockItems != null && !lowStockItems.isEmpty()) {
                int criticalItems = 0;
                int outOfStockItems = 0;
                double lostSalesValue = 0;

                for (Item item : lowStockItems) {
                    if (item.isOutOfStock()) {
                        outOfStockItems++;
                        lostSalesValue += item.getPrice() * 5; // Estimate 5 lost sales per out-of-stock item
                    } else if (item.getStockQuantity() <= 2) {
                        criticalItems++;
                    }
                }
        %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-value"><%= lowStockItems.size() %></div>
                <div class="summary-label">Items Needing Attention</div>
            </div>
            <div class="summary-card">
                <div class="summary-value"><%= outOfStockItems %></div>
                <div class="summary-label">Out of Stock</div>
            </div>
            <div class="summary-card">
                <div class="summary-value"><%= criticalItems %></div>
                <div class="summary-label">Critical Stock (≤2)</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(lostSalesValue) %></div>
                <div class="summary-label">Estimated Lost Sales</div>
            </div>
        </div>

        <table class="data-table">
            <thead>
            <tr>
                <th>Item Name</th>
                <th>Category</th>
                <th class="text-center">Current Stock</th>
                <th class="text-center">Status</th>
                <th class="text-right">Unit Price</th>
                <th>Recommendation</th>
            </tr>
            </thead>
            <tbody>
            <% for (Item item : lowStockItems) { %>
            <tr>
                <td><strong><%= item.getItemName() %></strong></td>
                <td><%= item.getCategory() != null ? item.getCategory() : "-" %></td>
                <td class="text-center"><%= item.getStockQuantity() %></td>
                <td class="text-center">
                                    <span class="status-badge status-<%= item.isOutOfStock() ? "out-of-stock" : "low-stock" %>">
                                        <%= item.getStockStatus() %>
                                    </span>
                </td>
                <td class="text-right">Rs. <%= df.format(item.getPrice()) %></td>
                <td>
                    <% if (item.isOutOfStock()) { %>
                    <strong style="color: #e74c3c;">URGENT: Restock immediately</strong>
                    <% } else if (item.getStockQuantity() <= 2) { %>
                    <strong style="color: #f39c12;">Order within 24 hours</strong>
                    <% } else { %>
                    <span style="color: #f39c12;">Plan next order</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <% } else { %>
        <div class="no-data">
            <h3>🎉 Great News!</h3>
            <p>All items are well-stocked. No low stock alerts at this time.</p>
        </div>
        <% } %>

        <% } else if ("date-range".equals(reportType)) { %>
        <!-- Date Range Report -->
        <%
            List<Bill> filteredBills = (List<Bill>) request.getAttribute("filteredBills");
            String startDate = (String) request.getAttribute("startDate");
            String endDate = (String) request.getAttribute("endDate");
            Double totalSales = (Double) request.getAttribute("totalSales");
            Integer totalBills = (Integer) request.getAttribute("totalBills");

            if (filteredBills != null) {
        %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-value"><%= totalBills %></div>
                <div class="summary-label">Total Bills</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(totalSales) %></div>
                <div class="summary-label">Total Sales</div>
            </div>
            <div class="summary-card">
                <div class="summary-value">Rs. <%= df.format(totalBills > 0 ? totalSales / totalBills : 0) %></div>
                <div class="summary-label">Average Bill</div>
            </div>
            <div class="summary-card">
                <div class="summary-value"><%= startDate %> to <%= endDate %></div>
                <div class="summary-label">Date Range</div>
            </div>
        </div>

        <% if (!filteredBills.isEmpty()) { %>
        <table class="data-table">
            <thead>
            <tr>
                <th>Bill Number</th>
                <th>Date</th>
                <th>Customer</th>
                <th class="text-right">Amount</th>
                <th>Payment Method</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <% for (Bill bill : filteredBills) { %>
            <tr>
                <td><%= bill.getBillNumber() %></td>
                <td><%= bill.getBillDate() %></td>
                <td><%= bill.getCustomerName() %></td>
                <td class="text-right">Rs. <%= df.format(bill.getFinalAmount()) %></td>
                <td><%= bill.getPaymentMethod() %></td>
                <td><%= bill.getPaymentStatus() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="no-data">No sales found for the selected date range.</div>
        <% } %>

        <% } %>

        <% } else { %>
        <div class="no-data">
            <h3>Report Not Found</h3>
            <p>The requested report type is not recognized.</p>
            <a href="reports" class="btn btn-primary">Back to Reports</a>
        </div>
        <% } %>

        <!-- Report Footer -->
        <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #ecf0f1; text-align: center; color: #7f8c8d;">
            <p><strong>Pahana Edu Bookshop Management System</strong></p>
            <p>Report generated on <%= new java.util.Date() %> by <%= user.getFullName() %></p>
            <p><em>This report is confidential and for internal use only.</em></p>
        </div>
    </div>
</div>

<script>
    // Print function
    function printReport() {
        window.print();
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', function(event) {
        if (event.ctrlKey && event.key === 'p') {
            event.preventDefault();
            printReport();
        }
    });
</script>
</body>
</html>