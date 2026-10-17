<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*"%>
<%
HttpSession currentSession = request.getSession(false);
if (currentSession == null) {
	response.sendRedirect("login.jsp");
	return;
}

String customerID = (String) currentSession.getAttribute("customerID");
if (customerID == null) {
	response.sendRedirect("login.jsp");
	return;
}

String customerName = "Valued Customer";
int totalRentals = 0;
int activeRentals = 0;
int carsAvailable = 0;

Connection connection = null;
PreparedStatement preparedStatement = null;
ResultSet resultSet = null;

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

	String nameQuery = "SELECT Cust_Name FROM Customer WHERE Cust_ID = ?";
	preparedStatement = connection.prepareStatement(nameQuery);
	preparedStatement.setString(1, customerID);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) {
		String fetchedName = resultSet.getString("Cust_Name");
		if (fetchedName != null && !fetchedName.trim().isEmpty()) {
			customerName = fetchedName;
		}
	}
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	String totalRentalsQuery = "SELECT COUNT(*) FROM Rental WHERE Cust_ID = ?";
	preparedStatement = connection.prepareStatement(totalRentalsQuery);
	preparedStatement.setString(1, customerID);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) {
		totalRentals = resultSet.getInt(1);
	}
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	String activeRentalsQuery = "SELECT COUNT(*) FROM Rental WHERE Cust_ID = ? AND Rental_Status = 'Ongoing'";
	preparedStatement = connection.prepareStatement(activeRentalsQuery);
	preparedStatement.setString(1, customerID);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) {
		activeRentals = resultSet.getInt(1);
	}
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

	String availableCarsQuery = "SELECT COUNT(*) FROM Car WHERE Car_Status = 'Available'";
	preparedStatement = connection.prepareStatement(availableCarsQuery);
	resultSet = preparedStatement.executeQuery();
	if (resultSet.next()) {
		carsAvailable = resultSet.getInt(1);
	}
	if (resultSet != null) resultSet.close();
	if (preparedStatement != null) preparedStatement.close();

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
    <title>Customer Dashboard - DriveLux</title>
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

    <!-- Unified Customer Navbar -->
    <header class="rental-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand" href="customer-dashboard.jsp">
                <div class="brand-badge"><i class="fas fa-car-side"></i></div>
                <span>Drive<span style="color: #60a5fa;">Lux</span> <small class="text-white-50 fs-6 fw-normal ms-1">Customer</small></span>
            </a>
            
            <nav class="d-none d-lg-flex align-items-center gap-2">
                <a class="nav-link active" href="customer-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a class="nav-link" href="availableCars.jsp"><i class="fas fa-car"></i> Available Cars</a>
                <a class="nav-link" href="myRentals.jsp"><i class="fas fa-calendar-check"></i> My Rentals</a>
                <a class="nav-link" href="ProfileUpdate.jsp"><i class="fas fa-user-circle"></i> Profile</a>
                
                <div class="nav-user-pill ms-2">
                    <div class="nav-user-avatar"><%= customerName.substring(0, 1).toUpperCase() %></div>
                    <span><%= customerName %></span>
                </div>
                
                <button class="btn-nav-logout ms-2" id="lbtn" title="Sign out of account">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </nav>

            <!-- Mobile Menu Toggle Button -->
            <button class="btn btn-outline-light d-lg-none" type="button" data-bs-toggle="collapse" data-bs-target="#mobileNav">
                <i class="fas fa-bars"></i>
            </button>
        </div>

        <!-- Mobile Collapsible Menu -->
        <div class="collapse d-lg-none mt-3 px-4" id="mobileNav">
            <div class="d-flex flex-column gap-2 pb-2">
                <div class="d-flex align-items-center gap-2 py-2 text-white border-bottom border-secondary mb-2">
                    <div class="nav-user-avatar"><%= customerName.substring(0, 1).toUpperCase() %></div>
                    <div>
                        <div class="fw-bold"><%= customerName %></div>
                        <div class="text-white-50 small">Customer ID: <%= customerID %></div>
                    </div>
                </div>
                <a class="nav-link active" href="customer-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a class="nav-link" href="availableCars.jsp"><i class="fas fa-car"></i> Available Cars</a>
                <a class="nav-link" href="myRentals.jsp"><i class="fas fa-calendar-check"></i> My Rentals</a>
                <a class="nav-link" href="ProfileUpdate.jsp"><i class="fas fa-user-circle"></i> Profile</a>
                <button class="btn btn-danger w-100 mt-2" id="lbtn-mobile"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </div>
        </div>
    </header>

    <!-- Hero Greeting Section -->
    <section class="page-hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <div class="hero-stats-badge">
                        <i class="fas fa-shield-alt text-success"></i> Customer ID: #<%= customerID %> • Verified Member
                    </div>
                    <h1>Welcome Back, <%= customerName %>!</h1>
                    <p>Manage your active vehicle bookings, explore our nationwide premium fleet, and book your next journey with instant confirmation.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                    <a href="availableCars.jsp" class="btn-rental btn-rental-primary btn-lg shadow-lg">
                        <i class="fas fa-key"></i> Rent a Car Now
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Container -->
    <main class="container my-5">
        <!-- Active Rentals Alert (if any ongoing trip) -->
        <% if (activeRentals > 0) { %>
        <div class="alert alert-warning border-0 shadow-sm d-flex align-items-center justify-content-between flex-wrap gap-2 mb-4 p-3" style="border-radius: var(--radius-md); background: #fef3c7; color: #92400e;">
            <div class="d-flex align-items-center gap-3">
                <div class="rounded-circle p-2 bg-warning text-white" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-car-side"></i>
                </div>
                <div>
                    <strong>Active Rental in Progress!</strong>
                    <div class="small">You currently have <%= activeRentals %> ongoing car rental trip(s).</div>
                </div>
            </div>
            <a href="myRentals.jsp" class="btn btn-sm btn-warning text-dark fw-bold px-3">
                View Active Booking <i class="fas fa-arrow-right ms-1"></i>
            </a>
        </div>
        <% } %>

        <!-- Metric KPI Cards -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value"><%= totalRentals %></div>
                            <div class="stat-label">Total Bookings</div>
                        </div>
                        <div class="stat-icon primary">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-history"></i> Lifetime</span>
                        <span>All rental reservations</span>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-warning"><%= activeRentals %></div>
                            <div class="stat-label">Active Rentals</div>
                        </div>
                        <div class="stat-icon warning">
                            <i class="fas fa-road"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-circle text-warning"></i> On-Road</span>
                        <span>Currently active trips</span>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <div class="stat-value text-success"><%= carsAvailable %></div>
                            <div class="stat-label">Cars Available Now</div>
                        </div>
                        <div class="stat-icon success">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="stat-footer">
                        <span class="stat-trend positive"><i class="fas fa-bolt text-success"></i> Instant</span>
                        <span>Ready for immediate booking</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Access Shortcuts Grid -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--radius-lg); background: #ffffff;">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="stat-icon info" style="width: 44px; height: 44px; font-size: 1.2rem;">
                            <i class="fas fa-search-plus"></i>
                        </div>
                        <h5 class="fw-bold mb-0">Browse Fleet</h5>
                    </div>
                    <p class="text-muted small mb-4">Search through all available luxury sedans, family SUVs, and compact hatchbacks.</p>
                    <a href="availableCars.jsp" class="btn-rental btn-rental-outline w-100">
                        Explore Vehicles <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--radius-lg); background: #ffffff;">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="stat-icon purple" style="width: 44px; height: 44px; font-size: 1.2rem;">
                            <i class="fas fa-receipt"></i>
                        </div>
                        <h5 class="fw-bold mb-0">My Rental History</h5>
                    </div>
                    <p class="text-muted small mb-4">Track ongoing bookings, review past trip invoices, and check payment status.</p>
                    <a href="myRentals.jsp" class="btn-rental btn-rental-outline w-100">
                        View Bookings <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--radius-lg); background: #ffffff;">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="stat-icon primary" style="width: 44px; height: 44px; font-size: 1.2rem;">
                            <i class="fas fa-id-card"></i>
                        </div>
                        <h5 class="fw-bold mb-0">Profile & Settings</h5>
                    </div>
                    <p class="text-muted small mb-4">Keep your contact number, residential address, and email information up to date.</p>
                    <a href="ProfileUpdate.jsp" class="btn-rental btn-rental-outline w-100">
                        Manage Profile <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Featured Available Vehicles Preview -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold mb-0">Recommended for You</h3>
            <a href="availableCars.jsp" class="text-primary text-decoration-none fw-semibold small">
                See all available (<%= carsAvailable %>) <i class="fas fa-chevron-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4" id="recommendedCarsGrid">
            <!-- Dynamic sample cars with fallback -->
            <div class="col-md-4">
                <div class="car-card">
                    <div class="car-card-img-wrap">
                        <img src="https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&w=800&q=80" 
                             onerror="this.src='Resources/Luxury Sedan.jpg'" alt="Honda City">
                        <span class="car-badge-type">Sedan</span>
                        <span class="car-badge-status badge-custom badge-available">Available</span>
                    </div>
                    <div class="car-card-body">
                        <h4 class="car-card-title">Honda City</h4>
                        <span class="car-card-reg">KA01AB1234 • 2020</span>
                        <div class="car-specs-grid">
                            <div class="spec-item"><i class="fas fa-cog"></i> Auto</div>
                            <div class="spec-item"><i class="fas fa-gas-pump"></i> Petrol</div>
                            <div class="spec-item"><i class="fas fa-users"></i> 5 Seats</div>
                            <div class="spec-item"><i class="fas fa-tachometer-alt"></i> 18 km/l</div>
                        </div>
                        <div class="car-card-footer">
                            <div class="car-price-block">
                                <span class="price-value">&#8377;2,200</span>
                                <span class="price-period">per day</span>
                            </div>
                            <a href="availableCars.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Rent Now</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="car-card">
                    <div class="car-card-img-wrap">
                        <img src="https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=800&q=80" 
                             onerror="this.src='Resources/Premium SUV.jpg'" alt="Tata Nexon">
                        <span class="car-badge-type">SUV</span>
                        <span class="car-badge-status badge-custom badge-available">Available</span>
                    </div>
                    <div class="car-card-body">
                        <h4 class="car-card-title">Tata Nexon</h4>
                        <span class="car-card-reg">KA05IJ3141 • 2022</span>
                        <div class="car-specs-grid">
                            <div class="spec-item"><i class="fas fa-cog"></i> Auto</div>
                            <div class="spec-item"><i class="fas fa-gas-pump"></i> Diesel</div>
                            <div class="spec-item"><i class="fas fa-users"></i> 5 Seats</div>
                            <div class="spec-item"><i class="fas fa-tachometer-alt"></i> 17 km/l</div>
                        </div>
                        <div class="car-card-footer">
                            <div class="car-price-block">
                                <span class="price-value">&#8377;2,500</span>
                                <span class="price-period">per day</span>
                            </div>
                            <a href="availableCars.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Rent Now</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="car-card">
                    <div class="car-card-img-wrap">
                        <img src="https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80" 
                             onerror="this.src='Resources/Luxury Sedan.jpg'" alt="Maruti Swift">
                        <span class="car-badge-type">Hatchback</span>
                        <span class="car-badge-status badge-custom badge-available">Available</span>
                    </div>
                    <div class="car-card-body">
                        <h4 class="car-card-title">Maruti Swift</h4>
                        <span class="car-card-reg">KA03EF9101 • 2021</span>
                        <div class="car-specs-grid">
                            <div class="spec-item"><i class="fas fa-cog"></i> Manual</div>
                            <div class="spec-item"><i class="fas fa-gas-pump"></i> Petrol</div>
                            <div class="spec-item"><i class="fas fa-users"></i> 5 Seats</div>
                            <div class="spec-item"><i class="fas fa-tachometer-alt"></i> 23 km/l</div>
                        </div>
                        <div class="car-card-footer">
                            <div class="car-price-block">
                                <span class="price-value">&#8377;1,400</span>
                                <span class="price-period">per day</span>
                            </div>
                            <a href="availableCars.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Rent Now</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="rental-footer">
        <div class="container text-center">
            <p class="mb-0 small text-muted">&copy; 2025 DriveLux DBMS Car Rental Management System. Logged in as <%= customerName %> (ID: #<%= customerID %>).</p>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/car-data.js"></script>
    <script>
        function triggerLogout() {
            Swal.fire({
                title: "Sign Out of DriveLux?",
                text: "Are you sure you want to log out of your session?",
                icon: "question",
                showCancelButton: true,
                confirmButtonColor: "#2563eb",
                cancelButtonColor: "#64748b",
                confirmButtonText: "Yes, Sign Out",
                cancelButtonText: "Stay Logged In"
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.replace("login.jsp");
                }
            });
        }

        const logoutBtn = document.getElementById("lbtn");
        if (logoutBtn) {
            logoutBtn.addEventListener("click", function(e) {
                e.preventDefault();
                triggerLogout();
            });
        }

        const logoutBtnMobile = document.getElementById("lbtn-mobile");
        if (logoutBtnMobile) {
            logoutBtnMobile.addEventListener("click", function(e) {
                e.preventDefault();
                triggerLogout();
            });
        }
    </script>
</body>
</html>
