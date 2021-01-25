-- Lab 5, 2.08

-- Q1 Rank films by length (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, and the rank.
select title, length, 
RANK() OVER(order by length DESC) as 'Rank'
from sakila.film 
having length > 0
order by length desc;

-- Q2 Rank films by length within the rating category (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, rating and the rank.
select title, length, rating,
RANK() OVER(order by Length DESC) as 'Rank'
from sakila.film 
order by length desc, rating desc;

-- Q3 How many films are there for each of the categories in the category table. Use appropriate join to write this query
select film_category.category_id, count(film_category.category_id) as count 
from sakila.film 
inner join film_category on film.film_id = film_category.film_id group by category_id;

-- Q4 Which actor has appeared in the most films?
select film_actor.actor_id, count(film_actor.film_id) as count, actor.first_name as FirstName, actor.last_name as LastName
from sakila.film_actor
join actor on film_actor.actor_id = actor.actor_id
group by actor_id order by count desc;

-- Q5 Most active customer (the customer that has rented the most number of films)
select rental.customer_id, count(rental.rental_id) as count, customer.first_name, customer.last_name
from sakila.rental
join customer on rental.customer_id = customer.customer_id
group by customer_id order by count desc;

-- Bonus: Which is the most rented film? The answer is Bucket Brotherhood 
-- This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons. 

select film.title,film.film_id,count(rental.rental_id) as count_of_rentals  
from sakila.film 
LEFT JOIN
inventory ON film.film_id = inventory.film_id
LEFT JOIN
rental ON rental.inventory_id = inventory.inventory_id
group by film.film_id
order by count(rental.rental_id) desc;

-- reference, bad codes below
select inventory_id, count(rental.rental_id) as count, film.title
from sakila.rental
join inventory on rental.inventory_id = inventory.inventory_id
join film on inventory.film_id = film.film_id
group by film_id 
order by count(rental.rental_id) desc;

select count(rental.inventory_id) as count, film.title
from sakila.rental
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film on film.film_id = inventory.film_id
group by inventory.inventory_id order by count(rental.rental_id) desc;

select count(film.film_id) as count, film.title
from sakila.film
left join inventory on inventory.inventory_id = rental.inventory_id
left join film on film.film_id = inventory.film_id
group by rental.inventory_id order by count(film.film_id)  desc;