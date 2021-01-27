-- Lab 10 replacement, 3.04

-- Q1 Write a query to print the ID, FIRST_NAME, and LAST_NAMEs of the customers whose combined name length, i.e., the sum of the length of the FIRST_NAME and LAST_NAME, is less than 12. The IDs and names should be printed in the ascending order of the combined name length. 

-- If two or more customers have the same combined name length, sort the result in lexicographical order of the full names, ignoring case. If two or more customers have the same full name, sort those results by ID, ascending.

select ID, FIRST_NAME, LAST_NAME, (concat(FIRST_NAME, ' ', LAST_NAME)) as full_name, length(concat(FIRST_NAME, ' ', LAST_NAME)) as character_count
from customer
where length(concat(FIRST_NAME, ' ', LAST_NAME)) < 12 
order by character_count asc, full_name, ID asc;

-- Q4 Given two tables, Employee and Department, generate a summary of how many employees are in each department. 

-- Each department should be listed, whether they currently have any employees or not. The results should be sorted from high to low by number of employees, and then alphabetically by department when departments have the same number of employees. The results should list the department name followed by the employee count. The column names are not tested, so use whatever is appropriate.

select d.name, count(e.name) as employee_count
from department as d
join employee as e 
on d.id = e.dept_id
group by d.name
order by employee_count desc, d.name desc;

-- Q5  There are two data tables with employee information: EMPLOYEE and EMPLOYEE_UIN. Query the tables to generate a list of all employees who are less than 25 years old first in order of NAME, then of ID, both ascending.  The result should include the UIN followed by the NAME.  

select eu.uin, e.name, e.age
from Employee as e
join Employee_uin as eu
on e.id = eu.id
where e.age < 25
order by e.name asc, e.id asc;

-- Q8 A company maintains an EMPLOYEE table with information for each of their employees. Write a query to produce a list containing two columns.  
-- The first column should include the name of an employee who earns less than some other employee.  
-- The second column should contain the name of a higher earning employee.  All combinations of lesser and greater earning employees should be included.  
-- Sort ascending, first by the lower earning employee's ID, then by the higher earning employee's SALARY.  

select e1.name, e2.name
from employee as e1
join employee as e2
on e1.salary < e2.salary
order by e1.id asc, e2.salary asc;