-- Lab 13, 3..07


-- Q1 Get number of monthly active customers.
-- setup data
create or replace view client_activity as
select customer_id, rental_date as activity_date,
date_format(rental_date, '%m') as activity_Month,
date_format(rental_date, '%Y') as activity_year
from rental;
select * from client_activity;

create or replace view monthly_active_clients as
select count(distinct customer_id) as active_users, activity_year, activity_month
from client_activity
group by activity_year, activity_month
order by activity_year, activity_month;
-- final query
select * from monthly_active_clients;



-- Q2 Active users in the previous month.
with cte_activity as (
	select active_users, lag(active_users, 1, active_users) over (partition by activity_year) as last_month, activity_year, activity_month
	from monthly_active_clients
)
select * from cte_activity
where last_month is not null;



-- Q3 Percentage change in the number of active customers.
with cte_activity as (
	select active_users, lag(active_users, 1, active_users) over (partition by activity_year) as last_month, activity_year, activity_month
	from monthly_active_clients
)
select *, round(((active_users - last_month) * 100/last_month),2) as diff_percent from cte_activity
where last_month is not null;


-- Q4 Retained customers every month.
-- setup data
create or replace view retained_clients_view as
with distinct_users as (
  select distinct customer_id , activity_month, activity_year
  from client_activity
)
select count(distinct d1.customer_id) as retained_customers, d1.activity_month, d1.activity_year
from distinct_users d1
join distinct_users d2 on d1.customer_id = d2.customer_id
and d1.activity_month = d2.activity_month + 1
group by d1.activity_month, d1.activity_year
order by d1.activity_year, d1.activity_month;
-- final query
select * from retained_clients_view;

