-- REFERENCE ONLY. Do not paste all queries into one APEX region.
-- Each SELECT belongs to its own report or chart region, WITHOUT a trailing semicolon.
-- PAGE 2 Orders interactive report (read-only view; separate form based on SP_ORDERS)
SELECT order_id,order_date,customer_name,order_status,payment_method,units,order_total
FROM sp_order_summary ORDER BY order_date DESC
;
-- PAGE 3 Products: report from joined SQL; edit via Form on SP_PRODUCTS
SELECT p.product_id,p.sku,p.product_name,c.category_name,p.unit_price,p.stock_qty,p.is_active
FROM sp_products p JOIN sp_categories c ON c.category_id=p.category_id ORDER BY p.product_name
;
-- PAGE 4 Categories: interactive report / form on SP_CATEGORIES
SELECT category_id,category_name FROM sp_categories ORDER BY category_name
;
-- PAGE 5 Customers: interactive report / form on SP_CUSTOMERS
SELECT customer_id,customer_name,email,city,joined_on FROM sp_customers ORDER BY customer_name
;
-- PAGE 6 Chart A: monthly paid revenue (LABEL = MONTH, VALUE = REVENUE)
SELECT TO_CHAR(TRUNC(order_date,'MM'),'YYYY-MM') AS month,SUM(order_total) AS revenue
FROM sp_order_summary WHERE order_status='PAID'
GROUP BY TRUNC(order_date,'MM') ORDER BY month
;
-- PAGE 6 Chart B: paid revenue by category (LABEL = CATEGORY_NAME, VALUE = REVENUE)
SELECT category_name,revenue FROM sp_sales_by_category ORDER BY revenue DESC
;
-- PAGE 6 Report C: top-selling products (paid orders only)
SELECT p.product_name,SUM(i.quantity) AS units_sold,SUM(i.quantity*i.unit_price) AS revenue
FROM sp_order_items i JOIN sp_products p ON p.product_id=i.product_id
JOIN sp_orders o ON o.order_id=i.order_id
WHERE o.order_status='PAID' GROUP BY p.product_name ORDER BY revenue DESC
;
-- PAGE 7 Inventory
SELECT product_id,sku,product_name,stock_qty,unit_price,
CASE WHEN stock_qty<15 THEN 'YES' ELSE 'NO' END AS low_stock
FROM sp_products ORDER BY stock_qty
;
-- OPTIONAL: daily order counts by status, stacked bar chart
SELECT TO_CHAR(TRUNC(order_date),'DD Mon') AS day_label,order_status,COUNT(*) AS order_count
FROM sp_orders WHERE order_date>=TRUNC(SYSDATE)-30
GROUP BY TRUNC(order_date),order_status ORDER BY TRUNC(order_date)
;
