-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS sales_db;
USE sales_db;

-- Step 2: Create Dimension Tables
CREATE TABLE customers (
    customer_code VARCHAR(45) PRIMARY KEY,
    custmer_name VARCHAR(45) NOT NULL,
    customer_type VARCHAR(45)
);

CREATE TABLE markets (
    markets_code VARCHAR(45) PRIMARY KEY,
    markets_name VARCHAR(45) NOT NULL,
    zone VARCHAR(45)
);

CREATE TABLE products (
    product_code VARCHAR(45) PRIMARY KEY,
    product_type VARCHAR(45)
);

CREATE TABLE date_dim (
    date DATE PRIMARY KEY,
    cy_date INT,
    year INT,
    month_name VARCHAR(45),
    date_yy_mmm VARCHAR(45)
);

-- Step 3: Create Fact Table
CREATE TABLE transactions (
    product_code VARCHAR(45),
    customer_code VARCHAR(45),
    market_code VARCHAR(45),
    order_date DATE,
    sales_qty INT,
    sales_amount DOUBLE,
    currency VARCHAR(45),
    FOREIGN KEY (customer_code) REFERENCES customers(customer_code),
    FOREIGN KEY (market_code) REFERENCES markets(markets_code),
    FOREIGN KEY (product_code) REFERENCES products(product_code),
    FOREIGN KEY (order_date) REFERENCES date_dim(date)
);

-- Step 4: Insert Seed Data
INSERT INTO customers VALUES 
('CUST001', 'Electricalsly Store', 'Physical Stores'),
('CUST002', 'Logic Stores', 'Physical Stores'),
('CUST003', 'E-Commerce Retail', 'E-Commerce');

INSERT INTO markets VALUES 
('Mark001', 'Chennai', 'South'),
('Mark002', 'Mumbai', 'Central'),
('Mark003', 'Delhi', 'North');

INSERT INTO products VALUES 
('Prod001', 'Prod_Category_1'),
('Prod002', 'Prod_Category_2');

INSERT INTO date_dim VALUES 
('2024-01-01', 2024, 2024, 'January', '01-Jan'),
('2024-02-01', 2024, 2024, 'February', '01-Feb');

-- Note: Includes invalid amounts (<=0) and non-INR currency to mimic real raw data.
INSERT INTO transactions VALUES 
('Prod001', 'CUST001', 'Mark001', '2024-01-01', 5, 25000, 'INR'),
('Prod002', 'CUST002', 'Mark002', '2024-01-01', 2, 0, 'INR'), -- Invalid sale
('Prod001', 'CUST003', 'Mark003', '2024-02-01', 10, 500, 'USD'), -- USD conversion needed
('Prod002', 'CUST001', 'Mark002', '2024-02-01', 4, 18000, 'INR');