// File: src/main/java/com/pahanaedu/models/User.java
package com.pahanaedu.models;

public class User {
    private int userId;
    private String username;
    private String password;
    private String role;
    private String fullName;
    private String createdDate;

    // Default constructor
    public User() {}

    // Constructor with parameters
    public User(String username, String password, String role, String fullName) {
        this.username = username;
        this.password = password;
        this.role = role;
        this.fullName = fullName;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getCreatedDate() { return createdDate; }
    public void setCreatedDate(String createdDate) { this.createdDate = createdDate; }

    // Add these methods to your User.java class

    public boolean isAdmin() {
        return "Admin".equals(role);
    }

    public boolean isManager() {
        return "Manager".equals(role);
    }

    public boolean isStaff() {
        return "Staff".equals(role);
    }
}