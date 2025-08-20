<%-- File: src/main/webapp/index.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%
    // Check if user is already logged in
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Bookshop - Management System</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
        }

        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
        }

        .hero-content {
            max-width: 800px;
            padding: 0 20px;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-subtitle {
            font-size: 1.3rem;
            margin-bottom: 30px;
            opacity: 0.9;
        }

        .hero-description {
            font-size: 1.1rem;
            margin-bottom: 40px;
            opacity: 0.8;
        }

        .cta-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 15px 30px;
            font-size: 1.1rem;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .btn-primary {
            background: #fff;
            color: #667eea;
        }

        .btn-primary:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .btn-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
        }

        .btn-secondary:hover {
            background: white;
            color: #667eea;
            transform: translateY(-2px);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .stats-section {
            background: #2c3e50;
            color: white;
            padding: 60px 20px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 40px;
            text-align: center;
        }

        .stat-item h3 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #3498db;
        }

        .stat-item p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .footer {
            background: #34495e;
            color: white;
            text-align: center;
            padding: 40px 20px;
        }

        .user-info-bar {
            background: #3498db;
            color: white;
            padding: 10px 20px;
            text-align: center;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .user-info-bar.logged-in + .main-content {
            margin-top: 60px;
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }

            .hero-subtitle {
                font-size: 1.1rem;
            }

            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 250px;
            }
        }
    </style>
</head>
<body>
<!-- User Info Bar (if logged in) -->
<% if (isLoggedIn) { %>
<div class="user-info-bar logged-in">
    <span>Welcome back, <strong><%= user.getFullName() %></strong> (<%= user.getRole() %>)</span>
    <span style="float: right;">
                <a href="dashboard.jsp" style="color: white; text-decoration: none; margin-right: 15px;">Dashboard</a>
                <a href="login" style="color: white; text-decoration: none;">Logout</a>
            </span>
</div>
<% } %>

<div class="main-content">
    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item">
                    <h3>100%</h3>
                    <p>Web-Based System</p>
                </div>
                <div class="stat-item">
                    <h3>3</h3>
                    <p>User Role Levels</p>
                </div>
                <div class="stat-item">
                    <h3>24/7</h3>
                    <p>System Availability</p>
                </div>
                <div class="stat-item">
                    <h3>∞</h3>
                    <p>Scalable Records</p>
                </div>
            </div>
        </div>
    </section>



    <!-- Hero Section ) -->
    <section class="hero-section">
        <div class="hero-content">
            <h1 class="hero-title">Pahana Edu Bookshop</h1>

            <p class="hero-description">
                Streamline your bookshop operations with our comprehensive management system.
                Handle customer accounts, inventory management, billing, and reporting all in one place.
            </p>

            <div class="cta-buttons">
                <% if (isLoggedIn) { %>
                <a href="dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
                <a href="customer" class="btn btn-secondary">Manage Customers</a>
                <% } else { %>
                <a href="login" class="btn btn-primary">Login to System</a>
                <% } %>
            </div>
        </div>
    </section>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <p>&copy; 2025 Pahana Edu Bookshop Management System. Built with Java Servlets & MySQL.</p>
        <p style="margin-top: 10px; opacity: 0.8;">Comprehensive solution for bookshop management and operations.</p>
    </div>
</footer>
</body>
</html>