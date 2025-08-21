<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 3:36 PM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/bill-list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%@ page import="com.pahanaedu.models.Bill" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bills - Pahana Edu</title>
    <link rel="stylesheet" href="">
    <style>
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding: 20px; background: #3498db; color: white; border-radius: 5px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; margin-right: 10px; }
        .btn-primary { background: #3498db; color: white; }
        .btn-success { background: #27ae60; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-small { padding: 5px 10px; font-size: 12px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ecf0f1; }
        th { background: #f8f9fa; font-weight: bold; color: #2c3e50; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>All Bills</h1>
        <div>
            <a href="bill?action=new" class="btn btn-success">New Bill</a>
            <a href="bill" class="btn btn-secondary">Dashboard</a>
        </div>
    </div>

    <table>
        <thead>
        <tr>
            <th>Bill Number</th>
            <th>Customer</th>
            <th>Date</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (bills != null && !bills.isEmpty()) { %>
        <% for (Bill bill : bills) { %>
        <tr>
            <td><%= bill.getBillNumber() %></td>
            <td><%= bill.getCustomerName() %></td>
            <td><%= bill.getBillDate() %></td>
            <td>Rs. <%= df.format(bill.getFinalAmount()) %></td>
            <td><%= bill.getPaymentStatus() %></td>
            <td>
                <a href="bill?action=view&billId=<%= bill.getBillId() %>" class="btn btn-primary btn-small">View</a>
                <a href="bill?action=print&billId=<%= bill.getBillId() %>" class="btn btn-warning btn-small">Print</a>
            </td>
        </tr>
        <% } %>
        <% } else { %>
        <tr><td colspan="6" style="text-align: center;">No bills found</td></tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>