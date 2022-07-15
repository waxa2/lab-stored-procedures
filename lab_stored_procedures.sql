 use sakila;
 
 -- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
 -- Convert the query into a simple stored procedure. Use the following query:
 
  
  CREATE PROCEDURE action_procedure()
	  select first_name, last_name, email
	  from customer
	  join rental on customer.customer_id = rental.customer_id
	  join inventory on rental.inventory_id = inventory.inventory_id
	  join film on film.film_id = inventory.film_id
	  join film_category on film_category.film_id = film.film_id
	  join category on category.category_id = film_category.category_id
	  where category.name = "Action" 
	  group by first_name, last_name, email;
      
CALL action_procedure();
  
  
-- 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it 
-- can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
-- For eg., it could be action, animation, children, classics, etc.

SELECT DISTINCT(name)
FROM category;

-- 1st version
  DELIMITER //
  CREATE PROCEDURE category_procedure(IN Cat_name varchar(30))
  BEGIN
	  select first_name, last_name, email
	  from customer
	  join rental on customer.customer_id = rental.customer_id
	  join inventory on rental.inventory_id = inventory.inventory_id
	  join film on film.film_id = inventory.film_id
	  join film_category on film_category.film_id = film.film_id
	  join category on category.category_id = film_category.category_id
      where category.name=Cat_name
	  group by first_name, last_name, email;
   END//
DELIMITER ;
      

-- 3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to 
-- filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the 
-- stored procedure.

-- The query we want to run:

SELECT c.name, COUNT(DISTINCT(fc.film_id)) as film_amount
FROM film_category fc
JOIN category c ON fc.category_id=c.category_id
GROUP BY c.category_id
HAVING film_amount>20 # movies that have released more than 20 movies
ORDER BY film_amount DESC;

  DELIMITER //
  CREATE PROCEDURE released_amount_category(IN Catname varchar(30))
  BEGIN
SELECT c.name, COUNT(DISTINCT(fc.film_id)) as film_amount
FROM film_category fc
JOIN category c ON fc.category_id=c.category_id
WHERE c.name=Catname
GROUP BY c.category_id
HAVING film_amount>20
ORDER BY film_amount DESC;
   END//
DELIMITER ;

CALL released_amount_category('Sports');