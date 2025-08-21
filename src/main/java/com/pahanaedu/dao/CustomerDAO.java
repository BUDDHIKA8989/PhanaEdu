// File: src/main/java/com/pahanaedu/dao/CustomerDAO.java
package com.pahanaedu.dao;

import com.pahanaedu.models.Customer;
import com.pahanaedu.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // Add new customer with improved
    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO customers (account_number, customer_name, address, phone_number, email) VALUES (?, ?, ?, ?, ?)";

        // Generate unique account number if not provided
        if (customer.getAccountNumber() == null || customer.getAccountNumber().trim().isEmpty()) {
            String accountNumber = generateUniqueAccountNumber();
            customer.setAccountNumber(accountNumber);
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getCustomerName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getPhoneNumber());
            stmt.setString(5, customer.getEmail());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("Error adding customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Generate unique account number with proper logic
    private String generateUniqueAccountNumber() {
        String accountNumber;
        int maxAttempts = 100;
        int attempt = 0;

        do {
            accountNumber = generateNextAccountNumber();
            attempt++;

            if (attempt > maxAttempts) {
                // Fallback to timestamp-based generation
                long timestamp = System.currentTimeMillis();
                accountNumber = "CUST" + String.format("%03d", (int)(timestamp % 1000));
                break;
            }

        } while (accountNumberExists(accountNumber));

        return accountNumber;
    }

    // Generate next sequential account number
    private String generateNextAccountNumber() {
        String sql = "SELECT COALESCE(MAX(CAST(SUBSTRING(account_number, 5) AS UNSIGNED)), 0) + 1 as next_number " +
                "FROM customers WHERE account_number REGEXP '^CUST[0-9]+$'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int nextNumber = rs.getInt("next_number");
                return String.format("CUST%03d", nextNumber);
            }

        } catch (SQLException e) {
            System.err.println("Error generating account number: " + e.getMessage());
            e.printStackTrace();
        }

        return "CUST001"; // Default fallback
    }

    // Check if account number already exists
    private boolean accountNumberExists(String accountNumber) {
        String sql = "SELECT COUNT(*) FROM customers WHERE account_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, accountNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error checking account number: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // Get all customers
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY customer_name";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAccountNumber(rs.getString("account_number"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setEmail(rs.getString("email"));
                customer.setRegistrationDate(rs.getString("registration_date"));
                customers.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }

    // Get customer by account number
    public Customer getCustomerByAccountNumber(String accountNumber) {
        String sql = "SELECT * FROM customers WHERE account_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, accountNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAccountNumber(rs.getString("account_number"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setEmail(rs.getString("email"));
                customer.setRegistrationDate(rs.getString("registration_date"));
                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get customer by ID
    public Customer getCustomerById(int customerId) {
        String sql = "SELECT * FROM customers WHERE customer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setAccountNumber(rs.getString("account_number"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setEmail(rs.getString("email"));
                customer.setRegistrationDate(rs.getString("registration_date"));
                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Update customer
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE customers SET customer_name = ?, address = ?, phone_number = ?, email = ? WHERE customer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customer.getCustomerName());
            stmt.setString(2, customer.getAddress());
            stmt.setString(3, customer.getPhoneNumber());
            stmt.setString(4, customer.getEmail());
            stmt.setInt(5, customer.getCustomerId());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete customer
    public boolean deleteCustomer(int customerId) {
        // First check if customer has any bills
        if (customerHasBills(customerId)) {
            return false;
        }

        String deleteSql = "DELETE FROM customers WHERE customer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(deleteSql)) {

            stmt.setInt(1, customerId);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Mark customer inactive (alternative to deletion)
    public boolean markCustomerInactive(int customerId) {
        String sql = "UPDATE customers SET is_active = false WHERE customer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if customer has bills
    public boolean customerHasBills(int customerId) {
        String sql = "SELECT COUNT(*) as bill_count FROM bills WHERE customer_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("bill_count") > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // FIXED: Generate next account number (used by servlet)
    public String generateAccountNumber() {
        return generateUniqueAccountNumber();
    }

    // Test method
    public static void main(String[] args) {
        CustomerDAO customerDAO = new CustomerDAO();

        // Test generating account number
        String accountNumber = customerDAO.generateAccountNumber();
        System.out.println("Generated Account Number: " + accountNumber);

        // Test getting all customers
        List<Customer> customers = customerDAO.getAllCustomers();
        System.out.println("Total customers: " + customers.size());

        for (Customer customer : customers) {
            System.out.println("Customer: " + customer.getCustomerName() +
                    " - Account: " + customer.getAccountNumber());
        }
    }
}