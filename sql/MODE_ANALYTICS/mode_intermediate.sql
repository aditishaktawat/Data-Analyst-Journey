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

-- 3.* Count the number of unique companies (don't double-count companies) and unique acquired companies by state. Do not include results for which there is no state data, and order by the number of acquired companies from highest to lowest.
SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_companies_acquired
  FROM tutorial.crunchbase_companies companies
  -- We use LEFT JOIN so we don't lose companies that were NEVER acquired
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1 -- Groups by state_code
 ORDER BY 3 DESC; -- Orders by the 3rd column (unique_companies_acquired)

-- Same query using right join
  SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS acquired_companies
  FROM tutorial.crunchbase_acquisitions acquisitions
 RIGHT JOIN tutorial.crunchbase_companies companies
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1
 ORDER BY 3 DESC
