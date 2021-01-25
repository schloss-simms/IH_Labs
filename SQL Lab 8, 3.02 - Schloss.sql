-- Lab 8, 3.02

-- Write a query to display for each store its store ID, city, and country.
select s.store_id, city, country 
from sakila.store as s
join sakila.address as a
on s.address_id = a.address_id
left join sakila.city as c
on a.city_id = c.city_id
left join sakila.country as co
on c.country_id = co.country_id;

-- Write a query to display how much business, in dollars, each store brought in.
select c.store_id, sum(p.amount) as "total_rev"
from sakila.payment as p
join sakila.customer as c
on c.customer_id = p.customer_id
group by store_id;

-- What is the average running time of films by category?
select c.name as "category", avg(f.length) as "avg_length" 
from sakila.category as c
left join sakila.film_category as fc
on c.category_id = fc.category_id
left join sakila.film as f
on fc.film_id = f.film_id
group by name;

-- Which film categories are longest?
select c.name as "category", avg(f.length) as "avg_length" 
from sakila.category as c
left join sakila.film_category as fc
on c.category_id = fc.category_id
left join sakila.film as f
on fc.film_id = f.film_id
group by c.name
order by avg(f.length) desc
limit 3;

-- Display the most frequently rented movies in descending order.
select f.title as "movie", count(rental_id) as "times_rented" from sakila.film as f
left join sakila.inventory as i
on f.film_id = i.film_id
left join sakila.rental as r
on i.inventory_id = r.inventory_id
group by f.title
order by count(rental_id) desc;

-- List the top five genres in gross revenue in descending order.
select c.name as "category", sum(p.amount) as "gross_revenue" 
from sakila.category as c
left join sakila.film_category as fc
on c.category_id = fc.category_id
left join sakila.inventory as i
on fc.film_id = i.film_id
left join sakila.rental as r
on i.inventory_id = r.inventory_id
left join sakila.payment as p
on r.rental_id = p.rental_id
group by name 
order by sum(amount)desc
limit 5;

-- testing regular joins (and inner joins), appears to have the same output as left join and right join...
select c.name as "category", sum(p.amount) as "gross_revenue" 
from sakila.category as c
join sakila.film_category as fc
on c.category_id = fc.category_id
join sakila.inventory as i
on fc.film_id = i.film_id
join sakila.rental as r
on i.inventory_id = r.inventory_id
join sakila.payment as p
on r.rental_id = p.rental_id
group by name 
order by sum(amount)desc
limit 5;


-- Is "Academy Dinosaur" available for rent from Store 1?
select f.title, s.store_id, inventory_id, i.last_update 
from sakila.film as f
join sakila.inventory as i
on f.film_id = i.film_id
join sakila.store as s
on i.store_id = s.store_id
where f.title = "Academy Dinosaur" and s.store_id = 1;
