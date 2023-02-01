SELECT
	country,
    product_class_desc,
    sum(product_quantity) AS total_value,
	(product_quantity * product_price) AS total_quantity
FROM
	address 
    JOIN online_customer ON address.address_id = online_customer.address_id
    JOIN order_header ON online_customer.customer_id = order_header.customer_id
    JOIN order_items ON order_header.order_id = order_items.order_id
    JOIN product ON order_items.product_id = product.product_id
    JOIN product_class ON product.product_class_code = product_class.product_class_code
WHERE 
	order_header.order_status = "Shipped" And country NOT IN ("India","USA")
GROUP BY
	order_header.order_id, product.product_id, product_class.product_class_code
order by
	count((product_quantity * product_price))desc limit 1;
