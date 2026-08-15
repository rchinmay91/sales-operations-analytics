# 📊 Sales Insights & Revenue Analytics Dashboard

An end-to-end data analytics project simulating an enterprise business intelligence workflow. This project integrates a relational SQL database pipeline with Power BI data modeling, DAX measure engineering, and interactive dashboard design to uncover key revenue trends, regional market bottlenecks, and customer concentration risks for **AtliQ Hardware**.

---

## 📌 Business Overview & Problem Statement

**AtliQ Hardware**, a fast-growing computer hardware and peripheral manufacturer in India, faced severe visibility issues regarding its sales performance:

- **Lack of Centralized Insights:** Regional sales managers provided fragmented, unstandardized Excel reports and verbal estimates.
- **Hidden Deficits:** Overall high-level sales obscured significant revenue drops and negative margins in specific territories (e.g., South Zone).
- **Currency Inconsistencies:** Sales records contained mixed currencies (INR and USD) without dynamic conversion, leading to distorted financial reporting.

### 🎯 Objective
Design and implement an automated, robust BI pipeline connecting a **MySQL relational database** to **Power BI Desktop** to provide executive leadership with a single source of truth for revenue, sales volume, top customer analysis, and regional performance trends.

---

## 🏗️ Architecture & Tech Stack

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐       ┌──────────────────┐
│  MySQL Database │ ────> │   Power Query   │ ────> │  Data Modeling  │ ────> │ Power BI Report  │
│  Raw ETL Engine │       │  Transformation │       │   Star Schema   │       │ Executive UI/UX  │
└─────────────────┘       └─────────────────┘       └─────────────────┘       └──────────────────┘
```

| Layer | Tool / Technology | Role & Key Responsibilities |
| :--- | :--- | :--- |
| **Database** | **MySQL Workbench / SQL** | Schema creation, primary/foreign key relations, exploratory data queries. |
| **ETL & Prep** | **Power Query (M Language)** | Data cleaning, filtering zero/invalid amounts, currency normalization (USD $ightarrow$ INR). |
| **Modeling** | **Power BI Desktop** | Star schema architecture, cardinality configuration, single-direction relationships. |
| **Analytics** | **DAX (Data Analysis Expressions)** | Custom KPIs, dynamic aggregations, Time Intelligence (YoY Growth). |
| **Visualization** | **Power BI Visuals & UI** | Executive cards, interactive charts, matrix drill-downs, dynamic slicers. |

---

## 📂 Project Structure

```
├── sql_scripts/
│   ├── db_schema_setup.sql          # Table definitions, Foreign Keys, Primary Keys
│   ├── sample_data_seed.sql         # Seed records & raw transactions
│   └── exploratory_queries.sql      # Analytical queries for data audit
├── power_bi/
│   ├── Sales_Insights_Dashboard.pbix # Interactive Power BI Dashboard report file
│   └── data_model_schema.png        # Star schema structure reference diagram
├── assets/
│   ├── dashboard_preview.png        # Executive Dashboard Screenshot
│   └── kpi_breakdown.png            # Visual KPI details
└── README.md                        # Project documentation (this file)
```

---

## 🗄️ Database Architecture & Data Modeling

### Star Schema Design
The data warehouse model strictly follows a **Star Schema** centered around the core `transactions` fact table to optimize query performance and DAX measure evaluation.

```
       +-------------------+
       |    customers      |
       +-------------------+
       | customer_code (PK)|
       | custmer_name      |
       | customer_type     |
       +---------+---------+
                 | 1
                 |
                 | N
+----------------+----------------+      +-------------------+
|          transactions           |      |      markets      |
+---------------------------------+      +-------------------+
| product_code (FK)               | N  1 | markets_code (PK) |
| customer_code (FK) -------------+----->| markets_name      |
| market_code (FK)                |      | zone              |
| order_date (FK)                 |      +-------------------+
| sales_qty                       |
| sales_amount                    |      +-------------------+
| currency                        |      |     products      |
| Normalized_Amount (Calculated)  |      +-------------------+
+----------------+----------------+      | product_code (PK) |
                 | N                     | product_type      |
                 |                       +---------+---------+
                 | 1                               | 1
                 +---------------------------------+
                 | N
       +---------+---------+
       |     date_dim      |
       +-------------------+
       | date (PK)         |
       | cy_date           |
       | year              |
       | month_name        |
       | date_yy_mmm       |
       +-------------------+
