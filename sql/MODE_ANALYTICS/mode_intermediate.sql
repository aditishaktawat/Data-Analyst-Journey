-- TOPIC: SQL Fundamentals - Filtering & Sorting
-- LESSON: SELECT, WHERE, ORDER BY

-- 1.Write a query that selects the school name, player name, position, and weight for every player in Georgia, ordered by weight (heaviest to lightest). 
SELECT p.school_name,p.player_name,p.position,p.weight
   FROM benn.college_football_players as p  
     WHERE p.state ="GA"
     ORDER BY p.weight DESC;

/* BUSINESS INSIGHT:
A fitness brand could use this data to identify regions with higher average player weights, allowing them to specifically target those areas for gym memberships or diet programs.
*/

-- LESSON: SQL INNER JOIN: Syntax, Examples & Use Cases
-- 1.Write a query that displays player names, school names and conferences for schools in the "FBS (Division I-A Teams)" division.
SELECT players.player_name,
       players.school_name,
       teams.conference
  FROM benn.college_football_players AS players
  JOIN benn.college_football_teams AS teams
    ON teams.school_name = players.school_name
 WHERE teams.division = 'FBS (Division I-A Teams)';

 /* TECHNICAL INSIGHT:
 I used inner join because tye data that is common in both the tables was required
 */

-- LESSON: SQL Outer Joins: LEFT, RIGHT, FULL OUTER
-- The Crunchbase dataset
1.Write a query that performs an inner join between the tutorial.crunchbase_acquisitions table and the tutorial.crunchbase_companies table, but instead of listing individual rows, count the number of non-null rows in each table.
SELECT  COUNT(companies.permalink),
 COUNT(acquisitions.company_permalink)
FROM tutorial.crunchbase_companies AS companies   
JOIN tutorial.crunchbase_acquisitions AS acquisitions     
ON companies.permalink = acquisitions.company_permalink

/* INSIGHT:
This query checks how many companies actually have acquisition data. By counting the matched rows, I ensured we have a clean dataset before diving into deeper analysis.
*/


-- 2.Modify the query above to be a LEFT JOIN. Note the difference in results.
SELECT  COUNT(companies.permalink),
 COUNT(acquisitions.company_permalink)
FROM tutorial.crunchbase_companies AS companies   
LEFT JOIN tutorial.crunchbase_acquisitions AS acquisitions     
ON companies.permalink = acquisitions.company_permalink

/* INSIGHT:
This shows that LEFT JOIN includes all the data of left_table + matching records from bo6th tables.
*/



