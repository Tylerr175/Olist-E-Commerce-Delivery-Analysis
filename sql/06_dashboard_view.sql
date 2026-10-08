-- 06_dashboard_view.sql
-- Flat table that feeds the Tableau dashboard.
-- One row per delivered order (96,470 rows).
-- Depends on: delivery_performance (04), avg_reviews (04)

-- Indexes: speed up the joins below
CREATE INDEX IF NOT EXISTS idx_orders_order_id ON orders(order_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_customers_customer_id ON customers(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_reviews_order_id ON order_reviews(order_id);

-- View: delivery status + state + review score in one place
DROP VIEW IF EXISTS dashboard_data;

CREATE VIEW dashboard_data AS
SELECT
    d.order_id,
    d.order_purchase_timestamp,
    d.order_delivered_carrier_date,
    d.order_delivered_customer_date,
    d.days_diff,
    d.delivery_status,
    c.customer_state,
    c.customer_unique_id,
    a.avg_review_score
FROM delivery_performance d
JOIN customers c ON d.customer_id = c.customer_id
LEFT JOIN avg_reviews a ON d.order_id = a.order_id;