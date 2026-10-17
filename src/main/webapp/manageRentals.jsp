<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Rental Reservations - Admin</title>
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
                <div class="brand-badge" style="background: linear-gradient(135deg, #4f46e5, #0ea5e9);"><i class="fas fa-shield-alt"></i></div>
                <span>Drive<span style="color: #60a5fa;">Lux</span> <small class="text-white-50 fs-6 fw-normal ms-1">Admin</small></span>
            </a>
            
            <nav class="d-flex align-items-center gap-2">
                <a class="nav-link" href="admin-dashboard.jsp"><i class="fas fa-chart-pie"></i> Overview</a>
                <a class="nav-link" href="ManageCars.jsp"><i class="fas fa-car"></i> Fleet</a>
                <a class="nav-link active" href="manageRentals.jsp"><i class="fas fa-calendar-alt"></i> Rentals</a>
                <a class="nav-link" href="ManageCustomers.jsp"><i class="fas fa-users"></i> Customers</a>
                <a class="btn-rental btn-rental-outline btn-rental-sm ms-2" href="admin-dashboard.jsp">
                    <i class="fas fa-arrow-left"></i> Dashboard
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
                        <i class="fas fa-clipboard-check text-info"></i> Booking Dispatch & Audit Desk
                    </div>
                    <h1>Manage Rental Reservations</h1>
                    <p>Track all client bookings across the system. Audit vehicle assignments, update journey statuses, or cancel contracts.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Container -->
    <main class="container my-5">
        <div class="table-card">
            <!-- Table Header with Search -->
            <div class="table-card-header">
                <div>
                    <h3><i class="fas fa-receipt text-primary"></i> Master Rentals Ledger</h3>
                </div>
                <div class="d-flex gap-2">
                    <div class="input-with-icon" style="min-width: 280px;">
                        <i class="fas fa-search"></i>
                        <input type="text" id="rentalSearchInput" class="form-control-custom form-control-sm" 
                               placeholder="Filter by ID, Customer, Car, or Status..." onkeyup="filterRentalsTable()">
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="table-responsive">
                <table class="custom-table" id="manageRentalsTable">
                    <thead>
                        <tr>
                            <th>Rental ID</th>
                            <th>Rental Name / Plan</th>
                            <th>Rental Period</th>
                            <th>Status</th>
                            <th>Payment</th>
                            <th>Cust ID</th>
                            <th>Car Reg No</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            Connection connection = null;
                            PreparedStatement preparedStatement = null;
                            ResultSet resultSet = null;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");
                                String query = "SELECT r.Rental_ID, r.Rental_Name, r.Rent_Start_Date, r.Rent_End_Date, r.Rental_Status, r.Cust_ID, r.Car_Regno, " +
                                               "p.Amount_Paid, p.Pay_Status, p.Pay_Method " +
                                               "FROM Rental r " +
                                               "LEFT JOIN (SELECT Rental_ID, MAX(Pay_ID) as max_pay_id FROM Payment GROUP BY Rental_ID) latest_p ON r.Rental_ID = latest_p.Rental_ID " +
                                               "LEFT JOIN Payment p ON latest_p.max_pay_id = p.Pay_ID " +
                                               "ORDER BY r.Rental_ID DESC";
                                preparedStatement = connection.prepareStatement(query);
                                resultSet = preparedStatement.executeQuery();
                                
                                while (resultSet.next()) {
                                    int rId = resultSet.getInt("Rental_ID");
                                    String rName = resultSet.getString("Rental_Name");
                                    Date sDate = resultSet.getDate("Rent_Start_Date");
                                    Date eDate = resultSet.getDate("Rent_End_Date");
                                    String rStatus = resultSet.getString("Rental_Status");
                                    int custId = resultSet.getInt("Cust_ID");
                                    String carReg = resultSet.getString("Car_Regno");
                                    double pAmount = resultSet.getDouble("Amount_Paid");
                                    String pStatus = resultSet.getString("Pay_Status");
                                    String pMethod = resultSet.getString("Pay_Method");

                                    String badgeClass = "badge-available";
                                    String icon = "fa-check";
                                    if ("Completed".equalsIgnoreCase(rStatus)) {
                                        badgeClass = "badge-completed";
                                        icon = "fa-check-double";
                                    } else if ("Ongoing".equalsIgnoreCase(rStatus)) {
                                        badgeClass = "badge-ongoing";
                                        icon = "fa-play-circle";
                                    } else if ("Cancelled".equalsIgnoreCase(rStatus)) {
                                        badgeClass = "badge-cancelled";
                                        icon = "fa-ban";
                                    }
                        %>
                        <tr class="rental-row" data-search="<%= rId %> <%= rName %> <%= rStatus %> <%= custId %> <%= carReg %>">
                            <td>
                                <span class="badge bg-light text-primary border font-monospace px-2 py-1">
                                    #<%= rId %>
                                </span>
                            </td>
                            <td>
                                <div class="fw-bold text-dark"><%= rName %></div>
                            </td>
                            <td>
                                <div class="small text-muted">
                                    <i class="fas fa-calendar-alt text-primary me-1"></i> <%= sDate %> &rarr; <%= eDate %>
                                </div>
                            </td>
                            <td>
                                <span class="badge-custom <%= badgeClass %>">
                                    <i class="fas <%= icon %>"></i> <%= rStatus %>
                                </span>
                            </td>
                            <td>
                                <% if ("Completed".equalsIgnoreCase(pStatus) && pAmount > 0.0) { %>
                                    <span class="badge bg-success-subtle text-success font-monospace fw-bold">
                                        &#8377;<%= String.format(java.util.Locale.US, "%,.2f", pAmount) %>
                                    </span>
                                    <div class="small text-muted"><%= pMethod != null ? pMethod : "Paid" %></div>
                                <% } else { %>
                                    <span class="badge bg-warning-subtle text-warning fw-semibold">
                                        <i class="fas fa-clock me-1"></i>Pending
                                    </span>
                                <% } %>
                            </td>
                            <td>
                                <a href="ManageCustomers.jsp" class="badge bg-light text-dark border text-decoration-none" title="View Customer Details">
                                    <i class="fas fa-user text-muted me-1"></i> Cust #<%= custId %>
                                </a>
                            </td>
                            <td>
                                <span class="font-monospace fw-bold text-secondary px-2 py-1 bg-light border rounded">
                                    <%= carReg %>
                                </span>
                            </td>
                            <td class="text-center">
                                <button class="btn-rental btn-rental-outline btn-rental-sm me-1" 
                                        onclick="window.location.href='UpdateRentalServlet?id=<%= rId %>'" title="Edit Rental Details">
                                    <i class="fas fa-edit text-primary"></i> Update
                                </button>
                                <button class="btn-rental btn-rental-danger btn-rental-sm" 
                                        onclick="confirmDelete('<%= rId %>')" title="Delete Rental Record">
                                    <i class="fas fa-trash-alt"></i> Delete
                                </button>
                            </td>
                        </tr>
                        <%  } 
                            } catch (Exception e) { 
                                e.printStackTrace();
                            } finally {
                                try { if (resultSet != null) resultSet.close(); } catch (Exception e) {}
                                try { if (preparedStatement != null) preparedStatement.close(); } catch (Exception e) {}
                                try { if (connection != null) connection.close(); } catch (Exception e) {}
                            } 
                        %>
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterRentalsTable() {
            const query = document.getElementById("rentalSearchInput").value.toLowerCase().trim();
            document.querySelectorAll(".rental-row").forEach(row => {
                const text = row.getAttribute("data-search").toLowerCase();
                row.style.display = text.includes(query) ? "" : "none";
            });
        }

        function confirmDelete(rentalId) {
            Swal.fire({
                title: 'Delete Rental #' + rentalId + '?',
                text: "This booking reservation record will be permanently deleted from the database.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                cancelButtonColor: '#64748b',
                confirmButtonText: 'Yes, delete record',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    deleteRental(rentalId);
                }
            });
        }

        function deleteRental(rentalId) {
            fetch('DeleteRentalServlet?id=' + rentalId)
                .then(response => response.text())
                .then(text => {
                    if (text === "success") {
                        Swal.fire({
                            title: 'Deleted!',
                            text: 'Rental reservation #' + rentalId + ' has been deleted.',
                            icon: 'success',
                            confirmButtonColor: '#2563eb'
                        }).then(() => {
                            window.location.reload();
                        });
                    } else {
                        Swal.fire({
                            title: 'Error!',
                            text: 'Failed to delete rental record from database.',
                            icon: 'error',
                            confirmButtonColor: '#2563eb'
                        });
                    }
                })
                .catch(error => {
                    Swal.fire({
                        title: 'System Error!',
                        text: error.message,
                        icon: 'error',
                        confirmButtonColor: '#2563eb'
                    });
                });
        }
    </script>
</body>
</html>