-- Lab 4
-- Part 1, Setup 
drop table if exists films_2020;
CREATE TABLE `films_2020` (
  `film_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year(4) DEFAULT NULL,
  `language_id` tinyint(3) unsigned NOT NULL,
  `original_language_id` tinyint(3) unsigned DEFAULT NULL,
  `rental_duration` int(6),
  `rental_rate` decimal(4,2),
  `length` smallint(5) unsigned DEFAULT NULL,
  `replacement_cost` decimal(5,2) DEFAULT NULL,
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- for reference below. do not run these codes (did not work for me, using GUI import function instead):
SET sql_mode = '';
load data infile '/Users/jessieschloss/dataV3_Lesson_2.7_lab/files_for_part1/films_2020.csv'
insert ignore into films_2020
lines terminated by ',';

SHOW VARIABLES LIKE "secure_file_priv";

bulk insert films_2020
from '/Users/jessieschloss/dataV3_Lesson_2.7_lab/files_for_part1/films_2020.csv';

-- Instructions
-- We have just one item for each film, and all will be placed in the new table.
-- For 2020, the rental duration will be 3 days, with an offer price of 2.99€ and a replacement cost of 8.99€ (these are all fixed values for all movies for this year).
-- The catalog is in a CSV file named films_2020.csv that can be found at files_for_lab folder.
-- Q1 Add the new films to the database. 
-- done via import function

-- Q2 Update information on rental_duration (3 days), rental_rate (2.99), and replacement_cost (8.99).
-- Hint: You might have to use the following commands to set bulk import option to ON:
show variables like 'local_infile';
set global local_infile = 1;

update `films_2020`
  set `rental_duration` = 3,
  `rental_rate` = 2.99,
  `replacement_cost` =8.99;
  
-- Part 2

-- Q1 In the table actor, which are the actors whose last names are not repeated? For example if you would sort the data in the table actor by last_name, you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name. So we do not want to include this last name in our output. Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.
select * from sakila.actor
where count(last_name)=1;

-- check last name counts
select count(last_name) as last_name_count, last_name from sakila.actor
group by last_name
having count(last_name) =1;

-- Q2 Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
select count(last_name) as last_name_count, last_name from sakila.actor
group by last_name
having count(last_name) >1;

-- Q3 Using the rental table, find out how many rentals were processed by each employee.
select count(staff_id) as staff_rental_count, staff_id from sakila.rental
group by staff_id;

-- Q4 Using the film table, find out how many films were released each year.
select count(release_year) as release_count, release_year from sakila.film
group by release_year;

-- Q5 Using the film table, find out for each rating how many films were there.
select count(rating) as rating_count, rating from sakila.film
group by rating;

-- Q6 What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
select round(avg(length),2) as mean_length, rating from sakila.film
group by rating;

-- Q7 Which kind of movies (rating) have a mean duration of more than two hours? (??)
select round(avg(length),2) as mean_length, rating from sakila.film
group by rating
having round(avg(length),2) > 120;
