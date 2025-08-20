// File: src/main/java/com/pahanaedu/models/Customer.java
package com.pahanaedu.models;

public class Customer {
    private int customerId;
    private String accountNumber;
    private String customerName;
    private String address;
    private String phoneNumber;
    private String email;
    private String registrationDate;

    // Default constructor
    public Customer() {}

    // Constructor with parameters
    public Customer(String accountNumber, String customerName, String address,
                    String phoneNumber, String email) {
        this.accountNumber = accountNumber;
        this.customerName = customerName;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.email = email;
    }

    // Getters and Setters
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(String registrationDate) { this.registrationDate = registrationDate; }
}