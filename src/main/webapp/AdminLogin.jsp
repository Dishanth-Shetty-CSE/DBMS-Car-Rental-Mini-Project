<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Sign In - DriveLux</title>
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

    <div class="auth-wrapper" style="background: radial-gradient(circle at top left, #1e1b4b 0%, #0f172a 100%);">
        <div class="auth-card" style="border-top: 4px solid var(--accent);">
            <!-- Brand Header -->
            <div class="auth-header">
                <a href="index.jsp" class="auth-logo">
                    <div class="brand-badge" style="background: linear-gradient(135deg, #0ea5e9, #6366f1);"><i class="fas fa-shield-alt"></i></div>
                    <span>Drive<span style="color: #6366f1;">Lux</span></span>
                </a>
                <h2 class="auth-title">Admin Management Console</h2>
                <p class="auth-subtitle">Authorized administrator verification and security clearance</p>
            </div>

            <!-- Login Form (Email & Password) -->
            <form id="adminLoginForm" action="AdminLoginServlet" method="post" novalidate>
                <div class="form-group-custom">
                    <label for="Admin_Email" class="form-label-custom">Administrator Email</label>
                    <div class="input-with-icon">
                        <i class="fas fa-envelope input-icon-left"></i>
                        <input type="email" id="Admin_Email" name="Admin_Email" class="form-control-custom" 
                               placeholder="Enter administrator email" required autofocus>
                    </div>
                    <div id="admin_email_error" class="error-message"></div>
                </div>

                <div class="form-group-custom">
                    <label for="Admin_Password" class="form-label-custom">Password</label>
                    <div class="input-with-icon">
                        <i class="fas fa-lock input-icon-left"></i>
                        <input type="password" id="Admin_Password" name="Admin_Password" class="form-control-custom" 
                               placeholder="Enter administrator password" required>
                        <button type="button" class="password-toggle-btn" onclick="toggleAdminPasswordVisibility('Admin_Password', this)">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div id="admin_password_error" class="error-message"></div>
                </div>

                <button type="submit" id="submitBtn" class="btn-rental w-100 py-3 mt-3" 
                        style="background: linear-gradient(135deg, #4f46e5, #0ea5e9); color: #fff; box-shadow: 0 4px 14px rgba(79, 70, 229, 0.3);">
                    <i class="fas fa-lock-open"></i> Unlock Admin Console
                </button>
            </form>

            <!-- Links -->
            <div class="text-center mt-4 pt-3 border-top">
                <p class="text-muted small mb-0">
                    Need Customer Login? <a href="login.jsp" class="text-primary fw-semibold text-decoration-none"><i class="fas fa-arrow-left small"></i> Back to Customer Login</a>
                </p>
            </div>
        </div>
    </div>

    <!-- SweetAlert Confirmation & Validation Script -->
    <script src="js/confirm-alert.js"></script>
    <script>
        function toggleAdminPasswordVisibility(inputId, btn) {
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

        const adminLoginForm = document.getElementById("adminLoginForm");
        const adminEmailInput = document.getElementById("Admin_Email");
        const adminPasswordInput = document.getElementById("Admin_Password");
        const adminEmailError = document.getElementById("admin_email_error");
        const adminPasswordError = document.getElementById("admin_password_error");
        const submitBtn = document.getElementById("submitBtn");

        function validateAdminEmail() {
            const emailValue = adminEmailInput.value.trim();
            if (emailValue === "") {
                adminEmailError.textContent = "Administrator email is required";
                adminEmailInput.classList.add("error-border");
                return false;
            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue)) {
                adminEmailError.textContent = "Please enter a valid email format";
                adminEmailInput.classList.add("error-border");
                return false;
            } else {
                adminEmailError.textContent = "";
                adminEmailInput.classList.remove("error-border");
                return true;
            }
        }

        function validateAdminPassword() {
            const passValue = adminPasswordInput.value.trim();
            if (passValue === "") {
                adminPasswordError.textContent = "Password is required";
                adminPasswordInput.classList.add("error-border");
                return false;
            } else {
                adminPasswordError.textContent = "";
                adminPasswordInput.classList.remove("error-border");
                return true;
            }
        }

        adminEmailInput.addEventListener("input", validateAdminEmail);
        adminPasswordInput.addEventListener("input", validateAdminPassword);

        adminLoginForm.addEventListener("submit", function(event) {
            event.preventDefault();

            const isEmailValid = validateAdminEmail();
            const isPasswordValid = validateAdminPassword();

            if (isEmailValid && isPasswordValid) {
                // Confirmation alert before admin clearance
                confirmAction({
                    title: "Confirm Admin Authentication",
                    text: "Are you sure you want to authenticate as " + adminEmailInput.value.trim() + "?",
                    confirmButtonText: "Yes, Authenticate",
                    icon: "question"
                }, function() {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verifying Credentials...';

                    const formData = new FormData(adminLoginForm);
                    const params = new URLSearchParams(formData);

                    fetch("AdminLoginServlet", {
                        method: "POST",
                        headers: { "Content-Type": "application/x-www-form-urlencoded" },
                        body: params
                    })
                    .then(response => response.text())
                    .then(result => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-lock-open"></i> Unlock Admin Console';

                        if (result.includes("Login successful")) {
                            Swal.fire({
                                title: "Clearance Approved!",
                                text: "Admin credentials verified. Launching Admin Dashboard...",
                                icon: "success",
                                timer: 1400,
                                showConfirmButton: false
                            }).then(() => {
                                window.location.href = "admin-dashboard.jsp"; 
                            });
                        } else {
                            adminEmailInput.classList.add("error-border");
                            adminPasswordInput.classList.add("error-border");
                            Swal.fire({
                                title: "Access Denied",
                                text: "Invalid admin email or password. Please verify your credentials.",
                                icon: "error",
                                confirmButtonColor: "#4f46e5"
                            });
                        }
                    })
                    .catch(error => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-lock-open"></i> Unlock Admin Console';

                        Swal.fire({
                            title: "System Error",
                            text: "An error occurred: " + error,
                            icon: "error",
                            confirmButtonColor: "#4f46e5"
                        });
                    });
                });
            }
        });
    </script>
</body>
</html>
