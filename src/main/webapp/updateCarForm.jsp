<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<% 
    ResultSet car = (ResultSet) request.getAttribute("car"); 
    if (car == null) {
        response.sendRedirect("ManageCars.jsp");
        return;
    }
    String carRegno = car.getString("Car_Regno");
    String carModel = car.getString("Car_Model");
    int carYear = car.getInt("Car_Year");
    String carColor = car.getString("Car_Color");
    String carStatus = car.getString("Car_Status");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Vehicle - <%= carRegno %></title>
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

    <!-- Unified Navbar -->
    <header class="rental-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand" href="admin-dashboard.jsp">
                <div class="brand-badge" style="background: linear-gradient(135deg, #4f46e5, #0ea5e9);"><i class="fas fa-shield-alt"></i></div>
                <span>Drive<span style="color: #60a5fa;">Lux</span> <small class="text-white-50 fs-6 fw-normal ms-1">Admin</small></span>
            </a>
            
            <nav class="d-flex align-items-center gap-2">
                <a class="btn-rental btn-rental-outline btn-rental-sm" href="ManageCars.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Fleet
                </a>
            </nav>
        </div>
    </header>

    <div class="auth-wrapper" style="min-height: calc(100vh - 150px); background: #f8fafc; padding: 50px 20px;">
        <div class="auth-card auth-card-wide shadow-lg border" style="background: #ffffff;">
            <!-- Header -->
            <div class="auth-header">
                <span class="badge bg-primary-subtle text-primary border font-monospace px-3 py-2 rounded-pill mb-2">
                    <i class="fas fa-id-card"></i> <%= carRegno %>
                </span>
                <h2 class="auth-title">Update Vehicle Specifications</h2>
                <p class="auth-subtitle">Modify fleet inventory records, availability status, and details</p>
            </div>

            <!-- Form to UpdateCarActionServlet -->
            <form action="UpdateCarActionServlet" method="post" id="updateCarForm">
                <input type="hidden" name="carRegno" value="<%= carRegno %>">

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="carModel" class="form-label-custom">Vehicle Model</label>
                            <div class="input-with-icon">
                                <i class="fas fa-car-side"></i>
                                <input type="text" class="form-control-custom" id="carModel" name="carModel" 
                                       value="<%= carModel %>" required>
                            </div>
                            <div id="carModelError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="carYear" class="form-label-custom">Manufacturing Year</label>
                            <div class="input-with-icon">
                                <i class="fas fa-calendar-alt"></i>
                                <input type="text" class="form-control-custom" id="carYear" name="carYear" 
                                       value="<%= carYear %>" maxlength="4" required>
                            </div>
                            <div id="carYearError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="carColor" class="form-label-custom">Exterior Paint Color</label>
                            <div class="input-with-icon">
                                <i class="fas fa-paint-brush"></i>
                                <input type="text" class="form-control-custom" id="carColor" name="carColor" 
                                       value="<%= carColor %>" required>
                            </div>
                            <div id="carColorError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="carStatus" class="form-label-custom">Fleet Availability Status</label>
                            <div class="input-with-icon">
                                <i class="fas fa-toggle-on"></i>
                                <select class="form-control-custom" id="carStatus" name="carStatus" required>
                                    <option value="Available" <%= "Available".equalsIgnoreCase(carStatus) ? "selected" : "" %>>Available (Ready to Rent)</option>
                                    <option value="Not Available" <%= "Not Available".equalsIgnoreCase(carStatus) ? "selected" : "" %>>Not Available (Rented / Maintenance)</option>
                                </select>
                            </div>
                            <div id="carStatusError" class="error-message"></div>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-3 mt-4">
                    <button type="submit" class="btn-rental btn-rental-primary flex-grow-1 py-3">
                        <i class="fas fa-check"></i> Commit Changes
                    </button>
                    <a href="ManageCars.jsp" class="btn-rental btn-rental-outline py-3 px-4">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="rental-footer">
        <div class="container text-center">
            <p class="mb-0 small text-muted">&copy; 2025 DriveLux DBMS Car Rental Management System. All Rights Reserved.</p>
        </div>
    </footer>

    <!-- Client Script -->
    <script>
        const carModelInput = document.getElementById('carModel');
        const carYearInput = document.getElementById('carYear');
        const carColorInput = document.getElementById('carColor');

        const carModelError = document.getElementById('carModelError');
        const carYearError = document.getElementById('carYearError');
        const carColorError = document.getElementById('carColorError');

        function validateModel() {
            if (carModelInput.value.trim() === "") {
                carModelError.textContent = "Vehicle model is required";
                carModelInput.classList.add("error-border");
                return false;
            } else {
                carModelError.textContent = "";
                carModelInput.classList.remove("error-border");
                return true;
            }
        }

        function validateYear() {
            const yearVal = carYearInput.value.trim();
            if (!/^\d{4}$/.test(yearVal)) {
                carYearError.textContent = "Year must be a valid 4-digit number";
                carYearInput.classList.add("error-border");
                return false;
            } else {
                carYearError.textContent = "";
                carYearInput.classList.remove("error-border");
                return true;
            }
        }

        function validateColor() {
            if (carColorInput.value.trim() === "") {
                carColorError.textContent = "Color is required";
                carColorInput.classList.add("error-border");
                return false;
            } else {
                carColorError.textContent = "";
                carColorInput.classList.remove("error-border");
                return true;
            }
        }

        carModelInput.addEventListener('input', validateModel);
        carYearInput.addEventListener('input', validateYear);
        carColorInput.addEventListener('input', validateColor);

        document.getElementById('updateCarForm').addEventListener('submit', function(event) {
            event.preventDefault();
            const isModelValid = validateModel();
            const isYearValid = validateYear();
            const isColorValid = validateColor();

            if (isModelValid && isYearValid && isColorValid) {
                confirmAction({
                    title: "Update Vehicle?",
                    text: "Are you sure you want to commit these updates to <%= carRegno %>?",
                    confirmText: "Yes, Update Vehicle",
                    cancelText: "Review",
                    onConfirm: () => {
                        this.submit();
                    }
                });
            }
        });
    </script>
</body>
</html>
