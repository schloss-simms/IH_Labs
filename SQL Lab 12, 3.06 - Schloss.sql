-- Lab 12, 3.06

-- Q1 List each pair of actors that have worked together.

# setup views
create view ac1 as select actor.actor_id, concat(first_name, ' ', last_name) as full_name, film_id 
from actor
inner join film_actor on actor.actor_id = film_actor.actor_id;

create view ac2 as select actor.actor_id, concat(first_name, ' ', last_name) as full_name, film_id 
from actor
inner join film_actor on actor.actor_id = film_actor.actor_id;

# list of actors, paired
select ac1.full_name, ac2.full_name 
from ac1 
	join ac2 
	on ac1.film_id = ac2.film_id and ac1.actor_id <> ac2.actor_id
order by ac1.actor_id;

# removing redundacy from previous list
select distinct concat(ac1.full_name, ' - ', ac2.full_name) as acting_pairs
from ac1 
	join ac2 
	on ac1.film_id = ac2.film_id and ac1.actor_id < ac2.actor_id;

-- Q2 For each film, list actor that has acted in more films.

# setup temp table
with num_roles_actor as (select actor_id, count(film_id) as num_appearances 
from film_actor
group by actor_id);

# check temp table
select * 
from num_roles_actor;

# begin query, include rank for easier classification 
select film.film_id, title, film_actor.actor_id, concat(first_name, ' ', last_name) as full_name, num_appearances, row_number() over (partition by film_id order by num_appearances desc) as rank_num_roles
from film_actor
	join num_roles_actor on film_actor.actor_id = num_roles_actor.actor_id
	join film on film_actor.film_id = film.film_id
	join actor on film_actor.actor_id = actor.actor_id
	order by film_id;

# final query - 26.3 ms
select * from (
	select film.film_id, title, film_actor.actor_id, concat(first_name, ' ', last_name) as full_name, num_appearances, row_number() over (partition by film_id order by num_appearances desc) as rank_num_roles
from film_actor
	join num_roles_actor on film_actor.actor_id = num_roles_actor.actor_id
	join film on film_actor.film_id = film.film_id
	join actor on film_actor.actor_id = actor.actor_id
	order by film_id) as sub
where rank_num_roles = 1;