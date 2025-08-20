// File: src/main/java/com/pahanaedu/dao/UserDAO.java
package com.pahanaedu.dao;

import com.pahanaedu.models.User;
import com.pahanaedu.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // Method to authenticate user login
    public User authenticateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setFullName(rs.getString("full_name"));
                user.setCreatedDate(rs.getString("created_date"));
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null; // Return null if authentication fails
    }

    // Method to get user by ID
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setFullName(rs.getString("full_name"));
                user.setCreatedDate(rs.getString("created_date"));
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Test method to verify DAO is working
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();

        // Test with sample data from your database
        User user = userDAO.authenticateUser("admin", "admin123");

        if (user != null) {
            System.out.println("✅ User authentication successful!");
            System.out.println("User: " + user.getFullName());
            System.out.println("Role: " + user.getRole());
        } else {
            System.out.println("❌ User authentication failed!");
        }
    }
}