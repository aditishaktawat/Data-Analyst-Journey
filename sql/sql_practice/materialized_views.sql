/*
Materialized Views -
 - Stores the query as well as the data returned from that query.
 - Improves the performance of query

*/

Create table random_tab (id int, random_val decimal);

insert into random_tab 
Select 1, random() from generate_series(1,10000000);

Select *
from random_tab;

insert into random_tab
Select 2, random() from generate_series(1, 10000000);

Select id, avg(random_val), count(1)
From random_tab
group by id;

-- Materialized View

create materialized view mv_random_tab 
as
Select id, avg(random_val), count(1)
From random_tab
group by id;

Select * from mv_random_tab;

Delete from random_tab where id = 1;

-- Need to manually refresh the materialized view after any modification in the table done because it stores the data at the time of its creation.

refresh materialized view mv_random_tab;

