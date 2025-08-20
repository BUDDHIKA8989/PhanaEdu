
package com.pahanaedu.models;

public class Item {
    private int itemId;
    private String itemName;
    private String description;
    private double price;
    private int stockQuantity;
    private String category;
    private String createdDate;

    // Default constructor
    public Item() {}

    // Constructor with essential parameters
    public Item(String itemName, double price, int stockQuantity) {
        this.itemName = itemName;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    // Constructor with all parameters
    public Item(String itemName, String description, double price,
                int stockQuantity, String category) {
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.category = category;
    }

    // Validation method
    public boolean isValid() {
        return itemName != null && !itemName.trim().isEmpty() &&
                price > 0 && stockQuantity >= 0;
    }

    // Business logic methods
    public boolean isInStock() {
        return stockQuantity > 0;
    }

    public boolean isLowStock() {
        return stockQuantity > 0 && stockQuantity <= 5; // Low stock threshold
    }

    public boolean isOutOfStock() {
        return stockQuantity == 0;
    }

    public String getStockStatus() {
        if (isOutOfStock()) return "Out of Stock";
        if (isLowStock()) return "Low Stock";
        return "In Stock";
    }

    public double getTotalValue() {
        return price * stockQuantity;
    }

    // Getters and Setters
    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) {
        this.itemName = itemName != null ? itemName.trim() : null;
    }

    public String getDescription() { return description; }
    public void setDescription(String description) {
        this.description = description != null ? description.trim() : null;
    }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getCategory() { return category; }
    public void setCategory(String category) {
        this.category = category != null ? category.trim() : null;
    }

    public String getCreatedDate() { return createdDate; }
    public void setCreatedDate(String createdDate) { this.createdDate = createdDate; }

    @Override
    public String toString() {
        return "Item{" +
                "itemId=" + itemId +
                ", itemName='" + itemName + '\'' +
                ", price=" + price +
                ", stockQuantity=" + stockQuantity +
                ", category='" + category + '\'' +
                '}';
    }
}