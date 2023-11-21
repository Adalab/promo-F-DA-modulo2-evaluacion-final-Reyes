USE sakila; 

#1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film; 

#2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"

SELECT title
FROM film
WHERE rating ="PG-13";

#3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description 
FROM film
WHERE description LIKE '%amazing%'; 

 #4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
 
 SELECT title
 FROM film 
 WHERE length > 120; 
 
 #5. Recupera los nombres de todos los actores.
 
 SELECT first_name
 FROM actor; 
 
 #6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
 
 SELECT first_name AS Nombre, last_name AS Apellido
 FROM actor 
 WHERE last_name LIKE '%Gibson%'; 
 
 #7 Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
 
 SELECT first_name AS Nombre
 FROM actor 
 WHERE actor_id BETWEEN 10 AND 20; 
 
 #8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
 
SELECT title
FROM film
WHERE rating NOT IN ('PG-13', 'R');

#9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(film_id) AS total_peliculas
FROM film
GROUP BY rating; 

#10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT *
FROM customer AS c
INNER JOIN rental AS r
ON c.customer_id=r.customer_id;

#LA SOLUCION DEL EJERCICIO 10 ES EL SIGUIENTE BLOQUE DE CÓDIGO:

SELECT c.first_name AS Nombre, c.last_name AS Apellido, c.customer_id,  COUNT(rental_id) AS Total_alquileres
FROM customer AS c
INNER JOIN rental AS r
ON c.customer_id=r.customer_id
GROUP BY c.customer_id;

#11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

#Uno todas las tablas que necesito para extraer la información por las columnas comunes, sumo el id de los alquileres que es la PK y por tanto valor único, y agrupo por nombre de la categoría. 

SELECT c.name AS Nombre_categoria, SUM(rental_id) AS Total_Alquileres
FROM rental AS r
INNER JOIN inventory AS i
ON r.inventory_id=i.inventory_id
INNER JOIN film AS f
ON i.film_id=f.film_id
INNER JOIN film_category AS f_c
ON f.film_id=f_c.film_id
INNER JOIN category AS c
ON f_c.category_id=c.category_id
GROUP BY Nombre_categoria; 

#12.Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT AVG(length) AS Promedio_duracion, rating
FROM film
GROUP BY rating; 

#13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM film AS f
INNER JOIN film_actor as f_a
ON f.film_id=f_a.film_id
INNER JOIN actor AS a
ON f_a.actor_id=a.actor_id
WHERE f.title = "Indian Love";

#14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

#15. ¿Hay algún actor que no aparece en ninguna película en la tabla film_actor?

#Solo quiero los actores de la tabla actor que no tengan correspondencia en la tabla film_actor, quiero compararlos todos por lo que aplico un LEFT JOIN. Además incluyo
#la condición de que me devuelva los nulos para los valores de la tabla film_actor

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor AS a
LEFT JOIN film_actor as fa
ON a.actor_id=fa.actor_id
WHERE fa.actor_id IS NULL; 

#16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT DISTINCT title
FROM film 
WHERE release_year BETWEEN 2005 AND 2010; 

#17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT category_id
FROM category
WHERE name="Family";

SELECT *
FROM film_category 
WHERE category_id=8; 

SELECT *
FROM film 
INNER JOIN film_category
ON film.film_id=film_category.film_id
WHERE category_id=8;

SELECT f.title, fc.category_id, c.name 
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id=fc.film_id
INNER JOIN category AS c
ON fc.category_id=c.category_id
WHERE fc.category_id IN 
	(SELECT category_id 
		FROM category 
        WHERE name= "Family");

#LA SOLUCIÓN DEL EJERCICIO 17 ES EL SIGUIENTE BLOQUE DE CÓDIGO:

SELECT f.title
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id=fc.film_id
INNER JOIN category AS c
ON fc.category_id=c.category_id
WHERE fc.category_id IN 
	(SELECT category_id 
		FROM category 
        WHERE name= "Family");
        
#18.Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT *
FROM film_actor AS fa
INNER JOIN actor AS a
ON fa.actor_id=a.actor_id;

#Cuento el numero de id de peliculas (PK, valor único) para luego incluirlo como condición y las agrupo para cada actor 
SELECT COUNT(fa.film_id) AS Numero_peliculas, a.first_name, a.last_name
FROM film_actor AS fa
INNER JOIN actor AS a
ON fa.actor_id=a.actor_id
GROUP BY a.actor_id;

