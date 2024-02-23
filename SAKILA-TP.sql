USE `sakila`;


#I. Opération CRUD : C pour Create

#1) Film : Pulp-Fiction / 1994 / langue française Pierrot Le fou / 1965 
-- / langue française / durée 01:55

INSERT INTO `film` (`title`, `release_year`, `language_id`) 
SELECT 'Pulp-Fiction' , '1994' , language_id
FROM language 
WHERE name = 'French';

INSERT INTO `film` (`title`, `release_year`, `language_id`, `length`) 
SELECT 'Pierrot Le fou', '1965', language_id , 115
FROM language 
WHERE name = 'French';

#2) Ajouter une table ‘director’ avec 5 champs : 
-- ‘director_id’, ‘first_name’, ‘last_name’, ‘description’ et ‘birth_date’. Cette table aura 
-- une relation (n,m) avec la table film – la table de jointure s’appellera ‘film_director’

CREATE TABLE sakila.director (
  director_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  descrip_tion TEXT,
  birth_date DATE
);

CREATE TABLE sakila.film_director (
  film_id SMALLINT(5) UNSIGNED NOT NULL,
  director_id INT NOT NULL,
  PRIMARY KEY (film_id, director_id),
  FOREIGN KEY (film_id) REFERENCES sakila.film (film_id),
  FOREIGN KEY (director_id) REFERENCES sakila.director (director_id)
);

#3)Ajouter les réalisateurs suivants : (prénom, nom, date de naissance, description) 
-- Quentin / Tarantino / 27 mars 1953 / Grand réalisateur..., 
-- Jean-Luc / Godard / / Réalisateur français

INSERT INTO director (`director_id`, `first_name`, `last_name`, `description`, `birth_date`) values (NULL, 'Quentin', 'Tarantino', 'Grand réalisateur', '1953-03-27');
SELECT *
FROM director;

#4) Genre : Insérer en une seule requête : Humour, Tragédie, Policier, Historique, 
-- Romance, Amour, Thriller

insert into category (`name`) values
('Humour'), ('Tragédie'), ('Policier'), ('Historique'),
('Romance'), ('Amour'), ('Thriller');

#5) Acteur : John / Travolta / 18 février 1954 Samuel / Lee Jackson / 21 décembre 1948

alter table actor 
	add column (`birth_date` DATE NULL);
    
INSERT INTO actor VALUES 
(NULL, 'John', 'Travolta', '2006-02-15 04:34:33'),
(NULL, 'Samuel', 'Lee Jackson', '2006-02-15 04:34:33');

#6) Associer Pulp fiction à Quentin Tarantino, Samuel L Jackson, John Travolta 
-- et au genre Policier et Thriller

insert into actor (`first_name`, `last_name`) values
('QUENTIN', 'TARANTINO');

INSERT INTO film_actor (`actor_id`, `film_id`)
select actor_id, film_id
from actor, film
where  (actor.first_name = 'QUENTIN' and actor.last_name = 'TARANTINO') and
 film.title = 'Pulp-Fiction';

INSERT INTO film_actor (`actor_id`, `film_id`)
select actor_id, film_id
from actor, film
where (actor.first_name = 'SAMUEL' and actor.last_name = 'LEE JACKSON') and
 film.title = 'Pulp-Fiction';
 
INSERT INTO film_actor (`actor_id`, `film_id`)
select actor_id, film_id
from actor, film
where (actor.first_name = 'JOHN' and actor.last_name = 'TRAVOLTA') and
 film.title = 'Pulp-Fiction';
 
INSERT INTO film_category (`film_id`, `category_id`)
select film_id, category_id
from film, category
where film.title = 'Pulp-Fiction' and category.name = 'Policier';
 
INSERT INTO film_category (`film_id`, `category_id`)
select film_id, category_id
from film, category
where film.title = 'Pulp-Fiction' and category.name = 'Thriller';

#7) Insérer en base le fait que le client « Alain Proviste » a loué le film 
-- « Pulp fiction » dans le magasin n°1.

INSERT INTO rental VALUES 
(CURRENT_TIMESTAMP, 
 (SELECT inventory_id FROM inventory WHERE film_id = 
 (SELECT film_id FROM film WHERE title = 'Pulp Fiction') AND store_id = 1 LIMIT 1),
 (SELECT customer_id FROM customer WHERE first_name = 'Alain' AND last_name = 'Proviste'),
 NULL, 1);

INSERT INTO rental VALUES 
(CURRENT_TIMESTAMP,  (SELECT inventory_id FROM inventory  
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Pulp Fiction') 
AND store_id = 1 LIMIT 1),
 (SELECT customer_id FROM customer WHERE first_name = 'Alain' AND last_name = 'Proviste'),
 NULL, 1,   CURRENT_TIMESTAMP);




#II. Opération CRUD : R pour Read

#Sélectionnez : 1) Tous les films
SELECT * FROM film;

#2) Tous les films en affichant uniquement leur nom et leur année de sortie
SELECT title, release_year FROM film;

#3) Tous les acteurs en affichant leur nom et prénom triés par nom alphabétique
SELECT last_name, first_name FROM actor ORDER BY last_name ASC;

#4) Tous les acteurs triés par id décroissant
SELECT * FROM actor ORDER BY actor_id DESC;

