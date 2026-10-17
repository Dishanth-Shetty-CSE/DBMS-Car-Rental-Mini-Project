<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Station Locations - Admin Console</title>
    <!-- Fonts -->
    <!-- Poppins Font Everywhere -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- Application CSS -->
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hub-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .hub-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: #93c5fd;
        }
        .hub-icon-circle {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 16px;
        }
    </style>
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
                <a class="nav-link" href="ManageCustomers.jsp"><i class="fas fa-users"></i> Customers</a>
                <a class="nav-link active" href="ManageLocations.jsp"><i class="fas fa-map-marked-alt"></i> Hub Locations</a>
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
                        <i class="fas fa-map-pin text-success"></i> Regional Station Hubs & Depots
                    </div>
                    <h1>Depot & Pickup Locations</h1>
                    <p>Audit vehicle pickup terminals, metropolitan station hubs, and regional return centers across India.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Container -->
    <main class="container my-5">
        <%
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;
            java.util.List<java.util.Map<String, String>> locList = new java.util.ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

                String query = "SELECT Loc_ID, Loc_Name, Loc_City, Loc_State, Loc_Zipcode FROM Location ORDER BY Loc_ID ASC";
                preparedStatement = connection.prepareStatement(query);
                resultSet = preparedStatement.executeQuery();

                while (resultSet.next()) {
                    java.util.Map<String, String> row = new java.util.HashMap<>();
                    row.put("id", String.valueOf(resultSet.getInt("Loc_ID")));
                    row.put("name", resultSet.getString("Loc_Name"));
                    row.put("city", resultSet.getString("Loc_City"));
                    row.put("state", resultSet.getString("Loc_State"));
                    row.put("zipcode", resultSet.getString("Loc_Zipcode"));
                    locList.add(row);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (resultSet != null) resultSet.close(); } catch (Exception e) {}
                try { if (preparedStatement != null) preparedStatement.close(); } catch (Exception e) {}
                try { if (connection != null) connection.close(); } catch (Exception e) {}
            }
        %>

        <!-- Hub Cards Grid -->
        <h3 class="fw-bold mb-4 d-flex align-items-center gap-2">
            <i class="fas fa-network-wired text-primary"></i> Active Regional Stations (<%= locList.size() %>)
        </h3>

        <div class="row g-4 mb-5">
            <% for (java.util.Map<String, String> loc : locList) { %>
            <div class="col-md-6 col-lg-4">
                <div class="hub-card">
                    <div>
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="hub-icon-circle">
                                <i class="fas fa-warehouse"></i>
                            </div>
                            <span class="badge bg-light text-primary border font-monospace px-2 py-1">
                                Hub #<%= loc.get("id") %>
                            </span>
                        </div>
                        <h4 class="fw-bold mb-1 text-dark"><%= loc.get("name") %></h4>
                        <div class="text-primary fw-semibold mb-2">
                            <i class="fas fa-map-marker-alt me-1"></i> <%= loc.get("city") %>, <%= loc.get("state") %>
                        </div>
                        <p class="text-muted small mb-0">
                            Equipped with 24/7 key return dropboxes, high-speed vehicle cleaning bays, and EV charging outlets.
                        </p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-3">
                        <span class="small text-muted font-monospace"><i class="fas fa-mail-bulk me-1"></i> PIN: <%= loc.get("zipcode") %></span>
                        <span class="badge-custom badge-available small"><i class="fas fa-circle text-success" style="font-size: 0.5rem;"></i> Active Depot</span>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Master Table View -->
        <div class="table-card">
            <div class="table-card-header">
                <div>
                    <h3><i class="fas fa-table text-primary"></i> Station Directory Register</h3>
                </div>
                <div>
                    <input type="text" id="locSearchInput" class="form-control-custom form-control-sm" 
                           placeholder="Filter stations..." onkeyup="filterLocationsTable()">
                </div>
            </div>

            <div class="table-responsive">
                <table class="custom-table" id="locationsTable">
                    <thead>
                        <tr>
                            <th>Location ID</th>
                            <th>Station / Hub Name</th>
                            <th>City</th>
                            <th>State</th>
                            <th>Postal Code</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (java.util.Map<String, String> loc : locList) { %>
                        <tr class="loc-row" data-search="<%= loc.get("id") %> <%= loc.get("name") %> <%= loc.get("city") %> <%= loc.get("state") %> <%= loc.get("zipcode") %>">
                            <td>
                                <span class="badge bg-light text-primary border font-monospace px-2 py-1">
                                    #<%= loc.get("id") %>
                                </span>
                            </td>
                            <td class="fw-bold text-dark">
                                <i class="fas fa-building text-muted me-1"></i> <%= loc.get("name") %>
                            </td>
                            <td><%= loc.get("city") %></td>
                            <td><%= loc.get("state") %></td>
                            <td><span class="font-monospace text-muted"><%= loc.get("zipcode") %></span></td>
                            <td>
                                <span class="badge-custom badge-available">
                                    <i class="fas fa-check-circle"></i> Operational
                                </span>
                            </td>
                        </tr>
                        <% } %>
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
        function filterLocationsTable() {
            const query = document.getElementById("locSearchInput").value.toLowerCase().trim();
            document.querySelectorAll(".loc-row").forEach(row => {
                const text = row.getAttribute("data-search").toLowerCase();
                row.style.display = text.includes(query) ? "" : "none";
            });
        }
    </script>
</body>
</html>