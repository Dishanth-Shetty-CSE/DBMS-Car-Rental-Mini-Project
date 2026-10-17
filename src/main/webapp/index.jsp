<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DriveLux - Premier Car Rental & Fleet Management</title>
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
        .landing-hero {
            position: relative;
            background: linear-gradient(rgba(15, 23, 42, 0.75), rgba(15, 23, 42, 0.85)),
                        url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
            padding: 130px 0 110px 0;
            color: #ffffff;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.15;
            margin-bottom: 20px;
            letter-spacing: -0.03em;
        }
        .hero-title span {
            background: linear-gradient(135deg, #60a5fa 0%, #06b6d4 100%);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero-lead {
            font-size: 1.25rem;
            color: #cbd5e1;
            margin-bottom: 35px;
            max-width: 600px;
        }
        .feature-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            padding: 30px 25px;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
            border-color: #cbd5e1;
        }
        .feature-icon {
            width: 58px;
            height: 58px;
            border-radius: 14px;
            background: var(--primary-soft);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 20px;
        }
        .step-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--primary);
            color: #ffffff;
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        @media (max-width: 768px) {
            .landing-hero {
                padding: 80px 0 60px 0;
            }
            .hero-title {
                font-size: 2.4rem;
            }
            .hero-lead {
                font-size: 1.05rem;
            }
        }
    </style>
