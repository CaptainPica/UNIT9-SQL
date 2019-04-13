USE sakila;
-- 1a
	-- CREATE VIEW 1a AS
SELECT first_name, last_name FROM actor;

-- 1b
SELECT CONCAT(first_name, " ", last_name) AS `Name` FROM actor;

-- 2a
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "JOE";

-- 2b
SELECT first_name, last_name FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c
SELECT last_name, first_name FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country FROM country
WHERE country IN ("Afghanistan","Bangladesh","China");

-- 3a
ALTER TABLE actor
	ADD description BLOB;
    
-- 3b
ALTER TABLE actor
	DROP description;
    
-- 4a
SELECT last_name, COUNT(last_name) FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name) AS num FROM actor
GROUP BY last_name
HAVING num > 1;

-- 4c
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name="WILLIAMS";

-- 4d
	-- Backing up table in case of more than one Harpo Williams
CREATE TABLE copy AS
SELECT * FROM actor;
	-- Changing all Harpo Williams to Groucho Williams
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name="WILLIAMS";
	-- Dropping backup as it wasn't needed
DROP TABLE copy;

-- 5a
 -- One way to get schema information
 SELECT * FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'address';
 -- Another way
 SHOW CREATE TABLE address;
 
-- 6a
SELECT first_name, last_name, address, address2 FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

-- 6b
SELECT first_name, last_name, SUM(amount) FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY first_name;

-- 6c
SELECT title,
(SELECT COUNT(film_id) FROM film_actor WHERE film_actor.film_id = film.film_id) AS `Num Actors`
FROM film;

-- 6d
SELECT title, 
(SELECT COUNT(film_id) FROM inventory WHERE inventory.film_id = film.film_id) AS `available`
FROM film
WHERE title = "Hunchback Impossible";

-- 6e
SELECT first_name, last_name, SUM(amount) FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY first_name, last_name
ORDER BY last_name, first_name;

-- 7a
SELECT title
FROM film
WHERE (title LIKE "K%" OR title LIKE "Q%")
AND
language_id IN
(
	SELECT language_id
    FROM language
    WHERE name = "English"
);

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
    )
);

-- 7c
/* THOUGHT YOU WANT ACTUAL ADDRESSES. OOPS. CORRECT CODE BELOW.
SELECT first_name, last_name, address, city, country
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country = "Canada";
*/
SELECT first_name, last_name, email
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country = "Canada";

-- 7d
SELECT title
FROM film
WHERE film_id IN
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = "family"
    )
);

-- 7e
SELECT * FROM FILM ORDER BY rental_rate DESC;

-- 7f
SELECT SUM(amount) AS `total`, store_id
FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY store_id
ORDER BY total DESC;

-- 7g
SELECT store_id, city, country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;

-- 7h
SELECT name, SUM(amount) AS `gross`
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY gross DESC
LIMIT 5;

-- 8a
CREATE VIEW Top5
AS SELECT name, SUM(amount) AS `gross`
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY gross DESC
LIMIT 5;

-- 8b
SELECT * FROM top5;

-- 8c
DROP VIEW top5;