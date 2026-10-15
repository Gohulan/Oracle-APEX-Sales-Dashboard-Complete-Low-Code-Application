-- Execute after 01_schema.sql. Re-running duplicates sample orders; run only once.
INSERT INTO sp_categories(category_name) VALUES ('Electronics');
INSERT INTO sp_categories(category_name) VALUES ('Accessories');
INSERT INTO sp_categories(category_name) VALUES ('Home & Living');
INSERT INTO sp_categories(category_name) VALUES ('Fashion');
INSERT INTO sp_categories(category_name) VALUES ('Stationery');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Ayesha Perera','ayesha@example.test','Colombo');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Nimal Fernando','nimal@example.test','Kandy');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Tharushi Silva','tharushi@example.test','Galle');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Kavindu Jayasinghe','kavindu@example.test','Negombo');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Fathima Rizwan','fathima@example.test','Colombo');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Dinuka Weerasinghe','dinuka@example.test','Matara');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Ishara De Silva','ishara@example.test','Jaffna');
INSERT INTO sp_customers(customer_name,email,city) VALUES ('Ruwan Dias','ruwan@example.test','Kurunegala');
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (1,'Wireless Headphones','EL-101',12900,45);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (1,'Bluetooth Speaker','EL-102',8900,28);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (2,'Laptop Sleeve','AC-201',3500,75);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (2,'Travel Backpack','AC-202',7900,32);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (3,'Desk Lamp','HM-301',4900,19);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (3,'Ceramic Mug','HM-302',1600,85);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (4,'Cotton T-Shirt','FA-401',2900,64);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (4,'Canvas Cap','FA-402',2100,9);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (5,'Premium Notebook','ST-501',1100,130);
INSERT INTO sp_products(category_id,product_name,sku,unit_price,stock_qty) VALUES (5,'Pen Set','ST-502',850,7);
DECLARE
  v_order_id NUMBER;
  v_customer NUMBER;
  v_product NUMBER;
  v_price NUMBER;
  v_status VARCHAR2(20);
BEGIN
  FOR n IN 1..120 LOOP
    v_customer := MOD(n-1,8)+1;
    v_status := CASE WHEN MOD(n,13)=0 THEN 'CANCELLED' WHEN MOD(n,7)=0 THEN 'PENDING' WHEN MOD(n,19)=0 THEN 'REFUNDED' ELSE 'PAID' END;
    INSERT INTO sp_orders(customer_id,order_date,order_status,payment_method)
    VALUES(v_customer,TRUNC(SYSDATE)-MOD(n*3,90)+MOD(n,12)/24,v_status,CASE WHEN MOD(n,2)=0 THEN 'Card' ELSE 'Cash' END)
    RETURNING order_id INTO v_order_id;
    FOR j IN 1..MOD(n,3)+1 LOOP
      v_product := MOD(n*7+j*3,10)+1;
      SELECT unit_price INTO v_price FROM sp_products WHERE product_id=v_product;
      INSERT INTO sp_order_items(order_id,product_id,quantity,unit_price)
      VALUES(v_order_id,v_product,MOD(n+j,4)+1,v_price);
    END LOOP;
  END LOOP;
END;
/
COMMIT;
