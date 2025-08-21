<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 2:44 AM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/dashboard.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userRole = user.getRole();
    String userName = user.getFullName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Bookshop - Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }

        .header {
            background: #3498db;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .menu-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
            border: 1px solid #e0e0e0;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .menu-card h3 {
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .menu-card p {
            color: #7f8c8d;
            margin-bottom: 20px;
        }

        .menu-btn {
            background: #3498db;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            transition: background 0.3s;
        }

        .menu-btn:hover {
            background: #2980b9;
        }

        .logout-btn {
            background: #e74c3c;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
        }

        .logout-btn:hover {
            background: #c0392b;
        }

        .user-info {
            background: #ecf0f1;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>Pahana Edu Bookshop</h1>
            <p>Management System Dashboard</p>
        </div>
        <a href="login" class="logout-btn">Logout</a>
    </div>

    <!-- User Info -->
    <div class="user-info">
        <h3>Welcome, <%= userName %>!</h3>
        <p><strong>Role:</strong> <%= userRole %></p>
        <p><strong>Access Level:</strong>
            <% if ("Admin".equals(userRole)) { %>
            Full System Access
            <% } else if ("Manager".equals(userRole)) { %>
            Management Functions
            <% } else { %>
            Staff Operations
            <% } %>
        </p>
    </div>

    <!-- Menu Grid -->
    <div class="menu-grid">
        <!-- Customer Management -->
        <div class="menu-card">
            <h3>👥 Customer Management</h3>
            <p>Add, edit, and view customer accounts</p>
            <a href="customers.jsp" class="menu-btn">Manage Customers</a>
        </div>

        <!-- Item Management -->
        <% if ("Admin".equals(userRole) || "Manager".equals(userRole)) { %>
        <div class="menu-card">
            <h3>📚 Item Management</h3>
            <p>Manage books and stationery items</p>
            <a href="items.jsp" class="menu-btn">Manage Items</a>
        </div>
        <% } %>

        <!-- Billing -->
        <div class="menu-card">
            <h3>🧾 Billing System</h3>
            <p>Create and print customer bills</p>
            <a href="billing.jsp" class="menu-btn">Create Bills</a>
        </div>

        <!-- Reports -->
        <% if ("Admin".equals(userRole) || "Manager".equals(userRole)) { %>
        <div class="menu-card">
            <h3>📊 Reports</h3>
            <p>View sales and inventory reports</p>
            <a href="reports.jsp" class="menu-btn">View Reports</a>
        </div>
        <% } %>

        <!-- User Management (Admin Only) -->
        <% if ("Admin".equals(userRole)) { %>
        <div class="menu-card">
            <h3>⚙️ User Management</h3>
            <p>Manage system users and permissions</p>
            <a href="reports.jsp" class="menu-btn">Manage Users</a>
        </div>
        <% } %>

        <!-- Help -->
        <div class="menu-card">
            <h3>❓ Help</h3>
            <p>System usage guidelines and support</p>
            <a href="help.jsp" class="menu-btn">Get Help</a>
        </div>
    </div>
</div>
</body>
</html>