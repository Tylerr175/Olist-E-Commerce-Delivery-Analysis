
Total orders: 99441
Total orders with a delivery date: 96476
Total orders missing a delivery date: 2,965
Breakdown: shipped (1,107), unavailable (609), canceled (619), invoiced (314), processing (301), delivered (8), created (5), approved (2)
Most are expected, unfinished orders have no delivery date
8 orders marked "delivered" with no delivery date, likely data-entry error
Decision: filter to order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL

Customer IDs: 99441
Unique Customer IDs: 96096
Repeat rate very low at 3.48%
Decision: use reviews as primary cost measure, retention as secondary with caveats

768 orders have no reviews
646 of those are delivered 
Less than 1% of delivered orders, unlikely to bias results
Decision: exclude from review analysis, include in delivery-rate calculations

Some orders have 2-3 reviews with different scores
Decision: average the scores per order_id

1,392 delivered orders have products with no category name.
Decision: Excluded from category analysis only