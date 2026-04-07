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

-- SQL Lesson 6: Multi-table queries with JOINs
-- Learnt how inner joins works -Primary keys of both tables should match

-- 1.Find the domestic and international sales for each movie ✓
SELECT Domestic_sales, international_sales, title FROM Boxoffice INNER JOIN movies where movie_id = id; 

-- 2.Show the sales numbers for each movie that did better internationally rather than domestically ✓
SELECT title, international_sales,domestic_sales FROM boxOffice INNER JOIN movies where movie_id = id and international_sales > domestic_sales;
-- Match the common attruibutes and required condition

-- 3.List all the movies by their ratings in descending order ✓
SELECT title, rating FROM movies INNER JOIN boxOffice where id = movie_id order by rating desc;

-- SQL Lesson 7: OUTER JOINs
-- 1.Find the list of all buildings that have employees ✓
SELECT DISTINCT building FROM employees;
-- 2.Find the list of all buildings and their capacity ✓
SELECT * FROM buildings;

-- 3.List all buildings and the distinct employee roles in each building (including empty buildings) ✓
-- left join = inner join + additional matching condition of left table
SELECT DISTINCT b.building_name, e.role 
FROM buildings as b
  LEFT JOIN employees as e   --left join becoz we want to include all buildings
    ON b.building_name = e.building;

-- SQL Lesson 8: A short note on NULLs
-- how to use null in the query
-- 1.Find the name and role of all employees who have not been assigned to a building ✓
SELECT e.name, e.role 
from employees as e
where e.building IS NULL
-- 2.Find the names of the buildings that hold no employees
Select DISTINCT b.building_name 
 from buildings as b 
 LEFT JOIN employees as e   --left join used becoz we want the names of  all building
ON b.building_name = e.Building
WHERE e.name IS NULL

-- SQL Lesson 9: Queries with expressions
-- how to use alias as keyword and how to do mathematical calculations in query
-- 1.List all movies and their combined sales in millions of dollars ✓
SELECT title, (domestic_sales + international_sales) / 1000000 AS combined_sales_millions
FROM movies
  JOIN boxoffice   --inner join used becoz all movies sales is given
    ON movies.id = boxoffice.movie_id;   --joining condition

-- 2.List all movies and their ratings in percent ✓
SELECT title, rating * 10 AS rating_percent   --if done (rating/10)*100 , then integer division can give error 
--avoid division if possible  ***if imp to do dividion do /10.0
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id;

--3. List all movies that were released on even number years ✓
Select title
from movies 
 where (year%2.0) = 0   Reaminder = 0 for even no years


-- SQL Lesson 10: Queries with aggregates (Pt. 1)
-- Using aggregate function(MAX,MIN,COUNT,AVG,SUM)
-- 1.Find the longest time that an employee has been at the studio ✓
SELECT MAX(years_employed)
from employees;

--Using GROUP BY to group same values in the rows
-- 2.For each role, find the average number of years employed by employees in that role ✓
SELECT role,AVG(years_employed)
from employees
GROUP BY role;

-- 3.Find the total number of employee years worked in each building ✓
SELECT building,SUM(years_employed)
from employees
GROUP BY building;

-- SQL Lesson 11: Queries with aggregates (Pt. 2)
-- Using HAVING clause with GROUP BY to filter grouped rows from result set

-- 1.Find the number of Artists in the studio (without a HAVING clause) ✓
SELECT COUNT(role) 
FROM employees
where role ="Artist";

--2.Find the number of Employees of each role in the studio ✓
SELECT role,COUNT(name)
FROM employees
GROUP BY role;

-- 3.Find the total number of years employed by all Engineers ✓
SELECT Sum(years_employed)
FROM employees
Group by role
having role = "Engineer"  --specified for the engineer role only count years

-- SQL Lesson 12: Order of execution of a Query
1.FROM JOIN 2. WHERE 3. GROUP BY 4.HAVING 5.SELECT 7.DISTINCT 6.ORDER BY 7.LIMIT/OFFSET

-- 1.Find the number of movies each director has directed ✓
SELECT COUNT(title), director
FROM movies
GROUP BY director;

-- 2.Find the total domestic and international sales that can be attributed to each director ✓
SELECT m.director, SUM(b.domestic_sales + b.international_sales) as Total_sales
FROM movies as m
JOIN boxoffice as b
 ON m.id = b.movie_id
GROUP BY director;

-- SQL Lesson 13: Inserting rows
-- INSERT INTO mytable
-- (column, another_column, …)
-- VALUES (value_or_expr, another_value_or_expr, …),
--       (value_or_expr_2, another_value_or_expr_2, …),
--       …;
-- 1.Add the studio's new production, Toy Story 4 to the list of movies (you can use any director) ✓
INSERT INTO movies
 (Title,Director,Year,Length_minute)
  VALUES ("Toy Story 4","Brad Bird",2026,106)

-- 2.Toy Story 4 has been released to critical acclaim! It had a rating of 8.7, and made 340 million domestically and 270 million internationally. Add the record to the BoxOffice table. ✓
INSERT INTO BoxOffice
(movie_id,rating,domestic_sales,international_sales)
 VALUES (15,8.7,340,270)


-- SQL Lesson 14: Updating rows
-- UPDATE mytable
-- SET column = value_or_expr, 
--     other_column = another_value_or_expr, 
--     …
-- WHERE condition;

-- 1.The director for A Bug's Life is incorrect, it was actually directed by John Lasseter ✓
UPDATE movies
 SET Director = "John Lasseter"
  WHERE id = 2;
-- 2.The year that Toy Story 2 was released is incorrect, it was actually released in 1999 ✓
UPDATE movies
 SET year = 1999
  WHERE id = 3;

-- 3.Both the title and director for Toy Story 8 is incorrect! The title should be "Toy Story 3" and it was directed by Lee Unkrich ✓
UPDATE movies
 SET title = "Toy Story 3",
     Director = "Lee Unkrich"
  WHERE id = 11;

  


