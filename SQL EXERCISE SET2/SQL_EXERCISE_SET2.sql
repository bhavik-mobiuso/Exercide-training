-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- SAKILA DATABASE PART1

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Q1 Display all tables available in the database “sakila” 
	USE Sakila;
	SHOW tables;

-- Q2 Display structure of table “actor”. (4 row) 
	DESCRIBE ACTOR;
    
-- Q3 Display the schema which was used to create table “actor” and view the complete schema using the viewer. (1 row) 
	SHOW CREATE TABLE ACTOR;  -- INCOMPLETE

-- Q4 Display the first and last names of all actors from the table actor. (200 rows) 
	SELECT 
		FIRST_NAME,
		LAST_NAME 
	FROM 
		ACTOR;

-- Q5 Which actors have the last name ‘Johansson’. (3 rows) 
	SELECT 
		* 
	FROM 
		ACTOR 
	WHERE 
		LAST_NAME = "Johansson";

-- Q6 Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. (200 rows)
	SELECT 
		UPPER(CONCAT(FIRST_NAME,LAST_NAME)) AS ACTOR_NAME 
	FROM 
		ACTOR;
		
/* Q7 You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one 
query would you use to obtain this information? (1 row) */
	SELECT 
		ACTOR_ID,
		FIRST_NAME,
        LAST_NAME 
	FROM 
		ACTOR 
	WHERE 
		FIRST_NAME = "Joe";

-- Q8 Which last names are not repeated? (66 rows) 
	SELECT 
		LAST_NAME 
	FROM 
		ACTOR 
	GROUP BY LAST_NAME
		HAVING count(LAST_NAME) = 1; 
    
-- Q9 List the last names of actors, as well as how many actors have that last 
	SELECT 
		ACTOR_ID,CONCAT(FIRST_NAME," ",LAST_NAME) AS ACTOR_NAME 
	FROM 
		ACTOR 
	ORDER BY ACTOR_ID DESC;
    
