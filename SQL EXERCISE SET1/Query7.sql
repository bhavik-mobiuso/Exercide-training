SELECT 
	carton_id,
    (len*width*height) AS carton_volume
FROM
	carton
WHERE 
	(len*width*height) > ( select sum(len*width*height*product_quantity) from product join order_items on product.product_id = order_items.product_id WHERE order_id = 10006)
limit 1
;
