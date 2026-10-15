# SalesPulse v2 — Oracle APEX, from zero to a polished multi-page app

## Architecture and decisions

**Use ONE navigation system:** Oracle APEX Universal Theme's native **Navigation Menu**. The previous prototype's buttons with `data-page` switched HTML sections inside one page, and were not connected to native APEX pages. In v2 the dashboard is **Page 1 only**, and all other pages are native APEX reports/forms. The custom CSS restyles the built-in sidebar consistently on every page. Do not paste the old standalone `index.html` into Page 1.

Browser → Oracle REST Data Services (ORDS) → APEX engine → Oracle Database tables/views. The `SP_DASHBOARD_JSON` Ajax Callback returns live database data to Page 1 JavaScript.

## 0. Files and purpose

- `sql/01_schema.sql` — tables, constraints, indexes and views.
- `sql/02_sample_data.sql` — synthetic 5 categories, 8 customers, 10 products, 120 orders, 240 line items. Run ONCE.
- `sql/03_reports.sql` — **reference file** of separate report/chart queries, NOT one query to paste wholesale.
- `sql/04_dashboard_ajax.sql` — PL/SQL callback. Paste only `DECLARE ... END;` into an Ajax Callback.
- `sql/05_verify.sql` — individually runnable validation SELECTs.
- `sql/00_reset_salespulse.sql` — destructive cleanup only when intentionally starting again.
- `web/apex_home_region.html` — Page 1 dashboard HTML only.
- `web/salespulse.css` — professional theme and APEX navigation styles.
- `web/salespulse.js` — Page 1 live dashboard rendering.
- `web/salespulse-logo.svg` — optional custom logo.

## 1. Create / access workspace

1. Open https://apex.oracle.com/ and sign in to your **existing** free workspace. The public free service is for learning/evaluation, not confidential production data.
2. Open **SQL Workshop → Object Browser** to inspect existing objects.
3. If starting fresh, first run `00_reset_salespulse.sql` **only if you accept permanent deletion of SalesPulse data**. Do not reset other workspace objects.
4. Go to **SQL Workshop → SQL Scripts → Upload**. Upload `01_schema.sql`, click **Run**, inspect Results.
5. Upload and run `02_sample_data.sql` ONCE using SQL Scripts. This script contains multiple SQL statements and a PL/SQL loop. `SQL Commands` is for one statement/block at a time; don't paste multiple SELECTs/INSERTs there.
6. Go to **SQL Workshop → SQL Commands**. Run each verification SELECT from `05_verify.sql` separately. Expect 5, 8, 10, 120, 240 rows.

**What are PL/SQL, `BEGIN`/`END`, `/` and semicolons?** SQL `SELECT` retrieves data; SQL `INSERT` stores data. PL/SQL groups statements and loops into a procedural block (`DECLARE` variables, `BEGIN` work, `END;` finish). The `;` terminates a statement. A standalone `/` on a new line is a script-client delimiter for a preceding PL/SQL block (used by SQL Scripts/SQL*Plus); do **not** paste `/` into APEX's PL/SQL process editor. `COMMIT` makes DML changes durable. `ORDER BY` sorts rows; `DESC` sorts descending. `FETCH FIRST 8 ROWS ONLY` limits the output. `LEVEL` is a pseudocolumn used with `CONNECT BY` to generate dates in our chart.

## 2. Create APEX application

1. **App Builder → Create → New Application**.
2. **Name:** `SalesPulse`. **Appearance:** Universal Theme (default). **Navigation:** Side Menu / Side Navigation (if wizard offers the choice). **Authentication:** APEX Accounts for the workshop; don't use No Authentication on editable business data.
3. Create application. APEX typically creates a **Home** page as Page 1.
4. In App Builder open Page 1, set **Name** `Dashboard` and **Title** `Dashboard`. Page Mode **Normal**; Page Template **Standard** (Universal Theme default); no dialog/drawer. Keep the normal header/navigation. Use **Content Body** display position.
5. **Create Region → Static Content** in Content Body. Region title `Sales Overview`; use a minimal/Blank with Attributes region template if available; set **Source → HTML Code** to contents of `web/apex_home_region.html`. Hide region heading via region template option if desired.
6. **Shared Components → Static Application Files → Upload** these three: `salespulse.css`, `salespulse.js`, `salespulse-logo.svg`.
7. Page Designer: select Page 1 (top of Rendering tree). **CSS → File URLs**: `#APP_FILES#salespulse.css`; **JavaScript → File URLs**: `#APP_FILES#salespulse.js`. For consistent CSS on all pages, set CSS File URLs at **Shared Components → User Interface Attributes → CSS** if available; otherwise add CSS URL to each page's CSS File URLs or use a common page template. Do NOT load the dashboard JS on every page unless it checks for Page 1 (ours does).
8. **Shared Components → Application Processes → Create → Ajax Callback**. Name `SP_DASHBOARD_JSON`, language PL/SQL, paste only the `DECLARE ... END;` block from `04_dashboard_ajax.sql`. Save. If your version instead exposes Ajax Callbacks in Page Designer, create it there with the same name on Page 1.
9. Run Page 1. The logged-in username comes from the APEX substitution `&APP_USER!HTML.`; it is not hardcoded. Click Refresh; KPI cards and charts come from the database. If the callback fails, inspect the browser console/network and APEX Debug.

