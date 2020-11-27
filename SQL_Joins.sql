-- Joins

/*
Exercise 1: 
Collect employee information (name, location id and department name) from location 1500


Hint:
(Use HR schema)
This exercise requires employee name which is present in the employees table and department name
which is present in the department table only for location id 1500. In order to get the 
desired records employees table and departments table has to be inner joined and location id has to be 
filtered
*/
use hr;

select concat(e.first_name,' ',e.last_name)as full_name ,d.location_id,d.department_name
	from employees e inner join departments d
    on e.department_id=d.department_id
    where d.location_id='1500';
    
/*
Exercise 2: 
Show the employee id, employee name, and full address (including country name) of employees who reside in Germany

Hint:
This exercise requires employee id, full name, address with country name who live in germany. In order to get the 
desired records employees table, departments table, location and country table has to be inner joined 
and country name has to be filtered
*/

select employee_id,concat(first_name,' ',last_name) as full_name,street_address, country_name
	from employees join departments
    using (department_id) join locations
    using (location_id) join countries
    using (country_id) 
    where country_name='Germany';
    
	

/* 
Exercise 3:
Gather employee name and salary data of employees who receive salary greater than their manager's salary. 

Hint:
In order to get the desired output, self join the employee table. select the employee name and their respective 
salary (To verify the results also select manager name and their respective salary. 
Use the '<' operator to check the salary condition part.
*/
	select concat(e1.first_name,' ',e1.last_name) as Name ,e1.employee_id,e1.salary,e2.manager_id,e2.salary
    from employees e1 join employees e2
    on e1.manager_id=e2.employee_id
    where e1.salary>e2.salary;



/*
Exercise 4:
Display the below details for the employees who were hired during 1997-2000
 - employee name, hiring date, current job and past job
*/


    select concat(first_name," ",last_name) as e_name,(hire_date),e.job_id as current_job,j.job_id as past_job
	from employees e left join job_history j
	using (employee_id)
	where year(hire_date) between '1997-01-01' and '2000-12-31';
	

/* 
Exercise 5:
Collect the below details for all the employees
- employee id, employee name, manager id and their corresponding manager name
*/

	select e1.employee_id,concat(e1.first_name," ",e1.last_name) as Emp_name,e2.manager_id,concat(e2.first_name," ",e2.last_name) as Man_name
		from employees e1 join employees e2
        on e1.employee_id=e2.manager_id;


/*
Exercise 6:
Display the employee name along with theie department name. Show all the employee name 
even those without department and show all the department names even if it doesnt have an employee 
*/

select concat(first_name,' ',last_name) as Name,Department_name
	from employees left join departments
    using(department_id)
union all
select concat(first_name,' ',last_name) as Name,Department_name
	from employees right join departments
    using(department_id);

/*
Exercise 7:
Collect the product information product id, product description and order id 
for the products which don't have even one order placed (Use order mangement schema)
*/
USE ORDERS;

select Product_id,Product_desc,order_id
	from product left join order_items
    using (product_id)
    where order_id is Null;



