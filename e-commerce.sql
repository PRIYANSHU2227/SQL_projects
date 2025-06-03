create database E_Commerce_database;
use E_Commerce_database;
create table users(
	user_id int primary key,
	name varchar(100),
	email varchar(100),
	signup_date date);
create table categories(
	category_id int primary key,
	category_name varchar(100));
create table products(
	product_id int primary key,
	product_name varchar(100),
	category_id int,
	price decimal(10,2),
	foreign key (category_id) references categories(category_id));
create table orders(
	order_id int primary key,
	user_id int,
	order_date date,
	foreign key (user_id) references users(user_id));
create table payments(
	payment_id int primary key,
	order_id int,
	amount decimal(10,2),
	payment_date date,
	foreign key (order_id) references orders(order_id));
create table order_items(
	item_id int primary key,
	order_id int,
	product_id int,
	quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id));

INSERT INTO users VALUES(1, 'Ravi Kumar', 'ravi@example.com', '2024-01-05'),(2, 'Priya Singh', 'priya@example.com', '2024-02-14'),(3, 'Aman Joshi', 'aman@example.com', '2024-03-21'),(4, 'Simran Kaur', 'simran@example.com', '2024-01-19'),(5, 'Neha Verma', 'neha@example.com', '2024-04-10'),(6, 'Rohit Sharma', 'rohit@example.com', '2024-02-28'),(7, 'Karan Mehta', 'karan@example.com', '2024-01-25'),(8, 'Tanya Yadav', 'tanya@example.com', '2024-03-03'),  (9, 'Alok Rathi', 'alok@example.com', '2024-04-01'),(10, 'Sneha Patil', 'sneha@example.com', '2024-03-11');
INSERT INTO categories VALUES(1, 'Electronics'),(2, 'Clothing'),(3, 'Books'),(4, 'Home & Kitchen'),(5, 'Beauty'),(6, 'Toys'),(7, 'Sports'),(8, 'Automotive'),(9, 'Grocery'),(10, 'Health');
INSERT INTO products VALUES(201, 'Smartphone', 1, 499.99),(202, 'T-Shirt', 2, 299.50),(203, 'Novel', 3, 150.00),(204, 'Blender', 4, 899.00),(205, 'Face Cream', 5, 120.75),(206, 'Action Figure', 6, 349.99),(207, 'Football', 7, 99.99),(208, 'Car Vacuum', 8, 499.00),(209, 'Rice Pack', 9, 799.25),(210, 'Vitamins', 10, 249.75);
INSERT INTO orders VALUES(101, 1, '2024-01-10'),(102, 2, '2024-01-15'),(103, 3, '2024-02-01'),(104, 4, '2024-02-10'),(105, 5, '2024-02-18'),(106, 6, '2024-02-20'),(107, 7, '2024-03-01'),(108, 8, '2024-03-11'),(109, 9, '2024-03-21'),(110, 10, '2024-04-05');
INSERT INTO payments VALUES(501, 101, 1299.48, '2024-01-10'),(502, 102, 450.00, '2024-01-15'),(503, 103, 899.00, '2024-02-01'),(504, 104, 241.50, '2024-02-10'),(505, 105, 349.99, '2024-02-18'),(506, 106, 499.95, '2024-02-20'),(507, 107, 998.00, '2024-03-01'),(508, 108, 799.25, '2024-03-11'),(509, 109, 999.00, '2024-03-21'),(510, 110, 1200.00, '2024-04-05');
INSERT INTO order_items VALUES(1, 101, 201, 2),(2, 101, 202, 1),(3, 102, 203, 3),(4, 103, 204, 1),(5, 104, 205, 2),(6, 105, 206, 1),(7, 106, 207, 5),(8, 107, 208, 2),(9, 108, 209, 1),(10, 109, 210, 4);

## first - (Top 5 Products by Quantity Sold) ->
SELECT
	p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM
	order_items AS oi
JOIN
	products AS p ON oi.product_id = p.product_id
GROUP BY
	p.product_id, p.product_name
ORDER BY
	total_quantity_sold DESC
LIMIT 5;
## second - (Users with Highest Spending) ->
SELECT
	u.user_id,
    u.name,
    SUM(p.amount) AS total_spending
FROM 
	users AS u 
JOIN
	orders AS o on u.user_id = o.user_id
JOIN
	payments AS p ON o.order_id = p.order_id
GROUP BY 
	u.user_id
ORDER BY
	total_spending DESC
LIMIT 5;
## third - (Daily Revenue) ->
SELECT 
	-- p.payment_date,  ## use for Payment Received Daily Revenue
    o.order_date,       ## use for Sales Based Daily Revenue
    SUM(p.amount) as daily_revenue
FROM
	orders AS o
JOIN
	payments AS p ON o.order_id = p.order_id
GROUP BY
	-- p.payment_date;
    o.order_date;
## fourth - (Returning vs New Customers) ->
SELECT
	SUM(CASE WHEN count_total > 1 THEN 1 ELSE 0 END) AS returning_customers,
    SUM(CASE WHEN count_total = 1 THEN 1 ELSE 0 END) AS new_customers
FROM
	(SELECT 
	u.name,
	COUNT(o.order_id) AS count_total
FROM
	users AS u
JOIN
	orders AS o ON u.user_id = o.user_id
GROUP BY
	u.user_id
) AS order_counts;    
## fifth - (Use Window Functions) ->
----### 5(a)->(RANK() or ROW_NUMBER() to rank users by spending) ->
SELECT
	RANK() OVER(ORDER BY SUM(p.amount) DESC) AS ranks,
	u.user_id,
    u.name,
    SUM(p.amount) as total_spending
FROM
	users AS u
JOIN
	orders AS o ON u.user_id = o.user_id
JOIN 
	payments AS p ON o.order_id = p.order_id
GROUP BY
	u.user_id,
    u.name
ORDER BY
    total_spending DESC;
----### 5(b)->(RANK() to rank products by sales)->
SELECT 
	RANK() OVER(ORDER BY SUM(oi.quantity)DESC) AS ranks,
	p.product_name,
    p.product_id,
	SUM(oi.quantity) AS total_sales
FROM
	order_items AS oi
JOIN
	products AS p on oi.product_id = p.product_id
GROUP BY
	p.product_id
ORDER BY 
	total_sales DESC;