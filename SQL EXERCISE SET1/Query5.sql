SELECT
	product.product_id,
	product_desc,
    sum(product_quantity) AS totalquantity
FROM
	product JOIN order_items ON product.product_id = order_items.product_id
WHERE 
	product.product_id = 201 
;