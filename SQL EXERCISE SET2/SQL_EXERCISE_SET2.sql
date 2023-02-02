/*Use “Sakila” database for the following questions*/ 
-- Q1 Display all tables available in the database “sakila” 
	USE Sakila;
	SHOW tables;

-- Q2 Display structure of table “actor”. (4 row) 
	DESCRIBE ACTOR;
    
-- Q3 Display the schema which was used to create table “actor” and view the complete schema using the viewer. (1 row) 
	SHOW CREATE TABLE ACTOR;  -- INCOMPLETE

-- Q4 Display the first and last names of all actors from the table actor. (200 rows) 
	SELECT FIRST_NAME,LAST_NAME FROM ACTOR;

-- Q5 Which actors have the last name ‘Johansson’. (3 rows) 
	SELECT * FROM ACTOR WHERE LAST_NAME = "Johansson";

-- Q6 Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. (200 rows)
	SELECT UPPER(CONCAT(FIRST_NAME,LAST_NAME)) AS ACTOR_NAME FROM ACTOR;
		
/* Q7 You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one 
query would you use to obtain this information? (1 row) */
	SELECT ACTOR_ID,FIRST_NAME,LAST_NAME FROM ACTOR WHERE FIRST_NAME = "Joe";

-- Q8 Which last names are not repeated? (66 rows) 
	SELECT DISTINCT LAST_NAME FROM ACTOR; -- INCOMPLETE
    
-- Q9 List the last names of actors, as well as how many actors have that last 
	SELECT ACTOR_ID,CONCAT(FIRST_NAME,LAST_NAME) AS ACTOR_NAME FROM ACTOR ORDER BY ACTOR_ID DESC;
    
-- Q10 Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables “staff” and “address”. (2 rows)
	SELECT 
		FIRST_NAME,LAST_NAME,ADDRESS 
	FROM 
		STAFF JOIN ADDRESS ON STAFF.ADDRESS_ID = ADDRESS.ADDRESS_ID;
        
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- Use “world” database for the following questions 

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