<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String rentalIdParam = request.getParameter("rentalId");
    if (rentalIdParam == null) {
        rentalIdParam = "";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Payment Checkout - DriveLux</title>
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
    <style>
        .payment-method-card {
            border: 2px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 14px 18px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 12px;
            background: #ffffff;
        }
        .payment-method-card:hover {
            border-color: #93c5fd;
            background: #f8fafc;
        }
        .payment-method-card.active {
            border-color: var(--primary);
            background: #eff6ff;
        }
        .method-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            background: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            color: var(--text-primary);
        }
        .payment-method-card.active .method-icon {
            background: var(--primary);
            color: #ffffff;
        }
    </style>
</head>
<body>

    <!-- Unified Navbar -->
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
                <a class="btn-rental btn-rental-outline btn-rental-sm ms-2" href="customer-dashboard.jsp">
                    <i class="fas fa-arrow-left"></i> Dashboard
                </a>
            </nav>
        </div>
    </header>

    <div class="auth-wrapper" style="background: radial-gradient(circle at center, #1e293b 0%, #0f172a 100%);">
        <div class="auth-card auth-card-wide" style="border-top: 4px solid var(--success);">
            <!-- Header -->
            <div class="auth-header">
                <div class="d-inline-flex p-3 rounded-circle bg-success-subtle text-success mb-3 fs-3">
                    <i class="fas fa-lock"></i>
                </div>
                <h2 class="auth-title">Secure Payment Checkout</h2>
                <p class="auth-subtitle">Finalize your vehicle booking transaction with 256-bit encrypted security</p>
            </div>

            <!-- Form -->
            <form id="paymentForm" action="processPayment" method="post">
                <!-- Rental ID Input -->
                <div class="form-group-custom">
                    <label for="rentalID" class="form-label-custom">
                        <i class="fas fa-hashtag text-primary me-1"></i> Rental Reference ID
                    </label>
                    <div class="input-with-icon">
                        <i class="fas fa-receipt"></i>
                        <input type="text" name="rentalID" id="rentalID" class="form-control-custom" 
                               placeholder="e.g. 1" value="<%= rentalIdParam %>" required>
                    </div>
                    <div id="rentalID-error" class="error-message"></div>
                </div>

                <!-- Hidden select matching backend param name -->
                <input type="hidden" name="payMethod" id="payMethod" value="Credit Card">

                <!-- Interactive Visual Payment Selector -->
                <label class="form-label-custom mt-3">Select Payment Method</label>
                <div id="payMethod-error" class="error-message mb-2"></div>

                <div class="payment-method-card active" onclick="selectMethod('Credit Card', this)">
                    <div class="method-icon"><i class="fas fa-credit-card"></i></div>
                    <div class="flex-grow-1">
                        <div class="fw-bold">Credit Card</div>
                        <div class="text-muted small">Visa, MasterCard, Amex, RuPay</div>
                    </div>
                    <i class="fas fa-check-circle text-primary fs-5 check-mark"></i>
                </div>

                <div class="payment-method-card" onclick="selectMethod('UPI', this)">
                    <div class="method-icon"><i class="fas fa-mobile-alt"></i></div>
                    <div class="flex-grow-1">
                        <div class="fw-bold">UPI / Instant QR</div>
                        <div class="text-muted small">Google Pay, PhonePe, Paytm, BHIM</div>
                    </div>
                    <i class="far fa-circle text-muted fs-5 check-mark"></i>
                </div>

                <div class="payment-method-card" onclick="selectMethod('Debit Card', this)">
                    <div class="method-icon"><i class="fas fa-money-check-alt"></i></div>
                    <div class="flex-grow-1">
                        <div class="fw-bold">Debit Card</div>
                        <div class="text-muted small">All major Indian banks supported</div>
                    </div>
                    <i class="far fa-circle text-muted fs-5 check-mark"></i>
                </div>

                <div class="payment-method-card" onclick="selectMethod('Net Banking', this)">
                    <div class="method-icon"><i class="fas fa-university"></i></div>
                    <div class="flex-grow-1">
                        <div class="fw-bold">Net Banking</div>
                        <div class="text-muted small">HDFC, ICICI, SBI, Axis & 50+ Banks</div>
                    </div>
                    <i class="far fa-circle text-muted fs-5 check-mark"></i>
                </div>

                <div class="payment-method-card" onclick="selectMethod('Cash', this)">
                    <div class="method-icon"><i class="fas fa-money-bill-wave"></i></div>
                    <div class="flex-grow-1">
                        <div class="fw-bold">Cash at Hub / Station</div>
                        <div class="text-muted small">Pay in person upon vehicle key collection</div>
                    </div>
                    <i class="far fa-circle text-muted fs-5 check-mark"></i>
                </div>

                <!-- Trust Badges -->
                <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded-3 mt-4 mb-3 border">
                    <div class="d-flex align-items-center gap-2 text-muted small">
                        <i class="fas fa-shield-alt text-success fs-5"></i>
                        <span>PCI-DSS Certified • SSL Encrypted</span>
                    </div>
                    <span class="badge bg-success-subtle text-success px-2 py-1">Instant Receipt</span>
                </div>

                <button type="submit" id="submitBtn" class="btn-rental btn-rental-primary w-100 py-3 mt-2">
                    <i class="fas fa-lock"></i> Authorize & Complete Payment
                </button>
            </form>

            <div class="text-center mt-3">
                <a href="customer-dashboard.jsp" class="text-muted small text-decoration-none">
                    <i class="fas fa-arrow-left"></i> Cancel & Return to Dashboard
                </a>
            </div>
        </div>
    </div>

    <!-- Client Script -->
    <script>
        function selectMethod(method, element) {
            document.getElementById("payMethod").value = method;
            document.querySelectorAll(".payment-method-card").forEach(c => {
                c.classList.remove("active");
                const icon = c.querySelector(".check-mark");
                if (icon) {
                    icon.classList.remove("fas", "fa-check-circle", "text-primary");
                    icon.classList.add("far", "fa-circle", "text-muted");
                }
            });
            element.classList.add("active");
            const mark = element.querySelector(".check-mark");
            if (mark) {
                mark.classList.remove("far", "fa-circle", "text-muted");
                mark.classList.add("fas", "fa-check-circle", "text-primary");
            }
            validatePayMethod();
        }

        const paymentForm = document.getElementById("paymentForm");
        const payMethodInput = document.getElementById("payMethod");
        const rentalIDInput = document.getElementById("rentalID");
        const submitBtn = document.getElementById("submitBtn");

        const payMethodError = document.getElementById("payMethod-error");
        const rentalIDError = document.getElementById("rentalID-error");

        function validatePayMethod() {
            if (payMethodInput.value.trim() === "") {
                payMethodError.textContent = "Please select a payment method";
                return false;
            } else {
                payMethodError.textContent = "";
                return true;
            }
        }

        function validateRentalID() {
            const rentalIDValue = rentalIDInput.value.trim();
            if (rentalIDValue === "") {
                rentalIDError.textContent = "Rental Reference ID is required";
                rentalIDInput.classList.add("error-border");
                return false;
            } else if (!/^\d+$/.test(rentalIDValue)) {
                rentalIDError.textContent = "Rental ID must contain only digits";
                rentalIDInput.classList.add("error-border");
                return false;
            } else {
                rentalIDError.textContent = "";
                rentalIDInput.classList.remove("error-border");
                return true;
            }
        }

        rentalIDInput.addEventListener("input", validateRentalID);

        paymentForm.addEventListener("submit", function(event) {
            event.preventDefault();

            const isPayMethodValid = validatePayMethod();
            const isRentalIDValid = validateRentalID();

            if (isPayMethodValid && isRentalIDValid) {
                confirmAction({
                    title: "Authorize Payment",
                    text: "Are you sure you want to proceed and authorize this payment?",
                    confirmText: "Yes, Pay Now",
                    cancelText: "Review",
                    onConfirm: function() {
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing Transaction...';

                        const formData = new FormData(paymentForm);
                        const params = new URLSearchParams(formData);

                        fetch("processPayment", {
                            method: "POST",
                            headers: { "Content-Type": "application/x-www-form-urlencoded" },
                            body: params
                        })
                        .then(response => response.text())
                        .then(result => {
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = '<i class="fas fa-lock"></i> Authorize & Complete Payment';

                            if (result.includes("Payment successful")) {
                                Swal.fire({
                                    title: "Payment Received!",
                                    text: "Your transaction has been approved and your booking status is updated.",
                                    icon: "success",
                                    confirmButtonColor: "#2563eb",
                                    confirmButtonText: "Go to Dashboard"
                                }).then(() => {
                                    window.location.href = "customer-dashboard.jsp";
                                });
                            } else {
                                Swal.fire({
                                    title: "Payment Unsuccessful",
                                    text: "Could not record payment for Rental ID #" + rentalIDInput.value + ". Please verify the Rental ID.",
                                    icon: "error",
                                    confirmButtonColor: "#2563eb"
                                });
                            }
                        })
                        .catch(error => {
                            submitBtn.disabled = false;
                            submitBtn.innerHTML = '<i class="fas fa-lock"></i> Authorize & Complete Payment';

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
