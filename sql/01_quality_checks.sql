-- Total orders and delivery date coverage
SELECT 
    COUNT(*) AS total_orders,
    COUNT(order_delivered_customer_date) AS has_delivery_date,
    COUNT(order_estimated_delivery_date) AS has_estimate
FROM orders;

-- What statuses have missing delivery dates?
SELECT order_status, COUNT(*) 
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status;

-- Are all orders from unique customers?
SELECT COUNT(*), COUNT(DISTINCT customer_unique_id)
FROM customers;

-- How many orders don't have a review?
SELECT COUNT(*)
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM order_reviews);

-- Of the order that don't have a review, how many were delivered?
SELECT order_status, COUNT(*)
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM order_reviews)
GROUP BY order_status;

-- Are there any orders that say they were delivered before they were purchased?
SELECT COUNT(*) AS delivery_count
FROM orders
WHERE order_purchase_timestamp > order_delivered_customer_date;

-- How many orders have 1, 2, or 3 reviews?
SELECT review_count, COUNT(*) AS num_orders
FROM (
    SELECT order_id, COUNT(*) AS review_count
    FROM order_reviews
    GROUP BY order_id
) AS review_counts
GROUP BY review_count
ORDER BY review_count;