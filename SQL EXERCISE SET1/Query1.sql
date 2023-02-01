SELECT
	product_class_code,
    product_id,
    product_desc,
    product_price,
CASE 
	WHEN product_class_code = 2050 THEN product_price + 2000
	WHEN product_class_code = 2051 THEN product_price + 500
	WHEN product_class_code = 2052 THEN product_price + 600
    ELSE product_price = 0
END AS IncreasedValue
FROM
	product;