-- Lab 7, 3.01

-- List number of films per category.
select count(*) as film_count, category_id
from sakila.film_category
group by category_id;

-- if you wanted the category titles for better understanding
select count(*) as film_count, a.category_id, b.name
from sakila.film_category as a
join sakila.category as b
on a.category_id = b.category_id
group by a.category_id;

-- Display the first and last names, as well as the address, of each staff member.
select name, address, `zip code`, city, country
from sakila.staff_list;

-- Display the total amount rung up by each staff member in August of 2005.
select s.first_name, sum(amount) 
from sakila.payment as p
join sakila.staff as s
on p.staff_id = s.staff_id
where (payment_date between "2005-07-31" and "2005-08-31")
group by s.first_name;

-- List each film and the number of actors who are listed for that film.
select title, count(a.actor_id) as actor_count 
from sakila.film as f
join sakila.film_actor as fa
on f.film_id = fa.film_id
join sakila.actor as a
on fa.actor_id = a.actor_id
group by title;

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
select first_name, last_name, sum(amount) as total_paid 
from sakila.customer as c
join sakila.payment as p
on c.customer_id = p.customer_id
group by first_name, last_name
order by last_name;

