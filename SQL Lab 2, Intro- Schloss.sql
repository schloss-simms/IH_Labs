-- Lab 2
-- Question 1
-- Select all the actors with the first name 'Scarlett'.
use sakila
select * from sakila.actor where first_name='Scarlett';

-- Question 2
-- How many films (movies) are available for rent and how many films have been rented?
select count(*) from sakila.inventory;

-- Question 3
-- What are the shortest and longest movie duration? Name the values max_duration and min_duration.
select max(length) as 'Max Length', min(length) as 'Min Length' from sakila.film;

-- Question 4
-- What's the average movie duration expressed in format (hours, minutes)?
select floor(avg(length)/60) as hours, round(avg(length) % 60) as minutes from sakila.film;

-- Question 5
-- How many distinct (different) actors' last names are there?
select count(distinct(last_name)) from sakila.actor;

-- Question 6
-- Since how many days has the company been operating (check DATEDIFF() function)?
select datediff(max(rental_date), min(rental_date)) as active_days from sakila.rental;

-- Question 7
-- Show rental info with additional columns month and weekday. Get 20 results.
SELECT *,
date_format(rental_date,'%M') as 'Month',
date_format(rental_date,'%W') as 'Weekday'
from sakila.rental
limit 20;

-- Question 8
-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *,
	CASE
    WHEN WEEKDAY(rental_date)=TRUE THEN 'Weekday'
    ELSE 'Weekend'
END as day_type
FROM sakila.rental;


-- Question 9
-- How many rentals were in the last month of activity?
select date(max(rental_date)) from sakila.rental;

select *, date_format(rental_date,'%M') as Month_, date_format(rental_date,'%Y')  as Year_
from sakila.rental;
having Month_ = 'February' and Year_ = 2006;
-- figure out how to next this into count, or create a subquery for count of this output!
select count(*);