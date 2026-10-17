<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Login - DriveLux</title>
    <!-- Google Fonts: Poppins -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Application CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <div class="auth-wrapper">
        <div class="auth-card">
            <!-- Brand Header -->
            <div class="auth-header">
                <a href="index.jsp" class="auth-logo">
                    <div class="brand-badge"><i class="fas fa-car-side"></i></div>
                    <span>Drive<span style="color: #2563eb;">Lux</span></span>
                </a>
                <h2 class="auth-title">Customer Sign In</h2>
                <p class="auth-subtitle">Enter your email and password to access your account</p>
            </div>

            <!-- Login Form (Email & Password) -->
            <form id="loginForm" action="LoginServlet" method="post" novalidate>
                <div class="form-group-custom">
                    <label for="Cust_Email" class="form-label-custom">Email Address</label>
                    <div class="input-with-icon">
                        <i class="fas fa-envelope input-icon-left"></i>
                        <input type="email" id="Cust_Email" name="Cust_Email" class="form-control-custom" 
                               placeholder="Enter your registered email" required autofocus>
                    </div>
                    <div id="cust_email_error" class="error-message"></div>
                </div>

                <div class="form-group-custom">
                    <label for="Cust_Password" class="form-label-custom">Password</label>
                    <div class="input-with-icon">
                        <i class="fas fa-lock input-icon-left"></i>
                        <input type="password" id="Cust_Password" name="Cust_Password" class="form-control-custom" 
                               placeholder="Enter your password" required>
                        <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('Cust_Password', this)">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div id="cust_password_error" class="error-message"></div>
                </div>

                <button type="submit" id="submitBtn" class="btn-rental btn-rental-primary w-100 py-3 mt-3">
                    <i class="fas fa-sign-in-alt"></i> Sign In to Account
                </button>
            </form>

            <!-- Links -->
            <div class="text-center mt-4 pt-3 border-top">
                <p class="text-muted small mb-2">
                    Don't have an account? <a href="registration.jsp" class="text-primary fw-semibold text-decoration-none">Register here</a>
                </p>
                <p class="text-muted small mb-0">
                    Administrator access? <a href="AdminLogin.jsp" class="text-secondary fw-semibold text-decoration-none">Admin Sign In <i class="fas fa-arrow-right small"></i></a>
                </p>
            </div>
        </div>
    </div>

    <!-- SweetAlert Confirmation & Validation Script -->
    <script src="js/confirm-alert.js"></script>
    <script>
        function togglePasswordVisibility(inputId, btn) {
            const input = document.getElementById(inputId);
            const icon = btn.querySelector("i");
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        const loginForm = document.getElementById("loginForm");
        const custEmailInput = document.getElementById("Cust_Email");
        const custPasswordInput = document.getElementById("Cust_Password");
        const custEmailError = document.getElementById("cust_email_error");
        const custPasswordError = document.getElementById("cust_password_error");
        const submitBtn = document.getElementById("submitBtn");

        function validateCustEmail() {
            const val = custEmailInput.value.trim();
            if (val === "") {
                custEmailError.textContent = "Email address is required";
                custEmailInput.classList.add("error-border");
                return false;
            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
                custEmailError.textContent = "Please enter a valid email address";
                custEmailInput.classList.add("error-border");
                return false;
            } else {
                custEmailError.textContent = "";
                custEmailInput.classList.remove("error-border");
                return true;
            }
        }

        function validateCustPassword() {
            const val = custPasswordInput.value.trim();
            if (val === "") {
                custPasswordError.textContent = "Password is required";
                custPasswordInput.classList.add("error-border");
                return false;
            } else {
                custPasswordError.textContent = "";
                custPasswordInput.classList.remove("error-border");
                return true;
            }
        }

        custEmailInput.addEventListener("input", validateCustEmail);
        custPasswordInput.addEventListener("input", validateCustPassword);

        loginForm.addEventListener("submit", function(event) {
            event.preventDefault();

            const isEmailValid = validateCustEmail();
            const isPasswordValid = validateCustPassword();

            if (isEmailValid && isPasswordValid) {
                // Confirmation prompt before logging in
                confirmAction({
                    title: "Confirm Sign In",
                    text: "Are you sure you want to log in with " + custEmailInput.value.trim() + "?",
                    confirmButtonText: "Yes, Sign In",
                    icon: "question"
                }, function() {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Authenticating...';

                    const formData = new FormData(loginForm);
                    const params = new URLSearchParams(formData);

                    fetch("LoginServlet", {
                        method: "POST",
                        headers: { "Content-Type": "application/x-www-form-urlencoded" },
                        body: params
                    })
                    .then(response => response.text())
                    .then(result => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-sign-in-alt"></i> Sign In to Account';

                        if (result.includes("Login successful")) {
                            Swal.fire({
                                title: "Authentication Successful!",
                                text: "Welcome back! Redirecting to customer dashboard...",
                                icon: "success",
                                timer: 1400,
                                showConfirmButton: false
                            }).then(() => {
                                window.location.href = "customer-dashboard.jsp";
                            });
                        } else {
                            custEmailInput.classList.add("error-border");
                            custPasswordInput.classList.add("error-border");
                            Swal.fire({
                                title: "Authentication Failed",
                                text: "Invalid email or password. Please verify your credentials.",
                                icon: "error",
                                confirmButtonColor: "#2563eb"
                            });
                        }
                    })
                    .catch(error => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-sign-in-alt"></i> Sign In to Account';

                        Swal.fire({
                            title: "System Error",
                            text: "A connection error occurred: " + error,
                            icon: "error",
                            confirmButtonColor: "#2563eb"
                        });
                    });
                });
            }
        });
    </script>
</body>
</html>
