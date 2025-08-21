// File: src/main/java/com/pahanaedu/models/Bill.java
package com.pahanaedu.models;

import java.util.ArrayList;
import java.util.List;

public class Bill {
    private int billId;
    private String billNumber;
    private int customerId;
    private String customerName;
    private String customerAccountNumber;
    private String billDate;
    private double subtotal;
    private double discountPercentage;
    private double discountAmount;
    private double finalAmount;
    private String paymentMethod;
    private String paymentStatus;
    private int createdBy;
    private String createdByName;
    private String notes;

    // List of items in this bill
    private List<BillItem> billItems;

    // Default constructor
    public Bill() {
        this.billItems = new ArrayList<>();
        this.paymentMethod = "Cash";
        this.paymentStatus = "Pending";
        this.discountPercentage = 0.0;
    }


    public Bill(String billNumber, int customerId, int createdBy) {
        this();
        this.billNumber = billNumber;
        this.customerId = customerId;
        this.createdBy = createdBy;
    }

    public boolean isValid() {
        return billNumber != null && !billNumber.trim().isEmpty() &&
                customerId > 0 && billItems != null && !billItems.isEmpty();
    }

    public void calculateTotals() {
        this.subtotal = 0.0;

        // Calculate subtotal from all bill items
        for (BillItem item : billItems) {
            this.subtotal += item.getLineTotal();
        }

        // Calculate discount amount
        this.discountAmount = subtotal * (discountPercentage / 100);

        // Calculate final amount
        this.finalAmount = subtotal - discountAmount;
    }

    public void addBillItem(BillItem billItem) {
        if (billItems == null) {
            billItems = new ArrayList<>();
        }
        billItems.add(billItem);
        calculateTotals();
    }

    public void removeBillItem(BillItem billItem) {
        if (billItems != null) {
            billItems.remove(billItem);
            calculateTotals();
        }
    }

    public int getTotalItems() {
        return billItems != null ? billItems.size() : 0;
    }

    public int getTotalQuantity() {
        int total = 0;
        if (billItems != null) {
            for (BillItem item : billItems) {
                total += item.getQuantity();
            }
        }
        return total;
    }

    public boolean isPaid() {
        return "Paid".equals(paymentStatus);
    }

    public boolean isPending() {
        return "Pending".equals(paymentStatus);
    }

    public boolean isCancelled() {
        return "Cancelled".equals(paymentStatus);
    }

    // Getters and Setters
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public String getBillNumber() { return billNumber; }
    public void setBillNumber(String billNumber) { this.billNumber = billNumber; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerAccountNumber() { return customerAccountNumber; }
    public void setCustomerAccountNumber(String customerAccountNumber) {
        this.customerAccountNumber = customerAccountNumber;
    }

    public String getBillDate() { return billDate; }
    public void setBillDate(String billDate) { this.billDate = billDate; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getDiscountPercentage() { return discountPercentage; }
    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
        calculateTotals();
    }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    public double getFinalAmount() { return finalAmount; }
    public void setFinalAmount(double finalAmount) { this.finalAmount = finalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<BillItem> getBillItems() { return billItems; }
    public void setBillItems(List<BillItem> billItems) {
        this.billItems = billItems;
        calculateTotals();
    }

    @Override
    public String toString() {
        return "Bill{" +
                "billNumber='" + billNumber + '\'' +
                ", customerName='" + customerName + '\'' +
                ", finalAmount=" + finalAmount +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", totalItems=" + getTotalItems() +
                '}';
    }
}