-- Q10 Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables “staff” and “address”. (2 rows)
	SELECT 
		FIRST_NAME,LAST_NAME,ADDRESS 
	FROM 
		STAFF JOIN ADDRESS ON STAFF.ADDRESS_ID = ADDRESS.ADDRESS_ID;
        
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- SAKILA DATABASE PART2

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Q1 Which actor has appeared in the most films? (‘107', 'GINA', 'DEGENERES', '42') 
	
	USE sakila;
    SELECT 
		ACTOR.ACTOR_ID,
    	CONCAT(ACTOR.FIRST_NAME," ",ACTOR.LAST_NAME)AS ACTOR_NAME,
        COUNT(FILM_ACTOR.FILM_ID) AS NO_OF_FILMS
	FROM
		ACTOR
			JOIN FILM_ACTOR ON ACTOR.ACTOR_ID = FILM_ACTOR.ACTOR_ID
	GROUP BY
		ACTOR.ACTOR_ID
    ORDER BY 
		 COUNT(FILM_ACTOR.FILM_ID) DESC
	LIMIT 1
    ;
    	
-- Q2 What is the average length of films by category? (16 rows) 

	SELECT 
		AVG(FILM.LENGTH) AS AVERAGE_LENGTH
	FROM
		FILM 
		JOIN FILM_CATEGORY ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID
		JOIN CATEGORY ON FILM_CATEGORY.CATEGORY_ID = CATEGORY.CATEGORY_ID
    GROUP BY 
    CATEGORY.CATEGORY_ID;

-- Q3 Which film categories are long? (5 rows) - DOUBT
	SELECT 
		NAME
	FROM
		CATEGORY
			JOIN FILM_CATEGORY ON CATEGORY.CATEGORY_ID = FILM_CATEGORY.CATEGORY_ID
			JOIN FILM ON FILM_CATEGORY.FILM_ID = FILM.FILM_ID
    WHERE
		(SELECT MAX(RENTAL_DURATION) FROM FILM)
    GROUP BY 
		CATEGORY.NAME
    ORDER BY 
		CATEGORY.NAME DESC
	LIMIT 5
    ;

-- Q4 How many copies of the film “Hunchback Impossible” exist in the inventory system? (6) 
	SELECT 
		FILM.TITLE AS MOVIE_NAME, 
        COUNT(INVENTORY.FILM_ID) AS NO_OF_COPPIES
	FROM 
		INVENTORY
	JOIN FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
    WHERE 
		TITLE = "Hunchback Impossible"; 

-- Q5 Using the tables “payment” and “customer” and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name (599 rows) 

	SELECT
		CUSTOMER.LAST_NAME AS CUSTOMER_NAME, 
		SUM(AMOUNT) AS TOTAL_PAID
	FROM 
		PAYMENT 
		JOIN CUSTOMER ON PAYMENT.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
	GROUP BY 
		PAYMENT.CUSTOMER_ID
	ORDER BY
		CUSTOMER.LAST_NAME ASC;
		
	

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- WORLD DATABASE PART1

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Q1 Display all columns and 10 rows from table “city”.(10 rows) 
	USE WORLD;
    SELECT 
		* 
	FROM 
		CITY LIMIT 10;
    
-- Q2 Modify the above query to display from row # 16 to 20 with all columns. (5 rows) 
	SELECT 
		* 
	FROM 
		CITY 
	LIMIT 
    5 OFFSET 15;
    
-- Q3 How many rows are available in the table city. (1 row)-4079. 
	USE WORLD;
	SELECT 
		COUNT(*) AS NO_OF_ROWS 
	FROM 
		CITY;
    
-- Q4 Using city table find out which is the most populated city. ('Mumbai (Bombay)', '10500000')  
	USE WORLD;
	SELECT 
		NAME AS MOSTPOPULATED_CITY,
		MAX(JSON_EXTRACT(INFO, "$.Population")) AS MOST_POPULATED_CITY
    FROM 
		CITY
	GROUP BY
		NAME
	ORDER BY 
		MOST_POPULATED_CITY DESC
    LIMIT 1
	;
    
-- Q5 Using city table find out the least populated city. ('Adamstown', '42')
	SELECT 
		NAME AS MOSTPOPULATED_CITY,
		MIN(JSON_EXTRACT(INFO, "$.Population")) AS LEAST_POPULATED_CITY
    FROM 
		CITY
	GROUP BY
		NAME
	ORDER BY 
		LEAST_POPULATED_CITY
    LIMIT 1
	;
		
-- Q6 Display name of all cities where population is between 670000 to 700000. (13 rows) 
	SELECT 
		NAME AS MOST_POPULATED_CITY
	FROM 
		CITY
	WHERE
		JSON_EXTRACT(INFO, "$.Population") BETWEEN 670000 AND 700000
	;
    
-- Q7 Find out 10 most populated cities and display them in a decreasing order i.e. most populated city to appear first. 

	SELECT 
		NAME AS MOST_POPULATED_CITY,
        JSON_EXTRACT(INFO, "$.Population") AS POPULATION
	FROM
		CITY
	ORDER BY
		JSON_EXTRACT(INFO, "$.Population") DESC
	LIMIT 10;

-- Q8 Order the data by city name and get first 10 cities from city table. 
	USE WORLD;
	SELECT
		* 
	FROM
		CITY
	ORDER BY
		NAME
	LIMIT 10
	;

-- Q9 Display all the districts of USA where population is greater than 3000000, from city table. (6 rows)
	-- WRONG NO OF ROWS
    SELECT
		 DISTRICT
	FROM
		CITY
	WHERE 
		COUNTRYCODE = "USA" AND JSON_EXTRACT(CITY.INFO, "$.Population") > 3000000;
	;
    
    
-- Q10 What is the value of name and population in the rows with ID =5, 23, 432 and 2021. Pl. write a single query to display the same. (4 rows). 
	
	SELECT 
		NAME,JSON_EXTRACT(CITY.INFO, "$.Population")
	FROM 
		CITY
	WHERE	
		ID IN(5,23,432,2021)
	;

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- WORLD DATABASE PART2

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Q1 Write a query in SQL to display the code, name, continent and GNP for all the countries whose country name last second word is 'd’, using “country” table. (22 rows) 
	
    USE WORLD;
	SELECT 
		JSON_EXTRACT(COUNTRYINFO.DOC, "$.Code") AS CODE,
        JSON_EXTRACT(COUNTRYINFO.DOC, "$.Name") AS NAME,
        JSON_EXTRACT(COUNTRYINFO.DOC, "$.geography.Continent") AS CONTINENT,
        JSON_EXTRACT(COUNTRYINFO.DOC, "$.GNP") AS GNP
	FROM
		COUNTRYINFO
	WHERE
		JSON_EXTRACT(COUNTRYINFO.DOC, "$.Name") LIKE "%d__"
	;
	

-- Q2 Write a query in SQL to display the code, name, continent and GNP of the 2nd and 3rd highest GNP from “country” table. (Japan & Germany) 
	
    SELECT * FROM COUNTRYINFO;
    SELECT 
		JSON_EXTRACT(COUNTRYINFO.DOC, "$.Code") AS Code,
        JSON_EXTRACT(COUNTRYINFO.DOC, "$.Name") AS Name,
        JSON_EXTRACT(COUNTRYINFO.DOC, "$.geography.Continent") AS CONTINENT,
        JSON_EXTRACT(COUNTRYINFO.DOC, "$.GNP") AS GNP
	FROM
		COUNTRYINFO
	ORDER BY
		GNP DESC
	LIMIT 2 OFFSET 1
	;
	
    
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- DEPARTMENT & EMPLOYEE TABLE QUERIES

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- Q1 Write a query to display Employee id and First Name of an employee whose dept_id = 100. (Use:Sub-query)(6 rows) 
	USE SAKILA;
    
	SELECT
		EMPLOYEE_ID,FIRST_NAME 
	FROM
		EMPLOYEES
	WHERE
		DEPARTMENT_ID = 100
	;
    
-- Q2. Write a query to display the dept_id, maximum salary, of all the departments whose maximum salary is greater than the average salary. (USE: SUB-QUERY) (11 rows) 
	USE SAKILA; -- WRONG NO OF ROWS
    SELECT
		EMPLOYEES.DEPARTMENT_ID,
        MAX(SALARY) AS MAXIMUM_SALARY 
	FROM
		EMPLOYEES
			JOIN DEPARTMENTS ON DEPARTMENTS.DEPARTMENT_ID = EMPLOYEES.DEPARTMENT_ID
	WHERE
		(SELECT MAX(SALARY) > AVG(SALARY) FROM EMPLOYEES)
	GROUP BY EMPLOYEES.DEPARTMENT_ID
	;
    
    SELECT * FROM DEPARTMENTS;

-- Q3 Write a query to display department name and, department id of the employees whose salary is less than 35000. .(USE:SUB-QUERY)(11 rows) 
	-- WRONG NO OF ROWS
	SELECT
		DEPARTMENT_NAME,
        DEPARTMENTS.DEPARTMENT_ID 
	FROM
		DEPARTMENTS
			JOIN EMPLOYEES ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
	WHERE 
		SALARY < 35000
	GROUP BY
		DEPARTMENT_ID
    ;
    