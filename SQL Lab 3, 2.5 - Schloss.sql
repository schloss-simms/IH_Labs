-- Lab 3

-- Q1 Get release years.
select release_year from sakila.film;

-- Q2 Get all films with ARMAGEDDON in the title.
select * from sakila.film where title regexp 'ARMAGEDDON';

-- Q3 Get all films which title ends with APOLLO.
select * from sakila.film where title regexp 'APOLLO$';

-- Q4 Get 10 the longest films.
select * from sakila.film order by length desc limit 10;

-- Q5 How many films include Behind the Scenes content?
select (*) from sakila.film 
where special_features regexp 'Behind the Scenes';

-- Q6 Drop column picture from staff.
alter table staff drop column picture;

-- Q7 A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
select * from sakila.customer
where first_name = 'TAMMY';
-- customer ID is 75, store ID 2, address ID 79, move her from customer to staff > can't figure this out...
select * into staff ('first_name', 'last_name', 'address_id', 'email', 'store_id', 'active', 'last_update') from customers where customer_id=75;

-- enters in new record with manual inputs:
INSERT INTO sakila.staff
VALUES ('3','Tammy', 'Sanders', '79', 'Tammy.Sanders@sakilastaff.com', '2', '1', 'Tammy', 'xdxd', CURRENT_TIMESTAMP);

-- Q8 Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1.
-- You can use current date for the rental_date column in the rental table. Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. To get that you can use the following query:
select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
-- Use similar method to get inventory_id, film_id, and staff_id.
-- checked details: 
select film_id from sakila.film
where title = 'Academy Dinosaur' ;

select staff_id from sakila.staff
where first_name = 'Mike' ;

select inventory_id from sakila.inventory
where film_id = 1 and store_id =2 ;

-- enters in new record with manual inputs, dummy entry for return_date set to CURRENT TIMESTAMP:
INSERT INTO sakila.rental
VALUES ('16051', CURRENT_TIMESTAMP, '1', '130', NULL, '1', CURRENT_TIMESTAMP); 


-- Q9 Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:

-- Check if there are any non-active users
select * from sakila.customer
where active = 0;

-- Create a table backup table as suggested (lol, I didn't understand the instructions correctly...see below is the real backup)
select * into customer_copy from sakila.customer;

-- Check the data types of the columns you need to make the new table with
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'customer';

-- Create a table with deleted_users, store: customer_id, email and date
create table sakila.customer_backup (
  customer_id smallint, 
  email varchar(255), 
  last_update TIMESTAMP,
  CONSTRAINT PRIMARY KEY (`customer_id`));

-- Insert the non active users in the table backup table
insert into customer_backup
select customer_id, email, last_update from sakila.customer
where active = 0;

-- Delete the non active users from the table customer
delete from customer_backup
where active =0;
