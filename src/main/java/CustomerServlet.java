import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/car_rental_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "trickortreat";

    /**
     * SHA-256 password hash generator
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) return "";
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            return password;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String custName = request.getParameter("Cust_Name");
        String custAddress = request.getParameter("Cust_Address");
        String custPhone = request.getParameter("Cust_Phone");
        String custEmail = request.getParameter("Cust_Email");
        String custPassword = request.getParameter("Cust_Password");

        if (custName != null) custName = custName.trim();
        if (custAddress != null) custAddress = custAddress.trim();
        if (custPhone != null) custPhone = custPhone.trim();
        if (custEmail != null) custEmail = custEmail.trim().toLowerCase();

        if (custPassword == null || custPassword.trim().isEmpty()) {
            custPassword = "password123"; // default fallback
        }
        String hashedPassword = hashPassword(custPassword.trim());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 1. Check if email already registered to prevent duplicate key exception
            try {
                PreparedStatement checkStmt = conn.prepareStatement("SELECT Cust_Email FROM customer WHERE Cust_Email = ?");
                checkStmt.setString(1, custEmail);
                ResultSet checkRs = checkStmt.executeQuery();
                if (checkRs.next()) {
                    checkRs.close();
                    checkStmt.close();
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"An account with email " + custEmail + " is already registered. Please sign in.\"}");
                    return;
                }
                checkRs.close();
                checkStmt.close();
            } catch (Exception ignore) {
                // Ignore if customer table doesn't have Cust_Email column
            }

            boolean inserted = false;
            // 2. Primary attempt: insert with Cust_Email and Cust_Password
            try {
                String sql = "INSERT INTO customer (Cust_Email, Cust_Name, Cust_Address, Cust_Phone, Cust_Password) VALUES (?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, custEmail);
                stmt.setString(2, custName);
                stmt.setString(3, custAddress);
                stmt.setString(4, custPhone);
                stmt.setString(5, hashedPassword);
                int rows = stmt.executeUpdate();
                if (rows > 0) inserted = true;
            } catch (SQLException ex1) {
                if (stmt != null) { try { stmt.close(); } catch (Exception e) {} }
                
                // Fallback attempt A: with Cust_Name first
                try {
                    String sqlA = "INSERT INTO customer (Cust_Name, Cust_Address, Cust_Phone, Cust_Email, Cust_Password) VALUES (?, ?, ?, ?, ?)";
                    stmt = conn.prepareStatement(sqlA);
                    stmt.setString(1, custName);
                    stmt.setString(2, custAddress);
                    stmt.setString(3, custPhone);
                    stmt.setString(4, custEmail);
                    stmt.setString(5, hashedPassword);
                    int rows = stmt.executeUpdate();
                    if (rows > 0) inserted = true;
                } catch (SQLException ex2) {
                    if (stmt != null) { try { stmt.close(); } catch (Exception e) {} }
                    
                    // Fallback attempt B: without Cust_Password
                    String sqlB = "INSERT INTO customer (Cust_Name, Cust_Address, Cust_Phone, Cust_Email) VALUES (?, ?, ?, ?)";
                    stmt = conn.prepareStatement(sqlB);
                    stmt.setString(1, custName);
                    stmt.setString(2, custAddress);
                    stmt.setString(3, custPhone);
                    stmt.setString(4, custEmail);
                    int rows = stmt.executeUpdate();
                    if (rows > 0) inserted = true;
                }
            }

            if (inserted) {
                String customerIdStr = custEmail;
                try {
                    PreparedStatement idStmt = conn.prepareStatement("SELECT Cust_ID FROM customer WHERE Cust_Email = ?");
                    idStmt.setString(1, custEmail);
                    ResultSet idRs = idStmt.executeQuery();
                    if (idRs.next()) {
                        int id = idRs.getInt("Cust_ID");
                        if (id > 0) customerIdStr = String.valueOf(id);
                    }
                    idRs.close();
                    idStmt.close();
                } catch (Exception ignore) {
                    // Cust_ID column not present; email serves as customer identifier
                }

                response.getWriter().write("{\"status\":\"success\", \"message\":\"Customer registered successfully!\", \"customerId\":\"" + customerIdStr + "\"}");
            } else {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to register customer account.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Error: " + e.getMessage() + "\"}");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
}
