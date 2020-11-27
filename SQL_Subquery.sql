/* 30 questions*/
use hr;

/*
Exercise 1:
Display the employee name along with theie department name. Show all the employee name 
even those without department and show all the department names even if it doesnt have an employee 
*/

	select concat(first_name,' ', last_name) as Emp_name, Department_name
		from employees left join departments
        using (department_id)
	union all
    select concat(first_name,' ', last_name) as Emp_name, Department_name
		from employees right join departments
        using (department_id);


-- Sub-Queries

                    
                  
/*
Exercise 3:
Display the state province of employees who get commission_pct greater than 0.25
*/ 

	select concat(first_name,' ',last_name)as Emp_name,State_Province,Commission_Pct
		from employees join departments
        using (department_id) join locations
        using(location_id)
        where commission_pct in (select commission_pct from employees where commission_pct>.25)
        group by state_province;



	select state_province as state
	from locations
	where location_id in (select location_id 
					  from  departments 
                      where department_id in (select department_id 
											  from employees
                                              where commission_pct>0.25));
	
/*
Exercise 4:
Collect the employee id, full name, phone number and email id of employees who work in Germany
*/ 

	select Employee_id,concat(first_name,' ',last_name)as Emp_name,Phone_number,Email,Country_name
		from employees join departments
        using(department_id) join locations
        using(location_id) join countries
        using(country_id) 
        where country_name in (select country_name from countries where country_name='Germany');
/*
Exercise 5:
Display the manager details who have more than 5 employees reporting to them
*/ 
	select * from employees
    where employee_id in (select manager_id from employees 
							group by manager_id having count(*)>5);


/*
Exercise 6:
Collect only the duplicate employee records
*/ 

	select * from employees
		where email in (select email from employees 
						group by email having count(email)>1);



##########################################  Window Functions ########################################## 
/*
Exercise 7: 
For department id 80 and commission percentage more than 30% collect the below details:
- employee id's of each department, their name, department id and the number of employees 
in each department
*/

	select Department_id,concat(first_name,' ', last_name) as Emp_name,Commission_Pct,
		count(employee_id) over(partition by department_id) as Emp_Count
        from employees join departments using (department_id)
        where department_id=80 and commission_pct>0.30;
    

/*
Exercise 8. 
Show the employee id's , employee name, manager id, salary, average salary
of employees reporting under each manager and the difference between them
*/

	select Employee_id,concat(first_name,' ', last_name) as Emp_name,Manager_id,Salary,
    avg(salary)over(partition by manager_id) as Avg_salary,
    Salary-avg(salary) over(partition by manager_id) as Salary_Diff
    from employees;

/*
Exercise 9: 
Show the employee id's , their name, job id, salary, total salary of employees job id level, 
and the proportion of their salary to their total salary in each job id
*/

	select Employee_id,concat(first_name,' ', last_name) as Emp_name,Job_id,Salary,
    sum(salary)over(partition by job_id) as Total_Salary,
   round( salary/sum(salary) over(partition by job_id)*100,2) as Salary_Proportion
    from employees
    order by salary_proportion desc;
    
/*
Exercise 10: 
For each employee, collect the employee id, department id, job id, start_date and their UNIQUE rank (use row number() consider start_date)
with the latest start date and hire date coming first.
*/

	select e.employee_id,e.department_id,e.job_id,e.hire_date,start_date,
		row_number() over(order by hire_date desc ,start_date desc)as Hire_date_rank
        from employees e join job_history j
        on e.employee_id=j.employee_id;

/*
Exercise 11: 
For each employee, display the employee id, department id, job id, their rank (without skip levels) by commission_pct. 
with recent hire_date coming first.
*/

	select employee_id,department_id,job_id,hire_date,commission_pct,
		row_number() over(order by commission_pct desc) as cpt_rank
        from employees;
/*	
Exercise 12: 
Divide the employees into 10 groups with highest paid employees coming first.
For each employee fetch the emp id, department id salary and the group they belong to
*/

	select employee_id,department_id,salary,
    ntile(10)over(order by salary desc) as group_emp
    from employees;

/*
Exercise 13: 
For each employee, gather the emp id, department id, salary  and sum of salary up to the current
hire_date when sorted by the hired date.
*/

	select employee_id,department_id,salary,hire_date,
		sum(salary) over(order by hire_date) as sum_salary
        from employees;

/*
Exercise 14: 
For employees in department 50,  get the emp id, department id salary  and the sum of 
salary of the remaining employees in the department (include the current row) 
with the oldest hire date coming first
*/

	select employee_id,department_id,salary,hire_date,
		sum(salary) over(order by hire_date) as sum_salary
        from employees
        where department_id=50;
	

/*
Exercise 15: 
Write a query to find the first day of the most recent job of every employee.
*/
	
    select distinct employee_id,first_name,
    last_value(start_date)over(partition by employee_id) as recent_job
    from job_history join employees
    using(employee_id);

	
/*
Exercise 16: 
Write a query to list the current designation and previous designation of all the employees
*/
	
    select distinct employee_id,
		last_value(e.job_id)over(partition by employee_id) as current_designation,
        last_value(j.job_id)over(partition by employee_id)as previous_designation
        from employees e join job_history j
        using(employee_id);
    


/*
Exercise 17: 
Get the order date, order id, product id, product quantity and Quantity ordered 
in a single day for each row
*/


/*
Exercise 18: 
Create a view with first name ,department id for department id 30 in a way ,if anyone wants to update 
view with other than department 30 it will not update.
*/

create view v3 as 
	select first_name,salary,department_id from employees
    where department_id=30
    with check option;





#####################################################################################################



Use Sakila;

