-- USE Funktion

USE magist;


-- -- -- Fragen -- -- -- 

-- -- 2.1 In relation to the products: -- -- 

-- What categories of tech products does Magist have? -- 

SELECT DISTINCT
    product_category_name_english
FROM
    product_category_name_translation
        LEFT JOIN
    products USING (product_category_name)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image');


/* How many products of these tech categories have been sold 
(within the time window of the database snapshot)? */

-- Kategorien mit Anzahl
SELECT 
    product_category_name_english,
    COUNT(DISTINCT (product_id)) AS Anzahl
FROM
    products
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
        LEFT JOIN
    orders USING (order_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image')
GROUP BY product_category_name_english
ORDER BY Anzahl DESC;


-- Direkt Anzahl
SELECT 
    COUNT(DISTINCT (product_id)) AS Anzahl
FROM
    products
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
        LEFT JOIN
    orders USING (order_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image');
-- Anzahl 3390


-- What percentage does that represent from the overall number of products sold? 

-- > Anzahl Technische Produkte: 3390 vorhin bestimmt 

SELECT 
    COUNT(DISTINCT(product_id)) AS Anzahl_Bestellungen
FROM
    order_items;
-- > Anzahl Bestellungen: 32951

-- > Prozentuales Verhältnis:
SELECT ROUND((3390 / 32951 * 100), 2) AS Wert_in_Prozent;
-- > 10,29%


-- > Prozentuales Verhältnis mit alles als eine Query
SELECT 
    product_category_name_english,
    COUNT(DISTINCT (product_id)) AS Anzahl_Tech_Produkte,
    (SELECT 
            COUNT(DISTINCT (product_id))
        FROM
            order_items) AS Gesamte_Anzahl,
    ROUND((COUNT(DISTINCT (product_id)) / (SELECT 
                    COUNT(DISTINCT (product_id))
                FROM
                    order_items) * 100),
            2) AS Prozentuales_Verhältnis
FROM
    products
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
        LEFT JOIN
    orders AS o USING (order_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image')
GROUP BY product_category_name_english
ORDER BY Anzahl_Tech_Produkte DESC;



-- What’s the average price of the products being sold? -- 

SELECT 
    ROUND(AVG(price), 2) AS Durchschnittlicher_Preis
FROM
    order_items
        LEFT JOIN
    products USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
        LEFT JOIN
    orders AS o USING (order_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image');



-- Are expensive tech products popular? -- 

SELECT COUNT(*) AS Anzahl,
	CASE 
		WHEN oi.price > 106.25 THEN 'Expensive'
        ELSE 'Cheap'
	END AS Kategorien_Preis
FROM
    products AS p
        LEFT JOIN
    order_items AS oi USING (product_id)
    LEFT JOIN product_category_name_translation AS pn USING(product_category_name)
WHERE
    pn.product_category_name_english IN ('audio',
        'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image')
GROUP BY Kategorien_Preis;
-- > Billige technische Produkte sind beliebter 




-- -- 2.2. In relation to the sellers: -- -- 

-- How many months of data are included in the magist database? -- 


-- Monate bestimmt Differenz von Min und Max Bestell Zeitraum
SELECT 
    TIMESTAMPDIFF(MONTH,
        (MIN(order_purchase_timestamp)),
        (MAX(order_purchase_timestamp))) AS Monate_Min_und_Max_Bestell_Zeitraum
FROM
    orders;
-- 25 Monate 


-- -- How many sellers are there? -- --
SELECT 
    COUNT(DISTINCT (seller_id))
FROM
    sellers;
-- > 3095 Verkäufer Allgemein


-- -- How many Tech sellers are there? -- --
SELECT 
    COUNT(DISTINCT seller_id) AS Anzahl_Tech_Sellers
FROM
    product_category_name_translation
        LEFT JOIN
    products USING (product_category_name)
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    sellers USING (seller_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image');
-- > 454 Verkäufer von Technischen Produkten


-- -- What percentage of overall sellers are Tech sellers? -- -- 
 
 SELECT ROUND(454 / 3095 * 100, 2);
 -- > 14.67% Tech Sellers

-- ALlgemeiner Code:
SELECT 
    COUNT(DISTINCT seller_id) AS Anzahl_Tech_Sellers,
    (SELECT 
            COUNT(DISTINCT seller_id)
        FROM
            sellers) AS Anzahl_alle_Sellers,
    (SELECT 
            ROUND(COUNT(DISTINCT seller_id) / (SELECT 
                                COUNT(DISTINCT seller_id)
                            FROM
                                sellers),
                        2) * 100
        ) AS Anzahl_techsellers_von_gesamtensellers_prozent
FROM
    product_category_name_translation
        LEFT JOIN
    products USING (product_category_name)
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    sellers USING (seller_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image');



-- What is the total amount earned by all sellers? -- 
SELECT 
    ROUND(SUM(price), 2)
FROM
    order_items
        LEFT JOIN
    orders o USING (order_id)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled'); 
-- 13494400.74


-- What is the total amount earned by all Tech sellers? -- 
SELECT 
    ROUND(SUM(price), 2)
FROM
    product_category_name_translation
        LEFT JOIN
    products USING (product_category_name)
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    sellers USING (seller_id)
        LEFT JOIN
    orders USING (order_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image')
        AND order_status NOT IN ('unavailable' , 'canceled');
 -- Geld was Tech Sellers durch Verkauf generieren 1666211.29



-- Can you work out the average monthly income of all sellers? -- 

SELECT 
    ROUND((SELECT 
                    (SUM(price))
                FROM
                    order_items
                        LEFT JOIN
                    orders o USING (order_id)
                WHERE
                    o.order_status NOT IN ('unavailable' , 'canceled')) / 25 / 3095,
            2) AS Durchschnittliches_Einkommen_alle_Sellers; 
-- 174.4



-- Can you work out the average monthly income of Tech sellers? -- 

SELECT 
    ROUND(SUM(price) / 25 / 454, 2) AS Durchschnittliches_Einkommen_Tech_Sellers
FROM
    product_category_name_translation
        LEFT JOIN
    products USING (product_category_name)
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    sellers USING (seller_id)
        LEFT JOIN
    orders USING (order_id)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'telephony',
        'tablets_printing_image')
        AND order_status NOT IN ('unavailable' , 'canceled');
-- 146.8





-- -- -- 2.3. In relation to the delivery time: -- -- -- 


/* What’s the average time between the order being placed 
and the product being delivered? */

-- Ohne GROUP BY
SELECT 
    AVG((DATEDIFF(order_delivered_customer_date,
            order_purchase_timestamp))) AS Tage_Differenz
FROM
    orders;   
 -- 12,5 Tage   
    
    
-- Mit GROUP BY    
SELECT 
    (AVG(Tage_Differenz))
FROM
    (SELECT 
        order_purchase_timestamp,
            order_delivered_customer_date,
            DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS Tage_Differenz
    FROM
        orders
    GROUP BY order_id) AS Tabelle_mit_Tage_Differenz;
-- 12,5 Tage


-- How many orders are delivered on time vs orders delivered with a delay? --

SELECT 
    COUNT(*) AS Bestellungen_Pünktlich
FROM
    orders
WHERE
    DATEDIFF(order_estimated_delivery_date,
            order_delivered_customer_date) >= 0
        AND order_status = 'delivered'
        AND order_estimated_delivery_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL;
-- 89805 pünktliche Bestellungen 



SELECT 
    COUNT(*) AS Bestellungen_Pünktlich
FROM
    orders
WHERE
    DATEDIFF(order_estimated_delivery_date,
            order_delivered_customer_date) < 0
        AND order_status = 'delivered'
        AND order_estimated_delivery_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL;
-- 6665 verspätete BEstellungen 
                
        
 
-- Gesamte Tabelle:  
SELECT 
    COUNT(*),
    CASE
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) > 0
        THEN
            'pünktlich'
        ELSE 'verspätet'
    END AS Tage_Kategorien
FROM
    orders
WHERE
    order_status = 'delivered'
        AND order_estimated_delivery_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL
GROUP BY Tage_Kategorien;     
   
    
    
/* Is there any pattern for delayed orders, 
 e.g. big products being delayed more often?  */  

-- Nur Kategorien und Pünktlichkeit    
SELECT DISTINCT
    product_category_name_english,
    CASE
        WHEN order_estimated_delivery_date >= order_delivered_customer_date THEN 'pünktlich'
        ELSE 'verspätet'
    END AS Tage_Kategorien
FROM
    orders
        LEFT JOIN
    order_items USING (order_id)
        LEFT JOIN
    products USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    order_delivered_customer_date IS NOT NULL;


-- Nur Summe Preis und Pünktlichkeit 
SELECT DISTINCT
    ROUND(SUM(price), 2) AS Preis_Summe_alle_Produkte,
    CASE
        WHEN order_estimated_delivery_date >= order_delivered_customer_date THEN 'pünktlich'
        ELSE 'verspätet'
    END AS Tage_Kategorien
FROM
    orders
        LEFT JOIN
    order_items USING (order_id)
        LEFT JOIN
    products USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    order_delivered_customer_date IS NOT NULL
GROUP BY Tage_Kategorien;   



-- Gewicht (Gesamte Lösung)
SELECT 
    AVG(product_weight_g) AS Durchschnittliches_Gewicht,
    MIN(product_weight_g) AS Min_Produkt_Gewicht,
    MAX(product_weight_g) AS Max_Produkt_Gewicht,
    SUM(product_weight_g) AS Summe_Produkt_Gewicht,
    COUNT(DISTINCT (order_id)) AS Anzahl_Bestellungen,
    CASE
        WHEN
            DATEDIFF(order_estimated_delivery_date,
                    order_delivered_customer_date) > 10
        THEN
            'sehr pünktlich'
        WHEN
            DATEDIFF(order_estimated_delivery_date,
                    order_delivered_customer_date) > 3
        THEN
            'pünktlich'
        WHEN
            DATEDIFF(order_estimated_delivery_date,
                    order_delivered_customer_date) >= 0
        THEN
            'knapp pünktlich'
        WHEN
            DATEDIFF(order_estimated_delivery_date,
                    order_delivered_customer_date) < - 20
        THEN
            'sehr spät'
        ELSE 'spät'
    END AS Kategorien_Pünktlichkeit
FROM
    products
        LEFT JOIN
    order_items USING (product_id)
        LEFT JOIN
    orders USING (order_id)
WHERE
    order_estimated_delivery_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL
        AND order_status = 'delivered'
GROUP BY Kategorien_Pünktlichkeit
ORDER BY AVG(product_weight_g);

    

