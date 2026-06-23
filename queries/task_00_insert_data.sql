/* ============================================================
   FitFuel v1 — SQL EDA Project
   Data Load Script (BULK INSERT)
   Tool: MS SQL Server (SSMS)

   Run schema.sql FIRST to create the database and tables.
   Place all 5 CSV files in C:\SQLProjectsData\FitFuel_v1(CSV''s)\ before running this.

   Load order = foreign-key dependency order:
   date_dim -> channels -> customers -> products -> orders
   ============================================================ */

USE FitFuelDB;
GO

/* ------------------------------------------------------------
   1. date_dim
   ------------------------------------------------------------ */
BULK INSERT date_dim
FROM 'C:\SQLProjectsData\FitFuel_v1(CSV''s)\date_dim.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

/* ------------------------------------------------------------
   2. channels
   ------------------------------------------------------------ */
BULK INSERT channels
FROM 'C:\SQLProjectsData\FitFuel_v1(CSV''s)\channels.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

/* ------------------------------------------------------------
   3. customers
   ------------------------------------------------------------ */
BULK INSERT customers
FROM 'C:\SQLProjectsData\FitFuel_v1(CSV''s)\customers.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

/* ------------------------------------------------------------
   4. products
   ------------------------------------------------------------ */
BULK INSERT products
FROM 'C:\SQLProjectsData\FitFuel_v1(CSV''s)\products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

/* ------------------------------------------------------------
   5. orders — loaded LAST, depends on customers/products/channels
   ------------------------------------------------------------ */
BULK INSERT orders
FROM 'C:\SQLProjectsData\FitFuel_v1(CSV''s)\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

/* ------------------------------------------------------------
   Sanity check — run immediately after loading (Task 1)
   ------------------------------------------------------------ */
SELECT COUNT(*) AS date_dim_rows  FROM date_dim;
SELECT COUNT(*) AS channels_rows  FROM channels;
SELECT COUNT(*) AS customers_rows FROM customers;
SELECT COUNT(*) AS products_rows  FROM products;
SELECT COUNT(*) AS orders_rows    FROM orders;

/* Expected results:
   date_dim_rows  ~1,095
   channels_rows  3
   customers_rows ~500
   products_rows  ~55
   orders_rows    ~4,000
*/