-- Lab 9, 3.03

-- Q1 Get all pairs of actors that worked together.
select fa1.film_id, concat(a1.first_name, ' ', a1.last_name) actor_1, concat(a2.first_name, ' ', a2.last_name) actor_2
from sakila.actor a1
join film_actor fa1
on a1.actor_id = fa1.actor_id
join film_actor fa2
on (fa1.film_id = fa2.film_id) and (fa1.actor_id != fa2.actor_id)
join actor a2
on a2.actor_id = fa2.actor_id
where fa2.actor_id > fa1.actor_id;

-- Q1 testing inner join function, same result
select fa1.film_id, concat(a1.first_name, ' ', a1.last_name) actor_1, concat(a2.first_name, ' ', a2.last_name) actor_2
from sakila.actor a1
inner join film_actor fa1
on a1.actor_id = fa1.actor_id
inner join film_actor fa2
on (fa1.film_id = fa2.film_id) and (fa1.actor_id != fa2.actor_id)
inner join actor a2
on a2.actor_id = fa2.actor_id;
    
-- Q2 Get all pairs of customers that have rented the same film more than 3 times.
-- better code
select concat(c1.first_name," ", c1.last_name) as Customer1, concat(c2.first_name," ", c2.last_name) as Customer2, count(r.inventory_id) as Overlapping_Film_Count
from rental as r
    inner join sakila.rental as r1
    on r.inventory_id = r1.inventory_id
    inner join sakila.customer as c1
    on r1.customer_id = c1.customer_id
	join sakila.rental as r2 
	on r1.inventory_id = r2.inventory_id and r1.customer_id < r2.customer_id
    inner join sakila.customer as c2
    on r2.customer_id=c2.customer_id
group by r1.customer_id, r2.customer_id
having count(*) > 3
order by count(*) desc;

-- Q3 Get all possible pairs of actors and films.
select concat(a.first_name,' ', a.last_name) as actor_name, f.title
from sakila.actor a
cross join sakila.film as f;

-- Q3 trying another version, better dataset
select * 
from (select distinct title from sakila.film) as a
cross join (select distinct actor_id, first_name, last_name from sakila.actor) as b;

