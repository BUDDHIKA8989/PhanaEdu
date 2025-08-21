<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 2:43 AM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/login.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Bookshop - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            position: relative;
        }

        .login-box {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 50px 40px;
            box-shadow: 0 25px 70px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            overflow: hidden;
        }

        .login-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .header-section {
            text-align: center;
            margin-bottom: 40px;
        }

        .logo-icon {
            width: 70px;
            height: 70px;
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
            font-size: 30px;
        }

        .login-title {
            font-size: 2.2rem;
            font-weight: 700;
            background: linear-gradient(135deg, #264ae8 0%, #141f57 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .login-subtitle {
            font-size: 1.1rem;
            color: #170b0b;
            font-weight: 400;
        }

        .error-message {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            color: white;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 500;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.3);
            animation: slideInDown 0.5s ease-out;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-form {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .form-group {
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #130d0d;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .form-group input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
            color: #1f1616;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-group input:valid {
            border-color: #27ae60;
        }

        .input-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 1.1rem;
            pointer-events: none;
            transition: color 0.3s ease;
        }

        .form-group input:focus + .input-icon {
            color: #667eea;
        }

        .login-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 18px 30px;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            margin-top: 10px;
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(23, 15, 15, 0.2), transparent);
            transition: left 0.5s;
        }

        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        .back-link {
            text-align: center;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid rgba(102, 126, 234, 0.2);
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .back-link a:hover {
            color: #764ba2;
            transform: translateX(-5px);
        }

        .security-note {
            margin-top: 20px;
            text-align: center;
            font-size: 0.85rem;
            color: #0c0808;
            font-style: italic;
        }

        /* Responsive Design */
        @media (max-width: 480px) {
            .login-box {
                padding: 40px 30px;
                margin: 10px;
            }

            .login-title {
                font-size: 1.8rem;
            }

            .form-group input {
                padding: 14px 18px;
            }

            .login-btn {
                padding: 16px 25px;
            }
        }

        /* Loading state */
        .login-btn.loading {
            pointer-events: none;
            opacity: 0.8;
        }

        .login-btn.loading::after {
            content: '';
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            border: 2px solid rgba(26, 17, 17, 0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: translateY(-50%) rotate(0deg); }
            100% { transform: translateY(-50%) rotate(360deg); }
        }

        /* Glassmorphism enhancement */
        @supports (backdrop-filter: blur(20px)) {
            .login-box {
                background: rgba(28, 18, 18, 0.1);
                backdrop-filter: blur(30px);
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-box">
        <!-- Header Section -->
        <div class="header-section">
            <div class="logo-icon"></div>
            <h2 class="login-title">Pahana Edu Bookshop</h2>
            <h3 class="login-subtitle">Welcome Back</h3>
        </div>

        <!-- Display error message if exists -->
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message">
            <strong>⚠️ Login Failed:</strong><br>
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <!-- Login Form -->
        <form action="login" method="post" class="login-form" id="loginForm">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required
                       autocomplete="username" placeholder="Enter your username">
                <span class="input-icon">👤</span>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required
                       autocomplete="current-password" placeholder="Enter your password">
                <span class="input-icon">🔒</span>
            </div>

            <button type="submit" class="login-btn" id="loginButton">
                Sign In to Dashboard
            </button>
        </form>

        <!-- Back to Home -->
        <div class="back-link">
            <a href="index.jsp">
                ← Back to Home
            </a>
        </div>

        <!-- Security Note -->
        <div class="security-note">
            🔐 Your credentials are encrypted and secure
        </div>
    </div>
</div>

<script>
    // Enhanced form interactions
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('loginForm');
        const loginButton = document.getElementById('loginButton');
        const inputs = document.querySelectorAll('input');

        // Add loading state on form submission
        form.addEventListener('submit', function() {
            loginButton.classList.add('loading');
            loginButton.textContent = 'Signing In...';
        });

        // Enhanced input interactions
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });

            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });

            // Auto-focus next field on Enter
            input.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    const nextInput = this.parentElement.nextElementSibling?.querySelector('input');
                    if (nextInput) {
                        nextInput.focus();
                    } else {
                        form.submit();
                    }
                }
            });
        });

        // Auto-focus first input
        document.getElementById('username').focus();

        // Clear error message on input
        const errorMessage = document.querySelector('.error-message');
        if (errorMessage) {
            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    if (errorMessage && this.value.length > 0) {
                        errorMessage.style.opacity = '0.5';
                    }
                });
            });
        }
    });
</script>
</body>
</html>