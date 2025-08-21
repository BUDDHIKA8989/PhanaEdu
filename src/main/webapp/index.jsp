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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #170e0e;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .main-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 60px 40px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            max-width: 600px;
            width: 100%;
            border: 1px solid rgba(31, 19, 19, 0.2);
        }

        .logo-section {
            margin-bottom: 40px;
        }

        .logo-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .logo-icon::before {
            content: "📚";
            font-size: 35px;
        }

        .system-title {
            font-size: 2.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #3553e0 0%, #1b28b2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
        }

        .system-subtitle {
            font-size: 1.2rem;
            color: #130c0c;
            margin-bottom: 40px;
            font-weight: 300;
        }

        .description-text {
            font-size: 1.1rem;
            color: #170f0f;
            margin-bottom: 50px;
            line-height: 1.8;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 18px 40px;
            font-size: 1.1rem;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            font-weight: 600;
            position: relative;
            overflow: hidden;
            min-width: 160px;
            justify-content: center;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(16, 7, 7, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-login {
            background: linear-gradient(135deg, #445eda 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.5);
        }

        .btn-icon {
            font-size: 1.2rem;
        }

        .features-preview {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(102, 126, 234, 0.2);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .feature-item {
            text-align: center;
            color: #1f1111;
        }

        .feature-icon {
            font-size: 2rem;
            margin-bottom: 10px;
            opacity: 0.8;
        }

        .feature-text {
            font-size: 0.9rem;
            font-weight: 500;
        }

        .footer-info {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9rem;
            text-align: center;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .welcome-card {
                padding: 40px 30px;
                margin: 20px;
            }

            .system-title {
                font-size: 2.2rem;
            }

            .action-buttons {
                justify-content: center;
            }

            .btn {
                width: 100%;
                max-width: 280px;
            }

            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .system-title {
                font-size: 1.8rem;
            }

            .welcome-card {
                padding: 30px 20px;
            }
        }

        /* Loading Animation */
        .btn:active {
            transform: scale(0.98);
        }

        /* Glassmorphism effect enhancement */
        @supports (backdrop-filter: blur(10px)) {
            .welcome-card {
                background: rgba(31, 21, 21, 0.1);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(37, 21, 21, 0.2);
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="welcome-card">
        <!-- Logo Section -->
        <div class="logo-section">
            <div class="logo-icon"></div>
            <h1 class="system-title">Pahana Edu Bookshop</h1>
            <p class="system-subtitle">Management System</p>
        </div>

        <!-- Description -->
        <div class="description-text">
            Comprehensive bookshop management solution for inventory tracking,
            customer management, billing, and business analytics.
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="login" class="btn btn-login">
                <span class="btn-icon">🔑</span>
                Login to System
            </a>
        </div>

        <!-- Features Preview -->
        <div class="features-preview">
            <div class="features-grid">
                <div class="feature-item">
                    <div class="feature-icon">👥</div>
                    <div class="feature-text">Customer Management</div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">📊</div>
                    <div class="feature-text">Inventory Control</div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">💰</div>
                    <div class="feature-text">Billing System</div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">📈</div>
                    <div class="feature-text">Reports & Analytics</div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Footer Info -->
<div class="footer-info">
    © 2025 Pahana Edu Bookshop • Java Web Application
</div>

<script>
    // Add some interactive effects
    document.addEventListener('DOMContentLoaded', function() {
        // Add smooth scroll behavior
        document.documentElement.style.scrollBehavior = 'smooth';

        // Add keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && e.target.classList.contains('btn')) {
                e.target.click();
            }
        });
    });
</script>
</body>
</html>