</head>
<body>

    <!-- Unified Top Navigation -->
    <header class="rental-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand" href="index.jsp">
                <div class="brand-badge"><i class="fas fa-car-side"></i></div>
                <span>Drive<span style="color: #60a5fa;">Lux</span></span>
            </a>
            
            <nav class="d-none d-md-flex align-items-center gap-2">
                <a class="nav-link active" href="index.jsp"><i class="fas fa-home"></i> Home</a>
                <a class="nav-link" href="login.jsp"><i class="fas fa-car"></i> Browse Fleet</a>
                <a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Customer Login</a>
                <a class="btn-rental btn-rental-primary btn-rental-sm ms-2" href="registration.jsp">
                    <i class="fas fa-user-plus"></i> Register
                </a>
                <a class="btn-rental btn-rental-outline btn-rental-sm ms-1" href="AdminLogin.jsp" title="Admin Portal">
                    <i class="fas fa-shield-alt text-primary"></i> Admin
                </a>
            </nav>

            <!-- Mobile Menu Toggle Button -->
            <button class="btn btn-outline-light d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#mobileNav">
                <i class="fas fa-bars"></i>
            </button>
        </div>

        <!-- Mobile Collapsible Menu -->
        <div class="collapse d-md-none mt-3 px-4" id="mobileNav">
            <div class="d-flex flex-column gap-2 pb-2">
                <a class="nav-link active" href="index.jsp"><i class="fas fa-home"></i> Home</a>
                <a class="nav-link" href="login.jsp"><i class="fas fa-car"></i> Browse Fleet</a>
                <a class="nav-link" href="login.jsp"><i class="fas fa-sign-in-alt"></i> Customer Login</a>
                <a class="nav-link" href="registration.jsp"><i class="fas fa-user-plus"></i> Customer Registration</a>
                <a class="nav-link" href="AdminLogin.jsp"><i class="fas fa-shield-alt"></i> Admin Portal</a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="landing-hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <div class="hero-stats-badge">
                        <i class="fas fa-award text-warning"></i> #1 Trusted Car Rental Platform
                    </div>
                    <h1 class="hero-title">Experience the <span>Freedom of Road</span> with Premium Comfort</h1>
                    <p class="hero-lead">Choose from hundreds of sanitized, verified luxury sedans, rugged SUVs, and efficient city hatchbacks. Instant booking with zero security deposit hassles.</p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="login.jsp" class="btn-rental btn-rental-primary btn-lg">
                            <i class="fas fa-key"></i> Book Your Car Now
                        </a>
                        <a href="registration.jsp" class="btn-rental btn-rental-outline btn-lg text-white" style="border-color: rgba(255,255,255,0.3); background: rgba(255,255,255,0.1);">
                            <i class="fas fa-user-plus"></i> Join DriveLux
                        </a>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block">
                    <!-- Quick Search / Overview Card -->
                    <div class="card border-0 shadow-lg" style="border-radius: 20px; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); color: #0f172a; padding: 25px;">
                        <h4 class="fw-bold mb-3 d-flex align-items-center gap-2">
                            <i class="fas fa-bolt text-warning"></i> Fast Rental Search
                        </h4>
                        <div class="mb-3">
                            <label class="form-label-custom">Pickup Location</label>
                            <div class="input-with-icon">
                                <i class="fas fa-map-marker-alt"></i>
                                <select class="form-control-custom">
                                    <option>Main Office Terminal - Bangalore</option>
                                    <option>West Branch Hub - Mumbai</option>
                                    <option>South Hub Station - Chennai</option>
                                    <option>North Yard Airport Depot - Delhi</option>
                                </select>
                            </div>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label-custom">Rental Type</label>
                                <select class="form-control-custom">
                                    <option>Personal Trip</option>
                                    <option>Business Lease</option>
                                    <option>VIP Service</option>
                                </select>
                            </div>
                            <div class="col-6">
                                <label class="form-label-custom">Vehicle Class</label>
                                <select class="form-control-custom">
                                    <option>All Classes</option>
                                    <option>Executive Sedan</option>
                                    <option>Premium SUV</option>
                                </select>
                            </div>
                        </div>
                        <a href="login.jsp" class="btn-rental btn-rental-primary w-100">
                            <i class="fas fa-search"></i> Check Available Fleet
                        </a>
                        <div class="text-center mt-3 text-muted small">
                            <i class="fas fa-shield-alt text-success"></i> 100% Sanitized • Free Cancellation • GPS Enabled
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Live Metrics Strip -->
    <section class="py-4" style="background: #ffffff; border-bottom: 1px solid var(--border-color);">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-6 col-md-3">
                    <h3 class="fw-bold text-primary mb-0 font-monospace">100+</h3>
                    <div class="text-muted small">Verified Vehicles</div>
                </div>
                <div class="col-6 col-md-3">
                    <h3 class="fw-bold text-success mb-0 font-monospace">10+</h3>
                    <div class="text-muted small">Metro Locations</div>
                </div>
                <div class="col-6 col-md-3">
                    <h3 class="fw-bold text-warning mb-0 font-monospace">15,000+</h3>
                    <div class="text-muted small">Happy Customers</div>
                </div>
                <div class="col-6 col-md-3">
                    <h3 class="fw-bold text-info mb-0 font-monospace">4.9 / 5</h3>
                    <div class="text-muted small">Average Customer Rating</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Fleet Section -->
    <section class="py-5" style="background-color: #f8fafc;">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4 flex-wrap gap-2">
                <div>
                    <span class="badge bg-primary-subtle text-primary fw-semibold px-3 py-2 rounded-pill mb-2">Our Premium Fleet</span>
                    <h2 class="fw-bold mb-1">Featured Real-World Vehicles</h2>
                    <p class="text-muted mb-0">Hand-picked and regularly maintained for the smoothest travel experience.</p>
                </div>
                <a href="login.jsp" class="btn-rental btn-rental-outline">
                    View Full Fleet <i class="fas fa-arrow-right"></i>
                </a>
            </div>

            <div class="row g-4" id="fleetGrid">
                <!-- Vehicle Card 1 -->
                <div class="col-md-6 col-lg-3">
                    <div class="car-card">
                        <div class="car-card-img-wrap">
                            <img src="https://images.unsplash.com/photo-1590362891991-f776e747a588?auto=format&fit=crop&w=800&q=80" 
                                 onerror="this.src='Resources/Luxury Sedan.jpg'" alt="Honda City">
                            <span class="car-badge-type">Sedan</span>
                            <span class="car-badge-status badge-custom badge-available">Available</span>
                        </div>
                        <div class="car-card-body">
                            <h4 class="car-card-title">Honda City</h4>
                            <span class="car-card-reg">KA01AB1234 • 2020</span>
                            <div class="car-specs-grid">
                                <div class="spec-item"><i class="fas fa-cog"></i> Auto</div>
                                <div class="spec-item"><i class="fas fa-gas-pump"></i> Petrol</div>
                                <div class="spec-item"><i class="fas fa-users"></i> 5 Seats</div>
                                <div class="spec-item"><i class="fas fa-tachometer-alt"></i> 18 km/l</div>
                            </div>
                            <div class="car-card-footer">
                                <div class="car-price-block">
                                    <span class="price-value">&#8377;2,200</span>
                                    <span class="price-period">per day</span>
                                </div>
                                <a href="login.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Rent Now</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Vehicle Card 2 -->
                <div class="col-md-6 col-lg-3">
                    <div class="car-card">
                        <div class="car-card-img-wrap">
                            <img src="https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80" 
                                 onerror="this.src='Resources/Premium SUV.jpg'" alt="Toyota Innova">
                            <span class="car-badge-type">7-Seater MPV</span>
                            <span class="car-badge-status badge-custom badge-available">Available</span>
                        </div>
                        <div class="car-card-body">
                            <h4 class="car-card-title">Toyota Innova</h4>
                            <span class="car-card-reg">KA04GH1121 • 2018</span>
                            <div class="car-specs-grid">
                                <div class="spec-item"><i class="fas fa-cog"></i> Manual</div>
                                <div class="spec-item"><i class="fas fa-gas-pump"></i> Diesel</div>
                                <div class="spec-item"><i class="fas fa-users"></i> 7 Seats</div>
                                <div class="spec-item"><i class="fas fa-tachometer-alt"></i> 14 km/l</div>
                            </div>
                            <div class="car-card-footer">
                                <div class="car-price-block">
                                    <span class="price-value">&#8377;3,400</span>
                                    <span class="price-period">per day</span>
                                </div>
                                <a href="login.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Rent Now</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Vehicle Card 3 -->
                <div class="col-md-6 col-lg-3">
                    <div class="car-card">
                        <div class="car-card-img-wrap">
                            <img src="https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=800&q=80" 
                                 onerror="this.src='Resources/Premium SUV.jpg'" alt="Tata Nexon">
                            <span class="car-badge-type">Compact SUV</span>
                            <span class="car-badge-status badge-custom badge-available">Available</span>
                        </div>
                        <div class="car-card-body">
                            <h4 class="car-card-title">Tata Nexon</h4>
                            <span class="car-card-reg">KA05IJ3141 • 2022</span>
                            <div class="car-specs-grid">
                                <div class="spec-item"><i class="fas fa-cog"></i> Auto</div>
                                <div class="spec-item"><i class="fas fa-gas-pump"></i> Diesel</div>
                                <div class="spec-item"><i class="fas fa-users"></i> 5 Seats</div>
                                <div class="spec-item"><i class="fas fa-tachometer-alt"></i> 17 km/l</div>
                            </div>
                            <div class="car-card-footer">
                                <div class="car-price-block">
                                    <span class="price-value">&#8377;2,500</span>
                                    <span class="price-period">per day</span>
                                </div>
                                <a href="login.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Rent Now</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Vehicle Card 4 -->
                <div class="col-md-6 col-lg-3">
                    <div class="car-card">
                        <div class="car-card-img-wrap">
                            <img src="https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80" 
                                 onerror="this.src='Resources/Luxury Sedan.jpg'" alt="Maruti Swift">
                            <span class="car-badge-type">Hatchback</span>
                            <span class="car-badge-status badge-custom badge-available">Available</span>
                        </div>
                        <div class="car-card-body">
                            <h4 class="car-card-title">Maruti Swift</h4>
                            <span class="car-card-reg">KA03EF9101 • 2021</span>
                            <div class="car-specs-grid">
                                <div class="spec-item"><i class="fas fa-cog"></i> Manual</div>
                                <div class="spec-item"><i class="fas fa-gas-pump"></i> Petrol</div>
                                <div class="spec-item"><i class="fas fa-users"></i> 5 Seats</div>
                                <div class="spec-item"><i class="fas fa-tachometer-alt"></i> 23 km/l</div>
                            </div>
                            <div class="car-card-footer">
                                <div class="car-price-block">
                                    <span class="price-value">&#8377;1,400</span>
                                    <span class="price-period">per day</span>
                                </div>
                                <a href="login.jsp" class="btn-rental btn-rental-primary btn-rental-sm">Rent Now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="py-5" style="background: #ffffff; border-top: 1px solid var(--border-color);">
        <div class="container text-center">
            <span class="badge bg-primary-subtle text-primary fw-semibold px-3 py-2 rounded-pill mb-2">Simple 3-Step Process</span>
            <h2 class="fw-bold mb-5">How Renting Works with DriveLux</h2>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="step-pill">1</div>
                        <h4 class="fw-bold">Select Vehicle</h4>
                        <p class="text-muted">Browse our verified fleet by model, category, transmission, or fuel preferences.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="step-pill">2</div>
                        <h4 class="fw-bold">Choose Dates</h4>
                        <p class="text-muted">Select your journey start and end dates with transparent pricing and no hidden costs.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="step-pill">3</div>
                        <h4 class="fw-bold">Drive & Return</h4>
                        <p class="text-muted">Pick up your car from any of our nationwide stations or opt for doorstep delivery.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="rental-footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="d-flex align-items-center gap-2 mb-3">
                        <div class="brand-badge"><i class="fas fa-car-side"></i></div>
                        <span class="fs-4 fw-bold text-white">Drive<span style="color: #60a5fa;">Lux</span></span>
                    </div>
                    <p class="small text-muted">A premier, modern DBMS car rental management enterprise system built with Java Servlets, JSP, and MySQL database.</p>
                </div>
                <div class="col-6 col-lg-2">
                    <h6 class="text-white fw-bold mb-3">Quick Navigation</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="index.jsp">Home</a></li>
                        <li class="mb-2"><a href="login.jsp">Browse Cars</a></li>
                        <li class="mb-2"><a href="login.jsp">Customer Login</a></li>
                        <li class="mb-2"><a href="registration.jsp">Register</a></li>
                    </ul>
                </div>
                <div class="col-6 col-lg-2">
                    <h6 class="text-white fw-bold mb-3">Administration</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="AdminLogin.jsp">Admin Portal</a></li>
                        <li class="mb-2"><a href="AdminLogin.jsp">Fleet Management</a></li>
                        <li class="mb-2"><a href="AdminLogin.jsp">Booking Desk</a></li>
                    </ul>
                </div>
                <div class="col-lg-4">
                    <h6 class="text-white fw-bold mb-3">Customer Support</h6>
                    <p class="small text-muted mb-2"><i class="fas fa-map-marker-alt text-primary me-2"></i> Main Office Terminal, MG Road, Bangalore</p>
                    <p class="small text-muted mb-2"><i class="fas fa-phone text-primary me-2"></i> +91 98765 43210</p>
                    <p class="small text-muted mb-0"><i class="fas fa-envelope text-primary me-2"></i> support@drivelux.com</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p class="mb-0">&copy; 2025 DriveLux DBMS Car Rental Management System. All Rights Reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/car-data.js"></script>
</body>
</html>
