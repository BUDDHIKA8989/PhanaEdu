<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 4:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/reports.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%@ page import="com.pahanaedu.models.Bill" %>
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

    // Check user role
    if (!"Admin".equals(user.getRole()) && !"Manager".equals(user.getRole())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Bill> recentBills = (List<Bill>) request.getAttribute("recentBills");

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics - Pahana Edu</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container {
            max-width: 1400px;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #3498db;
        }

        .stat-card.warning {
            border-left-color: #f39c12;
        }

        .stat-card.success {
            border-left-color: #27ae60;
        }

        .stat-card.danger {
            border-left-color: #e74c3c;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .stat-label {
            color: #7f8c8d;
            font-size: 1rem;
        }

        .reports-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .report-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
        }

        .report-card:hover {
            transform: translateY(-5px);
        }

        .report-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            display: block;
        }

        .report-title {
            font-size: 1.3rem;
            font-weight: bold;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .report-description {
            color: #7f8c8d;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin: 5px;
            transition: all 0.3s;
        }

        .btn-primary { background: #3498db; color: white; }
        .btn-success { background: #27ae60; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-secondary { background: #95a5a6; color: white; }

        .btn:hover { opacity: 0.9; transform: translateY(-1px); }

        .custom-report-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #2c3e50;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 5px;
            font-size: 14px;
        }

        .recent-activity {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .activity-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #ecf0f1;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .message {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>📊 Reports & Analytics</h1>
            <p>Welcome, <%= user.getFullName() %> (<%= user.getRole() %>)</p>
        </div>
        <div>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            <a href="login" class="btn btn-secondary">Logout</a>
        </div>
    </div>

    <!-- Messages -->
    <% if (successMessage != null) { %>
    <div class="message success"><%= successMessage %></div>
    <% } %>

    <% if (errorMessage != null) { %>
    <div class="message error"><%= errorMessage %></div>
    <% } %>

    <!-- Statistics Overview -->
    <% if (stats != null) { %>
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value"><%= stats.get("todayBills") %></div>
            <div class="stat-label">Today's Bills</div>
        </div>

        <div class="stat-card success">
            <div class="stat-value">Rs. <%= df.format((Double) stats.get("todaySales")) %></div>
            <div class="stat-label">Today's Sales</div>
        </div>

        <div class="stat-card">
            <div class="stat-value"><%= stats.get("totalCustomers") %></div>
            <div class="stat-label">Total Customers</div>
        </div>

        <div class="stat-card">
            <div class="stat-value"><%= stats.get("totalItems") %></div>
            <div class="stat-label">Total Items</div>
        </div>

        <div class="stat-card <%= (Integer) stats.get("lowStockItems") > 0 ? "warning" : "success" %>">
            <div class="stat-value"><%= stats.get("lowStockItems") %></div>
            <div class="stat-label">Low Stock Items</div>
        </div>

        <div class="stat-card success">
            <div class="stat-value">Rs. <%= df.format((Double) stats.get("totalInventoryValue")) %></div>
            <div class="stat-label">Inventory Value</div>
        </div>
    </div>
    <% } %>

    <!-- Quick Reports -->
    <div class="reports-grid">
        <div class="report-card">
            <span class="report-icon">📈</span>
            <div class="report-title">Daily Sales Report</div>
            <div class="report-description">View daily sales performance and trends</div>
            <a href="reports?type=daily-sales" class="btn btn-primary">Generate Report</a>
            <a href="reports?type=download&reportType=daily-sales" class="btn btn-secondary">Download TXT</a>
        </div>

        <div class="report-card">
            <span class="report-icon">👥</span>
            <div class="report-title">Customer Summary</div>
            <div class="report-description">Customer purchase history and analytics</div>
            <a href="reports?type=customer-summary" class="btn btn-success">Generate Report</a>
        </div>

        <div class="report-card">
            <span class="report-icon">📦</span>
            <div class="report-title">Inventory Report</div>
            <div class="report-description">Complete inventory status and valuation</div>
            <a href="reports?type=inventory" class="btn btn-info">Generate Report</a>
            <a href="reports?type=download&reportType=inventory" class="btn btn-secondary">Download TXT</a>
        </div>

        <div class="report-card">
            <span class="report-icon">⚠️</span>
            <div class="report-title">Low Stock Alert</div>
            <div class="report-description">Items requiring immediate restocking</div>
            <a href="reports?type=low-stock" class="btn btn-warning">Generate Report</a>
            <a href="reports?type=download&reportType=low-stock" class="btn btn-secondary">Download TXT</a>
        </div>
    </div>

    <!-- Custom Date Range Report -->
    <div class="custom-report-section">
        <h3>📅 Custom Date Range Report</h3>
        <p>Generate sales reports for specific date ranges</p>

        <form action="reports" method="post">
            <input type="hidden" name="action" value="custom-date-range">
            <div class="form-grid">
                <div class="form-group">
                    <label for="startDate">Start Date</label>
                    <input type="date" id="startDate" name="startDate" required>
                </div>

                <div class="form-group">
                    <label for="endDate">End Date</label>
                    <input type="date" id="endDate" name="endDate" required>
                </div>

                <button type="submit" class="btn btn-primary">Generate Report</button>
            </div>
        </form>
    </div>

    <!-- Recent Activity -->
    <% if (recentBills != null && !recentBills.isEmpty()) { %>
    <div class="recent-activity">
        <h3>🕒 Recent Transactions</h3>
        <% for (Bill bill : recentBills) { %>
        <div class="activity-item">
            <div>
                <strong><%= bill.getBillNumber() %></strong> - <%= bill.getCustomerName() %>
                <br><small style="color: #7f8c8d;"><%= bill.getBillDate() %></small>
            </div>
            <div>
                <strong>Rs. <%= df.format(bill.getFinalAmount()) %></strong>
                <br><small style="color: #7f8c8d;"><%= bill.getPaymentStatus() %></small>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<script>
    // Set default date range to last 30 days
    document.addEventListener('DOMContentLoaded', function() {
        const today = new Date();
        const thirtyDaysAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);

        document.getElementById('endDate').value = today.toISOString().split('T')[0];
        document.getElementById('startDate').value = thirtyDaysAgo.toISOString().split('T')[0];
    });

    // Refresh stats every 5 minutes
    setInterval(function() {
        location.reload();
    }, 300000);
</script>
</body>
</html>
