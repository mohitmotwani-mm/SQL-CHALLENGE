USE STEVE_CAR

CREATE TABLE cars (
car_id INT PRIMARY KEY,
make VARCHAR(50),
type VARCHAR(50),
style VARCHAR(50),
cost_$ INT
);

INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000),
(2, 'Toyota', 'Corolla', 'Hatchback', 25000),
(3, 'Ford', 'Explorer', 'SUV', 40000),
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
(5, 'BMW', 'X5', 'SUV', 55000),
(6, 'Audi', 'A4', 'Sedan', 48000),
(7, 'Mercedes', 'C-Class', 'Coupe', 60000),
(8, 'Nissan', 'Altima', 'Sedan', 26000);
--------------------
CREATE TABLE salespersons (
salesman_id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
city VARCHAR(50)
);
--------------------
INSERT INTO salespersons (salesman_id, name, age, city)
VALUES (1, 'John Smith', 28, 'New York'),
(2, 'Emily Wong', 35, 'San Fran'),
(3, 'Tom Lee', 42, 'Seattle'),
(4, 'Lucy Chen', 31, 'LA');
--------------------
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
car_id INT,
salesman_id INT,
purchase_date DATE,
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);
--------------------
INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date)
VALUES (1, 1, 1, '2021-01-01'),
(2, 3, 3, '2021-02-03'),
(3, 2, 2, '2021-02-10'),
(4, 5, 4, '2021-03-01'),
(5, 8, 1, '2021-04-02'),
(6, 2, 1, '2021-05-05'),
(7, 4, 2, '2021-06-07'),
(8, 5, 3, '2021-07-09'),
(9, 2, 4, '2022-01-01'),
(10, 1, 3, '2022-02-03'),
(11, 8, 2, '2022-02-10'),
(12, 7, 2, '2022-03-01'),
(13, 5, 3, '2022-04-02'),
(14, 3, 1, '2022-05-05'),
(15, 5, 4, '2022-06-07'),
(16, 1, 2, '2022-07-09'),
(17, 2, 3, '2023-01-01'),
(18, 6, 3, '2023-02-03'),
(19, 7, 1, '2023-02-10'),
(20, 4, 4, '2023-03-01');

SELECT * FROM cars
SELECT * FROM salespersons
SELECT * FROM sales

/*		 
Q1. What are the details of all cars purchased in the year 2022? 
Q2. What is the total number of cars sold by each salesperson?
Q3. What is the total revenue generated by each salesperson?
Q4. What are the details of the cars sold by each salesperson?
Q5. What is the total revenue generated by each car type?
Q6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?
Q7. What is the total revenue generated by the sales of hatchback cars?
Q8. What is the total revenue generated by the sales of SUV cars in the year 2022?
Q9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?
Q10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?
*/


--What are the details of all cars purchased in the year 2022? 

SELECT CARS.* FROM CARS JOIN sales ON
cars.car_id = sales.CAR_id
WHERE YEAR(SALES.purchase_date) = 2022;


--What is the total number of cars sold by each salesperson
SELECT salespersons.NAME,COUNT(SALES.SALESMAN_ID) AS "NUMBER OF SALES"  FROM sales JOIN salespersons
ON SALES.salesman_id = salespersons.salesman_id
GROUP BY salespersons.name;

 --What is the total revenue generated by each salesperson?
 SELECT ss.name, sum(c.COST_$) as 'revenue' FROM CARS C JOIN sales S 
 ON C.car_id = S.car_id 
 JOIN salespersons SS 
 ON SS.salesman_id = S.salesman_id
 GROUP BY SS.name

  --What are the details of the cars sold by each salesperson?

 SELECT ss.name as 'sales person' , c.make, c.style  from  CARS C JOIN sales S 
 ON C.car_id = S.car_id 
 JOIN salespersons SS 
  ON SS.salesman_id = S.salesman_id;

 
 
 --What is the total revenue generated by each car type?

 select type, sum(cost_$) as 'total revenue' from cars
 group by type;



-- What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?

 SELECT ss.name, c.make, c.type ,c.style , c.cost_$ from  CARS C JOIN sales S 
 ON C.car_id = S.car_id 
 JOIN salespersons SS 
  ON SS.salesman_id = S.salesman_id
  where ss.name like 'Emily Wong';


-- What is the total revenue generated by the sales of hatchback cars?
select style, sum(cost_$) as 'revenue' from cars
where style = 'Hatchback'
group by style;


--What is the total revenue generated by the sales of SUV cars in the year 2022?
select style, sum(cost_$) as 'revenue' from cars
where style = 'SUV'
group by style;

--What is the name and city of the salesperson who sold the most number of cars in the year 2023?

SELECT SS.NAME , SS.CITY FROM salespersons SS JOIN sales S
ON SS.salesman_id = S.salesman_id
group by ss.name , ss.city
having COUNT(S.SALESMAN_ID) = (select max(sales_count) 
from ( select count(salesman_id) as 'sales_count' 
from sales group by salesman_id) 
as subquery
);


--What is the name and age of the salesperson who generated the highest revenue in the year 2022?
 SELECT top 1 ss.name, ss.age, sum(c.COST_$) as 'revenue' FROM CARS C JOIN sales S 
 ON C.car_id = S.car_id 
 JOIN salespersons SS 
 ON SS.salesman_id = S.salesman_id
 group by ss.name , ss.age
 order by revenue desc;



