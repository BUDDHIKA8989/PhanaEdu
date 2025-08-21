<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 2:44 AM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/customers.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%@ page import="com.pahanaedu.models.Customer" %>
<%@ page import="java.util.List" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    Customer editCustomer = (Customer) request.getAttribute("customer");
    boolean editMode = request.getAttribute("editMode") != null;

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management - Pahana Edu</title>
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

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
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

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 5px;
            font-size: 14px;
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
        }

        .btn-primary { background: #3498db; color: white; }
        .btn-success { background: #27ae60; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-danger {
            background: #e74c3c;
            color: white;
        }

        .btn:hover { opacity: 0.9; }

        .btn-danger:hover {
            background: #c0392b;
        }

        .btn-danger:disabled {
            background: #95a5a6;
            cursor: not-allowed;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 12px;
            margin-right: 5px;
        }

        .actions-cell {
            white-space: nowrap;
        }

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

        .message {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .actions-cell {
            white-space: nowrap;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1>Customer Management</h1>
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

    <!-- Customer Form -->
    <div class="form-container">
        <h3><%= editMode ? "Edit Customer" : "Add New Customer" %></h3>

        <form action="customer" method="post">
            <input type="hidden" name="action" value="<%= editMode ? "update" : "add" %>">
            <% if (editMode && editCustomer != null) { %>
            <input type="hidden" name="customerId" value="<%= editCustomer.getCustomerId() %>">
            <% } %>

            <div class="form-grid">
                <div class="form-group">
                    <label for="customerName">Customer Name *</label>
                    <input type="text" id="customerName" name="customerName"
                           value="<%= editMode && editCustomer != null ? editCustomer.getCustomerName() : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="text" id="phoneNumber" name="phoneNumber"
                           value="<%= editMode && editCustomer != null ? (editCustomer.getPhoneNumber() != null ? editCustomer.getPhoneNumber() : "") : "" %>">
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email"
                           value="<%= editMode && editCustomer != null ? (editCustomer.getEmail() != null ? editCustomer.getEmail() : "") : "" %>">
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address"
                           value="<%= editMode && editCustomer != null ? (editCustomer.getAddress() != null ? editCustomer.getAddress() : "") : "" %>">
                </div>
            </div>

            <div>
                <button type="submit" class="btn btn-success">
                    <%= editMode ? "Update Customer" : "Add Customer" %>
                </button>

                <% if (editMode) { %>
                <a href="customer" class="btn btn-secondary">Cancel</a>
                <% } %>
            </div>
        </form>
    </div>

    <!-- Customer List -->
    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Account Number</th>
                <th>Customer Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Registration Date</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% if (customers != null && !customers.isEmpty()) { %>
            <% for (Customer customer : customers) { %>
            <tr>
                <td><%= customer.getAccountNumber() %></td>
                <td><%= customer.getCustomerName() %></td>
                <td><%= customer.getPhoneNumber() != null ? customer.getPhoneNumber() : "-" %></td>
                <td><%= customer.getEmail() != null ? customer.getEmail() : "-" %></td>
                <td><%= customer.getRegistrationDate() %></td>
                <td class="actions-cell">
                    <a href="customer?action=edit&accountNumber=<%= customer.getAccountNumber() %>"
                       class="btn btn-warning btn-small">Edit</a>

                    <% if (user.isAdmin()) { %>
                    <form action="customer" method="post" style="display: inline; margin-left: 5px;"
                          onsubmit="return confirmDelete('<%= customer.getCustomerName() %>')">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
                        <button type="submit" class="btn btn-danger btn-small">Delete</button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <% } %>
            <% } else { %>
            <tr>
                <td colspan="6" style="text-align: center; color: #7f8c8d;">
                    No customers found. Add your first customer above.
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function confirmDelete(customerName) {
        return confirm('Are you sure you want to delete customer "' + customerName + '"?\n\n' +
            'This action cannot be undone. The customer will be permanently removed from the system.\n\n' +
            'Note: Customers with existing bills cannot be deleted.');
    }

    // Optional: Add double-click protection
    let deleteInProgress = false;
    document.addEventListener('DOMContentLoaded', function() {
        const deleteForms = document.querySelectorAll('form[onsubmit*="confirmDelete"]');
        deleteForms.forEach(form => {
            form.addEventListener('submit', function(e) {
                if (deleteInProgress) {
                    e.preventDefault();
                    return false;
                }
                deleteInProgress = true;
                setTimeout(() => deleteInProgress = false, 3000);
            });
        });
    });
</script>

</body>
</html>