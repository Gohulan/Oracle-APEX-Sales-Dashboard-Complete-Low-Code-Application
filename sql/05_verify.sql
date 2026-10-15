-- Run each SELECT individually in SQL Workshop > SQL Commands.
SELECT 'SP_CATEGORIES' AS table_name,COUNT(*) AS row_count FROM sp_categories;
SELECT 'SP_CUSTOMERS' AS table_name,COUNT(*) AS row_count FROM sp_customers;
SELECT 'SP_PRODUCTS' AS table_name,COUNT(*) AS row_count FROM sp_products;
SELECT 'SP_ORDERS' AS table_name,COUNT(*) AS row_count FROM sp_orders;
SELECT 'SP_ORDER_ITEMS' AS table_name,COUNT(*) AS row_count FROM sp_order_items;
SELECT order_id,customer_name,order_status,order_total FROM sp_order_summary ORDER BY order_id FETCH FIRST 5 ROWS ONLY;
