<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Registration - DriveLux</title>
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

    <div class="auth-wrapper">
        <div class="auth-card auth-card-wide">
            <!-- Brand Header -->
            <div class="auth-header">
                <a href="index.jsp" class="auth-logo">
                    <div class="brand-badge"><i class="fas fa-car-side"></i></div>
                    <span>Drive<span style="color: #2563eb;">Lux</span></span>
                </a>
                <h2 class="auth-title">Create Customer Account</h2>
                <p class="auth-subtitle">Register once and unlock seamless vehicle rentals nationwide</p>
            </div>

            <!-- Registration Form -->
            <form id="customerForm" action="CustomerServlet" method="post" novalidate>
                <div class="row g-3">
                    <div class="col-12">
                        <div class="form-group-custom">
                            <label for="Cust_Name" class="form-label-custom">Full Legal Name</label>
                            <div class="input-with-icon">
                                <i class="fas fa-user"></i>
                                <input type="text" id="Cust_Name" name="Cust_Name" class="form-control-custom" 
                                       placeholder="Enter your full name" required autocomplete="name">
                            </div>
                            <div id="cust_name_error" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-group-custom">
                            <label for="Cust_Address" class="form-label-custom">Residential / Delivery Address</label>
                            <div class="input-with-icon">
                                <i class="fas fa-map-marker-alt"></i>
                                <input type="text" id="Cust_Address" name="Cust_Address" class="form-control-custom" 
                                       placeholder="Enter your residential address" required autocomplete="street-address">
                            </div>
                            <div id="cust_address_error" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="Cust_Phone" class="form-label-custom">Mobile Number (10 Digits)</label>
                            <div class="input-with-icon">
                                <i class="fas fa-phone-alt"></i>
                                <input type="tel" id="Cust_Phone" name="Cust_Phone" class="form-control-custom" 
                                       placeholder="Enter 10-digit mobile number" maxlength="10" required autocomplete="tel">
                            </div>
                            <div id="cust_phone_error" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label for="Cust_Email" class="form-label-custom">Email Address (Login Username)</label>
                            <div class="input-with-icon">
                                <i class="fas fa-envelope"></i>
                                <input type="email" id="Cust_Email" name="Cust_Email" class="form-control-custom" 
                                       placeholder="Enter your email address" required autocomplete="email">
                            </div>
                            <div id="cust_email_error" class="error-message"></div>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-group-custom">
                            <label for="Cust_Password" class="form-label-custom">Account Password</label>
                            <div class="input-with-icon" style="position: relative;">
                                <i class="fas fa-lock"></i>
                                <input type="password" id="Cust_Password" name="Cust_Password" class="form-control-custom" 
                                       placeholder="Create a strong password (min 6 characters)" required minlength="6" style="padding-right: 44px;" autocomplete="new-password">
                                <button type="button" id="togglePasswordBtn" class="btn-toggle-eye" 
                                        style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; color: #94a3b8; cursor: pointer; padding: 4px;"
                                        aria-label="Toggle password visibility">
                                    <i class="fas fa-eye" id="passwordEye"></i>
                                </button>
                            </div>
                            <div id="cust_password_error" class="error-message"></div>
                        </div>
                    </div>
                </div>

                <button type="submit" id="submitBtn" class="btn-rental btn-rental-primary w-100 py-3 mt-4">
                    <i class="fas fa-user-check"></i> Register Account
                </button>
            </form>

            <!-- Links -->
            <div class="text-center mt-4 pt-3 border-top">
                <p class="text-muted small mb-0">
                    Already have an account? <a href="login.jsp" class="text-primary fw-semibold text-decoration-none">Sign in with Email & Password</a>
                </p>
            </div>
        </div>
    </div>

    <!-- Client-side Validation and Registration Submission -->
    <script>
        const customerForm = document.getElementById("customerForm");
        const custNameInput = document.getElementById("Cust_Name");
        const custAddressInput = document.getElementById("Cust_Address");
        const custPhoneInput = document.getElementById("Cust_Phone");
        const custEmailInput = document.getElementById("Cust_Email");
        const custPasswordInput = document.getElementById("Cust_Password");
        const submitBtn = document.getElementById("submitBtn");

        const custNameError = document.getElementById("cust_name_error");
        const custAddressError = document.getElementById("cust_address_error");
        const custPhoneError = document.getElementById("cust_phone_error");
        const custEmailError = document.getElementById("cust_email_error");
        const custPasswordError = document.getElementById("cust_password_error");

        // Password visibility toggle
        const togglePasswordBtn = document.getElementById("togglePasswordBtn");
        const passwordEye = document.getElementById("passwordEye");
        if (togglePasswordBtn && custPasswordInput) {
            togglePasswordBtn.addEventListener("click", function() {
                if (custPasswordInput.type === "password") {
                    custPasswordInput.type = "text";
                    passwordEye.className = "fas fa-eye-slash";
                } else {
                    custPasswordInput.type = "password";
                    passwordEye.className = "fas fa-eye";
                }
            });
        }

        function validateName() {
            const nameValue = custNameInput.value.trim();
            if (nameValue === "") {
                custNameError.textContent = "Full name is required";
                custNameInput.classList.add("error-border");
                return false;
            } else if (!/^[a-zA-Z\s]+$/.test(nameValue)) {
                custNameError.textContent = "Name must contain only letters and spaces";
                custNameInput.classList.add("error-border");
                return false;
            } else {
                custNameError.textContent = "";
                custNameInput.classList.remove("error-border");
                return true;
            }
        }

        function validateAddress() {
            const addressValue = custAddressInput.value.trim();
            if (addressValue === "") {
                custAddressError.textContent = "Residential address is required";
                custAddressInput.classList.add("error-border");
                return false;
            } else {
                custAddressError.textContent = "";
                custAddressInput.classList.remove("error-border");
                return true;
            }
        }

        function validatePhone() {
            const phoneValue = custPhoneInput.value.trim();
            if (phoneValue === "") {
                custPhoneError.textContent = "Phone number is required";
                custPhoneInput.classList.add("error-border");
                return false;
            } else if (!/^\d{10}$/.test(phoneValue)) {
                custPhoneError.textContent = "Please enter a valid 10-digit mobile number";
                custPhoneInput.classList.add("error-border");
                return false;
            } else {
                custPhoneError.textContent = "";
                custPhoneInput.classList.remove("error-border");
                return true;
            }
        }

        function validateEmail() {
            const emailValue = custEmailInput.value.trim();
            if (emailValue === "") {
                custEmailError.textContent = "Email address is required";
                custEmailInput.classList.add("error-border");
                return false;
            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue)) {
                custEmailError.textContent = "Please enter a valid email address (e.g. name@example.com)";
                custEmailInput.classList.add("error-border");
                return false;
            } else {
                custEmailError.textContent = "";
                custEmailInput.classList.remove("error-border");
                return true;
            }
        }

        function validatePassword() {
            const passwordValue = custPasswordInput.value.trim();
            if (passwordValue === "") {
                custPasswordError.textContent = "Password is required";
                custPasswordInput.classList.add("error-border");
                return false;
            } else if (passwordValue.length < 6) {
                custPasswordError.textContent = "Password must be at least 6 characters long";
                custPasswordInput.classList.add("error-border");
                return false;
            } else {
                custPasswordError.textContent = "";
                custPasswordInput.classList.remove("error-border");
                return true;
            }
        }

        custNameInput.addEventListener("input", validateName);
        custAddressInput.addEventListener("input", validateAddress);
        custPhoneInput.addEventListener("input", validatePhone);
        custEmailInput.addEventListener("input", validateEmail);
        custPasswordInput.addEventListener("input", validatePassword);

        customerForm.addEventListener("submit", function(event) {
            event.preventDefault();

            const isNameValid = validateName();
            const isAddressValid = validateAddress();
            const isPhoneValid = validatePhone();
            const isEmailValid = validateEmail();
            const isPasswordValid = validatePassword();

            if (isNameValid && isAddressValid && isPhoneValid && isEmailValid && isPasswordValid) {
                confirmAction({
                    title: "Confirm Registration",
                    text: "Are you sure you want to register this DriveLux customer account?",
                    confirmText: "Yes, Register",
                    cancelText: "Review Details",
                    onConfirm: function() {
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Registering Account...';

                        const formData = new FormData(customerForm);
                        const params = new URLSearchParams(formData);

                        fetch("CustomerServlet", {
                            method: "POST",
                            headers: { "Content-Type": "application/x-www-form-urlencoded" },
                            body: params
                        })
                        .then(response => response.json()) 
                        .then(data => {
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = '<i class="fas fa-user-check"></i> Register Account';

                            if (data.status === 'success') {
                                Swal.fire({
                                    title: "Account Created!",
                                    html: "Welcome to DriveLux! Your account was registered successfully.<br><br>You can now sign in using your <strong>Email</strong> and <strong>Password</strong>.",
                                    icon: "success",
                                    confirmButtonText: "Sign In Now",
                                    confirmButtonColor: "#2563eb"
                                }).then(() => {
                                    window.location.href = "login.jsp";
                                });
                            } else {
                                Swal.fire({
                                    title: "Registration Failed",
                                    text: data.message || "Could not register account.",
                                    icon: "error",
                                    confirmButtonColor: "#2563eb"
                                });
                            }
                        })
                        .catch(error => {
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = '<i class="fas fa-user-check"></i> Register Account';

                            Swal.fire({
                                title: "System Error",
                                text: "An error occurred: " + error.message, 
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
