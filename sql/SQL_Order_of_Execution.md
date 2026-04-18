# SQL Logical Processing Order 

### The Execution Sequence:
1. **FROM / JOIN**: The database first identifies the tables and combines them.
2. **WHERE**: Filter rows based on specific conditions *before* grouping.
3. **GROUP BY**: Collapse rows into groups (e.g., by `city` or `candidate_id`).
4. **HAVING**: Filter the *groups* created in the previous step.
5. **SELECT**: Pick the specific columns and calculate expressions (like `SUM` or `CASE`).
6. **DISTINCT**: Remove duplicate results.
7. **ORDER BY**: Sort the final output.
8. **LIMIT / OFFSET**: Restrict the number of rows returned.


### Key Interview Insight:
**Why can't we use an alias created in `SELECT` inside a `WHERE` clause?**
Because the `WHERE` clause is executed in Step 2, but the `SELECT` (where the alias is born) doesn't happen until Step 5. The database literally doesn't know the alias exists yet!
