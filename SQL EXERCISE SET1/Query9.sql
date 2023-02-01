SELECT
	order_header.order_id,
    order_header.customer_id,
    CONCAT(online_customer.customer_fname, online_customer.customer_lname) AS customer_fullname,
	sum(product_quantity) AS total_quantity 
FROM
	order_header
    JOIN online_customer ON order_header.customer_id = online_customer.customer_id
	JOIN order_items ON order_header.order_id = order_items.order_id
WHERE 
	order_status = "Shipped" AND order_header.order_id > 10060
GROUP BY 
	order_header.order_id
;
