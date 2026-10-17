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

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
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
        String email = request.getParameter("Admin_Email");
        String password = request.getParameter("Admin_Password");
        String adminID = request.getParameter("Admin_ID"); // optional fallback

        if (email != null) email = email.trim();
        if (password != null) password = password.trim();

        String hashedPassword = hashPassword(password);

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

            // Query by Admin Email and Hashed Password (or plain text fallback)
            String query = "SELECT * FROM Administrator WHERE Admin_Email = ? AND (Admin_Password = ? OR Admin_Password = ? OR Admin_Password IS NULL)";
            
            // Backward compatibility if Admin_ID was supplied
            if ((email == null || email.isEmpty()) && adminID != null && !adminID.isEmpty()) {
                query = "SELECT * FROM Administrator WHERE Admin_ID = ?";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, adminID);
            } else {
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, email);
                preparedStatement.setString(2, hashedPassword);
                preparedStatement.setString(3, password);
            }

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String retrievedAdminID = email;
                try {
                    retrievedAdminID = resultSet.getString("Admin_ID");
                    if (retrievedAdminID == null || retrievedAdminID.isEmpty()) {
                        retrievedAdminID = email;
                    }
                } catch (Exception ex) {
                    retrievedAdminID = email;
                }

                String adminName = "Admin";
                try {
                    adminName = resultSet.getString("Admin_Name");
                } catch (Exception ex) {}

                HttpSession session = request.getSession();
                session.setAttribute("adminID", retrievedAdminID); 
                session.setAttribute("adminEmail", email);
                session.setAttribute("adminName", adminName);   
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
