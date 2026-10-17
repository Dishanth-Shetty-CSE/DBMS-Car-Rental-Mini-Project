<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Cars - DriveLux Fleet</title>
    <!-- Poppins Font Everywhere -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- jQuery & SweetAlert2 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Application CSS & Confirm Alert -->
    <link rel="stylesheet" href="css/style.css">
    <script src="js/confirm-alert.js"></script>
    <style>
        .filter-btn {
            background: #ffffff;
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
            font-weight: 600;
            font-size: 0.88rem;
            padding: 8px 18px;
            border-radius: var(--radius-full);
            cursor: pointer;
            transition: var(--transition);
        }
        .filter-btn:hover, .filter-btn.active {
            background: var(--primary);
            color: #ffffff;
            border-color: var(--primary);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }
        .view-btn {
            background: #ffffff;
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
            padding: 8px 14px;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: var(--transition);
        }
        .view-btn.active {
            background: #0f172a;
            color: #ffffff;
            border-color: #0f172a;
        }
        .modal-car-preview {
            background: #f8fafc;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-color);
            padding: 14px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .modal-car-thumb {
            width: 80px;
            height: 60px;
            border-radius: var(--radius-sm);
            object-fit: cover;
        }
        .cost-estimate-box {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: var(--radius-md);
            padding: 12px 16px;
            margin-bottom: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <!-- Unified Navigation Bar -->
    <header class="rental-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand" href="customer-dashboard.jsp">
                <div class="brand-badge"><i class="fas fa-car-side"></i></div>
                <span>Drive<span style="color: #60a5fa;">Lux</span></span>
            </a>
            
            <nav class="d-flex align-items-center gap-2">
                <a class="nav-link" href="customer-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a class="nav-link active" href="availableCars.jsp"><i class="fas fa-car"></i> Available Cars</a>
                <a class="nav-link" href="myRentals.jsp"><i class="fas fa-calendar-check"></i> My Rentals</a>
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
                        <i class="fas fa-check-double text-success"></i> Real-time Fleet Inventory
                    </div>
                    <h1>Available Fleet Ready to Rent</h1>
                    <p>Discover our meticulously maintained selection of cars. Compare models, check real-world specifications, and rent instantly with transparent pricing.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <div class="d-inline-flex bg-white rounded-pill p-1 shadow-sm border">
                        <button class="view-btn active" id="viewCardsBtn" onclick="switchView('cards')">
                            <i class="fas fa-th-large me-1"></i> Grid Cards
                        </button>
                        <button class="view-btn" id="viewTableBtn" onclick="switchView('table')">
                            <i class="fas fa-list me-1"></i> Data Table
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Fleet View Container -->
    <main class="container my-5">
        <!-- Search and Filter Bar -->
        <div class="card border-0 shadow-sm p-3 mb-4" style="border-radius: var(--radius-lg); background: #ffffff;">
            <div class="row g-3 align-items-center">
                <div class="col-lg-5">
                    <div class="input-with-icon">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" class="form-control-custom" 
                               placeholder="Search available cars by model, year, or color..." onkeyup="filterCars()">
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="d-flex flex-wrap gap-2 justify-content-lg-end">
                        <button class="filter-btn active" onclick="filterCategory('all', this)">All Types</button>
                        <button class="filter-btn" onclick="filterCategory('Sedan', this)">Sedans</button>
                        <button class="filter-btn" onclick="filterCategory('SUV', this)">SUVs</button>
                        <button class="filter-btn" onclick="filterCategory('Hatchback', this)">Hatchbacks</button>
                    </div>
                </div>
            </div>
        </div>

        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            boolean hasAvailableCars = false;

            // Structure to hold car data for both views
            java.util.List<java.util.Map<String, String>> carList = new java.util.ArrayList<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

                String query = "SELECT * FROM Car WHERE Car_Status = 'Available'";
                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    hasAvailableCars = true;
                    java.util.Map<String, String> c = new java.util.HashMap<>();
                    c.put("regNo", rs.getString("Car_Regno"));
                    c.put("model", rs.getString("Car_Model"));
                    c.put("year", String.valueOf(rs.getInt("Car_Year")));
                    c.put("color", rs.getString("Car_Color"));
                    c.put("status", rs.getString("Car_Status"));
                    carList.add(c);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>

        <!-- 1. GRID CARDS VIEW (DEFAULT & IMPRESSIVE) -->
        <div id="cardsViewContainer">
            <% if (!hasAvailableCars) { %>
                <div class="text-center py-5">
                    <div class="stat-icon warning mx-auto mb-3" style="width: 64px; height: 64px;">
                        <i class="fas fa-car-crash"></i>
                    </div>
                    <h4>No Cars Currently Available</h4>
                    <p class="text-muted">All vehicles in our fleet are currently booked or undergoing maintenance. Please check back shortly.</p>
                </div>
            <% } else { %>
                <div class="row g-4" id="carCardsRow">
                    <% for (java.util.Map<String, String> car : carList) { 
                        String regNo = car.get("regNo");
                        String model = car.get("model");
                        String year = car.get("year");
                        String color = car.get("color");
                        String status = car.get("status");
                    %>
                    <div class="col-md-6 col-lg-4 car-card-col" data-model="<%= model %>" data-color="<%= color %>" data-year="<%= year %>" data-reg="<%= regNo %>">
                        <div class="car-card">
                            <div class="car-card-img-wrap">
                                <img src="Resources/Luxury Sedan.jpg" id="img-<%= regNo %>" alt="<%= model %>" onerror="this.src='Resources/Luxury Sedan.jpg'">
                                <span class="car-badge-type" id="type-<%= regNo %>">Sedan</span>
                                <span class="car-badge-status badge-custom badge-available">
                                    <i class="fas fa-check-circle"></i> <%= status %>
                                </span>
                            </div>
                            <div class="car-card-body">
                                <h4 class="car-card-title"><%= model %></h4>
                                <span class="car-card-reg"><%= regNo %> • Year <%= year %> • <%= color %></span>
                                
                                <div class="car-specs-grid">
                                    <div class="spec-item" id="trans-<%= regNo %>"><i class="fas fa-cog"></i> Auto</div>
                                    <div class="spec-item" id="fuel-<%= regNo %>"><i class="fas fa-gas-pump"></i> Petrol</div>
                                    <div class="spec-item" id="seats-<%= regNo %>"><i class="fas fa-users"></i> 5 Seats</div>
                                    <div class="spec-item" id="mileage-<%= regNo %>"><i class="fas fa-tachometer-alt"></i> 18 km/l</div>
                                </div>

                                <div class="car-card-footer">
                                    <div class="car-price-block">
                                        <span class="price-value" id="price-<%= regNo %>">&#8377;2,200</span>
                                        <span class="price-period">per day</span>
                                    </div>
                                    <button class="btn-rental btn-rental-primary btn-rental-sm" onclick="openModal('<%= regNo %>', '<%= status %>', '<%= model %>')">
                                        <i class="fas fa-key"></i> Rent Now
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <!-- 2. DATA TABLE VIEW (SYNCHRONIZED POWER USER OPTION) -->
        <div id="tableViewContainer" style="display: none;">
            <div class="table-card">
                <div class="table-card-header">
                    <h3><i class="fas fa-list-alt text-primary"></i> Available Inventory Register</h3>
                    <span class="badge bg-primary px-3 py-2 rounded-pill"><%= carList.size() %> Cars Ready</span>
                </div>
                <div class="table-responsive">
                    <table class="custom-table" id="availableCarsTable">
                        <thead>
                            <tr>
                                <th>Car Photo</th>
                                <th>Registration</th>
                                <th>Vehicle Model</th>
                                <th>Model Year</th>
                                <th>Exterior Color</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (java.util.Map<String, String> car : carList) { 
                                String regNo = car.get("regNo");
                                String model = car.get("model");
                                String year = car.get("year");
                                String color = car.get("color");
                                String status = car.get("status");
                            %>
                            <tr class="car-table-row" data-model="<%= model %>" data-color="<%= color %>" data-year="<%= year %>" data-reg="<%= regNo %>">
                                <td>
                                    <img src="Resources/Luxury Sedan.jpg" id="tbl-img-<%= regNo %>" style="width: 70px; height: 48px; border-radius: 6px; object-fit: cover;" onerror="this.src='Resources/Luxury Sedan.jpg'" alt="<%= model %>">
                                </td>
                                <td><span class="font-monospace fw-bold text-dark"><%= regNo %></span></td>
                                <td>
                                    <div class="fw-bold text-primary"><%= model %></div>
                                    <small class="text-muted" id="tbl-type-<%= regNo %>">Standard Vehicle</small>
                                </td>
                                <td><%= year %></td>
                                <td><i class="fas fa-circle me-1 small" style="color: #64748b;"></i> <%= color %></td>
                                <td>
                                    <span class="badge-custom badge-available">
                                        <i class="fas fa-check-circle"></i> <%= status %>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <button class="btn-rental btn-rental-primary btn-rental-sm" onclick="openModal('<%= regNo %>', '<%= status %>', '<%= model %>')">
                                        <i class="fas fa-key"></i> Rent Now
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- Rental Booking Modal (Preserves all form inputs & processRent servlet integration) -->
    <div id="rentModal" class="modal-rental">
        <div class="modal-rental-content">
            <div class="modal-rental-header">
                <h3><i class="fas fa-key me-2 text-primary"></i> Reserve Vehicle</h3>
                <button type="button" class="modal-rental-close" onclick="closeModal()">&times;</button>
            </div>
            
            <div class="modal-rental-body">
                <!-- Selected Vehicle Preview -->
                <div class="modal-car-preview">
                    <img id="modalCarThumb" src="Resources/Luxury Sedan.jpg" class="modal-car-thumb" alt="Car">
                    <div>
                        <h5 class="fw-bold mb-1" id="modalCarModelDisplay">Vehicle Model</h5>
                        <div class="small text-muted font-monospace" id="modalCarRegDisplay">Reg No</div>
                    </div>
                </div>

                <!-- Live Duration & Cost Estimate -->
                <div class="cost-estimate-box" id="costEstimateBox">
                    <div>
                        <span class="text-muted">Estimated Duration:</span> <strong id="estDuration">1 Day</strong>
                    </div>
                    <div>
                        <span class="text-muted">Total Rent:</span> <strong class="text-primary fs-5" id="estPrice">&#8377;2,200</strong>
                    </div>
                </div>

                <!-- Form to processRent servlet -->
                <form action="processRent" method="post" id="rental">
                    <input type="hidden" name="carRegno" id="modalCarRegno">
                    <input type="hidden" name="rentalStatus" id="modalRentalStatus">

                    <div class="form-group-custom">
                        <label for="rentalName" class="form-label-custom">
                            <i class="fas fa-file-signature text-primary me-1"></i> Rental Plan / Purpose
                        </label>
                        <select name="rentalName" id="rentalName" class="form-control-custom" required>
                            <option value="" disabled selected>Select Rental Category</option>
                            <option value="Personal Trip">Personal Trip (Vacation / Leisure)</option>
                            <option value="Business Lease">Business Lease</option>
                            <option value="Corporate Rental">Corporate Rental</option>
                            <option value="Travel Agency">Travel Agency Tour</option>
                            <option value="Event Rental">Event / Wedding Rental</option>
                            <option value="VIP Service">VIP Luxury Chauffeur</option>
                            <option value="Government Contract">Government Contract</option>
                            <option value="Long-Term Lease">Long-Term Monthly Lease</option>
                            <option value="Ride Sharing Partner">Ride Sharing Partner</option>
                        </select>
                        <div id="rentalName-error" class="error-message"></div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="form-group-custom">
                                <label for="rentStartDate" class="form-label-custom">
                                    <i class="fas fa-calendar-alt text-primary me-1"></i> Start Date
                                </label>
                                <input type="date" name="rentStartDate" id="rentStartDate" class="form-control-custom" required>
                                <div id="rentStartDate-error" class="error-message"></div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group-custom">
                                <label for="rentEndDate" class="form-label-custom">
                                    <i class="fas fa-calendar-check text-primary me-1"></i> End Date
                                </label>
                                <input type="date" name="rentEndDate" id="rentEndDate" class="form-control-custom" required>
                                <div id="rentEndDate-error" class="error-message"></div>
                            </div>
                        </div>
                    </div>

                    <button type="submit" id="submitRentBtn" class="btn-rental btn-rental-primary w-100 py-3 mt-3">
                        <i class="fas fa-check-circle"></i> Confirm Reservation & Pay
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="rental-footer">
        <div class="container text-center">
            <p class="mb-0 small text-muted">&copy; 2025 DriveLux DBMS Car Rental Management System. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Vehicle Specs & Image Loader Script -->
    <script src="js/car-data.js"></script>
    <script>
        let currentSelectedCarRate = 2200;

        // Initialize car images & specs from CAR_CATALOG
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll(".car-card-col").forEach(col => {
                const reg = col.getAttribute("data-reg");
                const model = col.getAttribute("data-model");
                const details = getCarDetails(model);

                // Set Card Elements
                const img = document.getElementById("img-" + reg);
                if (img) {
                    img.src = details.image;
                    img.onerror = function() { this.src = details.fallbackImage; };
                }
                const type = document.getElementById("type-" + reg);
                if (type) type.textContent = details.category;
                const trans = document.getElementById("trans-" + reg);
                if (trans) trans.innerHTML = `<i class="fas fa-cog"></i> ` + details.transmission;
                const fuel = document.getElementById("fuel-" + reg);
                if (fuel) fuel.innerHTML = `<i class="fas fa-gas-pump"></i> ` + details.fuel;
                const seats = document.getElementById("seats-" + reg);
                if (seats) seats.innerHTML = `<i class="fas fa-users"></i> ` + details.seats + ` Seats`;
                const mileage = document.getElementById("mileage-" + reg);
                if (mileage) mileage.innerHTML = `<i class="fas fa-tachometer-alt"></i> ` + details.mileage;
                const price = document.getElementById("price-" + reg);
                if (price) price.innerHTML = `&#8377;` + details.dailyRate.toLocaleString('en-IN');

                // Set Table Elements
                const tblImg = document.getElementById("tbl-img-" + reg);
                if (tblImg) {
                    tblImg.src = details.image;
                    tblImg.onerror = function() { this.src = details.fallbackImage; };
                }
                const tblType = document.getElementById("tbl-type-" + reg);
                if (tblType) tblType.textContent = details.category + " • " + details.transmission;
            });

            // Set default dates to today and tomorrow
            const today = new Date().toISOString().split("T")[0];
            const tomorrow = new Date(Date.now() + 86400000).toISOString().split("T")[0];
            document.getElementById("rentStartDate").value = today;
            document.getElementById("rentEndDate").value = tomorrow;
            updateCostEstimate();
        });

        // View Switcher (Cards vs Table)
        function switchView(view) {
            const cardsContainer = document.getElementById("cardsViewContainer");
            const tableContainer = document.getElementById("tableViewContainer");
            const cardsBtn = document.getElementById("viewCardsBtn");
            const tableBtn = document.getElementById("viewTableBtn");

            if (view === 'cards') {
                cardsContainer.style.display = "block";
                tableContainer.style.display = "none";
                cardsBtn.classList.add("active");
                tableBtn.classList.remove("active");
            } else {
                cardsContainer.style.display = "none";
                tableContainer.style.display = "block";
                cardsBtn.classList.remove("active");
                tableBtn.classList.add("active");
            }
        }

        // Live Search Filter
        function filterCars() {
            const query = document.getElementById("searchInput").value.toLowerCase().trim();
            document.querySelectorAll(".car-card-col").forEach(col => {
                const text = (col.getAttribute("data-model") + " " + col.getAttribute("data-color") + " " + col.getAttribute("data-year") + " " + col.getAttribute("data-reg")).toLowerCase();
                col.style.display = text.includes(query) ? "block" : "none";
            });
            document.querySelectorAll(".car-table-row").forEach(row => {
                const text = (row.getAttribute("data-model") + " " + row.getAttribute("data-color") + " " + row.getAttribute("data-year") + " " + row.getAttribute("data-reg")).toLowerCase();
                row.style.display = text.includes(query) ? "" : "none";
            });
        }

        // Category Filter
        function filterCategory(category, btnElement) {
            document.querySelectorAll(".filter-btn").forEach(b => b.classList.remove("active"));
            if (btnElement) btnElement.classList.add("active");

            document.querySelectorAll(".car-card-col").forEach(col => {
                const model = col.getAttribute("data-model");
                const details = getCarDetails(model);
                if (category === 'all' || details.category.toLowerCase().includes(category.toLowerCase())) {
                    col.style.display = "block";
                } else {
                    col.style.display = "none";
                }
            });
            document.querySelectorAll(".car-table-row").forEach(row => {
                const model = row.getAttribute("data-model");
                const details = getCarDetails(model);
                if (category === 'all' || details.category.toLowerCase().includes(category.toLowerCase())) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }

        // Modal Open / Close
        function openModal(regNo, status, model) {
            document.getElementById('modalCarRegno').value = regNo;
            document.getElementById('modalRentalStatus').value = status;
            document.getElementById('modalCarModelDisplay').textContent = model || "Vehicle";
            document.getElementById('modalCarRegDisplay').textContent = "Reg No: " + regNo;

            const details = getCarDetails(model);
            currentSelectedCarRate = details.dailyRate;
            document.getElementById('modalCarThumb').src = details.image;
            document.getElementById('modalCarThumb').onerror = function() { this.src = details.fallbackImage; };

            updateCostEstimate();
            document.getElementById('rentModal').style.display = "block";
        }

        function closeModal() {
            document.getElementById('rentModal').style.display = "none";
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('rentModal')) {
                closeModal();
            }
        };

        // Date & Cost Calculation
        function updateCostEstimate() {
            const startVal = document.getElementById("rentStartDate").value;
            const endVal = document.getElementById("rentEndDate").value;
            if (startVal && endVal) {
                const s = new Date(startVal);
                const e = new Date(endVal);
                const diffTime = e - s;
                let days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                if (days <= 0) days = 1;

                document.getElementById("estDuration").textContent = days + (days === 1 ? " Day" : " Days");
                const total = days * currentSelectedCarRate;
                document.getElementById("estPrice").innerHTML = `&#8377;` + total.toLocaleString('en-IN');
            }
        }

        const rentalForm = document.getElementById("rental");
        const rentalNameInput = document.getElementById("rentalName");
        const rentStartDateInput = document.getElementById("rentStartDate");
        const rentEndDateInput = document.getElementById("rentEndDate");
        const submitRentBtn = document.getElementById("submitRentBtn");

        const rentalNameError = document.getElementById("rentalName-error");
        const rentStartDateError = document.getElementById("rentStartDate-error");
        const rentEndDateError = document.getElementById("rentEndDate-error");

        function validateRentalName() {
            if (rentalNameInput.value.trim() === "") {
                rentalNameError.textContent = "Please select a rental category";
                rentalNameInput.classList.add("error-border");
                return false;
            } else {
                rentalNameError.textContent = "";
                rentalNameInput.classList.remove("error-border");
                return true;
            }
        }

        function validateStartDate() {
            const startDateValue = rentStartDateInput.value;
            const today = new Date().toISOString().split("T")[0];

            if (startDateValue === "") {
                rentStartDateError.textContent = "Please select journey start date";
                rentStartDateInput.classList.add("error-border");
                return false;
            } else if (startDateValue < today) {
                rentStartDateError.textContent = "Start date must be current or future date";
                rentStartDateInput.classList.add("error-border");
                return false;
            } else {
                rentStartDateError.textContent = "";
                rentStartDateInput.classList.remove("error-border");
                return true;
            }
        }

        function validateEndDate() {
            const endDateValue = rentEndDateInput.value;
            const startDateValue = rentStartDateInput.value;

            if (endDateValue === "") {
                rentEndDateError.textContent = "Please select journey return date";
                rentEndDateInput.classList.add("error-border");
                return false;
            } else if (startDateValue && endDateValue < startDateValue) {
                rentEndDateError.textContent = "Return date must be equal or after start date";
                rentEndDateInput.classList.add("error-border");
                return false;
            } else {
                rentEndDateError.textContent = "";
                rentEndDateInput.classList.remove("error-border");
                return true;
            }
        }

        rentalNameInput.addEventListener("change", validateRentalName);
        rentStartDateInput.addEventListener("input", () => { validateStartDate(); updateCostEstimate(); });
        rentEndDateInput.addEventListener("input", () => { validateEndDate(); updateCostEstimate(); });

        rentalForm.addEventListener("submit", function(event) {
            event.preventDefault();

            const isRentalNameValid = validateRentalName();
            const isStartDateValid = validateStartDate();
            const isEndDateValid = validateEndDate();

            if (isRentalNameValid && isStartDateValid && isEndDateValid) {
                confirmAction({
                    title: "Confirm Vehicle Reservation",
                    text: "Are you sure you want to proceed with reserving this vehicle?",
                    confirmText: "Yes, Reserve",
                    cancelText: "Cancel",
                    onConfirm: function() {
                        submitRentBtn.disabled = true;
                        submitRentBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Reserving Vehicle...';

                        fetch('processRent', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: new URLSearchParams(new FormData(rentalForm)),
                        })
                        .then(response => {
                            if (!response.ok) {
                                return response.json().then(errorData => {
                                    throw new Error(errorData.message || 'Failed to process rental reservation');
                                });
                            }
                            return response.json();
                        })
                        .then(data => {
                            submitRentBtn.disabled = false;
                            submitRentBtn.innerHTML = '<i class="fas fa-check-circle"></i> Confirm Reservation & Pay';

                            if (data.status === 'success') {
                                closeModal();
                                Swal.fire({
                                    title: "Vehicle Reserved!",
                                    html: "Your rental reservation has been recorded successfully.<br><br><strong>Rental Reference ID: <span style='color: #2563eb; font-size: 1.3rem;'>" + data.rentalId + "</span></strong><br><small class='text-muted'>Proceeding to complete payment checkout...</small>",
                                    icon: "success",
                                    confirmButtonText: "Proceed to Payment",
                                    confirmButtonColor: "#2563eb"
                                }).then(() => {
                                    window.location.href = "payments.jsp?rentalId=" + data.rentalId;
                                });
                            } else {
                                Swal.fire({
                                    title: "Reservation Error",
                                    text: data.message || "An error occurred while booking.",
                                    icon: "error",
                                    confirmButtonColor: "#2563eb"
                                });
                            }
                        })
                        .catch(error => {
                            submitRentBtn.disabled = false;
                            submitRentBtn.innerHTML = '<i class="fas fa-check-circle"></i> Confirm Reservation & Pay';

                            Swal.fire({
                                title: "System Error",
                                text: error.message || "An unexpected error occurred.",
                                icon: "error",
                                confirmButtonColor: "#2563eb"
                            });
                        });
                    }
                });
            }
        });
    </script>
</body>
</html>
