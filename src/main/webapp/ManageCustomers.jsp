<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Directory - Admin Console</title>
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
                <a class="nav-link" href="manageRentals.jsp"><i class="fas fa-calendar-alt"></i> Rentals</a>
                <a class="nav-link active" href="ManageCustomers.jsp"><i class="fas fa-users"></i> Customers</a>
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
                        <i class="fas fa-address-book text-info"></i> Customer Relations & Accounts
                    </div>
                    <h1>Customer Directory</h1>
                    <p>Access registered client records, verify contact details, monitor membership standings, or manage accounts.</p>
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
                    <h3><i class="fas fa-users text-primary"></i> Registered Client Accounts</h3>
                </div>
                <div class="d-flex gap-2">
                    <div class="input-with-icon" style="min-width: 280px;">
                        <i class="fas fa-search"></i>
                        <input type="text" id="custSearchInput" class="form-control-custom form-control-sm" 
                               placeholder="Search customer by name, email, phone..." onkeyup="filterCustomersTable()">
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="table-responsive">
                <table class="custom-table" id="manageCustomersTable">
                    <thead>
                        <tr>
                            <th>Customer ID</th>
                            <th>Customer Name</th>
                            <th>Address / Location</th>
                            <th>Contact Phone</th>
                            <th>Email Address</th>
                            <th class="text-center">Action</th>
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

                                String query = "SELECT Cust_ID, Cust_Name, Cust_Address, Cust_Phone, Cust_Email FROM Customer ORDER BY Cust_ID ASC";
                                preparedStatement = connection.prepareStatement(query);
                                resultSet = preparedStatement.executeQuery();

                                while (resultSet.next()) {
                                    String custID = resultSet.getString("Cust_ID");
                                    String name = resultSet.getString("Cust_Name") != null ? resultSet.getString("Cust_Name") : "Guest";
                                    String address = resultSet.getString("Cust_Address") != null ? resultSet.getString("Cust_Address") : "N/A";
                                    String phone = resultSet.getString("Cust_Phone") != null ? resultSet.getString("Cust_Phone") : "N/A";
                                    String email = resultSet.getString("Cust_Email") != null ? resultSet.getString("Cust_Email") : "N/A";
                                    
                                    String initial = name.length() > 0 ? name.substring(0, 1).toUpperCase() : "U";
                        %>
                        <tr class="cust-row" data-search="<%= custID %> <%= name %> <%= address %> <%= phone %> <%= email %>">
                            <td>
                                <span class="badge bg-light text-primary border font-monospace px-2 py-1">
                                    #<%= custID %>
                                </span>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="nav-user-avatar" style="width: 32px; height: 32px; font-size: 0.85rem;">
                                        <%= initial %>
                                    </div>
                                    <div class="fw-bold text-dark"><%= name %></div>
                                </div>
                            </td>
                            <td>
                                <small class="text-muted"><i class="fas fa-map-marker-alt text-primary me-1"></i> <%= address %></small>
                            </td>
                            <td>
                                <a href="tel:<%= phone %>" class="text-decoration-none text-dark small fw-semibold">
                                    <i class="fas fa-phone-alt text-success me-1"></i> <%= phone %>
                                </a>
                            </td>
                            <td>
                                <a href="mailto:<%= email %>" class="text-decoration-none text-primary small">
                                    <i class="fas fa-envelope text-primary me-1"></i> <%= email %>
                                </a>
                            </td>
                            <td class="text-center">
                                <button class="btn-rental btn-rental-danger btn-rental-sm" 
                                        onclick="confirmDelete('<%= custID %>', '<%= name %>')" title="Delete Customer Account">
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterCustomersTable() {
            const query = document.getElementById("custSearchInput").value.toLowerCase().trim();
            document.querySelectorAll(".cust-row").forEach(row => {
                const text = row.getAttribute("data-search").toLowerCase();
                row.style.display = text.includes(query) ? "" : "none";
            });
        }

        function confirmDelete(customerId, customerName) {
            Swal.fire({
                title: 'Delete Customer #' + customerId + '?',
                text: "Deleting " + (customerName || "this customer") + " will remove all their historical data.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                cancelButtonColor: '#64748b',
                confirmButtonText: 'Yes, delete customer',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    deleteCustomer(customerId);
                }
            });
        }

        function deleteCustomer(customerId) {
            fetch('DeleteCustomerServlet?id=' + customerId)
                .then(response => {
                    if (response.ok) {
                        return response.text();
                    } else {
                        throw new Error('Failed to delete customer.');
                    }
                })
                .then(text => {
                    if (text === "success") {
                        Swal.fire({
                            title: 'Deleted!',
                            text: 'Customer has been deleted from system.',
                            icon: 'success',
                            confirmButtonColor: '#2563eb'
                        }).then(() => {
                            window.location.reload();
                        });
                    } else {
                        Swal.fire({
                            title: 'Error!',
                            text: 'Failed to delete customer: ' + text,
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