<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 4:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/help.jsp --%>
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Help & User Guide - Pahana Edu</title>
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
    .help-navigation {
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      margin-bottom: 30px;
    }

    .nav-tabs {
      display: flex;
      border-bottom: 2px solid #ecf0f1;
      margin-bottom: 20px;
    }

    .nav-tab {
      padding: 12px 20px;
      cursor: pointer;
      border: none;
      background: none;
      font-size: 14px;
      color: #7f8c8d;
      border-bottom: 3px solid transparent;
      transition: all 0.3s;
    }

    .nav-tab.active {
      color: #3498db;
      border-bottom-color: #3498db;
      font-weight: bold;
    }

    .nav-tab:hover {
      color: #2980b9;
      background: #f8f9fa;
    }

    .help-content {
      background: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .help-section {
      display: none;
    }

    .help-section.active {
      display: block;
      animation: fadeIn 0.3s ease-in;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .help-title {
      color: #2c3e50;
      border-bottom: 2px solid #3498db;
      padding-bottom: 10px;
      margin-bottom: 20px;
    }

    .step-list {
      list-style: none;
      padding: 0;
    }

    .step-item {
      background: #f8f9fa;
      margin: 10px 0;
      padding: 15px;
      border-left: 4px solid #3498db;
      border-radius: 5px;
    }

    .step-number {
      background: #3498db;
      color: white;
      border-radius: 50%;
      width: 25px;
      height: 25px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      margin-right: 10px;
      font-size: 12px;
    }

    .feature-card {
      background: #f8f9fa;
      padding: 20px;
      margin: 15px 0;
      border-radius: 8px;
      border-left: 4px solid #27ae60;
    }

    .feature-title {
      color: #27ae60;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .shortcut-table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
    }

    .shortcut-table th,
    .shortcut-table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #ecf0f1;
    }

    .shortcut-table th {
      background: #f8f9fa;
      font-weight: bold;
      color: #2c3e50;
    }

    .keyboard-key {
      background: #34495e;
      color: white;
      padding: 4px 8px;
      border-radius: 4px;
      font-family: monospace;
      font-size: 12px;
    }

    .alert {
      padding: 15px;
      border-radius: 5px;
      margin: 15px 0;
    }

    .alert-info {
      background: #d1ecf1;
      color: #0c5460;
      border-left: 4px solid #bee5eb;
    }

    .alert-warning {
      background: #fff3cd;
      color: #856404;
      border-left: 4px solid #ffeaa7;
    }

    .faq-item {
      margin: 20px 0;
      border: 1px solid #ecf0f1;
      border-radius: 5px;
    }

    .faq-question {
      background: #f8f9fa;
      padding: 15px;
      cursor: pointer;
      font-weight: bold;
      color: #2c3e50;
      border-bottom: 1px solid #ecf0f1;
    }

    .faq-question:hover {
      background: #e9ecef;
    }

    .faq-answer {
      padding: 15px;
      display: none;
    }

    .faq-answer.show {
      display: block;
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
    }

    .btn-primary { background: #3498db; color: white; }
    .btn-secondary { background: #95a5a6; color: white; }
    .btn:hover { opacity: 0.9; }
  </style>
</head>
<body>
<div class="container">
  <!-- Header -->
  <div class="header">
    <div>
      <h1>Help & User Guide</h1>
      <p>Welcome, <%= user.getFullName() %> (<%= userRole %>)</p>
    </div>
    <div>
      <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
      <a href="login" class="btn btn-secondary">Logout</a>
    </div>
  </div>

  <!-- Navigation -->
  <div class="help-navigation">
    <div class="nav-tabs">
      <button class="nav-tab active" onclick="showSection('getting-started')">🚀 Getting Started</button>
      <button class="nav-tab" onclick="showSection('features')">✨ Features</button>
      <button class="nav-tab" onclick="showSection('tutorials')">📚 Tutorials</button>
      <button class="nav-tab" onclick="showSection('shortcuts')">⌨️ Shortcuts</button>
      <button class="nav-tab" onclick="showSection('faq')">❓ FAQ</button>
      <button class="nav-tab" onclick="showSection('troubleshooting')">🔧 Troubleshooting</button>
    </div>
  </div>

  <!-- Help Content -->
  <div class="help-content">

    <!-- Getting Started Section -->
    <div id="getting-started" class="help-section active">
      <h2 class="help-title">🚀 Getting Started</h2>

      <div class="alert alert-info">
        <strong>Welcome to Pahana Edu Bookshop Management System!</strong> This guide will help you navigate and use all the features effectively.
      </div>

      <h3>Your Role: <%= userRole %></h3>
      <% if ("Admin".equals(userRole)) { %>
      <p>As an <strong>Admin</strong>, you have full access to all system features including:</p>
      <ul>
        <li>User management and permissions</li>
        <li>Complete customer and item management</li>
        <li>Advanced billing and reporting features</li>
        <li>System configuration and settings</li>
      </ul>
      <% } else if ("Manager".equals(userRole)) { %>
      <p>As a <strong>Manager</strong>, you can access business operations including:</p>
      <ul>
        <li>Customer account management</li>
        <li>Inventory and item management</li>
        <li>Bill creation and reporting</li>
        <li>Sales analytics and insights</li>
      </ul>
      <% } else { %>
      <p>As <strong>Staff</strong>, you can handle daily operations including:</p>
      <ul>
        <li>Customer registration and management</li>
        <li>Bill creation and printing</li>
        <li>Basic customer service functions</li>
        <li>View customer and item information</li>
      </ul>
      <% } %>

      <h3>Quick Start Guide</h3>
      <ol class="step-list">
        <li class="step-item">
          <span class="step-number">1</span>
          <strong>Dashboard:</strong> Start from the main dashboard to access all features
        </li>
        <li class="step-item">
          <span class="step-number">2</span>
          <strong>Customer Management:</strong> Add and manage customer accounts
        </li>
        <li class="step-item">
          <span class="step-number">3</span>
          <strong>Item Management:</strong> Manage your inventory and stock
        </li>
        <li class="step-item">
          <span class="step-number">4</span>
          <strong>Billing:</strong> Create bills and process transactions
        </li>
        <li class="step-item">
          <span class="step-number">5</span>
          <strong>Reports:</strong> View sales and inventory reports
        </li>
      </ol>
    </div>

    <!-- Features Section -->
    <div id="features" class="help-section">
      <h2 class="help-title">✨ System Features</h2>

      <div class="feature-card">
        <div class="feature-title">👥 Customer Management</div>
        <p>Add, edit, and manage customer accounts with unique account numbers. Track customer purchase history and contact information.</p>
        <ul>
          <li>Automatic account number generation</li>
          <li>Customer contact information management</li>
          <li>Purchase history tracking</li>
          <li>Search and filter customers</li>
        </ul>
      </div>

      <div class="feature-card">
        <div class="feature-title">📚 Inventory Management</div>
        <p>Complete item management system for books and stationery with stock tracking and low inventory alerts.</p>
        <ul>
          <li>Add, edit, and delete items</li>
          <li>Real-time stock level tracking</li>
          <li>Low stock alerts and reports</li>
          <li>Category-based organization</li>
          <li>Price management and updates</li>
        </ul>
      </div>

      <div class="feature-card">
        <div class="feature-title">🧾 Billing System</div>
        <p>Professional billing system with automatic calculations, discount support, and multiple output formats.</p>
        <ul>
          <li>Multiple item bill creation</li>
          <li>Automatic total calculations</li>
          <li>Discount percentage support</li>
          <li>Print-ready bill format</li>
          <li>TXT file export option</li>
          <li>Stock automatic deduction</li>
        </ul>
      </div>

      <div class="feature-card">
        <div class="feature-title">📊 Reports & Analytics</div>
        <p>Comprehensive reporting system for sales analysis and business insights.</p>
        <ul>
          <li>Daily sales summaries</li>
          <li>Customer purchase reports</li>
          <li>Inventory status reports</li>
          <li>Low stock alerts</li>
        </ul>
      </div>

      <% if ("Admin".equals(userRole)) { %>
      <div class="feature-card">
        <div class="feature-title">⚙️ User Management</div>
        <p>Admin-only feature for managing system users and their permissions.</p>
        <ul>
          <li>Add, edit, and delete users</li>
          <li>Role-based access control</li>
          <li>Password management</li>
          <li>User activity tracking</li>
        </ul>
      </div>
      <% } %>
    </div>

    <!-- Tutorials Section -->
    <div id="tutorials" class="help-section">
      <h2 class="help-title">📚 Step-by-Step Tutorials</h2>

      <h3>How to Add a New Customer</h3>
      <ol class="step-list">
        <li class="step-item">
          <span class="step-number">1</span>
          Navigate to <strong>Customer Management</strong> from the dashboard
        </li>
        <li class="step-item">
          <span class="step-number">2</span>
          Fill in the customer information form (Name is required)
        </li>
        <li class="step-item">
          <span class="step-number">3</span>
          Click <strong>"Add Customer"</strong> button
        </li>
        <li class="step-item">
          <span class="step-number">4</span>
          System will automatically generate an account number
        </li>
        <li class="step-item">
          <span class="step-number">5</span>
          Customer will appear in the customer list
        </li>
      </ol>

      <% if (!"Staff".equals(userRole)) { %>
      <h3>How to Add New Items</h3>
      <ol class="step-list">
        <li class="step-item">
          <span class="step-number">1</span>
          Go to <strong>Item Management</strong> section
        </li>
        <li class="step-item">
          <span class="step-number">2</span>
          Fill in item details: Name, Price, Stock Quantity
        </li>
        <li class="step-item">
          <span class="step-number">3</span>
          Select appropriate category
        </li>
        <li class="step-item">
          <span class="step-number">4</span>
          Add description (optional)
        </li>
        <li class="step-item">
          <span class="step-number">5</span>
          Click <strong>"Add Item"</strong> to save
        </li>
      </ol>
      <% } %>

      <h3>How to Create a Bill</h3>
      <ol class="step-list">
        <li class="step-item">
          <span class="step-number">1</span>
          Access <strong>Billing System</strong> and click <strong>"New Bill"</strong>
        </li>
        <li class="step-item">
          <span class="step-number">2</span>
          Select customer from dropdown list
        </li>
        <li class="step-item">
          <span class="step-number">3</span>
          Choose items and enter quantities
        </li>
        <li class="step-item">
          <span class="step-number">4</span>
          Add more items using <strong>"Add Another Item"</strong> button
        </li>
        <li class="step-item">
          <span class="step-number">5</span>
          Apply discount if needed (percentage)
        </li>
        <li class="step-item">
          <span class="step-number">6</span>
          Select payment method and add notes
        </li>
        <li class="step-item">
          <span class="step-number">7</span>
          Review totals and click <strong>"Create Bill"</strong>
        </li>
        <li class="step-item">
          <span class="step-number">8</span>
          Print or download the bill as needed
        </li>
      </ol>

      <div class="alert alert-warning">
        <strong>Important:</strong> Stock quantities are automatically reduced when creating bills. Make sure stock levels are sufficient before creating bills.
      </div>
    </div>

    <!-- Shortcuts Section -->
    <div id="shortcuts" class="help-section">
      <h2 class="help-title">⌨️ Keyboard Shortcuts</h2>

      <table class="shortcut-table">
        <thead>
        <tr>
          <th>Action</th>
          <th>Shortcut</th>
          <th>Context</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>Print Bill</td>
          <td><span class="keyboard-key">Ctrl</span> + <span class="keyboard-key">P</span></td>
          <td>Bill view/print pages</td>
        </tr>
        <tr>
          <td>Quick Navigation</td>
          <td><span class="keyboard-key">Alt</span> + <span class="keyboard-key">D</span></td>
          <td>Go to Dashboard</td>
        </tr>
        <tr>
          <td>Search</td>
          <td><span class="keyboard-key">Ctrl</span> + <span class="keyboard-key">F</span></td>
          <td>Find on current page</td>
        </tr>
        <tr>
          <td>Refresh</td>
          <td><span class="keyboard-key">F5</span></td>
          <td>Reload current page</td>
        </tr>
        <tr>
          <td>Help</td>
          <td><span class="keyboard-key">F1</span></td>
          <td>Open help page</td>
        </tr>
        </tbody>
      </table>

      <h3>Form Navigation Tips</h3>
      <ul>
        <li>Use <span class="keyboard-key">Tab</span> to move between form fields</li>
        <li>Use <span class="keyboard-key">Enter</span> to submit forms</li>
        <li>Use <span class="keyboard-key">Esc</span> to cancel form inputs</li>
      </ul>
    </div>

    <!-- FAQ Section -->
    <div id="faq" class="help-section">
      <h2 class="help-title">❓ Frequently Asked Questions</h2>

      <div class="faq-item">
        <div class="faq-question" onclick="toggleFaq(this)">
          How do I reset my password?
        </div>
        <div class="faq-answer">
          <% if ("Admin".equals(userRole)) { %>
          As an Admin, you can reset passwords through the User Management section. For your own password, contact your system administrator.
          <% } else { %>
          Contact your system administrator or an Admin user to reset your password.
          <% } %>
        </div>
      </div>

      <div class="faq-item">
        <div class="faq-question" onclick="toggleFaq(this)">
          What happens if I create a bill with insufficient stock?
        </div>
        <div class="faq-answer">
          The system will check stock availability before creating the bill. If there's insufficient stock, you'll get an error message and the bill won't be created. Make sure to check stock levels or update inventory first.
        </div>
      </div>

      <div class="faq-item">
        <div class="faq-question" onclick="toggleFaq(this)">
          Can I edit a bill after it's created?
        </div>
        <div class="faq-answer">
          Currently, bills cannot be edited after creation to maintain transaction integrity. If you need to make changes, <% if ("Admin".equals(userRole)) { %>you can delete the bill and create a new one<% } else { %>contact an Admin to delete the bill and create a new one<% } %>.
        </div>
      </div>

      <div class="faq-item">
        <div class="faq-question" onclick="toggleFaq(this)">
          How do I check low stock items?
        </div>
        <div class="faq-answer">
          <% if (!"Staff".equals(userRole)) { %>
          Go to Item Management and look for items with low stock status (usually highlighted in yellow or red). You can also use the filtering options to view only low stock items.
          <% } else { %>
          Contact your Manager or Admin to check low stock items. Staff members can view item information but cannot access inventory management directly.
          <% } %>
        </div>
      </div>

      <div class="faq-item">
        <div class="faq-question" onclick="toggleFaq(this)">
          Can I export customer or sales data?
        </div>
        <div class="faq-answer">
          Currently, you can download individual bills as TXT files. For bulk data export, contact your system administrator for additional reporting features.
        </div>
      </div>

      <div class="faq-item">
        <div class="faq-question" onclick="toggleFaq(this)">
          What browsers are supported?
        </div>
        <div class="faq-answer">
          The system works best with modern browsers including Chrome, Firefox, Safari, and Edge. Make sure JavaScript is enabled for full functionality.
        </div>
      </div>
    </div>

    <!-- Troubleshooting Section -->
    <div id="troubleshooting" class="help-section">
      <h2 class="help-title">🔧 Troubleshooting</h2>

      <h3>Common Issues and Solutions</h3>

      <div class="feature-card">
        <div class="feature-title">🚫 Login Issues</div>
        <p><strong>Problem:</strong> Cannot log in or "Invalid credentials" message</p>
        <p><strong>Solutions:</strong></p>
        <ul>
          <li>Check your username and password for typos</li>
          <li>Ensure Caps Lock is off</li>
          <li>Contact Admin for password reset</li>
          <li>Clear browser cache and cookies</li>
        </ul>
      </div>

      <div class="feature-card">
        <div class="feature-title">🐌 Slow Performance</div>
        <p><strong>Problem:</strong> System running slowly</p>
        <p><strong>Solutions:</strong></p>
        <ul>
          <li>Close unnecessary browser tabs</li>
          <li>Clear browser cache</li>
          <li>Check internet connection</li>
          <li>Try refreshing the page</li>
        </ul>
      </div>

      <div class="feature-card">
        <div class="feature-title">🖨️ Printing Issues</div>
        <p><strong>Problem:</strong> Bills not printing correctly</p>
        <p><strong>Solutions:</strong></p>
        <ul>
          <li>Check printer connection and paper</li>
          <li>Use "Print Preview" before printing</li>
          <li>Try downloading TXT version instead</li>
          <li>Adjust browser print settings</li>
        </ul>
      </div>

      <div class="feature-card">
        <div class="feature-title">📊 Data Not Showing</div>
        <p><strong>Problem:</strong> Expected data not appearing</p>
        <p><strong>Solutions:</strong></p>
        <ul>
          <li>Refresh the page (F5)</li>
          <li>Check your user permissions</li>
          <li>Verify data was saved correctly</li>
          <li>Contact Admin if issue persists</li>
        </ul>
      </div>

      <div class="alert alert-info">
        <strong>Need More Help?</strong> If you continue to experience issues, contact your system administrator or IT support team with details about the problem and any error messages you see.
      </div>

      <h3>System Requirements</h3>
      <ul>
        <li><strong>Browser:</strong> Chrome 80+, Firefox 75+, Safari 13+, Edge 80+</li>
        <li><strong>JavaScript:</strong> Must be enabled</li>
        <li><strong>Internet:</strong> Stable connection required</li>
        <li><strong>Screen:</strong> Minimum 1024x768 resolution</li>
      </ul>
    </div>
  </div>
</div>

<script>
  // Tab navigation
  function showSection(sectionId) {
    // Hide all sections
    const sections = document.querySelectorAll('.help-section');
    sections.forEach(section => section.classList.remove('active'));

    // Remove active class from all tabs
    const tabs = document.querySelectorAll('.nav-tab');
    tabs.forEach(tab => tab.classList.remove('active'));

    // Show selected section
    document.getElementById(sectionId).classList.add('active');

    // Add active class to clicked tab
    event.target.classList.add('active');
  }

  // FAQ toggle
  function toggleFaq(questionElement) {
    const answer = questionElement.nextElementSibling;
    answer.classList.toggle('show');
  }

  // Keyboard shortcuts
  document.addEventListener('keydown', function(event) {
    if (event.key === 'F1') {
      event.preventDefault();
      // Already on help page
    }

    if (event.altKey && event.key === 'd') {
      event.preventDefault();
      window.location.href = 'dashboard.jsp';
    }
  });

  // Auto-scroll to section if specified in URL
  window.addEventListener('load', function() {
    const hash = window.location.hash.substring(1);
    if (hash) {
      showSection(hash);
    }
  });
</script>
</body>
</html>