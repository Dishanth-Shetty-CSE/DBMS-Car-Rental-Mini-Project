-- ============================================================================
-- CAR RENTAL MANAGEMENT SYSTEM DATABASE SCHEMA & SEED DATA
-- DBMS Mini Project - Enterprise Grade Edition
-- ============================================================================

CREATE DATABASE IF NOT EXISTS car_rental_db;
USE car_rental_db;

-- ----------------------------------------------------------------------------
-- Drop tables in reverse dependency order
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS rental;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS location;
DROP TABLE IF EXISTS administrator;

-- ----------------------------------------------------------------------------
-- 1. Table structure for table `administrator`
-- Primary Key: Admin_Email
-- ----------------------------------------------------------------------------
CREATE TABLE administrator (
  Admin_Email VARCHAR(150) NOT NULL,
  Admin_ID INT NOT NULL AUTO_INCREMENT,
  Admin_Name VARCHAR(100) NOT NULL,
  Admin_Password VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (Admin_Email),
  UNIQUE KEY (Admin_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 2. Table structure for table `car`
-- Primary Key: Car_Regno
-- ----------------------------------------------------------------------------
CREATE TABLE car (
  Car_Regno VARCHAR(20) NOT NULL,
  Car_Model VARCHAR(255) DEFAULT NULL,
  Car_Year INT DEFAULT NULL,
  Car_Color VARCHAR(255) DEFAULT NULL,
  Car_Status VARCHAR(20) DEFAULT 'Available',
  PRIMARY KEY (Car_Regno)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 3. Table structure for table `customer`
-- Primary Key: Cust_Email
-- ----------------------------------------------------------------------------
CREATE TABLE customer (
  Cust_Email VARCHAR(150) NOT NULL,
  Cust_ID INT NOT NULL AUTO_INCREMENT,
  Cust_Name VARCHAR(255) DEFAULT NULL,
  Cust_Address VARCHAR(255) DEFAULT NULL,
  Cust_Phone VARCHAR(20) DEFAULT NULL,
  Cust_Password VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (Cust_Email),
  UNIQUE KEY (Cust_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 4. Table structure for table `location`
-- Primary Key: Loc_ID
-- ----------------------------------------------------------------------------
CREATE TABLE location (
  Loc_ID INT NOT NULL AUTO_INCREMENT,
  Loc_Name VARCHAR(255) DEFAULT NULL,
  Loc_City VARCHAR(255) DEFAULT NULL,
  Loc_State VARCHAR(255) DEFAULT NULL,
  Loc_Zipcode VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (Loc_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 5. Table structure for table `rental`
-- Primary Key: Rental_ID
-- ----------------------------------------------------------------------------
CREATE TABLE rental (
  Rental_ID INT NOT NULL AUTO_INCREMENT,
  Rental_Name VARCHAR(255) DEFAULT NULL,
  Rent_Start_Date DATE DEFAULT NULL,
  Rent_End_Date DATE DEFAULT NULL,
  Rental_Status VARCHAR(20) DEFAULT 'Available',
  Cust_ID INT DEFAULT NULL,
  Car_Regno VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (Rental_ID),
  FOREIGN KEY (Car_Regno) REFERENCES car (Car_Regno) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Cust_ID) REFERENCES customer (Cust_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 6. Table structure for table `payment`
-- Primary Key: Pay_ID
-- ----------------------------------------------------------------------------
CREATE TABLE payment (
  Pay_ID INT NOT NULL AUTO_INCREMENT,
  Pay_Date_Time DATETIME DEFAULT NULL,
  Pay_Method VARCHAR(50) DEFAULT NULL,
  Pay_Status VARCHAR(20) NOT NULL DEFAULT 'Completed',
  Amount_Paid DECIMAL(10,2) DEFAULT 0.00,
  Rental_ID INT DEFAULT NULL,
  PRIMARY KEY (Pay_ID),
  FOREIGN KEY (Rental_ID) REFERENCES rental (Rental_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