### Native APEX logo

Go to **Shared Components → User Interface Attributes → Logo** (location may vary by APEX version). Set **Logo Type** to Image and **Logo URL** to `#APP_FILES#salespulse-logo.svg`; alternatively choose Text and enter `SalesPulse`. The logo is shown in the native APEX header; it does not need a second sidebar logo.

### What do Page Template / Region Template / Display Position / Page Mode / Scrolling mean?

- **Page Template (Standard):** the overall APEX page frame with header, navigation and content; use this for Page 1 and report pages.
- **Region Template (Blank with Attributes):** a container around the dashboard HTML, minimizing double borders/headers.
- **Display Position (Content Body):** where the region appears in the page layout. Do not place the dashboard in Breadcrumb Bar or Navigation Bar.
- **Page Mode (Normal):** a full page; **Modal Dialog** opens a popup, good for short edit forms; **Drawer** opens a side panel. Use Normal for reports/dashboard.
- **Scrolling:** whether content/page scrolls when larger than the viewport. Keep standard/default vertical page scrolling; the dashboard CSS uses horizontal overflow *only for tables* on small screens. Avoid fixed-height nested scroll areas unless specifically needed.
- **Template Options:** visual layout choices (region border, header visibility, stretch/full width); these are not database settings.

## 3. Create separate native pages (one SQL query per region)

App Builder → Create Page → Interactive Report. Source: **Local Database** → **SQL Query**. Paste ONLY the corresponding SELECT below, without a trailing semicolon. Choose **Normal** page mode. For the wizard's **Include Form Page** toggle: OFF when source is a joined query/view; create separate Forms based on base tables if editing is required.

| Page ID | Page Name | Data source | Editing |
|---|---|---|---|
| 2 | Orders | `SP_ORDER_SUMMARY` query from `03_reports.sql` | Separate Form on `SP_ORDERS` (header only) |
| 3 | Products | Joined product/category query | Separate Form on `SP_PRODUCTS` |
| 4 | Categories | `SP_CATEGORIES` table or query | Form on `SP_CATEGORIES` |
| 5 | Customers | `SP_CUSTOMERS` table or query | Form on `SP_CUSTOMERS` |
| 6 | Sales Reports | Blank **Standard** page; add 3 regions | Charts/report, read only |
| 7 | Inventory | Inventory query | Form on `SP_PRODUCTS` if needed |

APEX may allocate other page numbers if some are already taken. Check App Builder's page list and update your navigation targets accordingly.

### Page 6: Sales Reports — multiple regions

1. **Create Page → Blank Page**, name `Sales Reports`, Mode Normal, Template Standard.
2. Page Designer → Content Body → Create Region, type **Chart**; name `Monthly Revenue`; series source **SQL Query** (monthly revenue query from `03_reports.sql`). Choose **Line**, Label column `MONTH`, Value `REVENUE`.
3. Add second **Chart** region named `Category Breakdown`; chart type **Pie** or **Donut**; source category revenue query; Label `CATEGORY_NAME`, Value `REVENUE`.
4. Add third region **Interactive Report** named `Top Products`; source top products SELECT from `03_reports.sql`.
5. Optional fourth chart: stacked Bar by day/status, with Series column `ORDER_STATUS`, Label `DAY_LABEL`, Value `ORDER_COUNT` (check chart series configuration for your APEX version).
6. Interactive Reports: demonstrate search, column sort, Actions → Filter, Actions → Download CSV. Set Inventory highlight: `LOW_STOCK = YES` via Actions → Format → Highlight.

### Form editing and security

