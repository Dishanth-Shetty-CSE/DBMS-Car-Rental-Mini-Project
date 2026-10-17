<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Rental Reservation - DriveLux</title>
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
                <a class="btn-rental btn-rental-outline btn-rental-sm" href="manageRentals.jsp">
                    <i class="fas fa-arrow-left"></i> Back to Rentals
                </a>
            </nav>
        </div>
    </header>

    <div class="auth-wrapper" style="min-height: calc(100vh - 150px); background: #f8fafc; padding: 50px 20px;">
        <div class="auth-card auth-card-wide shadow-lg border" style="background: #ffffff;">
            <!-- Header -->
            <div class="auth-header">
                <span class="badge bg-primary-subtle text-primary border font-monospace px-3 py-2 rounded-pill mb-2">
                    <i class="fas fa-receipt"></i> Rental Reference #${rentalId}
                </span>
                <h2 class="auth-title">Update Rental Details</h2>
                <p class="auth-subtitle">Modify dates, assigned vehicle, or customer reservation status</p>
            </div>

            <!-- Form to UpdateRentalActionServlet -->
            <form action="UpdateRentalActionServlet" method="post" id="updateRentalForm">
                <input type="hidden" name="rentalId" value="${rentalId}">

                <div class="row g-3">
                    <div class="col-12">
                        <div class="form-group-custom">
                            <label for="rentalName" class="form-label-custom">Rental Plan / Purpose</label>
                            <div class="input-with-icon">
                                <i class="fas fa-tag"></i>
                                <input type="text" class="form-control-custom" id="rentalName" name="rentalName" 
                                       value="${rentalName}" required>
                            </div>
                            <div id="rentalNameError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="rentStartDate" class="form-label-custom">Start Date</label>
                            <div class="input-with-icon">
                                <i class="fas fa-calendar-alt"></i>
                                <input type="date" class="form-control-custom" id="rentStartDate" name="rentStartDate" 
                                       value="${rentStartDate}" required>
                            </div>
                            <div id="rentStartDateError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="rentEndDate" class="form-label-custom">Return Date</label>
                            <div class="input-with-icon">
                                <i class="fas fa-calendar-check"></i>
                                <input type="date" class="form-control-custom" id="rentEndDate" name="rentEndDate" 
                                       value="${rentEndDate}" required>
                            </div>
                            <div id="rentEndDateError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group-custom">
                            <label for="rentalStatus" class="form-label-custom">Reservation Status</label>
                            <div class="input-with-icon">
                                <i class="fas fa-traffic-light"></i>
                                <select class="form-control-custom" id="rentalStatus" name="rentalStatus" required>
                                    <option value="Available" ${rentalStatus == 'Available' ? 'selected' : ''}>Available</option>
                                    <option value="Ongoing" ${rentalStatus == 'Ongoing' ? 'selected' : ''}>Ongoing</option>
                                    <option value="Completed" ${rentalStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                    <option value="Cancelled" ${rentalStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div id="rentalStatusError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group-custom">
                            <label for="custId" class="form-label-custom">Customer ID</label>
                            <div class="input-with-icon">
                                <i class="fas fa-user"></i>
                                <input type="text" class="form-control-custom" id="custId" name="custId" 
                                       value="${custId}" required>
                            </div>
                            <div id="custIdError" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group-custom">
                            <label for="carRegno" class="form-label-custom">Car Reg No</label>
                            <div class="input-with-icon">
                                <i class="fas fa-car"></i>
                                <input type="text" class="form-control-custom" id="carRegno" name="carRegno" 
                                       value="${carRegno}" required>
                            </div>
                            <div id="carRegnoError" class="error-message"></div>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-3 mt-4">
                    <button type="submit" class="btn-rental btn-rental-primary flex-grow-1 py-3">
                        <i class="fas fa-check"></i> Commit Rental Changes
                    </button>
                    <a href="manageRentals.jsp" class="btn-rental btn-rental-outline py-3 px-4">
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
        const rentalNameInput = document.getElementById('rentalName');
        const rentStartDateInput = document.getElementById('rentStartDate');
        const rentEndDateInput = document.getElementById('rentEndDate');
        const custIdInput = document.getElementById('custId');
        const carRegnoInput = document.getElementById('carRegno');

        const rentalNameError = document.getElementById('rentalNameError');
        const rentStartDateError = document.getElementById('rentStartDateError');
        const rentEndDateError = document.getElementById('rentEndDateError');
        const custIdError = document.getElementById('custIdError');
        const carRegnoError = document.getElementById('carRegnoError');

        function validateRentalName() {
            if (rentalNameInput.value.trim() === "") {
                rentalNameError.textContent = "Rental plan/name is required";
                rentalNameInput.classList.add("error-border");
                return false;
            } else {
                rentalNameError.textContent = '';
                rentalNameInput.classList.remove("error-border");
                return true;
            }
        }

        function validateRentEndDate() {
            if (rentEndDateInput.value < rentStartDateInput.value) {
                rentEndDateError.textContent = "End date cannot be earlier than start date";
                rentEndDateInput.classList.add("error-border");
                return false;
            } else {
                rentEndDateError.textContent = '';
                rentEndDateInput.classList.remove("error-border");
                return true;
            }
        }

        function validateCustId() {
            if (!/^\d+$/.test(custIdInput.value.trim())) {
                custIdError.textContent = "Customer ID must contain only numbers";
                custIdInput.classList.add("error-border");
                return false;
            } else {
                custIdError.textContent = '';
                custIdInput.classList.remove("error-border");
                return true;
            }
        }

        function validateCarRegno() {
            if (carRegnoInput.value.trim() === "") {
                carRegnoError.textContent = "Car Reg No is required";
                carRegnoInput.classList.add("error-border");
                return false;
            } else {
                carRegnoError.textContent = '';
                carRegnoInput.classList.remove("error-border");
                return true;
            }
        }

        rentalNameInput.addEventListener('input', validateRentalName);
        rentEndDateInput.addEventListener('input', validateRentEndDate);
        custIdInput.addEventListener('input', validateCustId);
        carRegnoInput.addEventListener('input', validateCarRegno);

        document.getElementById('updateRentalForm').addEventListener('submit', function(event) {
            event.preventDefault();
            let hasErrors = false;
            if (!validateRentalName()) hasErrors = true;
            if (!validateRentEndDate()) hasErrors = true;
            if (!validateCustId()) hasErrors = true;
            if (!validateCarRegno()) hasErrors = true;

            if (!hasErrors) {
                const self = this;
                confirmAction({
                    title: "Update Rental Record?",
                    text: "Are you sure you want to save modifications to Rental #${rentalId}?",
                    confirmText: "Yes, Update",
                    cancelText: "Review",
                    onConfirm: () => {
                        self.submit();
                    }
                });
            }
        });
    </script>
</body>
</html>
