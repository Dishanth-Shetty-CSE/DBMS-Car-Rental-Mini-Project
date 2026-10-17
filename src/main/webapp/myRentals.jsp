<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals - DriveLux Bookings</title>
    <!-- Fonts -->
    <!-- Poppins Font Everywhere -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Application CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Unified Customer Navbar -->
    <header class="rental-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand" href="customer-dashboard.jsp">
                <div class="brand-badge"><i class="fas fa-car-side"></i></div>
                <span>Drive<span style="color: #60a5fa;">Lux</span></span>
            </a>
            
            <nav class="d-flex align-items-center gap-2">
                <a class="nav-link" href="customer-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a class="nav-link" href="availableCars.jsp"><i class="fas fa-car"></i> Available Cars</a>
                <a class="nav-link active" href="myRentals.jsp"><i class="fas fa-calendar-check"></i> My Rentals</a>
                <a class="btn-rental btn-rental-outline btn-rental-sm ms-2" href="customer-dashboard.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </nav>
        </div>
    </header>

    <!-- Page Header / Hero -->
    <section class="page-hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <div class="hero-stats-badge">
                        <i class="fas fa-history text-info"></i> Customer Reservation Records
                    </div>
                    <h1>My Vehicle Rentals & History</h1>
                    <p>Track your ongoing trips, review previous car bookings, and inspect payment and rental details anytime.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <a href="availableCars.jsp" class="btn-rental btn-rental-primary">
                        <i class="fas fa-plus-circle"></i> New Rental Reservation
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Container -->
    <main class="container my-5">
        <%
            String customerID = (String) session.getAttribute("customerID");
            if (customerID == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            int totalCount = 0;
            int ongoingCount = 0;
            int completedCount = 0;

            java.util.List<java.util.Map<String, String>> rentalsList = new java.util.ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

                String query = "SELECT r.Rental_ID, r.Rental_Name, r.Rent_Start_Date, r.Rent_End_Date, r.Rental_Status, r.Car_Regno, c.Car_Model, " +
                               "p.Amount_Paid, p.Pay_Status, p.Pay_Method " +
                               "FROM Rental r " +
                               "LEFT JOIN Car c ON r.Car_Regno = c.Car_Regno " +
                               "LEFT JOIN (SELECT Rental_ID, MAX(Pay_ID) as max_pay_id FROM Payment GROUP BY Rental_ID) latest_p ON r.Rental_ID = latest_p.Rental_ID " +
                               "LEFT JOIN Payment p ON latest_p.max_pay_id = p.Pay_ID " +
                               "WHERE r.Cust_ID = ? ORDER BY r.Rental_ID DESC";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, customerID);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    totalCount++;
                    String status = rs.getString("Rental_Status");
                    if ("Ongoing".equalsIgnoreCase(status)) ongoingCount++;
                    if ("Completed".equalsIgnoreCase(status)) completedCount++;

                    java.util.Map<String, String> row = new java.util.HashMap<>();
                    row.put("id", String.valueOf(rs.getInt("Rental_ID")));
                    row.put("name", rs.getString("Rental_Name") != null ? rs.getString("Rental_Name") : "Standard Rental");
                    row.put("startDate", rs.getString("Rent_Start_Date") != null ? rs.getString("Rent_Start_Date") : "N/A");
                    row.put("endDate", rs.getString("Rent_End_Date") != null ? rs.getString("Rent_End_Date") : "N/A");
                    row.put("status", status != null ? status : "Available");
                    row.put("regNo", rs.getString("Car_Regno") != null ? rs.getString("Car_Regno") : "N/A");
                    row.put("carModel", rs.getString("Car_Model") != null ? rs.getString("Car_Model") : "Rental Vehicle");
                    double amtPaid = rs.getDouble("Amount_Paid");
                    row.put("amountPaid", String.valueOf(amtPaid));
                    row.put("payStatus", rs.getString("Pay_Status") != null ? rs.getString("Pay_Status") : "Pending");
                    row.put("payMethod", rs.getString("Pay_Method") != null ? rs.getString("Pay_Method") : "N/A");
                    rentalsList.add(row);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>

        <!-- Summary Metric Pills -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3 d-flex flex-row align-items-center gap-3" style="border-radius: var(--radius-md); background: #ffffff;">
                    <div class="stat-icon primary" style="width: 48px; height: 48px; font-size: 1.25rem;">
                        <i class="fas fa-layer-group"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold text-dark"><%= totalCount %></div>
                        <div class="text-muted small">Total Bookings</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3 d-flex flex-row align-items-center gap-3" style="border-radius: var(--radius-md); background: #ffffff;">
                    <div class="stat-icon warning" style="width: 48px; height: 48px; font-size: 1.25rem;">
                        <i class="fas fa-road"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold text-warning"><%= ongoingCount %></div>
                        <div class="text-muted small">Active Ongoing Trips</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-3 d-flex flex-row align-items-center gap-3" style="border-radius: var(--radius-md); background: #ffffff;">
                    <div class="stat-icon success" style="width: 48px; height: 48px; font-size: 1.25rem;">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div>
                        <div class="fs-4 fw-bold text-success"><%= completedCount %></div>
                        <div class="text-muted small">Completed Journeys</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rentals Table Card -->
        <div class="table-card">
            <div class="table-card-header">
                <div>
                    <h3><i class="fas fa-clipboard-list text-primary"></i> Booking History Log</h3>
                </div>
                <div class="d-flex gap-2">
                    <input type="text" id="rentalSearch" class="form-control-custom form-control-sm" placeholder="Filter rentals..." onkeyup="filterRentalTable()">
                </div>
            </div>

            <div class="table-responsive">
                <table class="custom-table" id="rentalsTable">
                    <thead>
                        <tr>
                            <th>Rental ID</th>
                            <th>Vehicle Model & Reg</th>
                            <th>Rental Plan</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th>Amount & Payment</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (rentalsList.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center py-5 text-muted">
                                <i class="fas fa-folder-open fs-2 mb-2 d-block text-secondary"></i>
                                <h5>No Rental Reservations Found</h5>
                                <p class="small mb-3">You haven't reserved any vehicles yet. Explore our fleet today!</p>
                                <a href="availableCars.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Browse Available Cars</a>
                            </td>
                        </tr>
                        <% } else { 
                            for (java.util.Map<String, String> row : rentalsList) { 
                                String rId = row.get("id");
                                String rName = row.get("name");
                                String sDate = row.get("startDate");
                                String eDate = row.get("endDate");
                                String status = row.get("status");
                                String reg = row.get("regNo");
                                String model = row.get("carModel");
                                String payStatus = row.get("payStatus");
                                String payMethod = row.get("payMethod");
                                double amtPaid = 0.0;
                                try { amtPaid = Double.parseDouble(row.get("amountPaid")); } catch (Exception ignored) {}

                                String badgeClass = "badge-available";
                                String icon = "fa-check";
                                if ("Completed".equalsIgnoreCase(status)) {
                                    badgeClass = "badge-completed";
                                    icon = "fa-check-double";
                                } else if ("Ongoing".equalsIgnoreCase(status)) {
                                    badgeClass = "badge-ongoing";
                                    icon = "fa-play-circle";
                                } else if ("Cancelled".equalsIgnoreCase(status)) {
                                    badgeClass = "badge-cancelled";
                                    icon = "fa-ban";
                                }
                        %>
                        <tr class="rental-row" data-search="<%= rId %> <%= rName %> <%= model %> <%= reg %> <%= status %>">
                            <td><span class="badge bg-light text-primary border font-monospace px-2 py-1">#<%= rId %></span></td>
                            <td>
                                <div class="fw-bold text-dark"><%= model %></div>
                                <span class="font-monospace text-muted small"><%= reg %></span>
                            </td>
                            <td><i class="fas fa-tag text-primary me-1 small"></i> <%= rName %></td>
                            <td><i class="fas fa-calendar-alt text-muted me-1 small"></i> <%= sDate %></td>
                            <td><i class="fas fa-calendar-check text-muted me-1 small"></i> <%= eDate %></td>
                            <td>
                                <span class="badge-custom <%= badgeClass %>">
                                    <i class="fas <%= icon %>"></i> <%= status %>
                                </span>
                            </td>
                            <td>
                                <% if ("Completed".equalsIgnoreCase(payStatus) && amtPaid > 0.0) { %>
                                    <div class="fw-bold text-success">&#8377;<%= String.format(java.util.Locale.US, "%,.2f", amtPaid) %></div>
                                    <div class="small text-muted"><i class="fas fa-check-circle text-success me-1"></i><%= payMethod %></div>
                                <% } else { %>
                                    <span class="badge bg-warning-subtle text-warning fw-semibold">
                                        <i class="fas fa-clock me-1"></i>Payment Pending
                                    </span>
                                <% } %>
                            </td>
                            <td class="text-center">
                                <% if ("Completed".equalsIgnoreCase(payStatus) && amtPaid > 0.0) { %>
                                    <a href="payments.jsp?rentalId=<%= rId %>" class="btn-rental btn-rental-outline btn-rental-sm" title="View Paid Receipt">
                                        <i class="fas fa-file-invoice text-success"></i> Receipt
                                    </a>
                                <% } else { %>
                                    <a href="payments.jsp?rentalId=<%= rId %>" class="btn-rental btn-rental-primary btn-rental-sm" title="Complete Payment">
                                        <i class="fas fa-credit-card"></i> Pay Now
                                    </a>
                                <% } %>
                            </td>
                        </tr>
                        <%  } 
                           } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="rental-footer">
        <div class="container text-center">
            <p class="mb-0 small text-muted">&copy; 2025 DriveLux DBMS Car Rental Management System. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Bootstrap JS & Filter -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterRentalTable() {
            const query = document.getElementById("rentalSearch").value.toLowerCase().trim();
            document.querySelectorAll(".rental-row").forEach(row => {
                const text = row.getAttribute("data-search").toLowerCase();
                row.style.display = text.includes(query) ? "" : "none";
            });
        }
    </script>
</body>
</html>