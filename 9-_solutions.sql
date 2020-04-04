--6.  You can use COUNT and GROUP BY to see how each party did in Scotland. Scottish constituencies start with 'S'. Show how many seats for each party in Scotland in 2017.

select party, COUNT(constituency) from
(SELECT constituency, party, RANK() OVER (partition by constituency ORDER BY votes DESC) as p
  FROM ge
 WHERE constituency LIKE 'S%' AND yr  = 2017) table_1
where p = 1
group by party

--or

select party, count(constituency) from
(select constituency, party from
(SELECT constituency, party, RANK() OVER (partition by constituency ORDER BY votes DESC) as p
  FROM ge
 WHERE constituency LIKE 'S%' AND yr  = 2017 ) as table_1
where p = 1) as table_2
group by party
