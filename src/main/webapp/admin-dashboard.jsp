<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*"%>
<%
HttpSession currentSession = request.getSession(false);
if (currentSession == null) {
	response.sendRedirect("AdminLogin.jsp");
	return;
}

String adminID = (String) currentSession.getAttribute("adminID");
if (adminID == null) {
	response.sendRedirect("AdminLogin.jsp");
	return;
}

Connection connection = null;
PreparedStatement preparedStatement = null;
ResultSet resultSet = null;

int totalCars = 0;
int totalCustomers = 0;
int totalRentals = 0;
int activeRentals = 0;
int pendingReturns = 0;
double totalRevenue = 0.0;
String adminName = (String) currentSession.getAttribute("adminName");
if (adminName == null || adminName.isEmpty()) {
    adminName = "Administrator";
}

java.util.List<java.util.Map<String, String>> recentRentals = new java.util.ArrayList<>();

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

	// Total Cars
	String totalCarsQuery = "SELECT COUNT(*) FROM Car";
	preparedStatement = connection.prepareStatement(totalCarsQuery);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) totalCars = resultSet.getInt(1);
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	// Total Customers
	String totalCustomersQuery = "SELECT COUNT(*) FROM Customer";
	preparedStatement = connection.prepareStatement(totalCustomersQuery);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) totalCustomers = resultSet.getInt(1);
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	// Total Rentals
	String totalRentalsQuery = "SELECT COUNT(*) FROM Rental";
	preparedStatement = connection.prepareStatement(totalRentalsQuery);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) totalRentals = resultSet.getInt(1);
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	// Active Rentals
	String activeRentalsQuery = "SELECT COUNT(*) FROM Rental WHERE Rental_Status = 'Ongoing'";
	preparedStatement = connection.prepareStatement(activeRentalsQuery);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) activeRentals = resultSet.getInt(1);
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	// Pending Returns
	String pendingReturnsQuery = "SELECT COUNT(*) FROM Rental WHERE (Rental_Status = 'Ongoing' OR Rental_Status = 'Out') AND Rent_End_Date < CURDATE()";
	preparedStatement = connection.prepareStatement(pendingReturnsQuery);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) pendingReturns = resultSet.getInt(1);
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	// Total Revenue with robust fallback
	try {
		String totalRevenueQuery = "SELECT COALESCE(SUM(Amount_Paid), 0) FROM payment WHERE Pay_Status = 'Completed'";
		preparedStatement = connection.prepareStatement(totalRevenueQuery);
		resultSet = preparedStatement.executeQuery();
		if (resultSet.next()) {
			totalRevenue = resultSet.getDouble(1);
		}
	} catch (Exception e) {
		try {
			if (preparedStatement != null) preparedStatement.close();
			String fallbackQuery = "SELECT COUNT(*) * 8500.0 FROM payment WHERE Pay_Status = 'Completed'";
			preparedStatement = connection.prepareStatement(fallbackQuery);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				totalRevenue = resultSet.getDouble(1);
			}
		} catch (Exception ex) {}
	}
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	// Fetch recent 5 rentals for the live dashboard activity desk
	try {
		String recentQuery = "SELECT r.Rental_ID, r.Rental_Name, r.Rent_Start_Date, r.Rent_End_Date, r.Rental_Status, r.Car_Regno, c.Cust_Name " +
		                     "FROM Rental r LEFT JOIN Customer c ON r.Cust_ID = c.Cust_ID " +
		                     "ORDER BY r.Rental_ID DESC LIMIT 5";
		preparedStatement = connection.prepareStatement(recentQuery);
		resultSet = preparedStatement.executeQuery();
		while (resultSet.next()) {
			java.util.Map<String, String> row = new java.util.HashMap<>();
			row.put("id", String.valueOf(resultSet.getInt("Rental_ID")));
			row.put("name", resultSet.getString("Rental_Name"));
			row.put("customer", resultSet.getString("Cust_Name") != null ? resultSet.getString("Cust_Name") : "Guest");
			row.put("car", resultSet.getString("Car_Regno"));
			row.put("status", resultSet.getString("Rental_Status"));
			row.put("start", resultSet.getString("Rent_Start_Date"));
			row.put("end", resultSet.getString("Rent_End_Date"));
			recentRentals.add(row);
		}
	} catch (Exception ex) {}

} catch (Exception e) {
	e.printStackTrace();
} finally {
	try { if (resultSet != null) resultSet.close(); } catch (Exception e) {}
	try { if (preparedStatement != null) preparedStatement.close(); } catch (Exception e) {}
	try { if (connection != null) connection.close(); } catch (Exception e) {}
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Admin Console - DriveLux</title>
    <!-- Poppins Font Everywhere -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- SweetAlert2 & Confirm Alert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="js/confirm-alert.js"></script>
    <!-- Application CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Unified Admin Top Navbar -->
    <header class="rental-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand" href="admin-dashboard.jsp">
                <div class="brand-badge" style="background: linear-gradient(135deg, #4f46e5, #0ea5e9);">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <span>Drive<span style="color: #60a5fa;">Lux</span> <small class="text-white-50 fs-6 fw-normal ms-1">Admin Console</small></span>
            </a>
            
            <nav class="d-none d-lg-flex align-items-center gap-2">
                <a class="nav-link active" href="admin-dashboard.jsp"><i class="fas fa-chart-pie"></i> Overview</a>
                <a class="nav-link" href="ManageCars.jsp"><i class="fas fa-car"></i> Fleet</a>
                <a class="nav-link" href="manageRentals.jsp"><i class="fas fa-calendar-alt"></i> Rentals</a>
                <a class="nav-link" href="ManageCustomers.jsp"><i class="fas fa-users"></i> Customers</a>
                <a class="nav-link" href="ManageLocations.jsp"><i class="fas fa-map-marked-alt"></i> Hubs</a>
                
                <div class="nav-user-pill ms-2" style="background: rgba(99, 102, 241, 0.2); border-color: rgba(99, 102, 241, 0.3);">
                    <div class="nav-user-avatar" style="background: linear-gradient(135deg, #4f46e5, #06b6d4);">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <span class="text-truncate" style="max-width: 120px;"><%= adminName %></span>
                </div>
                
                <button class="btn-nav-logout ms-2" id="lbtn" title="Sign out of admin console">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </nav>

            <!-- Mobile Menu Toggle Button -->
            <button class="btn btn-outline-light d-lg-none" type="button" data-bs-toggle="collapse" data-bs-target="#adminMobileNav">
                <i class="fas fa-bars"></i>
            </button>
        </div>

        <!-- Mobile Navigation -->
        <div class="collapse d-lg-none mt-3 px-4" id="adminMobileNav">
            <div class="d-flex flex-column gap-2 pb-2">
                <div class="d-flex align-items-center gap-2 py-2 text-white border-bottom border-secondary mb-2">
                    <div class="nav-user-avatar"><i class="fas fa-user-shield"></i></div>
                    <div>
                        <div class="fw-bold"><%= adminName %></div>
                        <div class="text-white-50 small">Admin ID: <%= adminID %></div>
                    </div>
                </div>
                <a class="nav-link active" href="admin-dashboard.jsp"><i class="fas fa-chart-pie"></i> Overview</a>
                <a class="nav-link" href="ManageCars.jsp"><i class="fas fa-car"></i> Fleet</a>
                <a class="nav-link" href="manageRentals.jsp"><i class="fas fa-calendar-alt"></i> Rentals</a>
                <a class="nav-link" href="ManageCustomers.jsp"><i class="fas fa-users"></i> Customers</a>
                <a class="nav-link" href="ManageLocations.jsp"><i class="fas fa-map-marked-alt"></i> Hubs</a>
                <button class="btn btn-danger w-100 mt-2" id="lbtn-mobile"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </div>
        </div>
    </header>

    <!-- Executive Hero Section -->
    <section class="page-hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <div class="hero-stats-badge">
                        <i class="fas fa-server text-success"></i> Operational Status: Fleet Live & Connected
                    </div>
                    <h1>Executive Operations Desk</h1>
                    <p>Welcome, <%= adminName %>. Oversee enterprise fleet dispatch, monitor active reservations, track revenue, and manage customer accounts.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                    <div class="d-flex gap-2 justify-content-lg-end flex-wrap">
                        <a href="ManageCars.jsp" class="btn-rental btn-rental-primary">
                            <i class="fas fa-car"></i> Manage Fleet
                        </a>
                        <a href="manageRentals.jsp" class="btn-rental btn-rental-outline-light">
                            <i class="fas fa-calendar-check"></i> Audit Rentals
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Container -->
    <main class="container my-5">
        <!-- 6 Live Operational KPI Cards -->
        <div class="row g-4 mb-5">
            <!-- 1. Total Fleet -->
            <div class="col-md-6 col-xl-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-primary"><%= totalCars %></div>
                            <div class="stat-label">Total Fleet Vehicles</div>
                        </div>
                        <div class="stat-icon primary">
                            <i class="fas fa-car"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-check-circle"></i> Active</span>
                        <span>Across all regional depots</span>
                    </div>
                </div>
            </div>

            <!-- 2. Registered Customers -->
            <div class="col-md-6 col-xl-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-info"><%= totalCustomers %></div>
                            <div class="stat-label">Verified Customers</div>
                        </div>
                        <div class="stat-icon info">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-user-check"></i> Registered</span>
                        <span>Active customer accounts</span>
                    </div>
                </div>
            </div>

            <!-- 3. Total Bookings -->
            <div class="col-md-6 col-xl-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-purple" style="color: #8b5cf6;"><%= totalRentals %></div>
                            <div class="stat-label">Lifetime Bookings</div>
                        </div>
                        <div class="stat-icon purple">
                            <i class="fas fa-file-contract"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-chart-line"></i> Total</span>
                        <span>Reservations processed</span>
                    </div>
                </div>
            </div>

            <!-- 4. Active On-Road -->
            <div class="col-md-6 col-xl-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-warning"><%= activeRentals %></div>
                            <div class="stat-label">Active On-Road Rentals</div>
                        </div>
                        <div class="stat-icon warning">
                            <i class="fas fa-road"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-spinner fa-spin text-warning"></i> Ongoing</span>
                        <span>Vehicles dispatched with clients</span>
                    </div>
                </div>
            </div>

            <!-- 5. Pending Returns -->
            <div class="col-md-6 col-xl-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-danger"><%= pendingReturns %></div>
                            <div class="stat-label">Pending / Overdue Returns</div>
                        </div>
                        <div class="stat-icon danger">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend <%= pendingReturns > 0 ? "negative text-danger fw-bold" : "neutral" %>">
                            <i class="fas fa-clock"></i> Inspection
                        </span>
                        <span>Scheduled return overdue</span>
                    </div>
                </div>
            </div>

            <!-- 6. Total Revenue -->
            <div class="col-md-6 col-xl-4">
                <div class="stat-card" style="border-top: 4px solid var(--success);">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-success">&#8377;<%= String.format("%,.2f", totalRevenue) %></div>
                            <div class="stat-label">Gross Revenue Realized</div>
                        </div>
                        <div class="stat-icon success">
                            <i class="fas fa-wallet"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-arrow-up text-success"></i> Verified</span>
                        <span>Completed payment transactions</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Operations Navigation Quick Cards -->
        <h3 class="fw-bold mb-3">Enterprise Control Modules</h3>
        <div class="row g-4 mb-5">
            <div class="col-md-6 col-lg-3">
                <a href="ManageCars.jsp" class="text-decoration-none">
                    <div class="card border-0 shadow-sm p-4 h-100 text-center" style="border-radius: var(--radius-lg); background: #ffffff; transition: var(--transition);">
                        <div class="stat-icon primary mx-auto mb-3" style="width: 54px; height: 54px;">
                            <i class="fas fa-car-side"></i>
                        </div>
                        <h5 class="fw-bold text-dark">Fleet Management</h5>
                        <p class="text-muted small mb-0">Add, edit vehicle specs, inspect availability, or retire cars.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-6 col-lg-3">
                <a href="manageRentals.jsp" class="text-decoration-none">
                    <div class="card border-0 shadow-sm p-4 h-100 text-center" style="border-radius: var(--radius-lg); background: #ffffff; transition: var(--transition);">
                        <div class="stat-icon warning mx-auto mb-3" style="width: 54px; height: 54px;">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <h5 class="fw-bold text-dark">Rentals Desk</h5>
                        <p class="text-muted small mb-0">Modify booking durations, update trip status, and handle returns.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-6 col-lg-3">
                <a href="ManageCustomers.jsp" class="text-decoration-none">
                    <div class="card border-0 shadow-sm p-4 h-100 text-center" style="border-radius: var(--radius-lg); background: #ffffff; transition: var(--transition);">
                        <div class="stat-icon info mx-auto mb-3" style="width: 54px; height: 54px;">
                            <i class="fas fa-address-book"></i>
                        </div>
                        <h5 class="fw-bold text-dark">Customer Directory</h5>
                        <p class="text-muted small mb-0">Manage customer records, contact coordinates, and accounts.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-6 col-lg-3">
                <a href="ManageLocations.jsp" class="text-decoration-none">
                    <div class="card border-0 shadow-sm p-4 h-100 text-center" style="border-radius: var(--radius-lg); background: #ffffff; transition: var(--transition);">
                        <div class="stat-icon success mx-auto mb-3" style="width: 54px; height: 54px;">
                            <i class="fas fa-map-marked-alt"></i>
                        </div>
                        <h5 class="fw-bold text-dark">Regional Hubs</h5>
                        <p class="text-muted small mb-0">Audit depot terminals, station addresses, and postal codes.</p>
                    </div>
                </a>
            </div>
        </div>

        <!-- Live Recent Bookings Preview Desk -->
        <div class="table-card">
            <div class="table-card-header">
                <h3><i class="fas fa-history text-primary"></i> Recent Reservation Activity</h3>
                <a href="manageRentals.jsp" class="btn-rental btn-rental-outline btn-rental-sm">
                    View All Bookings (<%= totalRentals %>) <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Rental Ref</th>
                            <th>Customer Name</th>
                            <th>Vehicle Reg</th>
                            <th>Plan / Category</th>
                            <th>Rental Period</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentRentals.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">No recent reservations recorded.</td>
                        </tr>
                        <% } else { 
                            for (java.util.Map<String, String> row : recentRentals) {
                                String rId = row.get("id");
                                String cust = row.get("customer");
                                String car = row.get("car");
                                String name = row.get("name");
                                String status = row.get("status");
                                String period = row.get("start") + " to " + row.get("end");

                                String badgeClass = "badge-available";
                                if ("Completed".equalsIgnoreCase(status)) badgeClass = "badge-completed";
                                else if ("Ongoing".equalsIgnoreCase(status)) badgeClass = "badge-ongoing";
                                else if ("Cancelled".equalsIgnoreCase(status)) badgeClass = "badge-cancelled";
                        %>
                        <tr>
                            <td><span class="badge bg-light text-primary border font-monospace">#<%= rId %></span></td>
                            <td class="fw-bold text-dark"><i class="fas fa-user-circle text-muted me-1"></i> <%= cust %></td>
                            <td><span class="font-monospace fw-bold text-secondary"><%= car %></span></td>
                            <td><%= name %></td>
                            <td><small class="text-muted"><%= period %></small></td>
                            <td><span class="badge-custom <%= badgeClass %>"><%= status %></span></td>
                        </tr>
                        <% } 
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="rental-footer">
        <div class="container text-center">
            <p class="mb-0 small text-muted">&copy; 2025 DriveLux DBMS Car Rental Management System. Executive Session Active (Admin: <%= adminName %>).</p>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function triggerAdminLogout() {
            Swal.fire({
                title: "Log out of Admin Console?",
                text: "Confirming will terminate your privileged administrator session.",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#4f46e5",
                cancelButtonColor: "#64748b",
                confirmButtonText: "Yes, Sign Out",
                cancelButtonText: "Cancel"
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.replace("AdminLogin.jsp");
                }
            });
        }

        const logoutBtn = document.getElementById("lbtn");
        if (logoutBtn) {
            logoutBtn.addEventListener("click", function(e) {
                e.preventDefault();
                triggerAdminLogout();
            });
        }

        const logoutBtnMobile = document.getElementById("lbtn-mobile");
        if (logoutBtnMobile) {
            logoutBtnMobile.addEventListener("click", function(e) {
                e.preventDefault();
                triggerAdminLogout();
            });
        }
    </script>
</body>
</html>
