SELECT 
	online_customer.customer_id,
    CONCAT(customer_fname, customer_lname) AS customer_full_name,
    city,
    pincode,
    order_header.order_id,
    order_date,
    product_class.product_class_desc,
    product_desc,
    product_quantity * product_price AS Subtotal
FROM
    online_customer
		JOIN
    address ON online_customer.address_id = address.address_id
		JOIN 
	order_header on online_customer.customer_id=order_header.customer_id
		JOIN
	order_items on order_header.order_id = order_items.order_id
		JOIN
	product on order_items.product_id = product.product_id
		LEFT JOIN
	product_class on product.product_class_code = product_class.product_class_code
WHERE
	order_status = "Shipped" AND pincode NOT LIKE "%0%"
ORDER BY
	customer_full_name asc ,Subtotal asc, order_date
;
