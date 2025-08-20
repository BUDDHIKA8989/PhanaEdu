<%--
  Created by IntelliJ IDEA.
  User: BUDDHIKA
  Date: 8/20/2025
  Time: 2:44 AM
  To change this template use File | Settings | File Templates.
--%>
<%-- File: src/main/webapp/billing.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.models.User" %>
<%@ page import="com.pahanaedu.models.Customer" %>
<%@ page import="com.pahanaedu.models.Item" %>
<%@ page import="com.pahanaedu.models.Bill" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    List<Item> items = (List<Item>) request.getAttribute("items");
    List<Bill> recentBills = (List<Bill>) request.getAttribute("recentBills");

    boolean newBill = request.getAttribute("newBill") != null;
    Integer todayBillsCount = (Integer) request.getAttribute("todayBillsCount");
    Double todayTotalSales = (Double) request.getAttribute("todayTotalSales");

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing System - Pahana Edu</title>
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .stat-card h3 {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #3498db;
        }

        .stat-card p {
            color: #7f8c8d;
            font-size: 1.1rem;
        }

        .bill-form-container {
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

        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 5px;
            font-size: 14px;
        }

        .items-section {
            margin-top: 30px;
            padding: 20px;
            border: 2px solid #ecf0f1;
            border-radius: 10px;
            background: #f8f9fa;
        }

        .item-row {
            display: grid;
            grid-template-columns: 2fr 1fr auto;
            gap: 15px;
            align-items: end;
            margin-bottom: 15px;
            padding: 15px;
            background: white;
            border-radius: 5px;
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

        .message {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .total-section {
            background: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .total-row.final {
            font-size: 1.5rem;
            font-weight: bold;
            border-top: 2px solid white;
            padding-top: 10px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <div class="header">
        <div>
            <h1><%= newBill ? "Create New Bill" : "Billing System" %></h1>
            <p>Welcome, <%= user.getFullName() %> (<%= user.getRole() %>)</p>
        </div>
        <div>
            <% if (!newBill) { %>
            <a href="bill?action=new" class="btn btn-success">New Bill</a>
            <a href="bill?action=list" class="btn btn-warning">View All Bills</a>
            <% } %>
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

    <% if (newBill) { %>
    <!-- New Bill Form -->
    <div class="bill-form-container">
        <h3>Bill Information</h3>

        <form id="billForm" action="bill" method="post">
            <input type="hidden" name="action" value="create">

            <div class="form-grid">
                <div class="form-group">
                    <label for="customerId">Select Customer *</label>
                    <select id="customerId" name="customerId" required>
                        <option value="">Choose a customer...</option>
                        <% if (customers != null) { %>
                        <% for (Customer customer : customers) { %>
                        <option value="<%= customer.getCustomerId() %>">
                            <%= customer.getCustomerName() %> (<%= customer.getAccountNumber() %>)
                        </option>
                        <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="paymentMethod">Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod">
                        <option value="Cash">Cash</option>
                        <option value="Card">Card</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                    </select>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="discountPercentage">Discount Percentage (%)</label>
                    <input type="number" id="discountPercentage" name="discountPercentage"
                           min="0" max="100" step="0.01" value="0" onchange="calculateTotal()">
                </div>

                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea id="notes" name="notes" rows="3" placeholder="Additional notes..."></textarea>
                </div>
            </div>

            <!-- Items Section -->
            <div class="items-section">
                <h4>Bill Items</h4>
                <div id="itemsContainer">
                    <div class="item-row">
                        <div class="form-group">
                            <label>Select Item</label>
                            <select name="itemId" onchange="updatePrice(this)" required>
                                <option value="">Choose an item...</option>
                                <% if (items != null) { %>
                                <% for (Item item : items) { %>
                                <option value="<%= item.getItemId() %>"
                                        data-price="<%= item.getPrice() %>"
                                        data-stock="<%= item.getStockQuantity() %>">
                                    <%= item.getItemName() %> - Rs.<%= df.format(item.getPrice()) %>
                                    (Stock: <%= item.getStockQuantity() %>)
                                </option>
                                <% } %>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Quantity</label>
                            <input type="number" name="quantity" min="1" value="1"
                                   onchange="calculateTotal()" required>
                        </div>

                        <button type="button" class="btn btn-danger btn-small" onclick="removeItemRow(this)">Remove</button>
                    </div>
                </div>

                <button type="button" class="btn btn-primary" onclick="addItemRow()">Add Another Item</button>

                <!-- Total Section -->
                <div class="total-section" id="totalSection">
                    <div class="total-row">
                        <span>Subtotal:</span>
                        <span id="subtotalAmount">Rs. 0.00</span>
                    </div>
                    <div class="total-row">
                        <span>Discount:</span>
                        <span id="discountAmount">Rs. 0.00</span>
                    </div>
                    <div class="total-row final">
                        <span>Final Total:</span>
                        <span id="finalAmount">Rs. 0.00</span>
                    </div>
                </div>
            </div>

            <div style="margin-top: 30px;">
                <button type="submit" class="btn btn-success" style="font-size: 1.2rem; padding: 15px 30px;">
                    Create Bill
                </button>
                <a href="bill" class="btn btn-secondary" style="font-size: 1.2rem; padding: 15px 30px;">Cancel</a>
            </div>
        </form>
    </div>

    <% } else { %>
    <!-- Billing Dashboard -->

    <!-- Today's Statistics -->
    <div class="stats-grid">
        <div class="stat-card">
            <h3><%= todayBillsCount != null ? todayBillsCount : 0 %></h3>
            <p>Today's Bills</p>
        </div>
        <div class="stat-card">
            <h3>Rs. <%= todayTotalSales != null ? df.format(todayTotalSales) : "0.00" %></h3>
            <p>Today's Sales</p>
        </div>
        <div class="stat-card">
            <h3><%= recentBills != null ? recentBills.size() : 0 %></h3>
            <p>Recent Bills</p>
        </div>
        <div class="stat-card">
            <h3>⚡</h3>
            <p>Quick Actions</p>
        </div>
    </div>

    <!-- Recent Bills -->
    <% if (recentBills != null && !recentBills.isEmpty()) { %>
    <div class="table-container">
        <h3 style="padding: 20px; margin: 0; background: #f8f9fa; border-bottom: 1px solid #ecf0f1;">Recent Bills</h3>
        <table>
            <thead>
            <tr>
                <th>Bill Number</th>
                <th>Customer</th>
                <th>Date</th>
                <th>Amount</th>
                <th>Payment Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% for (Bill bill : recentBills) { %>
            <tr>
                <td><strong><%= bill.getBillNumber() %></strong></td>
                <td><%= bill.getCustomerName() %></td>
                <td><%= bill.getBillDate() %></td>
                <td>Rs. <%= df.format(bill.getFinalAmount()) %></td>
                <td>
                                        <span style="padding: 4px 8px; border-radius: 4px; font-size: 12px;
                                                background: <%= bill.isPaid() ? "#d4edda" : "#fff3cd" %>;
                                                color: <%= bill.isPaid() ? "#155724" : "#856404" %>;">
                                            <%= bill.getPaymentStatus() %>
                                        </span>
                </td>
                <td>
                    <a href="bill?action=view&billId=<%= bill.getBillId() %>"
                       class="btn btn-primary btn-small">View</a>
                    <a href="bill?action=print&billId=<%= bill.getBillId() %>"
                       class="btn btn-warning btn-small">Print</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <div style="text-align: center; padding: 40px; background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h3 style="color: #7f8c8d;">No bills created yet</h3>
        <p style="color: #7f8c8d;">Click "New Bill" to create your first bill</p>
        <a href="bill?action=new" class="btn btn-success">Create First Bill</a>
    </div>
    <% } %>
    <% } %>
</div>

<!-- JavaScript for Bill Form -->
<% if (newBill) { %>
<script>
    function addItemRow() {
        const container = document.getElementById('itemsContainer');
        const firstRow = container.querySelector('.item-row');
        const newRow = firstRow.cloneNode(true);

        // Clear values
        const selects = newRow.querySelectorAll('select');
        const inputs = newRow.querySelectorAll('input');

        selects.forEach(select => select.selectedIndex = 0);
        inputs.forEach(input => input.value = input.type === 'number' ? '1' : '');

        container.appendChild(newRow);
        calculateTotal();
    }

    function removeItemRow(button) {
        const container = document.getElementById('itemsContainer');
        if (container.children.length > 1) {
            button.closest('.item-row').remove();
            calculateTotal();
        } else {
            alert('At least one item is required');
        }
    }

    function updatePrice(selectElement) {
        const option = selectElement.options[selectElement.selectedIndex];
        const stock = option.getAttribute('data-stock');
        const quantityInput = selectElement.closest('.item-row').querySelector('input[name="quantity"]');

        if (stock) {
            quantityInput.max = stock;
            if (parseInt(quantityInput.value) > parseInt(stock)) {
                quantityInput.value = stock;
                alert('Quantity adjusted to available stock: ' + stock);
            }
        }

        calculateTotal();
    }

    function calculateTotal() {
        let subtotal = 0;
        const itemRows = document.querySelectorAll('.item-row');

        itemRows.forEach(row => {
            const select = row.querySelector('select[name="itemId"]');
            const quantityInput = row.querySelector('input[name="quantity"]');

            if (select.value && quantityInput.value) {
                const option = select.options[select.selectedIndex];
                const price = parseFloat(option.getAttribute('data-price')) || 0;
                const quantity = parseInt(quantityInput.value) || 0;

                subtotal += price * quantity;
            }
        });

        const discountPercentage = parseFloat(document.getElementById('discountPercentage').value) || 0;
        const discountAmount = subtotal * (discountPercentage / 100);
        const finalAmount = subtotal - discountAmount;

        document.getElementById('subtotalAmount').textContent = 'Rs. ' + subtotal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
        document.getElementById('discountAmount').textContent = 'Rs. ' + discountAmount.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
        document.getElementById('finalAmount').textContent = 'Rs. ' + finalAmount.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
    }

    // Initialize calculations
    document.addEventListener('DOMContentLoaded', function() {
        calculateTotal();

        // Add event listeners to all existing inputs
        const quantityInputs = document.querySelectorAll('input[name="quantity"]');
        quantityInputs.forEach(input => {
            input.addEventListener('input', calculateTotal);
        });
    });
</script>
<% } %>
</body>
</html>