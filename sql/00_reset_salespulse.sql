-- DANGER: deletes SalesPulse data permanently. Backup first. Run in SQL Commands.
-- Drops ONLY named SalesPulse objects, not the APEX workspace or other applications.
BEGIN
 FOR r IN (SELECT view_name FROM user_views WHERE view_name IN
   ('SP_ORDER_SUMMARY','SP_SALES_DAILY','SP_SALES_BY_CATEGORY')) LOOP
   EXECUTE IMMEDIATE 'DROP VIEW "'||r.view_name||'"';
 END LOOP;
 FOR r IN (SELECT table_name FROM user_tables WHERE table_name IN
   ('SP_ORDER_ITEMS','SP_ORDERS','SP_PRODUCTS','SP_CUSTOMERS','SP_CATEGORIES')) LOOP
   EXECUTE IMMEDIATE 'DROP TABLE "'||r.table_name||'" CASCADE CONSTRAINTS PURGE';
 END LOOP;
END;
