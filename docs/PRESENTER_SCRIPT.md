# 40-minute presenter speaking notes

**Opening:** “Today we will go from a database table to a multi-page Oracle APEX sales application. You will see a custom dashboard, live SQL data, interactive reports, charts, and forms.”

**Architecture:** “The browser sends a request through ORDS to APEX, which reads and writes Oracle Database objects. APEX creates much of the application UI for us.”

**Schema:** “Tables hold categories, customers, products, orders and order items. Foreign keys connect them. A view is a reusable SELECT, such as order totals.”

**Sample data:** “The script inserts fictional data and generates 120 orders. The PL/SQL `FOR` loop saves us from typing each order. SQL Commands executes one statement or block; SQL Scripts handles full scripts.”

**Dashboard:** “Page 1 uses HTML for layout, CSS for appearance, JavaScript for rendering, and a PL/SQL Ajax Callback to return live JSON from Oracle. Click Refresh and watch KPIs update.”

**Navigation:** “The sidebar is the built-in APEX Navigation Menu, styled with CSS. We deliberately do not create a second HTML navigation because it would not automatically link to the native report pages.”

**Reports:** “Interactive Reports let users filter, sort, group and download records. We create each report with one SQL query, not all queries in a single editor.”

**Charts:** “A line chart shows monthly paid revenue; a donut chart shows revenue by category. Each chart is powered by a SQL SELECT.”

**Forms:** “APEX generates forms on tables, but we still need validations, authorization and safe data processing.”

**Public vs developer:** “Application users can be authenticated or public where appropriate; developers need workspace privileges. APEX export plus SQL scripts makes sharing reproducible.”

**Licensing:** “APEX itself has no separate per-user or per-app licence fee with Oracle Database; database/hosting/AI services may cost extra. The free hosted APEX service is for learning, not production.”

**GitHub:** “The README explains the exact steps, SQL scripts build the data model, static assets define the design, and a future APEX export will let others import the finished application.”

**Close:** “The core lesson is that Oracle APEX lets us build useful data-centric web apps quickly, while still allowing SQL, PL/SQL, HTML, CSS and JavaScript when we want deeper customization.”
