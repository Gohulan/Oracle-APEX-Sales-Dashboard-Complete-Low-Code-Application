-- Paste ONLY DECLARE..END; into Shared Components > Application Processes > Ajax Callback.
-- Do not run this as a SQL Commands query; it writes an HTTP JSON response.
DECLARE
    l_sales NUMBER;
    l_orders NUMBER;
    l_units NUMBER;
    l_customers NUMBER;
BEGIN
    SELECT NVL(SUM(order_total),0), COUNT(*), NVL(SUM(units),0)
      INTO l_sales,l_orders,l_units
      FROM sp_order_summary WHERE order_status='PAID';
    SELECT COUNT(*) INTO l_customers FROM sp_customers;
    apex_json.open_object;
    apex_json.write('sales',l_sales);
    apex_json.write('orders',l_orders);
    apex_json.write('units',l_units);
    apex_json.write('customers',l_customers);
    apex_json.open_array('trend');
    FOR r IN (
        SELECT TO_CHAR(d.sales_date,'DD Mon') AS label, NVL(s.revenue,0) AS value
          FROM (SELECT TRUNC(SYSDATE)-LEVEL+1 AS sales_date FROM dual CONNECT BY LEVEL<=14) d
          LEFT JOIN sp_sales_daily s ON s.sales_date=d.sales_date
         ORDER BY d.sales_date
    ) LOOP
        apex_json.open_object;
        apex_json.write('label',r.label);
        apex_json.write('value',r.value);
        apex_json.close_object;
    END LOOP;
    apex_json.close_array;
    apex_json.open_array('categories');
    FOR r IN (SELECT category_name AS label,revenue AS value FROM sp_sales_by_category ORDER BY revenue DESC) LOOP
        apex_json.open_object;
        apex_json.write('label',r.label);
        apex_json.write('value',r.value);
        apex_json.close_object;
    END LOOP;
    apex_json.close_array;
    apex_json.open_array('recent');
    FOR r IN (
        SELECT order_id,customer_name,order_status,order_total,TO_CHAR(order_date,'DD Mon YYYY') AS order_date
          FROM sp_order_summary ORDER BY order_date DESC,order_id DESC FETCH FIRST 8 ROWS ONLY
    ) LOOP
        apex_json.open_object;
        apex_json.write('id',r.order_id);
        apex_json.write('customer',r.customer_name);
        apex_json.write('status',r.order_status);
        apex_json.write('total',r.order_total);
        apex_json.write('date',r.order_date);
        apex_json.close_object;
    END LOOP;
    apex_json.close_array;
    apex_json.close_object;
END;
