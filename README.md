# 🚗 DriveLux - Enterprise Car Rental Management System

<div align="center">

![Java](https://img.shields.io/badge/Java-17%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-10.1.x-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-F09819?style=for-the-badge&logo=eclipse-ide&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Maven](https://img.shields.io/badge/Apache%20Maven-3.8%2B-C71A36?style=for-the-badge&logo=apache-maven&logoColor=white)
![SweetAlert2](https://img.shields.io/badge/SweetAlert2-Popup%20Engine-8B5CF6?style=for-the-badge&logo=javascript&logoColor=white)

<br/>

**A full-stack, enterprise-grade Car Rental & Fleet Dispatch Management Platform built with Java Servlets, Jakarta EE, JSP, MySQL, and a luxury bespoke CSS UI design system.**

[Features](#-key-features) • [System Architecture](#-system-architecture) • [Database Schema](#-database-schema--er-diagram) • [Quick Start](#-quick-start--installation) • [Default Credentials](#-default-demo-credentials) • [Project Structure](#-project-directory-structure) • [Contributors](#-contributors--academic-credits)

</div>

---

## 📖 Overview

**DriveLux** is a comprehensive **Database Management System (DBMS)** web application developed to modernize vehicle rental reservations, automated billing, fleet lifecycle tracking, and dispatch auditing. 

Built using an MVC-inspired architecture with **Jakarta EE Servlets**, **JSP**, and **MySQL**, it provides secure role-based portals for both **Clients** (browsing fleet, dynamic pricing calculation, booking, and multi-channel checkout) and **Administrators** (live KPI analytics, gross revenue audits, fleet status controls, and booking dispatch).

---

## ✨ Key Features

### 👤 Customer Experience Portal
* **🔐 Secure Authentication**: Customer registration and login protected with **SHA-256** one-way cryptographic hashing.
* **🚘 Interactive Fleet Catalog**: Explore verified vehicles categorized into Executive Sedans, Compact Hatchbacks, Premium MPVs, and Luxury SUVs with real-time availability filters.
* **⚡ Live Cost Estimator**: Dynamic duration and tariff calculator computing exact rental costs before reservation confirmation.
* **💳 Multi-Method Secure Checkout**: Complete payment checkout supporting **Credit Cards**, **Debit Cards**, **UPI / Instant QR**, **Net Banking**, and **Cash at Hub**.
* **📑 Booking Ledger & Invoices**: Personal rental ledger tracking upcoming, ongoing, and completed trips with real-time payment status badges and instant receipt generation.
* **👤 Profile Management**: Self-service profile updates for contact information, physical address, and personal details.

### 🛡️ Executive Admin Console
* **📊 Live Operations Dashboard**: High-level telemetry showing Total Fleet Size, Registered Clients, Total Bookings, Active Ongoing Trips, Overdue Returns, and **Gross Realized Revenue**.
* **📋 Master Rentals Ledger**: Complete booking registry with search filters, real-time journey stage indicators, customer references, and contract audit actions.
* **🚗 Fleet Inventory Control**: Register new vehicles, update specs, inspect maintenance states, and update availability (`Available`, `Rented`, `Maintenance`).
* **👥 Customer Directory**: Full client management ledger with administrative record controls and dispatch verification.
* **📍 Transit Hub Network**: Manage physical pickup/drop-off stations across major metro airports and railway junctions.

### 🛡️ Enterprise Security & UI Polishing
* **Font & Aesthetics**: Uniform luxury typography powered by Google **Poppins**, modern dark gradients, glassmorphism cards, and interactive hover effects.
* **Interactive Confirmations**: Global `confirmAction` dialogs powered by SweetAlert2 for payments, booking cancellations, and deletions.
* **Robust SQL Architecture**: Prepared statements across all servlets preventing SQL Injection, with foreign keys (`ON DELETE CASCADE ON UPDATE CASCADE`).
* **Auto-Healing Financial Engine**: Intelligent transaction handler in `processPayment` computing exact tariffs based on vehicle model and rental duration, eliminating zero-dollar transactions.

---

## 🏛️ System Architecture

```
                       +---------------------------------------+
                       |           Browser Client              |
                       |    (JSP + Vanilla CSS3 + SweetAlert2) |
                       +-------------------+-------------------+
                                           | HTTP (GET / POST / Fetch)
                                           v
                       +---------------------------------------+
                       |       Apache Tomcat 10.1 (Web Server) |
                       |       Jakarta EE Servlet Container    |
                       +-------------------+-------------------+
                                           |
            +------------------------------+------------------------------+
            |                                                             |
            v                                                             v
+-----------------------+                                     +-----------------------+
| Customer Servlets     |                                     | Admin Servlets        |
| - LoginServlet        |                                     | - AdminLoginServlet   |
| - CustomerServlet     |                                     | - UpdateCarServlet    |
| - processRent         |                                     | - UpdateRentalServlet |
| - processPayment      |                                     | - DeleteCarServlet    |
| - ProfileServlet      |                                     | - DeleteCustomerServlet|
+-----------+-----------+                                     +-----------+-----------+
            |                                                             |
            +------------------------------+------------------------------+
                                           | JDBC (com.mysql.cj.jdbc.Driver)
                                           v
                       +---------------------------------------+
                       |         MySQL Database Server         |
                       |          `car_rental_db`              |
                       +---------------------------------------+
```

---

## 🗄️ Database Schema & ER Diagram

The database schema utilizes strict primary and foreign key constraints enforcing relational integrity:

```mermaid
erDiagram
    ADMINISTRATOR {
        VARCHAR(150) Admin_Email PK
        INT Admin_ID UK
        VARCHAR(100) Admin_Name
        VARCHAR(255) Admin_Password
    }

    CUSTOMER {
        VARCHAR(150) Cust_Email PK
        INT Cust_ID UK
        VARCHAR(255) Cust_Name
        VARCHAR(255) Cust_Address
        VARCHAR(20) Cust_Phone
        VARCHAR(255) Cust_Password
    }

    LOCATION {
        INT Loc_ID PK
        VARCHAR(255) Loc_Name
        VARCHAR(255) Loc_City
        VARCHAR(255) Loc_State
        VARCHAR(20) Loc_Zipcode
    }

    CAR {
        VARCHAR(20) Car_Regno PK
        VARCHAR(255) Car_Model
        INT Car_Year
        VARCHAR(255) Car_Color
        VARCHAR(20) Car_Status
    }

    RENTAL {
        INT Rental_ID PK
        VARCHAR(255) Rental_Name
        DATE Rent_Start_Date
        DATE Rent_End_Date
        VARCHAR(20) Rental_Status
        INT Cust_ID FK
        VARCHAR(20) Car_Regno FK
    }

    PAYMENT {
        INT Pay_ID PK
        DATETIME Pay_Date_Time
        VARCHAR(50) Pay_Method
        VARCHAR(20) Pay_Status
        DECIMAL(10,2) Amount_Paid
        INT Rental_ID FK
    }

    CUSTOMER ||--o{ RENTAL : "books"
    CAR ||--o{ RENTAL : "assigned to"
    RENTAL ||--o{ PAYMENT : "settled via"
```

---

## 🔑 Default Demo Credentials

The database script (`Car-Rental-Management-DB.sql`) seeds ready-to-test accounts with SHA-256 encrypted credentials:

### 👑 System Administrator
* **Portal**: `AdminLogin.jsp`
* **Email**: `admin@carrental.com`
* **Password**: `Admin@123`

### 👥 Pre-Configured Customer Accounts
* **Portal**: `login.jsp`
* **Password Pattern**: `FirstName@123` (e.g. First name with capital initial followed by `@123`)

| Customer Name | Email ID | Password | Contact Phone | Registered City |
| :--- | :--- | :--- | :--- | :--- |
| **Aarav Sharma** | `aarav.sharma@gmail.com` | `Aarav@123` | `9845012345` | Bengaluru, KA |
| **Rohan Mehta** | `rohan.mehta@yahoo.com` | `Rohan@123` | `9820198765` | Mumbai, MH |
| **Priya Nair** | `priya.nair@outlook.com` | `Priya@123` | `9744123456` | Chennai, TN |
| **Sneha Patel** | `sneha.patel@gmail.com` | `Sneha@123` | `9898034567` | Ahmedabad, GJ |
| **Vikram Singh** | `vikram.singh@gmail.com` | `Vikram@123` | `9414056789` | Jaipur, RJ |
| **Ananya Deshmukh** | `ananya.deshmukh@gmail.com` | `Ananya@123` | `9850023456` | Pune, MH |
| **Rahul Verma** | `rahul.verma@hotmail.com` | `Rahul@123` | `9811098765` | New Delhi, DL |
| **Kavita Reddy** | `kavita.reddy@gmail.com` | `Kavita@123` | `9849012345` | Hyderabad, TS |
| **Aditya Roy** | `aditya.roy@gmail.com` | `Aditya@123` | `9830056789` | Kolkata, WB |
| **Pooja Fernandes**| `pooja.fernandes@yahoo.com` | `Pooja@123` | `9822145678` | Panaji, Goa |

---

## 🚀 Quick Start & Installation

### 1. Prerequisites
Ensure you have the following installed on your machine:
* **Java Development Kit (JDK)**: Version 17 or higher
* **Apache Tomcat**: Version 10.1.x (requires Jakarta EE 10 namespace `jakarta.servlet.*`)
* **MySQL Server**: Version 8.0 or higher
* **Apache Maven**: Version 3.8 or higher
* **IDE (Recommended)**: Eclipse IDE for Enterprise Java / VS Code / IntelliJ IDEA Ultimate

### 2. Database Initialization
1. Open your MySQL client (MySQL Workbench, Command Line, or phpMyAdmin).
2. Execute the bundled SQL schema and seed file:
   ```bash
   mysql -u root -p < Car-Rental-Management-DB.sql
   ```
   *(Or copy-paste the contents of `Car-Rental-Management-DB.sql` into MySQL Workbench and run it).*

3. Verify that the `car_rental_db` database is created with tables populated:
   ```sql
   USE car_rental_db;
   SHOW TABLES;
   SELECT COUNT(*) FROM customer; -- Returns 10
   SELECT COUNT(*) FROM car;      -- Returns 10
   SELECT COUNT(*) FROM payment;  -- Returns 10
   ```

### 3. Verify Database Credentials in Servlets
If your local MySQL root password differs from the default `trickortreat`, update the JDBC connection URL across the Java servlets:
```java
DriverManager.getConnection("jdbc:mysql://localhost:3306/car_rental_db", "YOUR_USERNAME", "YOUR_PASSWORD");
```

### 4. Build and Package with Maven
Open terminal inside the repository root directory:
```bash
# Clean previous builds and package the WAR artifact
mvn clean package
```
This generates `target/DBMS-MINI-PROJECT.war`.

### 5. Deployment Options

#### Option A: Running in Eclipse / VS Code with Tomcat 10.1
1. Import project as **Existing Maven Project**.
2. Right-click project &rarr; **Run As** &rarr; **Run on Server** &rarr; Select **Apache Tomcat 10.1**.
3. Access the application in your browser at:
   ```
   http://localhost:8080/DBMS-MINI-PROJECT/
   ```

#### Option B: Standalone Apache Tomcat Deployment
1. Copy the generated WAR file into your Tomcat `webapps/` folder:
   ```bash
   cp target/DBMS-MINI-PROJECT.war <TOMCAT_DIR>/webapps/
   ```
2. Start Tomcat:
   * **Windows**: `<TOMCAT_DIR>\bin\startup.bat`
   * **Linux/macOS**: `<TOMCAT_DIR>/bin/startup.sh`
3. Navigate to: `http://localhost:8080/DBMS-MINI-PROJECT/`

---

## 📁 Project Directory Structure

```text
DBMS-CAR-RENTAL-MANAGEMENT-SYSTEM/
├── pom.xml                               # Maven project dependencies and build lifecycle
├── Car-Rental-Management-DB.sql          # Unified MySQL relational schema & 10-record seed data
├── README.md                             # Comprehensive project documentation
├── DBMS-Mini-Project.pdf                 # Formatted academic laboratory project report
├── DBMS-Mini-Project.tex                 # LaTeX documentation source
│
├── src/main/java/                        # Backend Servlets (Jakarta EE 10)
│   ├── AdminLoginServlet.java            # Admin credential authentication with SHA-256
│   ├── CustomerServlet.java              # Customer registration handler & password hasher
│   ├── DeleteCarServlet.java             # Fleet retirement servlet
│   ├── DeleteCustomerServlet.java        # Customer deletion & cleanup handler
│   ├── DeleteRentalServlet.java          # Booking contract cancellation handler
│   ├── LoginServlet.java                 # Customer login authentication
│   ├── ProfileServlet.java               # Customer account profile updater
│   ├── UpdateCarServlet.java             # Car spec loader for update form
│   ├── UpdateCarActionServlet.java       # Vehicle update persistence servlet
│   ├── UpdateRentalServlet.java          # Rental data loader for update form
│   ├── UpdateRentalActionServlet.java    # Booking status update persistence servlet
│   ├── processPayment.java               # Payment processor, amount calculator & auto-healer
│   └── processRent.java                  # Vehicle reservation dispatch handler
│
└── src/main/webapp/                      # Frontend Presentation Layer
    ├── index.jsp                         # Landing homepage with luxury hero section
    ├── login.jsp                         # Customer sign-in portal
    ├── registration.jsp                  # Customer registration form with live validation
    ├── customer-dashboard.jsp            # Customer portal with trip counters & actions
    ├── availableCars.jsp                 # Real-time fleet view, catalog modal & booking desk
    ├── payments.jsp                      # Checkout portal with invoice breakdown & methods
    ├── myRentals.jsp                     # Customer bookings ledger with receipt generator
    ├── ProfileUpdate.jsp                 # Customer account profile management
    ├── AdminLogin.jsp                    # Secure administrator sign-in portal
    ├── admin-dashboard.jsp               # Executive analytics console with revenue tracking
    ├── ManageCars.jsp                    # Fleet inventory manager
    ├── updateCarForm.jsp                 # Edit vehicle modal / form
    ├── manageRentals.jsp                 # Enterprise rentals dispatch ledger
    ├── updateRentalForm.jsp              # Edit rental status modal / form
    ├── ManageCustomers.jsp               # Customer directory ledger
    ├── ManageLocations.jsp               # Mobility hub station manager
    │
    ├── css/
    │   └── style.css                     # Unified luxury design system & responsive stylesheet
    ├── js/
    │   ├── car-data.js                   # Vehicle models, specifications & imagery catalog
    │   └── confirm-alert.js              # SweetAlert2 unified confirmation modal wrapper
    └── WEB-INF/
        └── web.xml                       # Deployment descriptor & servlet mappings
```

---

## 🌐 Application Endpoints & Page Directory

| URL Endpoint | Target File / Servlet | Description | Access Level |
| :--- | :--- | :--- | :--- |
| `/` or `/index.jsp` | `index.jsp` | Public landing page & platform showcase | Public |
| `/login.jsp` | `login.jsp` | Customer sign-in page | Public |
| `/registration.jsp` | `registration.jsp` | Customer registration portal | Public |
| `/customer-dashboard.jsp`| `customer-dashboard.jsp` | Customer dashboard & booking status overview | Customer |
| `/availableCars.jsp` | `availableCars.jsp` | Interactive fleet catalog with instant reservation modal | Customer |
| `/payments.jsp` | `payments.jsp` | Secure checkout with order invoice breakdown | Customer |
| `/myRentals.jsp` | `myRentals.jsp` | Customer booking history ledger & receipt viewer | Customer |
| `/ProfileUpdate.jsp` | `ProfileUpdate.jsp` | Profile settings, password & contact updates | Customer |
| `/AdminLogin.jsp` | `AdminLogin.jsp` | Executive administrator login portal | Public |
| `/admin-dashboard.jsp` | `admin-dashboard.jsp` | Admin overview, real-time KPI metrics & revenue | Admin |
| `/ManageCars.jsp` | `ManageCars.jsp` | Fleet management ledger & vehicle status controls | Admin |
| `/manageRentals.jsp` | `manageRentals.jsp` | Master dispatch ledger & booking updates | Admin |
| `/ManageCustomers.jsp` | `ManageCustomers.jsp` | Client directory & account audits | Admin |
| `/ManageLocations.jsp` | `ManageLocations.jsp` | Transit hubs & mobility stations directory | Admin |
| `/processRent` | `processRent.java` | Processes vehicle reservations | Customer |
| `/processPayment` | `processPayment.java` | Records transaction amount and settles booking | Customer |

---


---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details. Open-source for academic and educational learning purposes.
