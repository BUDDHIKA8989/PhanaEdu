// File: src/main/java/com/pahanaedu/dao/BillDAO.java
package com.pahanaedu.dao;

import com.pahanaedu.models.Bill;
import com.pahanaedu.models.BillItem;
import com.pahanaedu.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    // Create new bill with items (Transaction)
    public boolean createBill(Bill bill) {
        Connection conn = null;
        PreparedStatement billStmt = null;
        PreparedStatement itemStmt = null;
        PreparedStatement stockStmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert bill
            String billSql = "INSERT INTO bills (bill_number, customer_id, subtotal, discount_percentage, discount_amount, final_amount, payment_method, payment_status, created_by, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            billStmt = conn.prepareStatement(billSql, Statement.RETURN_GENERATED_KEYS);

            billStmt.setString(1, bill.getBillNumber());
            billStmt.setInt(2, bill.getCustomerId());
            billStmt.setDouble(3, bill.getSubtotal());
            billStmt.setDouble(4, bill.getDiscountPercentage());
            billStmt.setDouble(5, bill.getDiscountAmount());
            billStmt.setDouble(6, bill.getFinalAmount());
            billStmt.setString(7, bill.getPaymentMethod());
            billStmt.setString(8, bill.getPaymentStatus());
            billStmt.setInt(9, bill.getCreatedBy());
            billStmt.setString(10, bill.getNotes());

            int billRows = billStmt.executeUpdate();

            if (billRows == 0) {
                conn.rollback();
                return false;
            }

            // Get generated bill ID
            ResultSet rs = billStmt.getGeneratedKeys();
            int billId = 0;
            if (rs.next()) {
                billId = rs.getInt(1);
                bill.setBillId(billId);
            }

            // 2. Insert bill items
            String itemSql = "INSERT INTO bill_items (bill_id, item_id, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?)";
            itemStmt = conn.prepareStatement(itemSql);

            String stockSql = "UPDATE items SET stock_quantity = stock_quantity - ? WHERE item_id = ?";
            stockStmt = conn.prepareStatement(stockSql);

            for (BillItem billItem : bill.getBillItems()) {
                // Insert bill item
                itemStmt.setInt(1, billId);
                itemStmt.setInt(2, billItem.getItemId());
                itemStmt.setInt(3, billItem.getQuantity());
                itemStmt.setDouble(4, billItem.getUnitPrice());
                itemStmt.setDouble(5, billItem.getLineTotal());
                itemStmt.addBatch();

                // Update stock
                stockStmt.setInt(1, billItem.getQuantity());
                stockStmt.setInt(2, billItem.getItemId());
                stockStmt.addBatch();
            }

            itemStmt.executeBatch();
            stockStmt.executeBatch();

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (billStmt != null) billStmt.close();
                if (itemStmt != null) itemStmt.close();
                if (stockStmt != null) stockStmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Get bill by ID with items
    public Bill getBillById(int billId) {
        String sql = "SELECT b.*, c.customer_name, c.account_number, u.full_name as created_by_name " +
                "FROM bills b " +
                "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                "LEFT JOIN users u ON b.created_by = u.user_id " +
                "WHERE b.bill_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Bill bill = createBillFromResultSet(rs);

                // Load bill items
                List<BillItem> billItems = getBillItemsByBillId(billId);
                bill.setBillItems(billItems);

                return bill;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get bill by bill number
    public Bill getBillByNumber(String billNumber) {
        String sql = "SELECT b.*, c.customer_name, c.account_number, u.full_name as created_by_name " +
                "FROM bills b " +
                "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                "LEFT JOIN users u ON b.created_by = u.user_id " +
                "WHERE b.bill_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, billNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Bill bill = createBillFromResultSet(rs);

                // Load bill items
                List<BillItem> billItems = getBillItemsByBillId(bill.getBillId());
                bill.setBillItems(billItems);

                return bill;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get all bills
    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, c.customer_name, c.account_number, u.full_name as created_by_name " +
                "FROM bills b " +
                "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                "LEFT JOIN users u ON b.created_by = u.user_id " +
                "ORDER BY b.bill_date DESC, b.bill_id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Bill bill = createBillFromResultSet(rs);
                bills.add(bill);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bills;
    }

    // Get bills by customer
    public List<Bill> getBillsByCustomer(int customerId) {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, c.customer_name, c.account_number, u.full_name as created_by_name " +
                "FROM bills b " +
                "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                "LEFT JOIN users u ON b.created_by = u.user_id " +
                "WHERE b.customer_id = ? " +
                "ORDER BY b.bill_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Bill bill = createBillFromResultSet(rs);
                bills.add(bill);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bills;
    }

    // Get bill items by bill ID
    public List<BillItem> getBillItemsByBillId(int billId) {
        List<BillItem> billItems = new ArrayList<>();
        String sql = "SELECT bi.*, i.item_name " +
                "FROM bill_items bi " +
                "LEFT JOIN items i ON bi.item_id = i.item_id " +
                "WHERE bi.bill_id = ? " +
                "ORDER BY bi.bill_item_id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                BillItem billItem = new BillItem();
                billItem.setBillItemId(rs.getInt("bill_item_id"));
                billItem.setBillId(rs.getInt("bill_id"));
                billItem.setItemId(rs.getInt("item_id"));
                billItem.setItemName(rs.getString("item_name"));
                billItem.setQuantity(rs.getInt("quantity"));
                billItem.setUnitPrice(rs.getDouble("unit_price"));
                billItem.setLineTotal(rs.getDouble("line_total"));
                billItems.add(billItem);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return billItems;
    }

    // Update bill payment status
    public boolean updatePaymentStatus(int billId, String paymentStatus) {
        String sql = "UPDATE bills SET payment_status = ? WHERE bill_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentStatus);
            stmt.setInt(2, billId);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Generate next bill number
    public String generateBillNumber() {
        String sql = "SELECT COUNT(*) as count FROM bills WHERE DATE(bill_date) = CURDATE()";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                int todayCount = rs.getInt("count");
                String dateStr = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
                return String.format("BILL%s%03d", dateStr, todayCount + 1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Fallback
        return "BILL" + System.currentTimeMillis();
    }

    // Delete bill (Admin only)
    public boolean deleteBill(int billId) {
        Connection conn = null;
        PreparedStatement billStmt = null;
        PreparedStatement itemStmt = null;
        PreparedStatement stockStmt = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // Get bill items first to restore stock
            List<BillItem> billItems = getBillItemsByBillId(billId);

            // Restore stock quantities
            String stockSql = "UPDATE items SET stock_quantity = stock_quantity + ? WHERE item_id = ?";
            stockStmt = conn.prepareStatement(stockSql);

            for (BillItem billItem : billItems) {
                stockStmt.setInt(1, billItem.getQuantity());
                stockStmt.setInt(2, billItem.getItemId());
                stockStmt.addBatch();
            }
            stockStmt.executeBatch();

            // Delete bill items
            String itemDeleteSql = "DELETE FROM bill_items WHERE bill_id = ?";
            itemStmt = conn.prepareStatement(itemDeleteSql);
            itemStmt.setInt(1, billId);
            itemStmt.executeUpdate();

            // Delete bill
            String billDeleteSql = "DELETE FROM bills WHERE bill_id = ?";
            billStmt = conn.prepareStatement(billDeleteSql);
            billStmt.setInt(1, billId);
            billStmt.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (billStmt != null) billStmt.close();
                if (itemStmt != null) itemStmt.close();
                if (stockStmt != null) stockStmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Helper method to create Bill from ResultSet
    private Bill createBillFromResultSet(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setBillNumber(rs.getString("bill_number"));
        bill.setCustomerId(rs.getInt("customer_id"));
        bill.setCustomerName(rs.getString("customer_name"));
        bill.setCustomerAccountNumber(rs.getString("account_number"));
        bill.setBillDate(rs.getString("bill_date"));
        bill.setSubtotal(rs.getDouble("subtotal"));
        bill.setDiscountPercentage(rs.getDouble("discount_percentage"));
        bill.setDiscountAmount(rs.getDouble("discount_amount"));
        bill.setFinalAmount(rs.getDouble("final_amount"));
        bill.setPaymentMethod(rs.getString("payment_method"));
        bill.setPaymentStatus(rs.getString("payment_status"));
        bill.setCreatedBy(rs.getInt("created_by"));
        bill.setCreatedByName(rs.getString("created_by_name"));
        bill.setNotes(rs.getString("notes"));
        return bill;
    }

    // Get today's bills count
    public int getTodayBillsCount() {
        String sql = "SELECT COUNT(*) as count FROM bills WHERE DATE(bill_date) = CURDATE()";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Get today's total sales
    public double getTodayTotalSales() {
        String sql = "SELECT SUM(final_amount) as total FROM bills WHERE DATE(bill_date) = CURDATE() AND payment_status = 'Paid'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // Test method
    public static void main(String[] args) {
        BillDAO billDAO = new BillDAO();

        // Test generating bill number
        String billNumber = billDAO.generateBillNumber();
        System.out.println("Generated Bill Number: " + billNumber);

        // Test getting today's stats
        int todayBills = billDAO.getTodayBillsCount();
        double todaySales = billDAO.getTodayTotalSales();

        System.out.println("Today's Bills: " + todayBills);
        System.out.println("Today's Sales: Rs." + todaySales);

        // Test getting all bills
        List<Bill> bills = billDAO.getAllBills();
        System.out.println("Total bills in system: " + bills.size());
    }
}