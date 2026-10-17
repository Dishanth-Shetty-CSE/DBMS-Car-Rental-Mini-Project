import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/processPayment")
public class processPayment extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Map<String, Double> MODEL_RATES = new HashMap<>();
    static {
        MODEL_RATES.put("honda city", 2200.0);
        MODEL_RATES.put("hyundai i20", 1600.0);
        MODEL_RATES.put("maruti swift", 1400.0);
        MODEL_RATES.put("toyota innova", 3400.0);
        MODEL_RATES.put("tata nexon", 2400.0);
        MODEL_RATES.put("mahindra thar", 3200.0);
        MODEL_RATES.put("hyundai creta", 2600.0);
        MODEL_RATES.put("kia seltos", 2600.0);
        MODEL_RATES.put("bmw 3 series", 6500.0);
        MODEL_RATES.put("audi a4", 6800.0);
    }

    private double resolveDailyRate(String carModel) {
        if (carModel == null) return 2500.0;
        String lower = carModel.trim().toLowerCase();
        for (Map.Entry<String, Double> entry : MODEL_RATES.entrySet()) {
            if (lower.contains(entry.getKey())) {
                return entry.getValue();
            }
        }
        if (lower.contains("audi") || lower.contains("bmw") || lower.contains("mercedes")) return 6500.0;
        if (lower.contains("fortuner") || lower.contains("endeavour")) return 4500.0;
        if (lower.contains("innova") || lower.contains("safari") || lower.contains("xuv")) return 3400.0;
        if (lower.contains("thar") || lower.contains("creta") || lower.contains("nexon")) return 2600.0;
        if (lower.contains("city") || lower.contains("verna")) return 2200.0;
        if (lower.contains("swift") || lower.contains("i20") || lower.contains("baleno")) return 1600.0;
        return 2500.0;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String payMethod = request.getParameter("payMethod");
        if (payMethod == null || payMethod.trim().isEmpty()) {
            payMethod = "Credit Card";
        }

        String rentalIdParam = request.getParameter("rentalID");
        if (rentalIdParam == null || rentalIdParam.trim().isEmpty()) {
            out.print("Payment failed: Invalid Rental Reference ID");
            return;
        }

        int rentalID;
        try {
            rentalID = Integer.parseInt(rentalIdParam.trim());
        } catch (NumberFormatException nfe) {
            out.print("Payment failed: Rental ID must be numeric");
            return;
        }

        double amountPaid = 0.0;
        String amountParam = request.getParameter("amountPaid");
        if (amountParam != null && !amountParam.trim().isEmpty()) {
            try {
                amountPaid = Double.parseDouble(amountParam.trim());
            } catch (Exception ignored) {}
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

            // If amount was not passed or is zero, dynamically calculate from Rental dates & Car model
            if (amountPaid <= 0.0) {
                String lookupQuery = "SELECT r.Rent_Start_Date, r.Rent_End_Date, c.Car_Model " +
                                     "FROM rental r LEFT JOIN car c ON r.Car_Regno = c.Car_Regno " +
                                     "WHERE r.Rental_ID = ?";
                PreparedStatement lookupStmt = conn.prepareStatement(lookupQuery);
                lookupStmt.setInt(1, rentalID);
                rs = lookupStmt.executeQuery();
                if (rs.next()) {
                    java.sql.Date sDate = rs.getDate("Rent_Start_Date");
                    java.sql.Date eDate = rs.getDate("Rent_End_Date");
                    String carModel = rs.getString("Car_Model");

                    long days = 1;
                    if (sDate != null && eDate != null) {
                        long diff = eDate.getTime() - sDate.getTime();
                        days = Math.max(1, (diff / (1000 * 60 * 60 * 24)));
                    }
                    double rate = resolveDailyRate(carModel);
                    amountPaid = days * rate;
                } else {
                    amountPaid = 3500.0; // Sensible default fallback
                }
                rs.close();
                lookupStmt.close();
            }

            // Insert into Payment table with Amount_Paid
            int rowsAffected = 0;
            try {
                String queryWithAmount = "INSERT INTO Payment (Pay_Method, Pay_status, Rental_ID, Pay_Date_Time, Amount_Paid) VALUES (?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(queryWithAmount);
                stmt.setString(1, payMethod);
                stmt.setString(2, "Completed");
                stmt.setInt(3, rentalID);
                Timestamp timestamp = new Timestamp(new Date().getTime());
                stmt.setTimestamp(4, timestamp);
                stmt.setDouble(5, amountPaid);
                rowsAffected = stmt.executeUpdate();
            } catch (Exception ex) {
                // If Amount_Paid column is missing in older DB schemas, fallback to 4 parameters
                if (stmt != null) stmt.close();
                String fallbackQuery = "INSERT INTO Payment (Pay_Method, Pay_status, Rental_ID, Pay_Date_Time) VALUES (?, ?, ?, ?)";
                stmt = conn.prepareStatement(fallbackQuery);
                stmt.setString(1, payMethod);
                stmt.setString(2, "Completed");
                stmt.setInt(3, rentalID);
                Timestamp timestamp = new Timestamp(new Date().getTime());
                stmt.setTimestamp(4, timestamp);
                rowsAffected = stmt.executeUpdate();
            }

            if (rowsAffected > 0) {
                // 1. Update Rental status to 'Ongoing' (or 'Completed' if past end date)
                try {
                    String updateRental = "UPDATE rental SET Rental_Status = " +
                                          "CASE WHEN Rent_End_Date < CURDATE() THEN 'Completed' ELSE 'Ongoing' END " +
                                          "WHERE Rental_ID = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateRental);
                    updateStmt.setInt(1, rentalID);
                    updateStmt.executeUpdate();
                    updateStmt.close();
                } catch (Exception ignored) {}

                // 2. Auto-heal any older legacy payments where Amount_Paid was left as 0.00
                try {
                    String healSql = "UPDATE payment p JOIN rental r ON p.Rental_ID = r.Rental_ID " +
                                     "SET p.Amount_Paid = GREATEST(1, DATEDIFF(r.Rent_End_Date, r.Rent_Start_Date)) * 2500.0 " +
                                     "WHERE (p.Amount_Paid IS NULL OR p.Amount_Paid <= 0.0) AND p.Pay_Status = 'Completed'";
                    Statement healStmt = conn.createStatement();
                    healStmt.executeUpdate(healSql);
                    healStmt.close();
                } catch (Exception ignored) {}

                // Return success token and the formatted transaction amount
                out.print("Payment successful:" + String.format(Locale.US, "%.2f", amountPaid));
            } else {
                out.print("Payment failed: Unable to record transaction");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("Payment failed: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
