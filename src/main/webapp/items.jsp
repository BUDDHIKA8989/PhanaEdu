<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 2:44 AM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/items.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%@ page import="com.pahanaedu.models.Item" %>
<%@ page import="java.util.List" %>
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

    List<Item> items = (List<Item>) request.getAttribute("items");
    Item editItem = (Item) request.getAttribute("item");
    boolean editMode = request.getAttribute("editMode") != null;

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String selectedCategory = (String) request.getAttribute("selectedCategory");

    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Management - Pahana Edu</title>
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

        .search-filter-container {
            display: grid;
            grid-template-columns: 1fr 1fr 200px;
            gap: 15px;
            margin-bottom: 20px;
            padding: 20px;
            background: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
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

        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 5px;
            font-size: 14px;
        }

        .form-group textarea {
            height: 80px;
            resize: vertical;
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
        .btn-danger { background: #e74c3c; color: white; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-small { padding: 5px 10px; font-size: 12px; }

        .btn:hover { opacity: 0.9; }

        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        th {
            background: #f8f9fa;
            font-weight: bold;
            color: #2c3e50;
        }

        .stock-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .in-stock { background: #d4edda; color: #155724; }
        .low-stock { background: #fff3cd; color: #856404; }
        .out-of-stock { background: #f8d7da; color: #721c24; }

        .message {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .quick-stock {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .quick-stock input {
            width: 60px;
            padding: 4px;
            border: 1px solid #bdc3c7;
            border-radius: 3px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>Item Management</h1>
            <p>Welcome, <%= user.getFullName() %> (<%= user.getRole() %>)</p>
        </div>
        <div>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            <a href="login" class="btn btn-secondary">Logout</a>
        </div>
    </div>

    <!-- Search and Filter -->
    <div class="search-filter-container">
        <form action="item" method="get" style="display: flex; gap: 10px;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="searchTerm" placeholder="Search items..."
                   value="<%= searchTerm != null ? searchTerm : "" %>" style="flex: 1;">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>

        <form action="item" method="get" style="display: flex; gap: 10px;">
            <input type="hidden" name="action" value="category">
            <select name="category" onchange="this.form.submit()" style="flex: 1;">
                <option value="">All Categories</option>
                <option value="Textbook" <%= "Textbook".equals(selectedCategory) ? "selected" : "" %>>Textbook</option>
                <option value="Stationery" <%= "Stationery".equals(selectedCategory) ? "selected" : "" %>>Stationery</option>
                <option value="Reference" <%= "Reference".equals(selectedCategory) ? "selected" : "" %>>Reference</option>
                <option value="Fiction" <%= "Fiction".equals(selectedCategory) ? "selected" : "" %>>Fiction</option>
            </select>
        </form>

        <a href="item" class="btn btn-secondary">View All</a>
    </div>

    <!-- Messages -->
    <% if (successMessage != null) { %>
    <div class="message success"><%= successMessage %></div>
    <% } %>

    <% if (errorMessage != null) { %>
    <div class="message error"><%= errorMessage %></div>
    <% } %>

    <!-- Item Form -->
    <div class="form-container">
        <h3><%= editMode ? "Edit Item" : "Add New Item" %></h3>

        <form action="item" method="post">
            <input type="hidden" name="action" value="<%= editMode ? "update" : "add" %>">
            <% if (editMode && editItem != null) { %>
            <input type="hidden" name="itemId" value="<%= editItem.getItemId() %>">
            <% } %>

            <div class="form-grid">
                <div class="form-group">
                    <label for="itemName">Item Name *</label>
                    <input type="text" id="itemName" name="itemName"
                           value="<%= editMode && editItem != null ? editItem.getItemName() : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="price">Price (Rs.) *</label>
                    <input type="number" id="price" name="price" step="0.01" min="0.01"
                           value="<%= editMode && editItem != null ? editItem.getPrice() : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="stockQuantity">Stock Quantity *</label>
                    <input type="number" id="stockQuantity" name="stockQuantity" min="0"
                           value="<%= editMode && editItem != null ? editItem.getStockQuantity() : "" %>"
                           required>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category">
                        <option value="">Select Category</option>
                        <option value="Textbook" <%= editMode && editItem != null && "Textbook".equals(editItem.getCategory()) ? "selected" : "" %>>Textbook</option>
                        <option value="Stationery" <%= editMode && editItem != null && "Stationery".equals(editItem.getCategory()) ? "selected" : "" %>>Stationery</option>
                        <option value="Reference" <%= editMode && editItem != null && "Reference".equals(editItem.getCategory()) ? "selected" : "" %>>Reference</option>
                        <option value="Fiction" <%= editMode && editItem != null && "Fiction".equals(editItem.getCategory()) ? "selected" : "" %>>Fiction</option>
                    </select>
                </div>

                <div class="form-group" style="grid-column: span 2;">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" placeholder="Enter item description..."><%= editMode && editItem != null && editItem.getDescription() != null ? editItem.getDescription() : "" %></textarea>
                </div>
            </div>

            <div>
                <button type="submit" class="btn btn-success">
                    <%= editMode ? "Update Item" : "Add Item" %>
                </button>

                <% if (editMode) { %>
                <a href="item" class="btn btn-secondary">Cancel</a>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Item List -->
    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Item Name</th>
                <th>Category</th>
                <th>Price (Rs.)</th>
                <th>Stock</th>
                <th>Status</th>
                <th>Total Value</th>
                <th>Quick Stock Update</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% if (items != null && !items.isEmpty()) { %>
            <% for (Item item : items) { %>
            <tr>
                <td>
                    <strong><%= item.getItemName() %></strong>
                    <% if (item.getDescription() != null && !item.getDescription().isEmpty()) { %>
                    <br><small style="color: #7f8c8d;"><%= item.getDescription() %></small>
                    <% } %>
                </td>
                <td><%= item.getCategory() != null ? item.getCategory() : "-" %></td>
                <td>Rs. <%= df.format(item.getPrice()) %></td>
                <td><%= item.getStockQuantity() %></td>
                <td>
                                    <span class="stock-status <%= item.isOutOfStock() ? "out-of-stock" : (item.isLowStock() ? "low-stock" : "in-stock") %>">
                                        <%= item.getStockStatus() %>
                                    </span>
                </td>
                <td>Rs. <%= df.format(item.getTotalValue()) %></td>
                <td>
                    <form action="item" method="post" class="quick-stock">
                        <input type="hidden" name="action" value="updateStock">
                        <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                        <input type="number" name="stockQuantity" value="<%= item.getStockQuantity() %>" min="0">
                        <button type="submit" class="btn btn-primary btn-small">Update</button>
                    </form>
                </td>
                <td>
                    <a href="item?action=edit&itemId=<%= item.getItemId() %>"
                       class="btn btn-warning btn-small">Edit</a>

                    <% if (user.isAdmin()) { %>
                    <form action="item" method="post" style="display: inline;"
                          onsubmit="return confirm('Are you sure you want to delete this item?')">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                        <button type="submit" class="btn btn-danger btn-small">Delete</button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <% } %>
            <% } else { %>
            <tr>
                <td colspan="8" style="text-align: center; color: #7f8c8d;">
                    No items found. Add your first item above.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <!-- Summary Statistics -->
    <% if (items != null && !items.isEmpty()) { %>
    <%
        int totalItems = items.size();
        int inStockItems = 0;
        int lowStockItems = 0;
        int outOfStockItems = 0;
        double totalValue = 0;

        for (Item item : items) {
            if (item.isOutOfStock()) outOfStockItems++;
            else if (item.isLowStock()) lowStockItems++;
            else inStockItems++;
            totalValue += item.getTotalValue();
        }
    %>
    <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px; margin-top: 20px;">
        <div style="background: white; padding: 20px; border-radius: 5px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
            <h3 style="margin: 0; color: #3498db;"><%= totalItems %></h3>
            <p style="margin: 5px 0 0 0; color: #7f8c8d;">Total Items</p>
        </div>
        <div style="background: white; padding: 20px; border-radius: 5px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
            <h3 style="margin: 0; color: #27ae60;"><%= inStockItems %></h3>
            <p style="margin: 5px 0 0 0; color: #7f8c8d;">In Stock</p>
        </div>
        <div style="background: white; padding: 20px; border-radius: 5px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
            <h3 style="margin: 0; color: #f39c12;"><%= lowStockItems %></h3>
            <p style="margin: 5px 0 0 0; color: #7f8c8d;">Low Stock</p>
        </div>
        <div style="background: white; padding: 20px; border-radius: 5px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
            <h3 style="margin: 0; color: #e74c3c;"><%= outOfStockItems %></h3>
            <p style="margin: 5px 0 0 0; color: #7f8c8d;">Out of Stock</p>
        </div>
        <div style="background: white; padding: 20px; border-radius: 5px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
            <h3 style="margin: 0; color: #8e44ad;">Rs. <%= df.format(totalValue) %></h3>
            <p style="margin: 5px 0 0 0; color: #7f8c8d;">Total Value</p>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>