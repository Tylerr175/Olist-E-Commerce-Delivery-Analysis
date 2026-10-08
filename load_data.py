import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql://postgres@localhost:5432/olist")

orders = pd.read_csv("data/olist_orders_dataset.csv", parse_dates=[
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
])
orders.to_sql("orders", engine, if_exists="replace", index=False)

print("Orders loaded")

customers = pd.read_csv("data/olist_customers_dataset.csv")
customers.to_sql("customers", engine, if_exists="replace", index=False)

print("Customers loaded")

order_items = pd.read_csv("data/olist_order_items_dataset.csv", parse_dates=[
    "shipping_limit_date"
])
order_items.to_sql("order_items", engine, if_exists="replace", index=False)

print("Order items loaded")

geolocation = pd.read_csv("data/olist_geolocation_dataset.csv")
geolocation.to_sql("geolocation", engine, if_exists="replace", index=False)

print("Geolocation loaded")

order_payments = pd.read_csv("data/olist_order_payments_dataset.csv")
order_payments.to_sql("order_payments", engine, if_exists="replace", index=False)

print("Order payments loaded")

order_reviews = pd.read_csv("data/olist_order_reviews_dataset.csv", parse_dates=[
    "review_creation_date",
    "review_answer_timestamp"
])
order_reviews.to_sql("order_reviews", engine, if_exists="replace", index=False)

print("Order reviews loaded")

products = pd.read_csv("data/olist_products_dataset.csv")
products.to_sql("products", engine, if_exists="replace", index=False)

print("Products loaded")   

sellers = pd.read_csv("data/olist_sellers_dataset.csv")
sellers.to_sql("sellers", engine, if_exists="replace", index=False)

print("Sellers loaded")   

category_translation = pd.read_csv("data/product_category_name_translation.csv")
category_translation.to_sql("category_translation", engine, if_exists="replace", index=False)

print("Category translation loaded")   