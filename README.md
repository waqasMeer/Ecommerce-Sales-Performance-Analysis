# 📊 E-Commerce Sales Performance & Analytics Dashboard

An end-to-end data analysis and interactive Power BI dashboard project designed to analyze e-commerce sales performance, customer ratings, regional distribution, and payment preferences.

---

## 🛠️ Tech Stack & Tools
- **Database:** PostgreSQL (v18)
- **Data Visualization:** Power BI Desktop (Import Mode)
- **Data Transformation:** Power Query & DAX
- **Version Control:** GitHub

---

## 🔑 Key Metrics & DAX Formulas
- **Total Revenue:** `$5.11M`
- **Total Orders:** `5K`
- **Average Order Value (AOV):** `$1.0K`
- **Avg Discount Rate:** `18.0%`

```dax
Total Revenue = SUM(sales_data[total_amount])
Total Orders = COUNT(sales_data[order_id])
AOV = [Total Revenue] / [Total Orders]
Avg Discount Rate = AVERAGE(sales_data[discount])