```

---

## 🔍 Data Cleaning & Transformation (Power Query ETL)

During initial data inspection, several data quality issues were identified and remediated in **Power Query**:

1. **Filtering Zero / Negative Values:**
   - Filtered out transaction records where `sales_amount <= 0` or `sales_qty <= 0`.
2. **Currency Standardization:**
   - Identified dual-currency transactions (`INR` vs. `USD` / `USD#`).
   - Created a custom column **`Normalized_Amount`** using M code to convert foreign currencies to INR:
     ```powerquery
     if [currency] = "USD" or [currency] = "USD#(cr)" then [sales_amount] * 83 else [sales_amount]
     ```
3. **Data Type & Relationship Alignment:**
   - Standardized `order_date` to standard Date format to match `date_dim[date]`.
   - Removed junk characters and whitespace across text dimensions.

---

## 🧮 Analytical SQL & DAX Calculations

### Exploratory SQL Queries
```sql
-- 1. Identify total sales revenue generated in Mumbai
SELECT SUM(t.sales_amount) AS total_mumbai_revenue
FROM transactions t
JOIN markets m ON t.market_code = m.markets_code
WHERE m.markets_name = 'Mumbai';

-- 2. Detect invalid zero/negative transactions
SELECT COUNT(*) FROM transactions WHERE sales_amount <= 0;

-- 3. Revenue distribution across client types
SELECT c.customer_type, SUM(t.sales_amount) AS total_revenue
FROM transactions t
JOIN customers c ON t.customer_code = c.customer_code
GROUP BY c.customer_type
ORDER BY total_revenue DESC;
```

### Key DAX Measures (Power BI)

```dax
// Total Revenue (INR Normalized)
Total Revenue = 
SUM('transactions'[Normalized_Amount])

// Total Quantity Sold
Total Quantity = 
SUM('transactions'[sales_qty])

// Revenue Year-over-Year (YoY) Growth %
Revenue YoY % = 
VAR CurrentYearRevenue = [Total Revenue]
VAR PreviousYearRevenue = CALCULATE([Total Revenue], SAMEPERIODLASTYEAR('date_dim'[date]))
RETURN
DIVIDE(CurrentYearRevenue - PreviousYearRevenue, PreviousYearRevenue, 0)

// Top Market Revenue Contribution %
Market Contribution % = 
DIVIDE([Total Revenue], CALCULATE([Total Revenue], ALL('markets')), 0)
```

---

## 📈 Executive Key Insights

1. **Market Concentration:**
   - **Delhi NCR** and **Mumbai** generate over **55%** of overall corporate revenue, while the **South Zone (Chennai, Kochi)** lags significantly despite high sales activity.
2. **Customer Risk Exposure:**
   - Top 2 E-Commerce retail clients account for **>45%** of overall product volume sold. High reliance on these key clients poses a volume risk if contracts change.
3. **ETL Value Realization:**
   - Normalizing USD transactions added hidden revenue back into visual reporting, preventing an initial **8–10% understatement** of annual total turnover.

---

## 🚀 How to Run & Reproduce This Project

### 1. Database Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/Sales_Insights-SQL-Power-BI.git
   cd Sales_Insights-SQL-Power-BI
   ```
2. Open **MySQL Workbench** or your preferred SQL tool.
3. Execute `sql_scripts/db_schema_setup.sql` followed by `sql_scripts/sample_data_seed.sql`.

### 2. Power BI Connection
1. Open **Power BI Desktop**.
2. Click **Get Data** $
ightarrow$ **MySQL Database**.
3. Set Server to `localhost` and Database to `sales_db`.
4. Open **Power Query Editor** to verify step applied transformations.
5. Save & Apply changes, then open `power_bi/Sales_Insights_Dashboard.pbix`.

---

## 📬 Contact & Connect

- **Author:** Chinmay R.
- **GitHub:** [github.com/rchinmay91](https://github.com/rchinmay91)
- **Email:** rchinmay2002@gmail.com
