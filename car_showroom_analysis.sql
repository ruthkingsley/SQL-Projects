-- An analysis of a car showroom
-- Q1. What are the details of all cars purchased in the year 2022?
SELECT cars.car_id,
		make,
        type,
        style,
        purchase_date
FROM cars
INNER JOIN sales
ON cars.car_id = sales.car_id
WHERE EXTRACT(YEAR FROM sales.purchase_date) = 2022;

-- Q2. What is the total number of cars sold by each salesperson?
SELECT s.name salesman,
		COUNT(sales.car_id) num_of_cars_sold
FROM cars c
INNER JOIN sales
USING (car_id)
INNER JOIN salespersons s
USING (salesman_id)
GROUP BY s.name
ORDER BY num_of_cars_sold DESC;

-- Q3. What is the total revenue generated by each salesperson?
SELECT s.name salesman,
		SUM(cost_$) revenue
FROM cars c
INNER JOIN sales
USING (car_id)
INNER JOIN salespersons s
USING(salesman_id)
GROUP BY s.name
ORDER BY revenue DESC;

-- Q4. What are the details of the cars sold by each salesperson?
SELECT 	s.name salesman,
		c.car_id,
		make,
        type,
        style,
        cost_$
FROM cars c
INNER JOIN sales
ON c.car_id = sales.car_id
INNER JOIN salespersons s
ON sales.salesman_id = s.salesman_id
GROUP BY salesman, c.car_id
ORDER BY salesman;

-- Q5. What is the total revenue generated by each car type?
SELECT c.type car_type,
		SUM(cost_$) revenue
FROM cars c
INNER JOIN sales
ON c.car_id = sales.car_id
GROUP BY car_type
ORDER BY revenue DESC;

-- Q6. What are the details of the cars sold in the year 2021 by salesperson 'Emily ----Wong'?
SELECT 	s.name salesman,
		c.car_id,
		make,
        type,
        style,
        cost_$,
        EXTRACT(YEAR FROM purchase_date) AS year
FROM cars c
INNER JOIN sales
ON c.car_id = sales.car_id
INNER JOIN salespersons s
ON sales.salesman_id = s.salesman_id
WHERE EXTRACT(year FROM purchase_date)= 2021
AND s.name = 'Emily Wong';

-- Q7. What is the total revenue generated by the sales of hatchback cars?
SELECT SUM(cost_$) total_revenue
FROM cars c
INNER JOIN sales
ON c.car_id = sales.car_id
WHERE make =
(SELECT make
FROM cars
WHERE style = 'Hatchback');

-- Q8. What is the total revenue generated by the sales of SUV cars in the year 2022?
SELECT 	style,
		SUM(cost_$) total_revenue
FROM cars c
INNER JOIN sales
ON c.car_id = sales.car_id
WHERE style = 'SUV'
AND EXTRACT(YEAR FROM purchase_date) = 2022
GROUP BY style;

-- Q9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?
SELECT name,
		city,
        COUNT(sales.car_id) no_of_cars_sold
FROM sales
INNER JOIN salespersons s
ON sales.salesman_id = s.salesman_id
WHERE EXTRACT(year FROM purchase_date) = 2023
GROUP BY name, city
ORDER BY COUNT(sales.car_id) DESC
LIMIT 1;

-- Q10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?
SELECT name,
		age,
		SUM(c.cost_$) AS total_revenue
FROM salespersons
INNER JOIN sales s
USING(salesman_id)
INNER JOIN cars c
USING(car_id)
WHERE EXTRACT(year FROM purchase_date) = 2022
GROUP BY name, age
HAVING SUM(c.cost_$) = (
  	SELECT MAX(total_revenue)
    FROM (
      	SELECT name,
				SUM(c.cost_$) AS total_revenue
		FROM salespersons
		INNER JOIN sales s
		USING(salesman_id)
		INNER JOIN cars c
		USING(car_id)
		WHERE EXTRACT(year FROM purchase_date) = 2022
		GROUP BY salespersons.name) AS revenue_table
         );