#5) Tous les acteurs en affichant leur nom et leur date de modification triés 
-- par date de modification (les modifiés les plus récemment d'abord)
SELECT last_name, first_name, last_update FROM actor ORDER BY last_update DESC;

#6) Tous les films dont la durée est comprise entre 1h30 et 1h45
SELECT * FROM film WHERE length BETWEEN 90 AND 105;
#90min=1h30min et 105min=1h45min

#7) Donner le nombre de films sortis dont la durée est comprise entre 1h30 et 1h45
SELECT COUNT(*) FROM film WHERE length BETWEEN 90 AND 105;

#8) Renvoyer uniquement le dernier film sorti
SELECT * FROM film ORDER BY last_update DESC LIMIT 1;




#III. Opération CRUD : U pour Update

#Mettez à jour : 1) Films : Pulp fiction en ajoutant le synopsis : 
-- "L'odyssée sanglante et burlesque de petits malfrats dans la jungle de Hollywood 
-- à travers trois histoires qui s'entremêlent. "

UPDATE film 
SET description = 'Lodyssée sanglante et burlesque de petits malfrats 
dans la jungle de Hollywood à travers trois histoires qui sentremêlent.' 
WHERE title = 'Pulp Fiction';

#2) Réalisateur : Jean-Luc Godard en mettant sa date de naissance

UPDATE director 
SET birth_date = '1930-12-03' WHERE first_name = 'Jean-Luc' AND last_name = 'Godard';

#3) Acteur : Samuel Lee Jackson en supprimant sa date de naissance et 
-- en ajoutant sa pointure 42

ALTER TABLE actor ADD shoe_size INT;
UPDATE actor 
SET birth_date = NULL, shoe_size = 42
WHERE first_name = 'Samuel' AND last_name = 'Lee Jackson';

#4) Langue originale : Changez la valeur de la langue originale en suivant ces critères : 
-- o Identifiant compris entre [97 et 215] : 5 ; 
-- o Identifiant compris entre [421 et 467] : 4 ; 
-- o Identifiant compris entre [632 et 927] : 3.

-- Pour les films dont l'identifiant est compris entre 97 et 215
UPDATE film 
SET original_language_id = 5
WHERE film_id BETWEEN 97 AND 215;

-- Pour les films dont l'identifiant est compris entre 421 et 467
UPDATE film 
SET original_language_id = 4
WHERE film_id BETWEEN 421 AND 467;

-- Pour les films dont l'identifiant est compris entre 632 et 927
UPDATE film 
SET original_language_id = 3
WHERE film_id BETWEEN 632 AND 927;




#IV. Opération CRUD : D pour Delete

#Supprimez : 1) Le client qui a loué un exemplaire de Pulp Fiction.
delete from customer
where customer_id in (
	select customer_id
	from inventory i 
	join rental r
	on i.inventory_id=r.inventory_id
	where i.film_id in (
		select film_id
        from film
        where title='Pulp-Fiction'
        )
);


#2) Cela ne fonctionne pas. Pourquoi ?

-- car la ligne primaire ne peux etre supprimer

#3) Supprimer la location concernant ce client et le film Pulp Fiction
delete from rental
where rental_id in (
	select rental_id
	from inventory i 
	join rental r
	on i.inventory_id=r.inventory_id
	where i.film_id in (
		select film_id
        from film
        where title='Pulp-Fiction'
        )
);

#4) Supprimer le genre « Romance »

DELETE FROM genre WHERE name = 'Romance';




#V. Jointures

#1) Afficher tous les films avec leur langue originale
SELECT title, name
from film 
join language
on film.film_id = language.language_id;

#2) Sélectionner tous les films dont la langue originale est le français
SELECT title, name
from film
join language 
on film.film_id = language.language_id
where language.name='French';

#3) Idem en utilisant un alias (ex : FROM film AS f)
SELECT f.title
FROM film AS f
JOIN language AS l ON f.language_id = l.language_id
WHERE l.name = 'French';

#4) Idem en utilisant un alias sans le AS
SELECT f.title
FROM film f
JOIN language l ON f.language_id = l.language_id
WHERE l.name = 'French';

#5) Utiliser le nom de la langue dans la clause WHERE au lieu de l'id
SELECT f.title
FROM film f
JOIN language l ON f.language_id = l.language_id
WHERE l.name = 'French';

 #6) Sélectionner tous les films de science-fiction triés 
 -- par titre par ordre alphabétique décroissant
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Science-Fiction'
ORDER BY f.title DESC;




#VI. Requêtes en vrac

#1) Quels acteurs ont pour prénom ‘SCARLETT ?
SELECT first_name, last_name FROM actor WHERE first_name = 'Scarlett';

#2) Quels acteurs ont le nom de famille qui contient ‘JOHANSSON ?
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%Johansson%';

#3) Combien y-a-t-il de noms de famille d’acteurs différents ?
SELECT COUNT(DISTINCT last_name) FROM actor;

#4) Quels sont les noms de famille d’acteurs uniques ?
SELECT DISTINCT last_name FROM actor ORDER BY last_name;

#5) Quels sont les noms de famille d’acteurs qui apparaissent plus d’une fois ?
SELECT last_name 
FROM actor 
GROUP BY last_name 
HAVING COUNT(last_name) > 1;

#6) Quel acteur apparait dans le plus de films ?
SELECT actor.last_name, COUNT(*) as 'NombreFilms'
from actor
JOIN film_actor  ON actor.actor_id = film_actor.actor_id
GROUP BY actor.last_name
ORDER BY 'NombreFilms' DESC
LIMIT 1;

#7) Quelle est la durée moyenne de tous les films ?
SELECT AVG(length) FROM film ;
-- avg= average = moyenne

#8) Quelle est la durée moyenne des films groupés par catégorie ?
SELECT c.name AS category_name, AVG(f.length) AS average_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id
ORDER BY average_length DESC;


