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
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
        String email = request.getParameter("Cust_Email");
        String password = request.getParameter("Cust_Password");
        String customerID = request.getParameter("Cust_ID"); // optional fallback

        if (email != null) email = email.trim();
        if (password != null) password = password.trim();

        String hashedPassword = hashPassword(password);

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

            // Query by Email and Hashed Password (or plain text fallback if entered directly in DB)
            String query = "SELECT * FROM Customer WHERE Cust_Email = ? AND (Cust_Password = ? OR Cust_Password = ? OR Cust_Password IS NULL)";
            
            // Backward compatibility if Cust_ID was also supplied
            if ((email == null || email.isEmpty()) && customerID != null && !customerID.isEmpty()) {
                query = "SELECT * FROM Customer WHERE Cust_ID = ?";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, customerID);
            } else {
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, email);
                preparedStatement.setString(2, hashedPassword);
                preparedStatement.setString(3, password);
            }

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String retrievedCustomerID = email;
                try {
                    retrievedCustomerID = resultSet.getString("Cust_ID");
                    if (retrievedCustomerID == null || retrievedCustomerID.isEmpty()) {
                        retrievedCustomerID = email;
                    }
                } catch (Exception ex) {
                    retrievedCustomerID = email;
                }

                String customerName = "Customer";
                try {
                    customerName = resultSet.getString("Cust_Name");
                } catch (Exception ex) {}

                HttpSession session = request.getSession();
                session.setAttribute("customerID", retrievedCustomerID);
                session.setAttribute("customerEmail", email);
                if (customerName != null) {
                    session.setAttribute("customerName", customerName);
                }
                session.setMaxInactiveInterval(1800);

                response.getWriter().write("Login successful");
            } else {
                response.getWriter().write("Login failed");
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.err.println("Database error: " + e.getMessage());
            response.getWriter().write("Error: " + e.getMessage());
        } finally {
            try { if (resultSet != null) resultSet.close(); } catch (SQLException e) {}
            try { if (preparedStatement != null) preparedStatement.close(); } catch (SQLException e) {}
            try { if (connection != null) connection.close(); } catch (SQLException e) {}
        }
    }
}