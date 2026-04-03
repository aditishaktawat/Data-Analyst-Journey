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