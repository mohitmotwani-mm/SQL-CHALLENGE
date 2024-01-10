use [Challenge Pub Pricing Analysis]

CREATE TABLE pubs (
pub_id INT PRIMARY KEY,
pub_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50)
);

CREATE TABLE beverages (
beverage_id INT PRIMARY KEY,
beverage_name VARCHAR(50),
category VARCHAR(50),
alcohol_content FLOAT,
price_per_unit DECIMAL(8, 2)
);

CREATE TABLE sales (
sale_id INT PRIMARY KEY,
pub_id INT,
beverage_id INT,
quantity INT,
transaction_date DATE,
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id),
FOREIGN KEY (beverage_id) REFERENCES beverages(beverage_id)
);
 CREATE TABLE ratings (
 rating_id INT PRIMARY KEY,
 pub_id INT, 
 customer_name VARCHAR(50), 
 rating FLOAT, 
 review TEXT, 
 FOREIGN KEY (pub_id) REFERENCES pubs(pub_id) );


INSERT INTO pubs (pub_id, pub_name, city, state, country)
VALUES
(1, 'The Red Lion', 'London', 'England', 'United Kingdom'),
(2, 'The Dubliner', 'Dublin', 'Dublin', 'Ireland'),
(3, 'The Cheers Bar', 'Boston', 'Massachusetts', 'United States'),
(4, 'La Cerveceria', 'Barcelona', 'Catalonia', 'Spain');

INSERT INTO beverages (beverage_id, beverage_name, category, alcohol_content, price_per_unit)
VALUES
(1, 'Guinness', 'Beer', 4.2, 5.99),
(2, 'Jameson', 'Whiskey', 40.0, 29.99),
(3, 'Mojito', 'Cocktail', 12.0, 8.99),
(4, 'Chardonnay', 'Wine', 13.5, 12.99),
(5, 'IPA', 'Beer', 6.8, 4.99),
(6, 'Tequila', 'Spirit', 38.0, 24.99);
--------------------
INSERT INTO sales (sale_id, pub_id, beverage_id, quantity, transaction_date)
VALUES
(1, 1, 1, 10, '2023-05-01'),
(2, 1, 2, 5, '2023-05-01'),
(3, 2, 1, 8, '2023-05-01'),
(4, 3, 3, 12, '2023-05-02'),
(5, 4, 4, 3, '2023-05-02'),
(6, 4, 6, 6, '2023-05-03'),
(7, 2, 3, 6, '2023-05-03'),
(8, 3, 1, 15, '2023-05-03'),
(9, 3, 4, 7, '2023-05-03'),
(10, 4, 1, 10, '2023-05-04'),
(11, 1, 3, 5, '2023-05-06'),
(12, 2, 2, 3, '2023-05-09'),
(13, 2, 5, 9, '2023-05-09'),
(14, 3, 6, 4, '2023-05-09'),
(15, 4, 3, 7, '2023-05-09'),
(16, 4, 4, 2, '2023-05-09'),
(17, 1, 4, 6, '2023-05-11'),
(18, 1, 6, 8, '2023-05-11'),
(19, 2, 1, 12, '2023-05-12'),
(20, 3, 5, 5, '2023-05-13');

INSERT INTO ratings (rating_id, pub_id, customer_name, rating, review)
VALUES
(1, 1, 'John Smith', 4.5, 'Great pub with a wide selection of beers.'),
(2, 1, 'Emma Johnson', 4.8, 'Excellent service and cozy atmosphere.'),
(3, 2, 'Michael Brown', 4.2, 'Authentic atmosphere and great beers.'),
(4, 3, 'Sophia Davis', 4.6, 'The cocktails were amazing! Will definitely come back.'),
(5, 4, 'Oliver Wilson', 4.9, 'The wine selection here is outstanding.'),
(6, 4, 'Isabella Moore', 4.3, 'Had a great time trying different spirits.'),
(7, 1, 'Sophia Davis', 4.7, 'Loved the pub food! Great ambiance.'),
(8, 2, 'Ethan Johnson', 4.5, 'A good place to hang out with friends.'),
(9, 2, 'Olivia Taylor', 4.1, 'The whiskey tasting experience was fantastic.'),
(10, 3, 'William Miller', 4.4, 'Friendly staff and live music on weekends.');

SELECT * FROM pubs
SELECT * FROM beverages
SELECT * FROM sales
SELECT * FROM ratings