A joined report/view isn't automatically writable. Use **Create Page → Form → Form on a Table** selecting the base table and primary key (`PRODUCT_ID`, `CUSTOMER_ID`, `CATEGORY_ID`, or `ORDER_ID`). Set link from report to form if needed. Orders header editing does not edit child `SP_ORDER_ITEMS`; use master-detail pages for order lines. Use authorization/validations for real deployments.

## 4. Native navigation — no duplicates

**Shared Components → Navigation Menu** (or Lists → Navigation Menu). Edit entries: Dashboard → Page 1, Orders → Page 2, Products → Page 3, Categories → Page 4, Customers → Page 5, Sales Reports → Page 6, Inventory → Page 7. Use the APEX target picker **Page in this Application**, not manual JavaScript buttons. Native navigation is shared across pages and uses APEX session/security handling. The CSS makes it look polished; do **not** hide `.t-Body-nav` or `.t-TreeNav`.

## 5. APEX debugging

- Blank dashboard: check that Static Content HTML is pasted, CSS/JS URLs are uploaded and `SP_DASHBOARD_JSON` is named correctly.
- `ORA-01788`: use the corrected Ajax code in `04_dashboard_ajax.sql`; `LEVEL` stays in its own date-generation inline view.
- `ORA-03405`: a report accepts **one** SELECT; the multi-query reference file must be split across regions.
- `ORA-00955`: schema already exists; don't run schema twice.
- Zero trend values: demo data are spread over 90 days; some recent dates may have zero sales. This is valid.
- Page numbering differs: use actual APEX page IDs in the native navigation menu.
- `APP_USER` displays workspace username when APEX Accounts authentication is used; use an application profile table if you want a friendly full name.

## 6. Presentation: 40 minutes

0–4 min: problem, low-code, architecture. 4–10: create schema and insert sample data (preload a backup). 10–16: create APEX application and Page 1. 16–22: upload CSS/JS, show Ajax KPI refresh. 22–29: native Orders/Products reports, sorting, filtering. 29–34: charts (Line + Donut), low stock. 34–37: form editing and security. 37–40: Github sharing, licence clarification, Q&A.

## 7. GitHub upload, manual workflow (no terminal needed)

1. Sign in to https://github.com, click **New repository**. Name `salespulse-oracle-apex-workshop`; choose Public only after reviewing files for secrets; initialize empty or with README.
2. Extract the ZIP. In GitHub repository choose **Add file → Upload files** and upload the contents/folders (GitHub web upload may require dragging a folder; if not, use GitHub Desktop).
3. Include `README.md`, `docs/`, `sql/`, `web/`, `LICENSE` and `checksums.sha256`. **Never upload workspace passwords, API keys, real customer data, connection strings, or session IDs.**
4. Commit message: `Initial SalesPulse APEX workshop v2`.
5. For future updates, use a feature branch via GitHub's branch dropdown, upload modified files, commit, open a Pull Request and merge after review.
6. Release: repository → **Releases → Draft a new release** → tag `v2.0.0` → title `SalesPulse APEX Workshop v2.0.0` → notes: `Native APEX navigation, live dashboard Ajax, reports, charts, sample schema, setup guide`.
7. When the app is complete, export it: App Builder → SalesPulse → **Export / Import → Export**. Save exported application SQL as `apex/application_export.sql` (only after actually exporting; not included in this ZIP). An APEX export is version/environment-dependent and still needs schema/data scripts and appropriate configuration. Upload this exported file to GitHub for a reproducible app import.
8. Share your GitHub repository URL with attendees. On slide: `github.com/YOUR-USERNAME/salespulse-oracle-apex-workshop` (replace placeholder).

## 8. MD5, SHA-256 and Markdown

- `README.md` is a **Markdown** file (not MD5). It documents setup and usage.
- **MD5** is an older file checksum algorithm; it can detect accidental changes but is unsuitable for security/integrity assurances against tampering.
- `checksums.sha256` in this package lists **SHA-256** file digests. To verify on Windows PowerShell: `Get-FileHash .\web\salespulse.css -Algorithm SHA256`. Hashes change whenever files change. This is optional and unrelated to APEX authentication.

## 9. Important limits

This package contains the actual source files and instructions, but is **not an importable APEX application export**; the application export can only be produced after building the app in APEX. The standalone legacy `web/index.html` remains as a separate offline prototype, not the APEX Page 1 source. Database sample data are synthetic. Production needs authorization, data protection, backups, error logging and validation.
