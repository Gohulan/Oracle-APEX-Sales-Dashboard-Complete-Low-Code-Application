# Oracle-APEX-Sales-Dashboard-Complete-Low-Code-Application
Oracle APEX hands-on project featuring a sales dashboard, interactive reports, charts, SQL, PL/SQL, JavaScript, CSS, and complete setup instructions for beginners.

A modern multi-page Oracle APEX sales analytics demonstration with **live Oracle Database KPIs**, interactive reports, line/donut charts, native APEX navigation, editable forms and a professional custom theme.

![Oracle APEX](https://img.shields.io/badge/Oracle-APEX-red) ![Workshop](https://img.shields.io/badge/Workshop-40%20minutes-6255ed)

## Quick start

1. Request/sign in to an APEX workspace at https://apex.oracle.com/.
2. SQL Workshop → SQL Scripts: run `sql/01_schema.sql` then `sql/02_sample_data.sql` **once**.
3. App Builder → Create New Application → `SalesPulse` → Universal Theme, Side Navigation, APEX Accounts authentication.
4. Make Page 1 `Dashboard` (Normal/Standard), add Static Content region from `web/apex_home_region.html`.
5. Upload `web/salespulse.css`, `web/salespulse.js`, `web/salespulse-logo.svg` to Static Application Files; reference them using `#APP_FILES#`.
6. Create Ajax Callback `SP_DASHBOARD_JSON` using `sql/04_dashboard_ajax.sql`.
7. Create Pages 2–7 and their report/chart regions from **individual** SELECTs in `sql/03_reports.sql`.
8. Use Shared Components → Navigation Menu for links to Pages 1–7; do **not** paste the old standalone HTML sidebar into APEX.

**Read the full click-by-click guide:** [`docs/APEX_ZERO_TO_HERO.md`](docs/APEX_ZERO_TO_HERO.md). Presenter notes: [`docs/PRESENTER_SCRIPT.md`](docs/PRESENTER_SCRIPT.md).

## Project files

```text
SalesPulse_APEX_Workshop_v2/
├── README.md
├── LICENSE
├── checksums.sha256
├── sql/
│   ├── 00_reset_salespulse.sql    # destructive, optional
│   ├── 01_schema.sql              # tables, views, indexes
│   ├── 02_sample_data.sql         # fictional seed data
│   ├── 03_reports.sql             # one query per region
│   ├── 04_dashboard_ajax.sql      # live JSON callback
│   └── 05_verify.sql             # test queries
├── web/
│   ├── apex_home_region.html      # APEX Page 1 region
│   ├── salespulse.css             # custom theme
│   ├── salespulse.js              # live dashboard
│   ├── salespulse-logo.svg        # custom logo
│   └── index.html                # LEGACY offline prototype only
└── docs/
    ├── APEX_ZERO_TO_HERO.md
    └── PRESENTER_SCRIPT.md
```

## Data model

`SP_CATEGORIES` → `SP_PRODUCTS` → `SP_ORDER_ITEMS` ← `SP_ORDERS` ← `SP_CUSTOMERS`.

Three reporting views: `SP_ORDER_SUMMARY`, `SP_SALES_DAILY`, `SP_SALES_BY_CATEGORY`.

## Requirements

Oracle APEX workspace with permission to create schema objects; Oracle Database supporting identity columns and `FETCH FIRST` (19c+ recommended); a modern browser. No third-party frontend CDN is required for the APEX dashboard.

## Security and licensing

Demo data are synthetic. Keep authentication enabled for editable pages; do not publish credentials, personal data, keys, or session tokens. Oracle APEX has no separate per-user or per-app fee, but Oracle Database/hosting/services may cost money. Oracle's free hosted service is intended for evaluation/learning.

## Application export (important)

This repository **does not yet include an actual APEX application export**. After building the app, use App Builder → Export to generate an APEX application SQL export, and add it as `apex/application_export.sql`. SQL schema/data scripts alone cannot recreate all APEX pages.

## GitHub release

Suggested repository name: `salespulse-oracle-apex-workshop`. Tag: `v2.0.0`. See the guide for manual GitHub upload and release steps.

## License

MIT License — see [`LICENSE`](LICENSE).
