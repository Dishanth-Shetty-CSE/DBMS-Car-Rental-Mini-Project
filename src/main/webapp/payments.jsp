<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Locale" %>
<%
    String rentalIdParam = request.getParameter("rentalId");
    if (rentalIdParam == null) {
        rentalIdParam = "";
    }

    String carModel = "Executive Fleet Car";
    String carReg = "";
    String rentalPlan = "Standard Rental Plan";
    String startDateStr = "Immediate";
    String endDateStr = "Flexible";
    String existingStatus = "Available";
    long durationDays = 1;
    double dailyRate = 2200.0;
    double totalAmount = 2200.0;
    boolean isExistingPaid = false;
    double alreadyPaidAmount = 0.0;
    String paidMethod = "Card";
    String paymentDate = "";

    if (!rentalIdParam.trim().isEmpty()) {
        Connection connDetail = null;
        PreparedStatement stmtDetail = null;
        ResultSet rsDetail = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connDetail = DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "root", "trickortreat");
            
            String q = "SELECT r.Rental_ID, r.Rental_Name, r.Rent_Start_Date, r.Rent_End_Date, r.Rental_Status, r.Car_Regno, " +
                       "c.Car_Model, p.Pay_ID, p.Amount_Paid, p.Pay_Method, p.Pay_Status, p.Pay_Date_Time " +
                       "FROM rental r " +
                       "LEFT JOIN car c ON r.Car_Regno = c.Car_Regno " +
                       "LEFT JOIN payment p ON r.Rental_ID = p.Rental_ID " +
                       "WHERE r.Rental_ID = ? ORDER BY p.Pay_ID DESC LIMIT 1";
            stmtDetail = connDetail.prepareStatement(q);
            stmtDetail.setInt(1, Integer.parseInt(rentalIdParam.trim()));
            rsDetail = stmtDetail.executeQuery();
            if (rsDetail.next()) {
                if (rsDetail.getString("Car_Model") != null) carModel = rsDetail.getString("Car_Model");
                if (rsDetail.getString("Car_Regno") != null) carReg = rsDetail.getString("Car_Regno");
                if (rsDetail.getString("Rental_Name") != null) rentalPlan = rsDetail.getString("Rental_Name");
                if (rsDetail.getString("Rental_Status") != null) existingStatus = rsDetail.getString("Rental_Status");
                
                java.sql.Date sDate = rsDetail.getDate("Rent_Start_Date");
                java.sql.Date eDate = rsDetail.getDate("Rent_End_Date");
                if (sDate != null) startDateStr = sDate.toString();
                if (eDate != null) endDateStr = eDate.toString();
                
                if (sDate != null && eDate != null) {
                    long diff = eDate.getTime() - sDate.getTime();
                    durationDays = Math.max(1, (diff / (1000 * 60 * 60 * 24)));
                }

                // Model pricing lookup
                String mLower = carModel.toLowerCase();
                if (mLower.contains("bmw") || mLower.contains("audi") || mLower.contains("mercedes")) {
                    dailyRate = 6500.0;
                } else if (mLower.contains("fortuner") || mLower.contains("endeavour")) {
                    dailyRate = 4500.0;
                } else if (mLower.contains("innova") || mLower.contains("safari") || mLower.contains("xuv")) {
                    dailyRate = 3400.0;
                } else if (mLower.contains("thar") || mLower.contains("creta") || mLower.contains("seltos") || mLower.contains("nexon")) {
                    dailyRate = 2600.0;
                } else if (mLower.contains("city") || mLower.contains("verna") || mLower.contains("ciaz")) {
                    dailyRate = 2200.0;
                } else if (mLower.contains("swift") || mLower.contains("i20") || mLower.contains("baleno")) {
                    dailyRate = 1600.0;
                } else {
                    dailyRate = 2200.0;
                }
                totalAmount = durationDays * dailyRate;

                // Check existing payment status
                double pAmount = rsDetail.getDouble("Amount_Paid");
                String pStatus = rsDetail.getString("Pay_Status");
                if ("Completed".equalsIgnoreCase(pStatus) && pAmount > 0.0) {
                    isExistingPaid = true;
                    alreadyPaidAmount = pAmount;
                    if (rsDetail.getString("Pay_Method") != null) paidMethod = rsDetail.getString("Pay_Method");
                    Timestamp ts = rsDetail.getTimestamp("Pay_Date_Time");
                    if (ts != null) paymentDate = ts.toString();
                }
            }
        } catch (Exception ex) {
            // fallback
        } finally {
            if (rsDetail != null) try { rsDetail.close(); } catch (Exception ignored) {}
            if (stmtDetail != null) try { stmtDetail.close(); } catch (Exception ignored) {}
            if (connDetail != null) try { connDetail.close(); } catch (Exception ignored) {}
        }
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
        .order-summary-box {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border: 1px solid #e2e8f0;
            border-radius: var(--radius-md);
            border-left: 4px solid var(--primary) !important;
            padding: 18px 20px;
            margin-bottom: 24px;
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

            <!-- Existing Completed Notice if already paid -->
            <% if (isExistingPaid) { %>
            <div class="alert alert-success d-flex align-items-center gap-3 mb-4 shadow-sm" style="border-radius: var(--radius-md);">
                <i class="fas fa-check-circle fs-3 text-success"></i>
                <div>
                    <h6 class="fw-bold mb-1">Payment Successfully Completed</h6>
                    <p class="small mb-0 text-muted">
                        &#8377;<%= String.format(Locale.US, "%,.2f", alreadyPaidAmount) %> has been verified and settled via <strong><%= paidMethod %></strong>.
                    </p>
                </div>
            </div>
            <% } %>

            <!-- Order / Booking Invoice Breakdown Card -->
            <div class="order-summary-box">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div>
                        <div class="fw-bold fs-5 text-dark"><%= carModel %></div>
                        <div class="text-muted small">
                            <span class="font-monospace fw-semibold"><i class="fas fa-car text-primary me-1"></i><%= carReg.isEmpty() ? "Fleet Vehicle" : carReg %></span>
                            <span class="mx-1">•</span>
                            <span><%= rentalPlan %></span>
                        </div>
                    </div>
                    <span class="badge bg-primary-subtle text-primary fs-6 px-3 py-2 font-monospace">
                        Rental #<%= rentalIdParam.isEmpty() ? "---" : rentalIdParam %>
                    </span>
                </div>
                <hr class="my-2" style="opacity: 0.15;">
                <div class="d-flex justify-content-between text-muted small py-1">
                    <span><i class="fas fa-calendar-alt text-primary me-1"></i> Rental Window:</span>
                    <span class="fw-semibold text-dark"><%= startDateStr %> &rarr; <%= endDateStr %> (<%= durationDays %> <%= durationDays == 1 ? "Day" : "Days" %>)</span>
                </div>
                <div class="d-flex justify-content-between text-muted small py-1">
                    <span><i class="fas fa-tag text-primary me-1"></i> Daily Standard Tariff:</span>
                    <span class="fw-semibold text-dark">&#8377;<%= String.format(Locale.US, "%,.2f", dailyRate) %> / day</span>
                </div>
                <div class="d-flex justify-content-between text-muted small py-1">
                    <span><i class="fas fa-shield-alt text-success me-1"></i> Comprehensive Insurance & Taxes:</span>
                    <span class="text-success fw-semibold">Included (&#8377;0.00)</span>
                </div>
                <hr class="my-2" style="opacity: 0.15;">
                <div class="d-flex justify-content-between align-items-center pt-1">
                    <span class="fw-bold text-dark fs-5">Total Amount Payable:</span>
                    <span class="fw-bold fs-4 text-primary" id="displayTotal">&#8377;<%= String.format(Locale.US, "%,.2f", totalAmount) %></span>
                </div>
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

                <!-- Hidden parameters: payment method & exact calculated amount -->
                <input type="hidden" name="payMethod" id="payMethod" value="Credit Card">
                <input type="hidden" name="amountPaid" id="amountPaid" value="<%= String.format(Locale.US, "%.2f", totalAmount) %>">

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
                        <span>PCI-DSS Certified • 256-Bit SSL Encrypted</span>
                    </div>
                    <span class="badge bg-success-subtle text-success px-2 py-1">Instant Verified Receipt</span>
                </div>

                <button type="submit" id="submitBtn" class="btn-rental btn-rental-primary w-100 py-3 mt-2">
                    <i class="fas fa-lock"></i> Authorize & Complete Payment (&#8377;<%= String.format(Locale.US, "%,.2f", totalAmount) %>)
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
                const totalText = document.getElementById("displayTotal").textContent;
                confirmAction({
                    title: "Authorize Payment: " + totalText,
                    text: "Are you sure you want to authorize payment of " + totalText + " via " + payMethodInput.value + "?",
                    confirmText: "Yes, Authorize & Pay",
                    cancelText: "Review",
                    onConfirm: function() {
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Authorizing Transaction...';

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
                                let finalPaidStr = document.getElementById("displayTotal") ? document.getElementById("displayTotal").textContent.replace(/[^\d.,]/g, "").trim() : "";
                                if (result.includes(":")) {
                                    const parts = result.split(":");
                                    if (parts.length > 1) {
                                        const parsed = parseFloat(parts[1]);
                                        if (!isNaN(parsed) && parsed > 0) {
                                            finalPaidStr = parsed.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                                        }
                                    }
                                }

                                Swal.fire({
                                    title: "Payment Received!",
                                    html: "<div class='text-center my-2'>" +
                                          "<div class='fs-1 text-success mb-2'><i class='fas fa-check-circle'></i></div>" +
                                          "<h4 class='fw-bold text-dark mb-1'>&#8377;" + finalPaidStr + "</h4>" +
                                          "<p class='text-muted small mb-3'>Your payment has been successfully verified & captured.</p>" +
                                          "<span class='badge bg-light text-primary border font-monospace px-3 py-2'>Rental Reference #" + rentalIDInput.value + "</span>" +
                                          "</div>",
                                    icon: "success",
                                    confirmButtonColor: "#2563eb",
                                    confirmButtonText: "Return to Dashboard"
                                }).then(() => {
                                    window.location.href = "customer-dashboard.jsp";
                                });
                            } else {
                                Swal.fire({
                                    title: "Payment Unsuccessful",
                                    text: result || ("Could not record payment for Rental ID #" + rentalIDInput.value),
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
