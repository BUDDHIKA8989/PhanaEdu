// File: src/main/java/com/pahanaedu/models/BillItem.java
package com.pahanaedu.models;

public class BillItem {
    private int billItemId;
    private int billId;
    private int itemId;
    private String itemName;
    private int quantity;
    private double unitPrice;
    private double lineTotal;

    // Default constructor
    public BillItem() {}

    // Constructor with essential parameters
    public BillItem(int itemId, String itemName, int quantity, double unitPrice) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        calculateLineTotal();
    }

    // Constructor with all parameters
    public BillItem(int billId, int itemId, String itemName, int quantity, double unitPrice) {
        this.billId = billId;
        this.itemId = itemId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        calculateLineTotal();
    }

    // Business logic methods
    public void calculateLineTotal() {
        this.lineTotal = this.quantity * this.unitPrice;
    }

    public boolean isValid() {
        return itemId > 0 && quantity > 0 && unitPrice > 0;
    }

    // Method overloading for updating quantity
    public void updateQuantity(int newQuantity) {
        this.quantity = newQuantity;
        calculateLineTotal();
    }

    public void updatePrice(double newPrice) {
        this.unitPrice = newPrice;
        calculateLineTotal();
    }

    public void updateQuantityAndPrice(int newQuantity, double newPrice) {
        this.quantity = newQuantity;
        this.unitPrice = newPrice;
        calculateLineTotal();
    }

    // Getters and Setters
    public int getBillItemId() { return billItemId; }
    public void setBillItemId(int billItemId) { this.billItemId = billItemId; }

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
        calculateLineTotal();
    }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        calculateLineTotal();
    }

    public double getLineTotal() { return lineTotal; }
    public void setLineTotal(double lineTotal) { this.lineTotal = lineTotal; }

    @Override
    public String toString() {
        return "BillItem{" +
                "itemName='" + itemName + '\'' +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", lineTotal=" + lineTotal +
                '}';
    }
}