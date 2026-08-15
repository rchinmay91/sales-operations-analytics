-- 1. Check total transaction records
SELECT COUNT(*) FROM transactions;

-- 2. Find transactions with invalid or zero sales amount
SELECT * FROM transactions WHERE sales_amount <= 0;

-- 3. Identify distinct currencies (detect dual-currency issues)
SELECT DISTINCT currency FROM transactions;

-- 4. Calculate total revenue generated in Mumbai market (Mark002)
SELECT SUM(t.sales_amount) AS total_mumbai_revenue
FROM transactions t
JOIN markets m ON t.market_code = m.markets_code
WHERE m.markets_name = 'Mumbai';