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
		ACTOR; -- INCOMPLETE
    
-- Q9 List the last names of actors, as well as how many actors have that last 
	SELECT 
		ACTOR_ID,CONCAT(FIRST_NAME,LAST_NAME) AS ACTOR_NAME 
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
        MAX(CONCAT(ACTOR.FIRST_NAME," ",ACTOR.LAST_NAME)) AS ACTOR_NAME
    FROM
		ACTOR JOIN FILM_ACTOR 
        ON ACTOR.ACTOR_ID = FILM_ACTOR.ACTOR_ID
        JOIN FILM 
        ON FILM_ACTOR.FILM_ID = FILM.FILM_ID
	WHERE
		(SELECT MAX(FILM_ACTOR.FILM_ID) FROM FILM_ACTOR);
    	
        
-- Q2 What is the average length of films by category? (16 rows) 

	SELECT 
		AVG(FILM.LENGTH) AS AVERAGE_LENGTH
	FROM
		FILM 
		JOIN FILM_CATEGORY ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID
		JOIN CATEGORY ON FILM_CATEGORY.CATEGORY_ID = CATEGORY.CATEGORY_ID
    GROUP BY 
    CATEGORY.CATEGORY_ID;

-- Q3 Which film categories are long? (5 rows) 

	-- CONFUSED

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

-- Q2 Modify the above query to display from row # 16 to 20 with all columns. (5 rows) 

-- Q3 How many rows are available in the table city. (1 row)-4079. 

-- Q4 Using city table find out which is the most populated city. ('Mumbai (Bombay)', '10500000') 

-- Q5 Using city table find out the least populated city. ('Adamstown', '42')
 
-- Q6 Display name of all cities where population is between 670000 to 700000. (13 rows) 

-- Q7 Find out 10 most populated cities and display them in a decreasing order i.e. most populated city to appear first. 

-- Q8 Order the data by city name and get first 10 cities from city table. 

-- Q9 Display all the districts of USA where population is greater than 3000000, from city table. (6 rows) 

-- Q10 What is the value of name and population in the rows with ID =5, 23, 432 and 2021. Pl. write a single query to display the same. (4 rows). 

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- WORLD DATABASE PART2

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Use “world” database for the following questions 

-- Q1 Write a query in SQL to display the code, name, continent and GNP for all the countries whose country name last second word is 'd’, using “country” table. (22 rows) 

-- Q2 Write a query in SQL to display the code, name, continent and GNP of the 2nd and 3rd highest GNP from “country” table. (Japan & Germany) 