/* QUESTIONS
1. How many pubs are located in each country??
2. What is the total sales amount for each pub, including the beverage price and quantity sold?
3. Which pub has the highest average rating?
4. What are the top 5 beverages by sales quantity across all pubs?
5. How many sales transactions occurred on each date?
6. Find the name of someone that had cocktails and which pub they had it in.
7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?
8. Which pubs have a rating higher than the average rating of all pubs?
9. What is the running total of sales amount for each pub, ordered by the transaction date?
10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?
11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount? */
 
--1. How many pubs are located in each country?

select country, count(*) as count_of_pub from pubs
group by country


-- 2. What is the total sales amount for each pub, including the beverage price and quantity sold? 

select pub_name, sum(s.quantity * b.price_per_unit) as total_sale from pubs as pb
join sales as s on pb.pub_id = s.pub_id
join beverages as b on s.beverage_id = b.beverage_id
group by pub_name
order by sum(s.quantity * b.price_per_unit) desc

-- 3. Which pub has the highest average rating? 

select top 1 pb.pub_name, round(avg(cast(r.rating as numeric)),1) as avg_rating from pubs as pb
join ratings as r on pb.pub_id = r.pub_id
group by pb.pub_name
order by round(avg(cast(r.rating as numeric)),1) desc



-- 4. What are the top 5 beverages by sales quantity across all pubs? 

select top 5 b.beverage_name,count(s.quantity) as sale_quantity from beverages as b
join sales as s on b.beverage_id = s.beverage_id
group by b.beverage_name
order by count(s.quantity) desc


-- 5. How many sales transactions occurred on each date? 

select transaction_date,count(*)as sales_count from sales
group by  transaction_date
order by transaction_date

-- 6. Find the name of someone that had cocktails and which pub they had it in? 

select r.customer_name,pb.pub_name,b.category from beverages as b
join sales as s on b.beverage_id = s.beverage_id
join pubs as pb on s.pub_id = pb.pub_id
join ratings as r on pb.pub_id = r.pub_id
where category = 'Cocktail'
group by r.customer_name,pb.pub_name,b.category

-- 7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'? 

select category, round(avg(price_per_unit),1) as avg_price
from beverages 
where category != 'Spirit'
group by category



-- 8. Which pubs have a rating higher than the average rating of all pubs? 

select pub_name,round(avg(cast(r.rating as numeric)),1)as avg_rating from pubs as pb
join ratings as r on pb.pub_id = r.pub_id
group by pub_name
having avg(r.rating) > (select round(avg(cast(rating as numeric)),1) from ratings)


-- 9. What is the running total of sales amount for each pub, ordered by the transaction date? 


with total as(
	select *,(s.quantity*b.price_per_unit) as sale from sales as s
	join beverages as b on s.beverage_id=b.beverage_id
) 

select p.pub_name,t.transaction_date,sum(t.sale)as total_amount  from total as t
join pubs as p on t.pub_id = p.pub_id
group by  p.pub_name,t.transaction_date
order by  t.transaction_date


--10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?



with avg_price as(
	select p.country,b.category,round(avg(b.price_per_unit),2)as avg_amount from pubs as p
	join sales as s on p.pub_id = s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by  p.country,b.category
),
total_avg_price as (
	select p.country,round(avg(b.price_per_unit),2) as overall_amount from pubs as p
	join sales as s on p.pub_id = s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by p.country	
)
select ap.country,ap.category,ap.avg_amount,tp.overall_amount from avg_price as ap
join total_avg_price as tp on ap.country=tp.country
order by ap.category



-- 11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount?


with individual_sales as (
	select p.pub_name,b.category,sum(b.price_per_unit*s.quantity) as sales_by_category from pubs as p
	join sales as s on p.pub_id = s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by p.pub_name,b.category
),
total_sales as(
	select p.pub_name,sum(b.price_per_unit*s.quantity) as sales_by_pubname from pubs as p
	join sales as s on p.pub_id=s.pub_id
	join beverages as b on s.beverage_id=b.beverage_id
	group by p.pub_name
)

select i.pub_name,i.category,round((i.sales_by_category/ts.sales_by_pubname)*100,2) as percentage_contribution,ts.sales_by_pubname as overall_Sale_amount from individual_sales as i
join total_sales as ts on i.pub_name=ts.pub_name
order by i.pub_name