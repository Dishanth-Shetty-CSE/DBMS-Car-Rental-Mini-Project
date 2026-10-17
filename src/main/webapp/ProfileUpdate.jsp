<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile - DriveLux</title>
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
    <!-- Application CSS & Confirm Alert -->
    <link rel="stylesheet" href="css/style.css">
    <script src="js/confirm-alert.js"></script>
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
                <a class="nav-link" href="myRentals.jsp"><i class="fas fa-calendar-check"></i> My Rentals</a>
                <a class="nav-link active" href="ProfileUpdate.jsp"><i class="fas fa-user-circle"></i> Profile</a>
                <a class="btn-rental btn-rental-outline btn-rental-sm ms-2" href="customer-dashboard.jsp">
                    <i class="fas fa-arrow-left"></i> Dashboard
                </a>
            </nav>
        </div>
    </header>

    <%
        String customerID = (String) session.getAttribute("customerID");
        if (customerID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = "";
        String address = "";
        String phone = "";
        String email = "";

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");

            String sql = "SELECT Cust_Name, Cust_Address, Cust_Phone, Cust_Email FROM Customer WHERE Cust_ID = ?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, customerID);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                name = resultSet.getString("Cust_Name") != null ? resultSet.getString("Cust_Name") : "";
                address = resultSet.getString("Cust_Address") != null ? resultSet.getString("Cust_Address") : "";
                phone = resultSet.getString("Cust_Phone") != null ? resultSet.getString("Cust_Phone") : "";
                email = resultSet.getString("Cust_Email") != null ? resultSet.getString("Cust_Email") : "";
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (resultSet != null) resultSet.close(); } catch (SQLException e) {}
            try { if (preparedStatement != null) preparedStatement.close(); } catch (SQLException e) {}
            try { if (connection != null) connection.close(); } catch (SQLException e) {}
        }
        
        String initial = name.length() > 0 ? name.substring(0, 1).toUpperCase() : "U";
    %>

    <div class="auth-wrapper" style="min-height: calc(100vh - 150px); background: #f8fafc; padding: 50px 20px;">
        <div class="auth-card auth-card-wide shadow-lg border" style="background: #ffffff;">
            <!-- Profile Avatar Card Header -->
            <div class="text-center mb-4">
                <div class="mx-auto mb-3" style="width: 76px; height: 76px; border-radius: 50%; background: linear-gradient(135deg, #2563eb, #06b6d4); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 700; box-shadow: 0 4px 14px rgba(37,99,235,0.3);">
                    <%= initial %>
                </div>
                <h3 class="fw-bold mb-1"><%= name.isEmpty() ? "Customer Profile" : name %></h3>
                <span class="badge bg-primary-subtle text-primary border px-3 py-1 font-monospace rounded-pill">
                    Customer ID: #<%= customerID %>
                </span>
            </div>

            <!-- Profile Edit Form -->
            <form action="ProfileServlet" method="post" id="profile">
                <input type="hidden" name="Cust_ID" value="<%= customerID %>">

                <div class="row g-3">
                    <div class="col-12">
                        <div class="form-group-custom">
                            <label for="Cust_Name" class="form-label-custom">Full Legal Name</label>
                            <div class="input-with-icon">
                                <i class="fas fa-user"></i>
                                <input type="text" id="Cust_Name" name="Cust_Name" class="form-control-custom" 
                                       value="<%= name %>" required>
                            </div>
                            <div id="name_error" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-group-custom">
                            <label for="Cust_Address" class="form-label-custom">Address / Location</label>
                            <div class="input-with-icon">
                                <i class="fas fa-map-marker-alt"></i>
                                <input type="text" id="Cust_Address" name="Cust_Address" class="form-control-custom" 
                                       value="<%= address %>" required>
                            </div>
                            <div id="address_error" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="Cust_Phone" class="form-label-custom">Phone Number</label>
                            <div class="input-with-icon">
                                <i class="fas fa-phone"></i>
                                <input type="tel" id="Cust_Phone" name="Cust_Phone" class="form-control-custom" 
                                       value="<%= phone %>" maxlength="10" required>
                            </div>
                            <div id="phone_error" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="Cust_Email" class="form-label-custom">Registered Email</label>
                            <div class="input-with-icon">
                                <i class="fas fa-envelope"></i>
                                <input type="email" id="Cust_Email" name="Cust_Email" class="form-control-custom" 
                                       value="<%= email %>" required>
                            </div>
                            <div id="email_error" class="error-message"></div>
                        </div>
                    </div>
                </div>

                <button type="submit" id="saveBtn" class="btn-rental btn-rental-primary w-100 py-3 mt-4">
                    <i class="fas fa-save"></i> Save Updated Profile
                </button>
            </form>

            <div class="text-center mt-3 pt-3 border-top">
                <a href="customer-dashboard.jsp" class="text-muted small text-decoration-none">
                    <i class="fas fa-arrow-left"></i> Return to Customer Dashboard
                </a>
            </div>
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
        const profileForm = document.getElementById("profile");
        const nameInput = document.getElementById("Cust_Name");
        const addressInput = document.getElementById("Cust_Address");
        const phoneInput = document.getElementById("Cust_Phone");
        const emailInput = document.getElementById("Cust_Email");
        const saveBtn = document.getElementById("saveBtn");

        const nameError = document.getElementById("name_error");
        const addressError = document.getElementById("address_error");
        const phoneError = document.getElementById("phone_error");
        const emailError = document.getElementById("email_error");

        function validateName() {
            const val = nameInput.value.trim();
            if (val === "") {
                nameError.textContent = "Name is required";
                nameInput.classList.add("error-border");
                return false;
            } else if (!/^[a-zA-Z\s]+$/.test(val)) {
                nameError.textContent = "Name must contain only alphabets and spaces";
                nameInput.classList.add("error-border");
                return false;
            } else {
                nameError.textContent = "";
                nameInput.classList.remove("error-border");
                return true;
            }
        }

        function validateAddress() {
            const val = addressInput.value.trim();
            if (val === "") {
                addressError.textContent = "Address is required";
                addressInput.classList.add("error-border");
                return false;
            } else {
                addressError.textContent = "";
                addressInput.classList.remove("error-border");
                return true;
            }
        }

        function validatePhone() {
            const val = phoneInput.value.trim();
            if (val === "") {
                phoneError.textContent = "Phone number is required";
                phoneInput.classList.add("error-border");
                return false;
            } else if (!/^\d{10}$/.test(val)) {
                phoneError.textContent = "Please enter a valid 10-digit number";
                phoneInput.classList.add("error-border");
                return false;
            } else {
                phoneError.textContent = "";
                phoneInput.classList.remove("error-border");
                return true;
            }
        }

        function validateEmail() {
            const val = emailInput.value.trim();
            if (val === "") {
                emailError.textContent = "Email is required";
                emailInput.classList.add("error-border");
                return false;
            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
                emailError.textContent = "Invalid email format";
                emailInput.classList.add("error-border");
                return false;
            } else {
                emailError.textContent = "";
                emailInput.classList.remove("error-border");
                return true;
            }
        }

        nameInput.addEventListener("input", validateName);
        addressInput.addEventListener("input", validateAddress);
        phoneInput.addEventListener("input", validatePhone);
        emailInput.addEventListener("input", validateEmail);

        profileForm.addEventListener("submit", function(event) {
            event.preventDefault();

            const isNameValid = validateName();
            const isAddressValid = validateAddress();
            const isPhoneValid = validatePhone();
            const isEmailValid = validateEmail();

            if (isNameValid && isAddressValid && isPhoneValid && isEmailValid) {
                confirmAction({
                    title: "Save Profile Changes?",
                    text: "Are you sure you want to update your profile details?",
                    confirmText: "Yes, Save",
                    cancelText: "Cancel",
                    onConfirm: function() {
                        saveBtn.disabled = true;
                        saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving Changes...';

                        const formData = new FormData(profileForm);
                        const params = new URLSearchParams(formData);

                        fetch("ProfileServlet", {
                            method: "POST",
                            headers: { "Content-Type": "application/x-www-form-urlencoded" },
                            body: params
                        })
                        .then(response => response.text())
                        .then(result => {
                            saveBtn.disabled = false;
                            saveBtn.innerHTML = '<i class="fas fa-save"></i> Save Updated Profile';

                            if (result.includes("Updated")) {
                                Swal.fire({
                                    title: "Profile Saved!",
                                    text: "Your account details have been updated successfully.",
                                    icon: "success",
                                    confirmButtonColor: "#2563eb"
                                }).then(() => {
                                    window.location.href = "customer-dashboard.jsp";
                                });
                            } else {
                                Swal.fire({
                                    title: "Update Failed",
                                    text: "Failed to update profile. Please verify your details.",
                                    icon: "error",
                                    confirmButtonColor: "#2563eb"
                                });
                            }
                        })
                        .catch(error => {
                            saveBtn.disabled = false;
                            saveBtn.innerHTML = '<i class="fas fa-save"></i> Save Updated Profile';

                            Swal.fire({
                                title: "System Error",
                                text: "An error occurred: " + error,
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
