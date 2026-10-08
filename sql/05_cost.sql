-- Create view to handle orders with multiple reviews by averaging scores
CREATE VIEW avg_reviews AS
SELECT order_id, ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_reviews
GROUP BY order_id;

-- What is the average review score for late orders and for on-time orders?
-- Results: Late orders have a significantly lower average review score compared to on-time with late having 2.27 and on time having 4.29.
SELECT 
    d.delivery_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(a.avg_review_score), 2) AS avg_review
FROM delivery_performance d
JOIN avg_reviews a ON d.order_id = a.order_id
GROUP BY d.delivery_status;

-- What is the average review score for different ranges of delivery times (early, on-time, 1-7 days late, 8+ days late)?
-- Results: Early: 4.29, On-Time: 4.04, 1-7 Days Late: 2.72, 8+ Days Late: 1.70.
-- It appears that the longer the delivery time, even if it is already late, the lower the review score.
SELECT 
CASE
    WHEN days_diff < 0 THEN 'early'
    WHEN days_diff = 0 THEN 'on_time'
    WHEN days_diff > 0 AND days_diff <= 7 THEN '1-7_days_late'
    ELSE '8+_days_late'
END AS late_scale,
COUNT(*) AS total_reviews,
ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM delivery_performance d
JOIN avg_reviews a ON a.order_id = d.order_id
GROUP BY late_scale
ORDER BY avg_review_score DESC;

-- What is the 1 star review percentage for late and on-time orders?
-- Results: Late orders have a 1 star review percentage of 53.69%, while on-time orders only have a 1 star review percentage of 6.58%.
SELECT 
    d.delivery_status,
    COUNT(*) AS total_orders,
    ROUND(100.0 * COUNT(CASE WHEN a.avg_review_score = 1 THEN 1 END) / COUNT(*), 2) AS one_star_pct
FROM delivery_performance d
JOIN avg_reviews a ON a.order_id = d.order_id
GROUP BY d.delivery_status;

-- Do states with the highest late rates also have the worst review scores?
-- Results: On average, as late percentage goes down, review score goes up
SELECT 
    c.customer_state,
    COUNT(*) AS total_orders,
    ROUND(100.0 * COUNT(CASE WHEN d.delivery_status = 'late' THEN 1 END) / COUNT(*), 2) AS late_percentage,
    ROUND(AVG(a.avg_review_score), 2) AS avg_review_score
FROM delivery_performance d
JOIN avg_reviews a ON d.order_id = a.order_id
JOIN customers c ON d.customer_id = c.customer_id
GROUP BY c.customer_state
HAVING COUNT(*) >= 50
ORDER BY late_percentage DESC;

-- When a customer's first order is late, does it affect its repeat rate?
-- Results: The repeat rate for late orders is 2.50% and for on-time orders it is 3.04%. Both percentages are too small to draw strong conclusions from.
WITH first_orders AS (
    SELECT 
        c.customer_unique_id,
        d.delivery_status,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id 
            ORDER BY d.order_purchase_timestamp
        ) AS rn
    FROM delivery_performance d
    JOIN customers c ON d.customer_id = c.customer_id
),
order_counts AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT d.order_id) AS total_orders
    FROM delivery_performance d
    JOIN customers c ON d.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT 
    f.delivery_status AS first_order_status,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN o.total_orders > 1 THEN 1 END) AS repeat_customers,
    ROUND(100.0 * COUNT(CASE WHEN o.total_orders > 1 THEN 1 END) / COUNT(*), 2) AS repeat_rate
FROM first_orders f
JOIN order_counts o ON f.customer_unique_id = o.customer_unique_id
WHERE f.rn = 1
GROUP BY f.delivery_status;