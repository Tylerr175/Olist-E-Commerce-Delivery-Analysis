-- Flag orders that are late in delivery
CREATE VIEW delivery_performance AS
SELECT order_id,
    customer_id,
    order_purchase_timestamp,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    (order_delivered_customer_date::DATE - order_estimated_delivery_date::DATE) AS days_diff,
    CASE 
        WHEN (order_delivered_customer_date::DATE - order_estimated_delivery_date::DATE) > 0 
        THEN 'late'
        ELSE 'on_time' 
    END AS delivery_status
FROM orders
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL;