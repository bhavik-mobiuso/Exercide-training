SELECT
	online_customer.customer_id,
    CONCAT(customer_fname, customer_lname) AS customer_fullname,
    order_header.order_id,
    sum(product_quantity) AS total_quantity
FROM
	online_customer 
    JOIN order_header ON online_customer.customer_id = order_header.customer_id
	JOIN order_items ON order_header.order_id = order_items.order_id
WHERE 
	order_header.order_status = "Shipped" 
GROUP BY 
	order_header.order_id
HAVING sum(product_quantity) > 10
;