SELECT 
	product_class_desc, 
    product_id, 
    product_desc, 
    product_quantity_avail,
CASE
WHEN product_class_desc IN ("Electronics","Computer") AND product_quantity_avail <= 10 THEN "LOW STOCK"
WHEN product_class_desc IN ("Electronics","Computer") AND PRODUCT_QUANTITY_AVAIL >= 11 AND PRODUCT_QUANTITY_AVAIL <= 30 THEN "IN STOCK"
WHEN product_class_desc IN ("Electronics","Computer") AND product_quantity_avail >= 31 THEN "ENOUGH STOCK"
WHEN product_class_desc IN ("Stationery","Clothes") AND product_quantity_avail <= 20 THEN "LOW STOCK"
WHEN product_class_desc IN ("Stationery","Clothes") AND PRODUCT_QUANTITY_AVAIL >= 21 AND PRODUCT_QUANTITY_AVAIL <= 81 THEN "IN STOCK"
WHEN product_class_desc IN ("Stationery","Clothes") AND product_quantity_avail >= 81 THEN "ENOUGH STOCK"
WHEN product_class_desc NOT IN ("Stationery","Clothes","Electronics","Computer") AND product_quantity_avail <= 15 THEN "LOW STOCK"
WHEN product_class_desc NOT IN ("Stationery","Clothes","Electronics","Computer") AND PRODUCT_QUANTITY_AVAIL >= 16 AND PRODUCT_QUANTITY_AVAIL <= 50 THEN "IN STOCK"
WHEN product_class_desc NOT IN ("Stationery","Clothes","Electronics","Computer") AND product_quantity_avail >= 51 THEN "ENOUGH STOCK"
END AS inventory_status
FROM 
	PRODUCT
JOIN
	product_class on product.product_class_code = product_class.product_class_code
;
    