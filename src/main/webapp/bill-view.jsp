<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 3:36 PM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/bill-view.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%@ page import="com.pahanaedu.models.Bill" %>
<%@ page import="com.pahanaedu.models.BillItem" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Bill bill = (Bill) request.getAttribute("bill");
    if (bill == null) {
        response.sendRedirect("bill");
        return;
    }

    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Details - <%= bill.getBillNumber() %></title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container {
            max-width: 800px;
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

        .bill-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid #ecf0f1;
        }

        .bill-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #3498db;
        }

        .company-info {
            margin-bottom: 20px;
        }

        .bill-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .info-section h4 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }

        .info-section p {
            margin: 5px 0;
            color: #34495e;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .items-table th,
        .items-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        .items-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #2c3e50;
        }

        .items-table .text-right {
            text-align: right;
        }

        .totals-section {
            margin-left: auto;
            width: 300px;
            margin-top: 20px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #ecf0f1;
        }

        .total-row.final {
            font-size: 1.2rem;
            font-weight: bold;
            border-top: 2px solid #2c3e50;
            border-bottom: 2px solid #2c3e50;
            margin-top: 10px;
            padding-top: 15px;
            color: #2c3e50;
        }

        .btn {
            padding: 12px 25px;
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

        .btn:hover { opacity: 0.9; }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-paid { background: #d4edda; color: #155724; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-cancelled { background: #f8d7da; color: #721c24; }

        @media print {
            .header, .action-buttons { display: none; }
            .container { margin: 0; padding: 0; }
            .bill-container { box-shadow: none; border: none; }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>Bill Details</h1>
            <p>Bill Number: <%= bill.getBillNumber() %></p>
        </div>
        <div class="action-buttons">
            <a href="bill?action=print&billId=<%= bill.getBillId() %>" class="btn btn-warning" target="_blank">Print Bill</a>
            <a href="bill?action=list" class="btn btn-primary">Back to Bills</a>
            <a href="bill" class="btn btn-secondary">Dashboard</a>
        </div>
    </div>

    <!-- Bill Container -->
    <div class="bill-container">
        <!-- Bill Header -->
        <div class="bill-header">
            <div class="company-info">
                <h2>Pahana Edu Bookshop</h2>
                <p>Complete Bookshop Management System</p>
                <p>Colombo, Sri Lanka</p>
            </div>
            <h3>INVOICE</h3>
        </div>

        <!-- Bill Information -->
        <div class="bill-info">
            <div class="info-section">
                <h4>Bill Information</h4>
                <p><strong>Bill Number:</strong> <%= bill.getBillNumber() %></p>
                <p><strong>Date:</strong> <%= bill.getBillDate() %></p>
                <p><strong>Payment Method:</strong> <%= bill.getPaymentMethod() %></p>
                <p><strong>Status:</strong>
                    <span class="status-badge status-<%= bill.getPaymentStatus().toLowerCase() %>">
                            <%= bill.getPaymentStatus() %>
                        </span>
                </p>
                <% if (bill.getNotes() != null && !bill.getNotes().trim().isEmpty()) { %>
                <p><strong>Notes:</strong> <%= bill.getNotes() %></p>
                <% } %>
            </div>

            <div class="info-section">
                <h4>Customer Information</h4>
                <p><strong>Name:</strong> <%= bill.getCustomerName() %></p>
                <p><strong>Account Number:</strong> <%= bill.getCustomerAccountNumber() %></p>
                <% if (bill.getCreatedByName() != null) { %>
                <p><strong>Served By:</strong> <%= bill.getCreatedByName() %></p>
                <% } %>
            </div>
        </div>

        <!-- Items Table -->
        <table class="items-table">
            <thead>
            <tr>
                <th>Item</th>
                <th class="text-right">Unit Price</th>
                <th class="text-right">Quantity</th>
                <th class="text-right">Total</th>
            </tr>
            </thead>
            <tbody>
            <% if (bill.getBillItems() != null && !bill.getBillItems().isEmpty()) { %>
            <% for (BillItem item : bill.getBillItems()) { %>
            <tr>
                <td><%= item.getItemName() %></td>
                <td class="text-right">Rs. <%= df.format(item.getUnitPrice()) %></td>
                <td class="text-right"><%= item.getQuantity() %></td>
                <td class="text-right">Rs. <%= df.format(item.getLineTotal()) %></td>
            </tr>
            <% } %>
            <% } else { %>
            <tr>
                <td colspan="4" style="text-align: center; color: #7f8c8d;">No items found</td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <!-- Totals Section -->
        <div class="totals-section">
            <div class="total-row">
                <span>Subtotal:</span>
                <span>Rs. <%= df.format(bill.getSubtotal()) %></span>
            </div>

            <% if (bill.getDiscountPercentage() > 0) { %>
            <div class="total-row">
                <span>Discount (<%= bill.getDiscountPercentage() %>%):</span>
                <span>Rs. <%= df.format(bill.getDiscountAmount()) %></span>
            </div>
            <% } %>

            <div class="total-row final">
                <span>Final Total:</span>
                <span>Rs. <%= df.format(bill.getFinalAmount()) %></span>
            </div>
        </div>

        <!-- Footer -->
        <div style="margin-top: 40px; text-align: center; color: #7f8c8d; font-size: 14px;">
            <p>Thank you for your business!</p>
            <p>This is a computer generated invoice.</p>
        </div>
    </div>
</div>

<script>
    // Print function
    function printBill() {
        window.print();
    }

    // Add keyboard shortcut for printing
    document.addEventListener('keydown', function(event) {
        if (event.ctrlKey && event.key === 'p') {
            event.preventDefault();
            printBill();
        }
    });
</script>
</body>
</html>