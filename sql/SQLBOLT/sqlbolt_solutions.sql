/* LESSON 1: SELECT Queries 101
Focus: Understanding the basic anatomy of a SELECT statement.
*/
-- 1. Get film titles
SELECT Title FROM movies;
-- 2. Find directors
SELECT director FROM movies;
-- 3. Find title and directors
SELECT title,director FROM movies;
-- 4. Find title and year
SELECT title,year FROM movies;
-- 5. Find all the information about each film
SELECT * FROM movies;

-- SQL Lesson 2: Queries with constraints (Pt. 1)
-- 1.Movie with a row id of 6 
SELECT title FROM movies where id=6;
-- 2. Movies released in the years between 2000 and 2010
SELECT title FROM movies where year between 2000 and 2010;
-- 3. Movies not released in the years between 2000 and 2010
SELECT title FROM movies where year not between 2000 and 2010;
-- 4. First 5 Pixar movies and their release year
SELECT title,year FROM movies where id BETWEEN 1 AND 5;

-- SQL Lesson 3: Queries with constraints (Pt. 2)
-- 1.Find all the Toy Story movies
SELECT title,director FROM movies where title LIKE "Toy Story%";
-- 2.Find all the movies directed by John Lasseter
SELECT title, director FROM movies WHERE director = "John Lasseter";
-- 3.Find all the movies (and director) not directed by John Lasseter
SELECT title, director FROM movies where director != "John Lasseter";
-- 4.Find all the WALL-* movies
SELECT title, director FROM movies where title LIKE "WALL-_"

-- SQL Lesson 4: Filtering and sorting Query results
-- 1.List all directors of Pixar movies (alphabetically), without duplicates
SELECT DISTINCT director FROM movies ORDER BY director asc;
-- 2.List the last four Pixar movies released (ordered from most recent to least)
SELECT title, director,year FROM movies ORDER BY year desc limit 4;
-- 3.List the first five Pixar movies sorted alphabetically
SELECT title, director,year FROM movies ORDER BY title asc limit 5;
-- 4.List the next five Pixar movies sorted alphabetically
SELECT title, director,year FROM movies ORDER BY title asc LIMIT 5 OFFSET 5;

-- SQL Review: Simple SELECT Queries
-- Review 1 — Tasks
-- 1.List all the Canadian cities and their populations
SELECT city,country,population FROM north_american_cities where country ="Canada";
-- 2.Order all the cities in the United States by their latitude from north to south
SELECT city,country,latitude FROM north_american_cities where country ="United States" order by latitude desc;
-- 3.List all the cities west of Chicago, ordered from west to east
SELECT city, longitude FROM north_american_cities WHERE longitude < -87.629798 ORDER BY longitude ASC;
-- 4.List the two largest cities in Mexico (by population)
Select city,Country,Population from North_american_cities where country ="Mexico" order by population desc LiMIT 2;
-- 5.List the third and fourth largest cities (by population) in the United States and their population
Select city,Country,Population from North_american_cities where country ="United States" order by population desc LiMIT 2  offset 2;