SELECT 
	online_customer.customer_id,
    CONCAT(Customer_fname, customer_lname) AS customer_name,
    customer_email,
    order_header.order_id,
    product_desc,
    product_quantity,
    (product_quantity*product_price) AS subtotal
FROM
	online_customer 
LEFT JOIN 
	order_header on online_customer.customer_id = order_header.customer_id
LEFT JOIN 
	order_items on order_header.order_id = order_items.order_id
LEFT JOIN 
	product on order_items.product_id = product.product_id
;

	