-- Lab 11, 3.05

-- Q1 How many copies of the film Hunchback Impossible exist in the inventory system?
select count(i.inventory_id) as number_of_copies, f.title
from inventory as i
	inner join film as f
	on i.film_id = f.film_id
where f.title = "Hunchback Impossible";

-- Q2 List all films whose length is longer than the average of all the films.
select title, length
from film
where length > (
	select avg(length)
	from film
	);

-- Q3 Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
from actor
where actor_id in(
	select actor_id
	from film_actor
	where film_id in (
		select film_id
		from film
		where title = "Alone Trip"
));


-- Q4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title, description 
from film 
where film_id in(
	select film_id from film_category
	where category_id in(
		select category_id from category
		where name = "Family"
));

-- quick n easy solution
select title, category from film_list
where category = 'family';

-- Q5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select c.first_name, c.last_name, c.email 
from customer as c
	join address a 
	on (c.address_id = a.address_id)
	join city cty
	on (cty.city_id = a.city_id)
	join country
	on (country.country_id = cty.country_id)
where country.country= "Canada";

-- Q6 Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

# step1 - number of films count
select actor_id, count(film_id) as num_films 
from film_actor
group by actor_id;

# step2 - max number
select max(num_films) 
from (
	select actor_id, count(film_id) as num_films 
	from film_actor
	group by actor_id) as sub;

# step3 - actor id with max number
select actor_id from (
	select actor_id, count(film_id) as num_films 
	from film_actor
	group by actor_id) as sub1 
where sub1.num_films = (
	select max(num_films) from (
		select actor_id, count(film_id) as num_films 
		from film_actor
		group by actor_id) as sub);

# final query - 4.2ms
select a.actor_id, concat(first_name, " ", last_name) as full_name, film.film_id, title
from actor as a
	join film_actor 
	on film_actor.actor_id = a.actor_id
	join film 
	on film_actor.film_id = film.film_id
	where a.actor_id = (
		select actor_id from (
			select actor_id, count(film_id) as num_films 
			from film_actor
			group by actor_id) as sub1 
			where sub1.num_films = (
				select max(num_films) 
				from (
					select actor_id, count(film_id) as num_films 
					from film_actor
					group by actor_id) as sub));

-- Q7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

# step1 - customers and sum of money spent on rentals
select customer_id, sum(amount) as sum_spent
from payment
group by customer_id;

# step 2- max sum spent on rentals
select max(sum_spent) 
from (
	select customer_id, sum(amount) as sum_spent
	from payment
	group by customer_id) as sub;

# step 3 - customer_id with max spent on rentals
select customer_id 
from (
	select customer_id, sum(amount) as sum_spent
	from payment
	group by customer_id) as sub1 
where sub1.sum_spent = (
	select max(sum_spent) 
	from (
		select customer_id, sum(amount) as sum_spent
		from payment
		group by customer_id) as sub);

# final query - 48.6 ms
select c.customer_id, concat(first_name, " ", last_name) as full_name, f.film_id, title
from rental as r
	join customer as c 
	on r.customer_id = c.customer_id
	join inventory as i 
	on r.inventory_id = i.inventory_id
	join film as f
	on i.film_id = f.film_id
where c.customer_id = (
	select customer_id 
	from (
		select customer_id, sum(amount) as sum_spent
		from payment 
		group by customer_id) as sub1 
where sub1.sum_spent = (
	select max(sum_spent) 
	from (
		select customer_id, sum(amount) as sum_spent
		from payment
		group by customer_id) as sub));


-- Q8 Customers who spent more than the average payments.

# step 1 - average money spent
select customer_id, sum(amount) as sum_spent 
from payment
group by customer_id;

select round(avg(sum_spent), 2) as avg_spent
from (
	select customer_id, sum(amount) as sum_spent 
	from payment
	group by customer_id) as sub;

# final query - 34.3 ms
select c.customer_id, concat(c.first_name, " ", c.last_name) as full_name, sum(amount) as sum_spent 
from payment as p
	join customer as c
	on p.customer_id = c.customer_id
	group by c.customer_id
	having sum_spent > (
		select round(avg(sum_spent), 2) 
		from (
			select customer_id, sum(amount) as sum_spent 
			from payment
			group by customer_id) as sub);

