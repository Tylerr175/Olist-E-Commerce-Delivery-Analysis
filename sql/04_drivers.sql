-- Which sellers with 50+ orders have the worst delivery performance?
-- Results: No sellers with 50+ orders have particularly poor delivery performance compared to others.
SELECT 
    o.seller_id,
    COUNT(DISTINCT d.order_id) AS total_orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN d.delivery_status = 'late' THEN d.order_id END) / COUNT(DISTINCT d.order_id), 2) AS late_percentage
FROM delivery_performance d
JOIN order_items o ON d.order_id = o.order_id
GROUP BY o.seller_id
HAVING COUNT(DISTINCT d.order_id) >= 50
ORDER BY late_percentage DESC
LIMIT 15;

-- Which states have the highest late delivery rate?
-- Results: Northeastern states have significantly higher late delivery rates than others, ranging from around 15%-21%, while Southeastern states perform the best, ranging around 4-5% at its best.
SELECT 
    c.customer_state,
    COUNT(*) AS total_orders,
    ROUND(100.0 * COUNT(CASE WHEN d.delivery_status = 'late' THEN 1 END) / COUNT(*), 2) AS late_percentage
FROM delivery_performance d
JOIN customers c ON d.customer_id = c.customer_id
GROUP BY c.customer_state
HAVING COUNT(*) >= 50
ORDER BY late_percentage DESC;

-- Which product categories have the worst delivery performance?
-- Results: The products have minimal impact on late delivery rates, only maxing out at around 11% late delivery. Geography is a more significant factor.
SELECT 
    c.product_category_name_english,
    COUNT(DISTINCT d.order_id) AS total_orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN d.delivery_status = 'late' THEN d.order_id END) / COUNT(DISTINCT d.order_id), 2) AS late_percentage
FROM delivery_performance d
JOIN order_items o ON d.order_id = o.order_id
JOIN products p ON o.product_id = p.product_id
JOIN category_translation c ON p.product_category_name = c.product_category_name
GROUP BY c.product_category_name_english
HAVING COUNT(DISTINCT d.order_id) >= 50
ORDER BY late_percentage DESC
LIMIT 15;


-- Do heavier products have a higher likelihood of being delivered late?
-- Results: Heavier products also have a minimal impact on late delivery rates, only maxing out at around 7%.
SELECT 
    CASE 
        WHEN p.product_weight_g < 500 THEN 'under 500g'
        WHEN p.product_weight_g < 2000 THEN '500-2000g'
        WHEN p.product_weight_g < 5000 THEN '2000-5000g'
        ELSE 'over 5000g'
    END AS weight_bucket,
    COUNT(DISTINCT d.order_id) AS total_orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN d.delivery_status = 'late' THEN d.order_id END) / COUNT(DISTINCT d.order_id), 2) AS late_percentage
FROM delivery_performance d
JOIN order_items o ON d.order_id = o.order_id
JOIN products p ON o.product_id = p.product_id
GROUP BY weight_bucket
ORDER BY late_percentage DESC;

-- How many orders are in each seller state and which have the highest late percentages?
-- Results: São Paulo has the highest number of orders by far with 68635 orders out of 96857 total orders.
-- The highest late delivery rate seems to be due to long distance orders from the Southeast to the Northeast.
-- Maranhão has the highest late delivery rate by far from the sellers at around 19%, but has a small number of orders.
SELECT 
    s.seller_state,
    COUNT(DISTINCT d.order_id) AS total_orders,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN d.delivery_status = 'late' THEN d.order_id END) / COUNT(DISTINCT d.order_id), 2) AS late_percentage
FROM delivery_performance d
JOIN order_items o ON d.order_id = o.order_id
JOIN sellers s ON o.seller_id = s.seller_id
GROUP BY s.seller_state
HAVING COUNT(DISTINCT d.order_id) >= 50
ORDER BY late_percentage DESC;

-- Do seller processing days or carrier transit days affect late deliveries the most?
-- Results: Carrier transit days are significantly more impactful on late deliveries than seller processing days, with late carrier transit days being on average 3.5 times longer than on time carrier transit days.
SELECT 
    delivery_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_delivered_carrier_date::DATE - order_purchase_timestamp::DATE), 2) AS avg_seller_processing_days,
    ROUND(AVG(order_delivered_customer_date::DATE - order_delivered_carrier_date::DATE), 2) AS avg_carrier_transit_days
FROM delivery_performance
WHERE order_delivered_carrier_date IS NOT NULL
GROUP BY delivery_status;





