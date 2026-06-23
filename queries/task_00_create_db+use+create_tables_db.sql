/* ============================================================
   FitFuel v1 — SQL EDA Project
   Database & Table Creation Script
   Tool: MS SQL Server (SSMS)
   Run this BEFORE any BULK INSERT.
   Tables are created in foreign-key dependency order:
   date_dim -> channels -> customers -> products -> orders
   ============================================================ */

CREATE DATABASE FitFuelDB;
GO

USE FitFuelDB;
GO

/* ------------------------------------------------------------
   1. date_dim — Calendar lookup table (no foreign keys)
   ------------------------------------------------------------ */
CREATE TABLE date_dim (
    date_key      DATE         PRIMARY KEY,
    year          INT          NOT NULL,
    month_num     INT          NOT NULL,
    month_name    VARCHAR(20)  NOT NULL,
    quarter       VARCHAR(5)   NOT NULL,
    is_weekend    BIT          NOT NULL
);
GO

/* ------------------------------------------------------------
   2. channels — Sales channel lookup (no foreign keys)
   ------------------------------------------------------------ */
CREATE TABLE channels (
    channel_id    VARCHAR(10)  PRIMARY KEY,
    channel_name  VARCHAR(50)  NOT NULL,
    channel_type  VARCHAR(20)  NOT NULL
);
GO

/* ------------------------------------------------------------
   3. customers — Customer profile dimension (no foreign keys)
   ------------------------------------------------------------ */
CREATE TABLE customers (
    customer_id   VARCHAR(20)  PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    city          VARCHAR(50)  NOT NULL,
    region        VARCHAR(20)  NOT NULL,
    segment       VARCHAR(20)  NOT NULL,
    signup_date   DATE         NOT NULL
);
GO

/* ------------------------------------------------------------
   4. products — Supplement catalogue dimension (no foreign keys)
   ------------------------------------------------------------ */
CREATE TABLE products (
    product_id    VARCHAR(20)   PRIMARY KEY,
    product_name  VARCHAR(100)  NOT NULL,
    category      VARCHAR(50)   NOT NULL,
    flavour       VARCHAR(50)   NULL,
    size_kg       DECIMAL(4,2)  NOT NULL,
    base_price    DECIMAL(8,2)  NOT NULL,
    is_active     BIT           NOT NULL
);
GO

/* ------------------------------------------------------------
   5. orders — Fact table (FKs to customers, products, channels)
      Loaded LAST — depends on all four tables above.
   ------------------------------------------------------------ */
CREATE TABLE orders (
    order_id       VARCHAR(20)    PRIMARY KEY,
    customer_id    VARCHAR(20)    NOT NULL,
    product_id     VARCHAR(20)    NOT NULL,
    channel_id     VARCHAR(10)    NOT NULL,
    order_date     DATE           NOT NULL,
    quantity       INT            NOT NULL,
    unit_price     DECIMAL(8,2)   NOT NULL,
    total_amount   DECIMAL(10,2)  NOT NULL,
    order_status   VARCHAR(20)    NOT NULL,
    delivery_date  DATE           NULL,        -- NULL for pending / cancelled orders

    CONSTRAINT FK_orders_customers
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT FK_orders_products
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT FK_orders_channels
        FOREIGN KEY (channel_id) REFERENCES channels(channel_id)
);
GO

/* ------------------------------------------------------------
   Sanity check — run after BULK INSERT to confirm row counts
   ------------------------------------------------------------ */
-- SELECT COUNT(*) AS date_dim_rows  FROM date_dim;
-- SELECT COUNT(*) AS channels_rows  FROM channels;
-- SELECT COUNT(*) AS customers_rows FROM customers;
-- SELECT COUNT(*) AS products_rows  FROM products;
-- SELECT COUNT(*) AS orders_rows    FROM orders;