// File: src/main/java/com/pahanaedu/controllers/ItemServlet.java
package com.pahanaedu.controllers;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.models.Item;
import com.pahanaedu.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/item")
public class ItemServlet extends HttpServlet {

    private ItemDAO itemDAO;

    @Override
    public void init() throws ServletException {
        itemDAO = new ItemDAO();
    }

    // Handle GET request - Show item management page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Check user role - only Admin and Manager can manage items
        if (!user.isAdmin() && !user.isManager()) {
            request.setAttribute("errorMessage", "Access denied. Only Admin and Manager can manage items.");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            // Edit item form
            String itemIdStr = request.getParameter("itemId");
            if (itemIdStr != null) {
                try {
                    int itemId = Integer.parseInt(itemIdStr);
                    Item item = itemDAO.getItemById(itemId);
                    request.setAttribute("item", item);
                    request.setAttribute("editMode", true);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid item ID");
                }
            }
        } else if ("search".equals(action)) {
            // Search items
            String searchTerm = request.getParameter("searchTerm");
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                List<Item> items = itemDAO.searchItemsByName(searchTerm.trim());
                request.setAttribute("items", items);
                request.setAttribute("searchTerm", searchTerm);
            } else {
                List<Item> items = itemDAO.getAllItems();
                request.setAttribute("items", items);
            }
        } else if ("category".equals(action)) {
            // Filter by category
            String category = request.getParameter("category");
            if (category != null && !category.trim().isEmpty()) {
                List<Item> items = itemDAO.getItemsByCategory(category);
                request.setAttribute("items", items);
                request.setAttribute("selectedCategory", category);
            } else {
                List<Item> items = itemDAO.getAllItems();
                request.setAttribute("items", items);
            }
        } else {
            // Default - Show all items
            List<Item> items = itemDAO.getAllItems();
            request.setAttribute("items", items);
        }

        request.getRequestDispatcher("items.jsp").forward(request, response);
    }

    // Handle POST request - Process item operations
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Check user role - only Admin and Manager can manage items
        if (!user.isAdmin() && !user.isManager()) {
            request.setAttribute("errorMessage", "Access denied. Only Admin and Manager can manage items.");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addItem(request, response);
        } else if ("update".equals(action)) {
            updateItem(request, response);
        } else if ("delete".equals(action)) {
            deleteItem(request, response);
        } else if ("updateStock".equals(action)) {
            updateStock(request, response);
        } else {
            // Default redirect
            response.sendRedirect("item");
        }
    }

    // Add new item
    private void addItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String itemName = request.getParameter("itemName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String category = request.getParameter("category");

        // Basic validation
        if (itemName == null || itemName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Item name is required");
            loadItemsAndForward(request, response);
            return;
        }

        double price;
        int stockQuantity;

        try {
            price = Double.parseDouble(priceStr);
            stockQuantity = Integer.parseInt(stockQuantityStr);

            if (price <= 0) {
                request.setAttribute("errorMessage", "Price must be greater than 0");
                loadItemsAndForward(request, response);
                return;
            }

            if (stockQuantity < 0) {
                request.setAttribute("errorMessage", "Stock quantity cannot be negative");
                loadItemsAndForward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price or stock quantity format");
            loadItemsAndForward(request, response);
            return;
        }

        // Create item object
        Item item = new Item();
        item.setItemName(itemName.trim());
        item.setDescription(description != null ? description.trim() : "");
        item.setPrice(price);
        item.setStockQuantity(stockQuantity);
        item.setCategory(category != null ? category.trim() : "");

        // Save to database
        boolean success = itemDAO.addItem(item);

        if (success) {
            request.setAttribute("successMessage", "Item added successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to add item. Please try again.");
        }

        loadItemsAndForward(request, response);
    }

    // Update existing item
    private void updateItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String itemIdStr = request.getParameter("itemId");
        String itemName = request.getParameter("itemName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String category = request.getParameter("category");

        // Validate item ID
        int itemId;
        try {
            itemId = Integer.parseInt(itemIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid item ID");
            response.sendRedirect("item");
            return;
        }

        // Basic validation
        if (itemName == null || itemName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Item name is required");
            Item item = itemDAO.getItemById(itemId);
            request.setAttribute("item", item);
            request.setAttribute("editMode", true);
            loadItemsAndForward(request, response);
            return;
        }

        double price;
        int stockQuantity;

        try {
            price = Double.parseDouble(priceStr);
            stockQuantity = Integer.parseInt(stockQuantityStr);

            if (price <= 0) {
                request.setAttribute("errorMessage", "Price must be greater than 0");
                Item item = itemDAO.getItemById(itemId);
                request.setAttribute("item", item);
                request.setAttribute("editMode", true);
                loadItemsAndForward(request, response);
                return;
            }

            if (stockQuantity < 0) {
                request.setAttribute("errorMessage", "Stock quantity cannot be negative");
                Item item = itemDAO.getItemById(itemId);
                request.setAttribute("item", item);
                request.setAttribute("editMode", true);
                loadItemsAndForward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price or stock quantity format");
            Item item = itemDAO.getItemById(itemId);
            request.setAttribute("item", item);
            request.setAttribute("editMode", true);
            loadItemsAndForward(request, response);
            return;
        }

        // Create item object
        Item item = new Item();
        item.setItemId(itemId);
        item.setItemName(itemName.trim());
        item.setDescription(description != null ? description.trim() : "");
        item.setPrice(price);
        item.setStockQuantity(stockQuantity);
        item.setCategory(category != null ? category.trim() : "");

        // Update in database
        boolean success = itemDAO.updateItem(item);

        if (success) {
            request.setAttribute("successMessage", "Item updated successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to update item. Please try again.");
        }

        response.sendRedirect("item");
    }

    // Delete item
    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemIdStr = request.getParameter("itemId");

        try {
            int itemId = Integer.parseInt(itemIdStr);
            boolean success = itemDAO.deleteItem(itemId);

            if (success) {
                request.setAttribute("successMessage", "Item deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to delete item. Please try again.");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid item ID");
        }

        response.sendRedirect("item");
    }

    // Update stock quantity only
    private void updateStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemIdStr = request.getParameter("itemId");
        String stockQuantityStr = request.getParameter("stockQuantity");

        try {
            int itemId = Integer.parseInt(itemIdStr);
            int stockQuantity = Integer.parseInt(stockQuantityStr);

            if (stockQuantity < 0) {
                request.setAttribute("errorMessage", "Stock quantity cannot be negative");
            } else {
                boolean success = itemDAO.updateStock(itemId, stockQuantity);

                if (success) {
                    request.setAttribute("successMessage", "Stock updated successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to update stock. Please try again.");
                }
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid item ID or stock quantity");
        }

        response.sendRedirect("item");
    }

    // Helper method to load items and forward to JSP
    private void loadItemsAndForward(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Item> items = itemDAO.getAllItems();
        request.setAttribute("items", items);
        request.getRequestDispatcher("items.jsp").forward(request, response);
    }
}