/* Question 19 : Marketing manager wants to decide a discount stratergy to order to increase the sales. 
Help this guy by creating a view of Create a view of least rented movies in ascending order of rental count.*/

	create view v1_sakila as
    select distinct f.film_id,f.title,i.inventory_id,count(r.rental_id) as times_rented
    from film f inner join inventory i
    on f.film_id=i.film_id
    inner join rental r
    on i.inventory_id=r.inventory_id
    group by f.film_id
    order by count(r.rental_id);


/*Question 20
The Marketing manager has decided to give maximum 20 % dicount to all the movies having rental count < 20 .
Display movie name and the rental rate after deducting discount % from the view created in Q1.If Rental
 count <= 20 then 5% discount , if Rental count <=15 then 10% discount, 
 if Rental count <=10 then 20% discount else 0% discount.
*/

	select film_id,f.title,
		case when times_rented<=20 then rental_rate*0.95
			 when times_rented<=15 then rental_rate*0.90
             when times_rented<=10 then rental_rate*0.80
             else rental_rate end as Discounted_rental_rate
	from film f join v1_sakila l using(film_id)
    order by times_Rented;

/* Question 21 
create a view of all actors who appear in the films 'AFRICAN EGG','ANGELS LIFE','BADMAN DAWN'.
*/

	create view v1_actors as
    select f.film_id,f.title,fa.actor_id,concat(first_name,' ',last_name)as actor_name
		from film f inner join film_actor fa
        on f.film_id=fa.film_id
        and f.title in ('african egg','angels life','badman dawn')
        inner join actor a
        on fa.actor_id=a.actor_id;
    
/*Question 22
Create a view on Film with all the details which belongs to 
 categories 'Horror','Comedy','Drama','Sci-Fi'.
*/

	create view v2_actors as 
    select f.film_id,f.title,f.description
    from film f inner join film_category fc
    on f.film_id=fc.film_id
    inner join category c
    on fc.category_id=c.category_id
    and c.name in('horror','comedy','drama','sci-fi');
    

/* Question 23
Below is the mention scenarion with few clauses in SQL

CREATE TABLE emp_data (
    no NUMBER(3), 
    name VARCHAR(50), 
    code VARCHAR(12)
    );
SAVEPOINT table_create;
insert into emp_data VALUES(1,'Opal', 'e1401');
SAVEPOINT insert_1;
insert into emp_data VALUES(2,'Becca', 'e1402');
SAVEPOINT insert_2;
SELECT * FROM emp_data;

Now give the command line which will rollback only last inserted row

*/
-- rollback to insert_2

/* Question 24
a.	Is ROLLBACK transaction supports for DDL statement?
b.Explain SAVEPOINT.
c.What statement do you use to delete SAVEPOINT?
*/

# a.We cannot roll back the transaction by using the ROLLBACK statement for DDL statements.
# b.	A savepoint is a defined point in a transaction. 
#       The SAVEPOINT statement is used to set a savepoint with a name. 
#       The ROLLBACK TO SAVEPOINT statement is used to roll back the transaction to the named
#       savepoint specified. Instead of rolling back all the changes in the transaction, 
#       ROLLBACK TO SAVEPOINT savepointname rolls back modifications to rows made in the current
#       transaction after the savepoint at savepointname. The data is in the same state it was in 
#       at the time the savepoint was reached by the transaction.
# c.To remove the named savepoint from the set of defined savepoints in the current transaction, 
#      we can use the RELEASE SAVEPOINT command.   

/*Question 25
Find the average length of films by film category.
*/



/*Question 26 
Create table 
 -- Accounts(Account_number int PRIMARY KEY, account_holder_name TEXT , balance  DECIMAL, last_transaction_date DATETIME)
 -- insert following records into the table Accounts
 -- 1. (15234,'Rohan kumar', 20000, null)
 -- 2. (16779,'Atul singh', 30000, null)
 ## Rohan wants to transfer 10000 to Atul. Write a transaction to complete this update and commit it.

Create table Accounts
(
  Account_number int PRIMARY KEY,
  account_holder_name TEXT,
  balance DECIMAL(8,2),
  last_transaction_date DATETIME 
);

INSERT INTO Accounts values (15234,'Rohan kumar', 20000, null);
INSERT INTO Accounts values (16779,'Atul singh', 30000, null);
commit;
select * from Accounts;
*/ 
set autocommit=0;

start transaction;
update accounts set balance=balance-10000 where account_holder_name='Rohan kumar';
update accounts set balance=balance+10000 where account_holder_name='Atul singh';


/*Question 27 
"Create table dept 
deptid number should be a primary key
dname string should be maximum of 50 characters"
*/

create table dept (
dep_id int primary key,
dname varchar(50) );


/*Question 28
Create table  emp with below mentioned details:-
1.empid should be number datatype and  primary key
2.emp_name should be string and not null
3.salary should  be number datatype
4.deptid should be number datatype and  foreign key (dept table - deptid) 
5.hire_date should be date data type 
in such a way if you update deptid in dept table ,should be autochanged in emp table
*/

create table emp(
emp_id int primary key,
emp_name varchar(20) not null,
salary int,
dep_id int,
hire_date date,
foreign key (dep_id) references dept(dep_id)
on update cascade );


/*Question 29
Create a table Customer_info with the below mentioned column
Cust_name - should be of character type maximum 50 length 
                      ,must not accept nulls
Cust_age - should be of number type
Cust_DOB - should be of date type
*/

create table customer_info (
cust_name varchar(50) not null,
cust_age int,
cust_dob date);

/*Question 30
1.Add a rule on age column ,it should be greater than 17
2.Add a column of phone of number type with a default rule of 0
*/
# 1
alter table customer_info add constraint c1 check(cust_age>17);
# 2
alter table customer_info add phone int(10) default 0;
