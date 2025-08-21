<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 3:48 PM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/bill-print.jsp --%>
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
  <title>Print Bill - <%= bill.getBillNumber() %></title>
  <style>
    /* Print-optimized styles */
    @media print {
      @page {
        margin: 0.5in;
        size: A4;
      }

      .no-print {
        display: none !important;
      }

      body {
        font-family: 'Courier New', monospace;
        font-size: 12px;
        line-height: 1.4;
        color: #000;
        background: white;
      }
    }

    @media screen {
      body {
        font-family: 'Courier New', monospace;
        font-size: 14px;
        line-height: 1.4;
        margin: 20px;
        background: #f5f5f5;
      }

      .bill-container {
        background: white;
        padding: 30px;
        margin: 0 auto;
        max-width: 800px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
      }
    }

    .bill-container {
      background: white;
    }

    .header {
      text-align: center;
      border-bottom: 2px solid #000;
      padding-bottom: 15px;
      margin-bottom: 20px;
    }

    .company-name {
      font-size: 20px;
      font-weight: bold;
      margin: 0;
    }

    .company-details {
      font-size: 12px;
      margin: 5px 0;
    }

    .bill-title {
      font-size: 16px;
      font-weight: bold;
      margin: 10px 0;
      text-decoration: underline;
    }

    .bill-info {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
    }

    .customer-info, .bill-details {
      width: 48%;
    }

    .info-title {
      font-weight: bold;
      text-decoration: underline;
      margin-bottom: 5px;
    }

    .items-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }

    .items-table th,
    .items-table td {
      padding: 5px;
      text-align: left;
      border-bottom: 1px solid #000;
    }

    .items-table th {
      font-weight: bold;
      border-top: 2px solid #000;
      border-bottom: 2px solid #000;
    }

    .text-right {
      text-align: right;
    }

    .text-center {
      text-align: center;
    }

    .totals {
      margin-left: auto;
      width: 250px;
      margin-top: 10px;
    }

    .total-line {
      display: flex;
      justify-content: space-between;
      padding: 3px 0;
      border-bottom: 1px dotted #000;
    }

    .final-total {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-top: 2px solid #000;
      border-bottom: 2px solid #000;
      font-weight: bold;
      margin-top: 5px;
    }

    .footer {
      text-align: center;
      margin-top: 30px;
      padding-top: 15px;
      border-top: 1px solid #000;
      font-size: 11px;
    }

    .print-controls {
      text-align: center;
      margin: 20px 0;
      padding: 15px;
      background: #e3f2fd;
      border-radius: 5px;
    }

    .btn {
      padding: 10px 20px;
      margin: 5px;
      border: none;
      border-radius: 3px;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      font-size: 14px;
    }

    .btn-primary { background: #2196f3; color: white; }
    .btn-success { background: #4caf50; color: white; }
    .btn-secondary { background: #6c757d; color: white; }

    .separator {
      border: none;
      border-top: 1px dashed #000;
      margin: 15px 0;
    }
  </style>
</head>
<body>
<!-- Print Controls (hidden during print) -->
<div class="print-controls no-print">
  <h3>Print Options</h3>
  <button onclick="window.print()" class="btn btn-primary">🖨️ Save Bill</button>
  <button onclick="downloadTxtBill()" class="btn btn-success">🖨️ quick Bill txt  </button>
  <a href="bill?action=view&billId=<%= bill.getBillId() %>" class="btn btn-secondary">👁️ View Bill</a>
  <a href="bill" class="btn btn-secondary">🏠 Dashboard</a>
</div>

<!-- Bill Container -->
<div class="bill-container">
  <!-- Header -->
  <div class="header">
    <div class="company-name">PAHANA EDU BOOKSHOP</div>
    <div class="company-details">Complete Bookshop Management System</div>
    <div class="company-details">Colombo, Sri Lanka</div>
    <div class="company-details">Tel: +94-11-XXXXXXX | Email: info@pahanaedu.com</div>
    <div class="bill-title">SALES INVOICE</div>
  </div>

  <!-- Bill Information -->
  <div class="bill-info">
    <div class="customer-info">
      <div class="info-title">BILL TO:</div>
      <div><strong><%= bill.getCustomerName() %></strong></div>
      <div>Account: <%= bill.getCustomerAccountNumber() %></div>
      <% if (bill.getCreatedByName() != null) { %>
      <div>Served by: <%= bill.getCreatedByName() %></div>
      <% } %>
    </div>

    <div class="bill-details">
      <div class="info-title">BILL DETAILS:</div>
      <div><strong>Bill No:</strong> <%= bill.getBillNumber() %></div>
      <div><strong>Date:</strong> <%= bill.getBillDate() %></div>
      <div><strong>Payment:</strong> <%= bill.getPaymentMethod() %></div>
      <div><strong>Status:</strong> <%= bill.getPaymentStatus() %></div>
    </div>
  </div>

  <hr class="separator">

  <!-- Items Table -->
  <table class="items-table">
    <thead>
    <tr>
      <th>ITEM DESCRIPTION</th>
      <th class="text-center">QTY</th>
      <th class="text-right">UNIT PRICE</th>
      <th class="text-right">TOTAL</th>
    </tr>
    </thead>
    <tbody>
    <% if (bill.getBillItems() != null && !bill.getBillItems().isEmpty()) { %>
    <% for (BillItem item : bill.getBillItems()) { %>
    <tr>
      <td><%= item.getItemName() %></td>
      <td class="text-center"><%= item.getQuantity() %></td>
      <td class="text-right">Rs. <%= df.format(item.getUnitPrice()) %></td>
      <td class="text-right">Rs. <%= df.format(item.getLineTotal()) %></td>
    </tr>
    <% } %>
    <% } %>
    </tbody>
  </table>

  <!-- Totals -->
  <div class="totals">
    <div class="total-line">
      <span>SUBTOTAL:</span>
      <span>Rs. <%= df.format(bill.getSubtotal()) %></span>
    </div>

    <% if (bill.getDiscountPercentage() > 0) { %>
    <div class="total-line">
      <span>DISCOUNT (<%= bill.getDiscountPercentage() %>%):</span>
      <span>Rs. <%= df.format(bill.getDiscountAmount()) %></span>
    </div>
    <% } %>

    <div class="final-total">
      <span>TOTAL AMOUNT:</span>
      <span>Rs. <%= df.format(bill.getFinalAmount()) %></span>
    </div>
  </div>

  <% if (bill.getNotes() != null && !bill.getNotes().trim().isEmpty()) { %>
  <hr class="separator">
  <div><strong>Notes:</strong> <%= bill.getNotes() %></div>
  <% } %>

  <!-- Footer -->
  <div class="footer">
    <div>Thank you for your business!</div>
    <div>This is a computer generated invoice - No signature required</div>
    <div>Generated on: <%= new java.util.Date() %></div>
  </div>
</div>

<script>
  // Auto-print when page loads (optional)
  // window.onload = function() { window.print(); };

  // Download TXT version of bill
  function downloadTxtBill() {
    const billText = generateTxtBill();
    const blob = new Blob([billText], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = '<%= bill.getBillNumber() %>.txt';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  // Generate TXT format bill
  function generateTxtBill() {
    const txt = `
=====================================
    PAHANA EDU BOOKSHOP
    Complete Bookshop Management System
    Colombo, Sri Lanka
    Tel: +94-11-2245342
=====================================

SALES INVOICE

Bill Number: <%= bill.getBillNumber() %>
Date: <%= bill.getBillDate() %>
Customer: <%= bill.getCustomerName() %>
Account: <%= bill.getCustomerAccountNumber() %>
Payment Method: <%= bill.getPaymentMethod() %>
Status: <%= bill.getPaymentStatus() %>

-------------------------------------
ITEMS:
-------------------------------------
<% if (bill.getBillItems() != null && !bill.getBillItems().isEmpty()) { %>
<% for (BillItem item : bill.getBillItems()) { %>
<%= item.getItemName() %>
  Qty: <%= item.getQuantity() %> x Rs.<%= df.format(item.getUnitPrice()) %> = Rs.<%= df.format(item.getLineTotal()) %>
<% } %>
<% } %>

-------------------------------------
TOTALS:
-------------------------------------
Subtotal:     Rs.<%= df.format(bill.getSubtotal()) %>
<% if (bill.getDiscountPercentage() > 0) { %>
Discount (<%= bill.getDiscountPercentage() %>%): Rs.<%= df.format(bill.getDiscountAmount()) %>
<% } %>
FINAL TOTAL:  Rs.<%= df.format(bill.getFinalAmount()) %>

<% if (bill.getNotes() != null && !bill.getNotes().trim().isEmpty()) { %>
Notes: <%= bill.getNotes() %>
<% } %>

-------------------------------------
Thank you for your business!
Generated: <%= new java.util.Date() %>
=====================================
            `;
    return txt.trim();
  }

  // Keyboard shortcuts
  document.addEventListener('keydown', function(event) {
    if (event.ctrlKey && event.key === 'p') {
      event.preventDefault();
      window.print();
    }
  });
</script>
</body>
</html>