#LA SOLUCIÓN DEL EJERCICIO 18 ES EL SIGUIENTE BLOQUE DE CÓDIGO:

SELECT a.first_name AS Nombre, a.last_name as Apellido
FROM actor AS a
INNER JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id)> 10;

#19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
FROM film 
WHERE rating = 'R' AND length >120;

#20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración

#Echo un vistazo a la unión de todas las tablas que necesito: 

SELECT *
FROM category AS c
INNER JOIN film_category AS fc
ON c.category_id=fc.category_id
INNER JOIN film AS f
ON fc.film_id=f.film_id; 

#Agrupo la información por el ID de categoría y saco la media de la duración de peliculas por categoría: 

SELECT c.name AS Nombre_categoria, AVG (f.length)
FROM category AS c
INNER JOIN film_category AS fc
ON c.category_id=fc.category_id
INNER JOIN film AS f
ON fc.film_id=f.film_id
GROUP BY c.category_id; 

#LA SOLUCIÓN DEL EJERCICIO 20 ES EL SIGUIENTE BLOQUE DE CÓDIGO:

SELECT c.name AS Nombre_categoria, AVG(f.length) AS Promedio_duracion
FROM category AS c
INNER JOIN film_category AS fc
ON c.category_id=fc.category_id
INNER JOIN film AS f
ON fc.film_id=f.film_id
GROUP BY c.category_id
HAVING AVG(f.length)>120;

#21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name AS Nombre, a.last_name AS Apellido, COUNT(f.film_id) AS Peliculas_actuadas
FROM actor AS a
INNER JOIN film_actor AS fa
ON a.actor_id=fa.actor_id
INNER JOIN film as f 
ON fa.film_id=f.film_id
GROUP BY a.actor_id
HAVING COUNT(f.film_id)>5; 

#22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
#Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

#La resta natural de las columnas me devolvía valores por debajo de 5 días, internet me regaló la función DATEDIFF para solucionar ese problema. 

SELECT rental_id
FROM rental 
WHERE DATEDIFF(return_date,rental_date)>5;

SELECT f.title, r.rental_date, r.return_date
FROM rental AS r
INNER JOIN inventory AS i
ON r.inventory_id=i.inventory_id
INNER JOIN film AS f 
ON i.film_id=f.film_id;

#LA SOLUCIÓN DEL EJERCICIO 22 ES EL SIGUIENTE BLOQUE DE CÓDIGO:

#Agrupamos por título porque un mismo título, está en diferentes tiendas y hay diferentes ejemplares, por lo que si no agrupamos nos devuelve repetidas 
#tantos valores como veces se haya alquilado cada ejemplar y haya tardado en devolverse más de 5 días.

SELECT f.title
FROM rental AS r
INNER JOIN inventory AS i
ON r.inventory_id=i.inventory_id
INNER JOIN film AS f 
ON i.film_id=f.film_id
WHERE r.rental_id IN 
			(SELECT rental_id
				FROM rental 
				WHERE DATEDIFF(return_date,rental_date)>5)
GROUP BY f.title; 
                
#23.Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
# Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

#Aquí tengo todos los actores que salen en las películas de categoría Horror: 

SELECT a.first_name, a.last_name, c.name
FROM actor AS a 
INNER JOIN film_actor AS fa
ON a.actor_id=fa.actor_id 
INNER JOIN film AS f
ON fa.film_id=f.film_id
INNER JOIN film_category AS fc
ON f.film_id=fc.film_id
INNER JOIN category AS c
ON fc.category_id=c.category_id
WHERE c.name='Horror'; 

#Para excluirlos de la lista y que solo me devuelvan los que NO salen en Horror uso la cláusula NOT IN con la condición anterior

#LA SOLUCIÓN DEL EJERCICIO 23 ES EL SIGUIENTE BLOQUE DE CÓDIGO:

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor
WHERE actor_id NOT IN (SELECT  fa.actor_id
						FROM film_actor as fa
                        INNER JOIN film AS f
						ON fa.film_id=f.film_id
						INNER JOIN film_category AS fc
						ON f.film_id=fc.film_id
						INNER JOIN category AS c
						ON fc.category_id=c.category_id
						WHERE c.name='Horror');


#24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT f.title
FROM film AS f
INNER JOIN film_category AS fc
ON f.film_id=fc.film_id
INNER JOIN category AS c
ON fc.category_id=c.category_id
WHERE c.name="Comedy" and f.length >180; 

