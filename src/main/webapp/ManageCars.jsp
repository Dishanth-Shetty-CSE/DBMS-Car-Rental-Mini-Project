<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fleet Inventory Management - Admin</title>
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
                <a class="nav-link active" href="ManageCars.jsp"><i class="fas fa-car"></i> Fleet</a>
                <a class="nav-link" href="manageRentals.jsp"><i class="fas fa-calendar-alt"></i> Rentals</a>
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
                        <i class="fas fa-tools text-warning"></i> Fleet Vehicle Control Console
                    </div>
                    <h1>Manage Fleet Vehicles</h1>
                    <p>Review all motor vehicles registered across nationwide stations. Update vehicle statuses, modify specifications, or remove retired cars.</p>
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
                    <h3><i class="fas fa-car text-primary"></i> Registered Fleet Registry</h3>
                </div>
                <div class="d-flex gap-2">
                    <div class="input-with-icon" style="min-width: 280px;">
                        <i class="fas fa-search"></i>
                        <input type="text" id="carSearchInput" class="form-control-custom form-control-sm" 
                               placeholder="Search by Model, Reg No, or Status..." onkeyup="filterCarsTable()">
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="table-responsive">
                <table class="custom-table" id="manageCarsTable">
                    <thead>
                        <tr>
                            <th>Vehicle Photo</th>
                            <th>Registration Plate</th>
                            <th>Model & Class</th>
                            <th>Model Year</th>
                            <th>Color</th>
                            <th>Status</th>
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

                                String query = "SELECT Car_Regno, Car_Model, Car_Year, Car_Color, Car_Status FROM Car ORDER BY Car_Regno ASC";
                                preparedStatement = connection.prepareStatement(query);
                                resultSet = preparedStatement.executeQuery();

                                while (resultSet.next()) {
                                    String carRegno = resultSet.getString("Car_Regno");
                                    String carModel = resultSet.getString("Car_Model");
                                    int carYear = resultSet.getInt("Car_Year");
                                    String carColor = resultSet.getString("Car_Color");
                                    String carStatus = resultSet.getString("Car_Status");

                                    boolean isAvail = "Available".equalsIgnoreCase(carStatus);
                        %>
                        <tr class="car-row" data-search="<%= carRegno %> <%= carModel %> <%= carYear %> <%= carColor %> <%= carStatus %>">
                            <td>
                                <img src="Resources/Luxury Sedan.jpg" id="admin-thumb-<%= carRegno %>" 
                                     style="width: 72px; height: 50px; border-radius: 8px; object-fit: cover;" 
                                     onerror="this.src='Resources/Luxury Sedan.jpg'" alt="<%= carModel %>">
                            </td>
                            <td>
                                <span class="font-monospace fw-bold text-dark px-2 py-1 bg-light border rounded">
                                    <%= carRegno %>
                                </span>
                            </td>
                            <td>
                                <div class="fw-bold text-primary"><%= carModel %></div>
                                <small class="text-muted" id="admin-cat-<%= carRegno %>">Standard Vehicle</small>
                            </td>
                            <td><%= carYear %></td>
                            <td>
                                <span class="d-inline-flex align-items-center gap-1">
                                    <i class="fas fa-circle small text-secondary"></i> <%= carColor %>
                                </span>
                            </td>
                            <td>
                                <span class="badge-custom <%= isAvail ? "badge-available" : "badge-not-available" %>">
                                    <i class="fas <%= isAvail ? "fa-check-circle" : "fa-clock" %>"></i> <%= carStatus %>
                                </span>
                            </td>
                            <td class="text-center">
                                <button class="btn-rental btn-rental-outline btn-rental-sm me-1" 
                                        onclick="window.location.href='UpdateCarServlet?id=<%= carRegno %>'" title="Edit Car">
                                    <i class="fas fa-edit text-primary"></i> Update
                                </button>
                                <button class="btn-rental btn-rental-danger btn-rental-sm" 
                                        onclick="confirmDelete('<%= carRegno %>')" title="Delete Car">
                                    <i class="fas fa-trash-alt"></i> Delete
                                </button>
                            </td>
                        </tr>
                        <%
                                }
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

    <!-- Bootstrap JS & Vehicle Data Helper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/car-data.js"></script>
    <script>
        // Populate car images dynamically
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll(".car-row").forEach(row => {
                const search = row.getAttribute("data-search");
                const parts = search.split(" ");
                const reg = parts[0];
                const model = parts[1] + (parts[2] ? " " + parts[2] : "");
                const details = getCarDetails(model);

                const thumb = document.getElementById("admin-thumb-" + reg);
                if (thumb) {
                    thumb.src = details.image;
                    thumb.onerror = function() { this.src = details.fallbackImage; };
                }
                const cat = document.getElementById("admin-cat-" + reg);
                if (cat) {
                    cat.textContent = details.category;
                }
            });
        });

        // Search Filter
        function filterCarsTable() {
            const query = document.getElementById("carSearchInput").value.toLowerCase().trim();
            document.querySelectorAll(".car-row").forEach(row => {
                const text = row.getAttribute("data-search").toLowerCase();
                row.style.display = text.includes(query) ? "" : "none";
            });
        }

        // Delete with SweetAlert2 (Preserves backend contract)
        function confirmDelete(carRegno) {
            Swal.fire({
                title: 'Delete Vehicle ' + carRegno + '?',
                text: "This vehicle and its associated historical references will be permanently removed.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                cancelButtonColor: '#64748b',
                confirmButtonText: 'Yes, delete vehicle',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    deleteCar(carRegno);
                }
            });
        }

        function deleteCar(carRegno) {
            fetch('DeleteCarServlet?id=' + encodeURIComponent(carRegno))
                .then(response => response.text())
                .then(text => {
                    if (text === "success") {
                        Swal.fire({
                            title: 'Deleted!',
                            text: 'Vehicle has been successfully removed from fleet.',
                            icon: 'success',
                            confirmButtonColor: '#2563eb'
                        }).then(() => {
                            window.location.reload();
                        });
                    } else if (text === "notfound") {
                        Swal.fire(
                            'Not Found!',
                            'Car does not exist in the database.',
                            'warning'
                        );
                    } else {
                        Swal.fire(
                            'Error!',
                            'Failed to delete vehicle. Database error or constraint.',
                            'error'
                        );
                    }
                })
                .catch(error => {
                    Swal.fire(
                        'Error!',
                        error.message,
                        'error'
                    );
                });
        }
    </script>
</body>
</html>