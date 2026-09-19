DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data(
 order_id VARCHAR(50),
 order_date DATE,
 customer_id VARCHAR(50),
 product_category VARCHAR(100),
 region VARCHAR(50),
 quantity INT,
 unit_price DECIMAL(10,2),
 discount DECIMAL(10,2),
 payment_method VARCHAR(40),
 delivery_days INT,
 customer_rating DECIMAL(10,1),
 revenue DECIMAL(10,2)
);
SELECT * FROM sales_data LIMIT 5;

SELECT 
    product_category,
	SUM(revenue) AS total_revenue,
	SUM(quantity) AS total_unit_sold,
	COUNT(DISTINCT order_id)
FROM sales_data
GROUP BY product_category
ORDER BY total_revenue DESC;


WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date)::DATE AS sales_month,
        SUM(quantity * unit_price) AS current_month_revenue
    FROM sales_data
    GROUP BY 1
)
SELECT 
    sales_month,
    current_month_revenue,
    LAG(current_month_revenue, 1) OVER (ORDER BY sales_month) AS previous_month_revenue,
    ROUND(
        ((current_month_revenue - LAG(current_month_revenue, 1) OVER (ORDER BY sales_month)) 
        / NULLIF(LAG(current_month_revenue, 1) OVER (ORDER BY sales_month), 0)) * 100, 2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY sales_month ASC;


WITH customer_rfm AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(quantity * unit_price) AS total_spent
    FROM sales_data
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT 
        customer_id,
        NTILE(4) OVER (ORDER BY last_order_date ASC) AS r_score,
        NTILE(4) OVER (ORDER BY total_orders ASC) AS f_score,
        NTILE(4) OVER (ORDER BY total_spent ASC) AS m_score
    FROM customer_rfm
)
SELECT 
    customer_id,
    CASE 
        WHEN r_score = 4 AND f_score >= 3 THEN 'VIP Customer'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At-Risk (High Value)'
        WHEN r_score = 1 THEN 'Lost Customer'
        ELSE 'Regular Customer'
    END AS customer_segment
FROM rfm_scores;