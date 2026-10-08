-- What percentage of orders are late? Result: 6.77%
SELECT
ROUND(100.0 * COUNT(CASE WHEN delivery_status = 'late' THEN 1 END) / COUNT(*), 2) AS late_percentage
FROM delivery_performance;

-- On average, how many days late are orders? Result: 10.62 days
SELECT
ROUND(AVG(CASE WHEN delivery_status = 'late' THEN days_diff ELSE 0 END), 2) AS avg_late_days
FROM delivery_performance;

-- What is the average late order percentage by month? Result: Late orders spiked in late 2017 and early 2018.
SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month_ordered,
ROUND(100.0 * COUNT(CASE WHEN delivery_status = 'late' THEN 1 END) / COUNT(*), 2) AS late_percentage
FROM delivery_performance
GROUP BY month_ordered
ORDER BY month_ordered;
