# ecommerce-rfm-customer-analytics
# 🛒 E-Commerce Customer Analytics: RFM Segmentation & Churn Dashboard

An end-to-end data analytics project that takes raw online retail transactions (2009–2011), cleans them in **SQL Server**, segments customers with **RFM analysis in Python**, and presents the findings in an interactive **Power BI** dashboard.

## 🎯 Business Questions
- How is revenue trending over time and across countries?
- Who are our best customers, and who is slipping away?
- What share of customers has churned, and which segments do they belong to?
- Which segments generate the most revenue and the highest average customer value?

## 🧰 Tech Stack
| Stage | Tool |
|---|---|
| Data cleaning & combining | SQL Server (T-SQL) |
| Segmentation & feature engineering | Python (pandas) in Jupyter |
| Visualisation | Power BI |

## 🔄 Project Workflow
```
Raw data (2 yearly sheets)
        │
        ▼
 SQL Server  ──►  combine years, safe type conversion, quality checks, de-duplication
        │
        ▼
 Python      ──►  RFM scoring, customer segments, churn flag
        │
        ▼
 Power BI    ──►  3-page interactive dashboard
```

### 1️⃣ SQL: Data Cleaning (`SQLQuery5.sql`)
- Combined the 2009–2010 and 2010–2011 tables with `UNION ALL` and added a `sourcesheet` column.
- Converted dates and prices safely with `TRY_CONVERT`, handling multiple date formats via `COALESCE`.
- Ran data quality checks: failed date/price conversions, missing customer IDs, negative or zero quantities, missing descriptions, exact duplicates.
- Removed exact duplicate rows with `ROW_NUMBER()` and saved the result as `retailcleaned`.

### 2️⃣ Python: RFM Segmentation (`rfm_segmentation.ipynb`)
- Kept only valid transactions (known customer ID, quantity > 0).
- Calculated per customer, using a snapshot date of **2011-12-10**:
  - **Recency**: days since last purchase
  - **Frequency**: number of unique invoices
  - **Monetary**: total spend (quantity × price)
- Scored each metric from 1 to 5 using quintiles (`qcut`).
- Assigned segments with rule-based logic: **Champions, Loyal, At Risk, New, Needs Attention, Lost**.
- Flagged **churned** customers (no purchase in the last 90 days).
- Merged the results back into the transaction data and exported it for Power BI.

### 3️⃣ Power BI: Dashboard (`ikea_dashboards.pbix`)
| Page | What it shows |
|---|---|
| **Revenue** | Total revenue, average customer value, churn rate, total customers, revenue trend by month, revenue by segment, churned vs. active split |
| **Customer** | Customer count trends over time, customers by segment and churn status |
| **RFM Analysis** | Churn rate over time, average customer value by segment, R/F/M score matrix with customers and revenue |

Filters: country, month, churn status.

## 📊 Key Insights
> *(Replace with your real findings)*
- [X]% of customers are classified as churned.
- Champions make up [X]% of customers but generate [X]% of revenue.
- Revenue peaks in [month], suggesting seasonality.
- [Country] is the largest market after the UK.

## 💡 Recommendations
- Run win-back campaigns for **At Risk** customers before they become Lost.
- Reward **Champions** with loyalty perks and early access.
- Nurture **New** customers with a second-purchase offer.

## 📁 Repository Structure
```
├── sql/
│   └── SQLQuery5.sql
├── notebooks/
│   └── rfm_segmentation.ipynb
├── dashboard/
│   └── ikea_dashboards.pbix
├── images/
│   └── dashboard_preview.png
└── README.md
```

## ▶️ How to Reproduce
1. Import the two yearly retail sheets into SQL Server and run `SQLQuery5.sql`.
2. Export `retailcleaned` to `retail.csv`.
3. Run `rfm_segmentation.ipynb` to generate `ecommercedashboarddata.xlsx`.
4. Open the `.pbix` in Power BI Desktop and refresh the data source path.


