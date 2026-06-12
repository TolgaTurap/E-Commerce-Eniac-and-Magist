USE magist;

-- 1. Frage How many orders are there in the dataset?

SELECT 
    COUNT(*) AS Anzahl_Bestellungen
FROM
    orders;


-- 2. Frage Are orders actually delivered?

SELECT 
    order_status, COUNT(*) AS Anzahl_Bestellungen_Status
FROM
    orders
GROUP BY order_status;


-- 3. Frage Is Magist having user growth?

SELECT 
    YEAR(order_purchase_timestamp) AS Jahr,
    MONTH(order_purchase_timestamp) AS Monat,
    COUNT(customer_id) AS Anzahl_Bestellungen
FROM
    orders
GROUP BY YEAR(order_purchase_timestamp) , MONTH(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp) DESC , MONTH(order_purchase_timestamp) DESC;



-- Übersicht
SELECT  YEAR(order_purchase_timestamp), COUNT(*)
FROM orders
GROUP BY YEAR(order_purchase_timestamp);


-- 4. Frage How many products are there on the products table?

SELECT 
    COUNT(DISTINCT product_id) AS Gesamtanzahl
FROM
    products;



-- 5. Frage Which are the categories with the most products?

SELECT 
    product_category_name, COUNT(*) AS Anzahl
FROM
    products
GROUP BY product_category_name
ORDER BY Anzahl DESC
LIMIT 3;

SELECT
    t.product_category_name_english AS product_category_name,
    COUNT(p.product_id) AS product_count
FROM
    products p
    LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY
    p.product_category_name,
    t.product_category_name_english
ORDER BY product_count DESC
LIMIT 10;



-- 6. Frage How many of those products were present in actual transactions?

SELECT 
    COUNT(DISTINCT(product_id)) AS Produkte, COUNT(DISTINCT(order_id)) AS Bestellungen
FROM
    products
        LEFT JOIN
    order_items USING (product_id);


-- Anzahl Produkte
SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;



-- 7.Frage What’s the price for the most expensive and cheapest products? 

SELECT 
    MIN(price) AS billigste, 
    MAX(price) AS teuerste
FROM 
	order_items;




/* 8. Frage What are the highest and lowest payment values? 
      Some orders contain multiple products. 
	  What’s the highest someone has paid for an order? */

-- höchster und niedrigster Preis 
SELECT 
    MAX(payment_value) AS Maximum_Bezahlt,
    MIN(payment_value) AS Minimum_Bezahlt
FROM
    order_payments;

-- Teuerste Bestellung (mit mehreren Produkten in einer Bestellung)
SELECT 
    order_id AS Bestellnummer,
    ROUND(SUM(payment_value), 2) AS Teuerste_Bestellung
FROM
    order_payments
GROUP BY order_id
ORDER BY Teuerste_Bestellung DESC
LIMIT 1;


