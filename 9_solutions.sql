--1. How many stops are in the database.

SELECT COUNT(id) AS stops FROM stops;

--2 Find the id value for the stop 'Craiglockhart'

SELECT stop FROM route JOIN stops ON id = stop WHERE stops.name = 'Craiglockhart' GROUP BY stop;

--3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT DISTINCT stop, stops.name FROM route JOIN stops ON stop = stops.id WHERE num = 4 AND company = 'LRT';

--4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num HAVING COUNT(*) = 2;

--5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149;

--6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road';

--7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT DISTINCT a.company, a.num FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Haymarket' AND stopb.name='Leith'; 

--8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT DISTINCT a.company, a.num 
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' 
AND stopb.name='Tollcross'; 

--or

SELECT distinct a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
JOIN stops on stops.id = a.stop
where a.stop IN (select stops.id from stops where stops.name = 'Craiglockhart')
and b.stop IN (select stops.id from stops where stops.name = 'Tollcross')

--9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

SELECT stopb.name, a.company, a.num FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND a.company = 'LRT' ;

--or

SELECT distinct d.name, a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
JOIN stops c on c.id = a.stop
JOIN stops d on d.id= b.stop
where a.company = 'LRT' and
c.name = 'Craiglockhart'

--10. Find the routes involving two buses that can go from Craiglockhart to Lochend. 
--Show the bus no. and company for the first bus, the name of the stop for the transfer, 
--and the bus no. and company for the second bus.

select T1.num fn, 
		T1.company fc, 
		stops.name transfer, 
		T2.num tn, 
		T2.company tc 
		
	from
		(
		select * from route where (num, company) IN 
			(
				SELECT DISTINCT num, company
				FROM route
				JOIN stops ON stop = id
				WHERE name='Craiglockhart'  )) T1

		JOIN

		(
		select * from route where (num, company) IN 
			(
				SELECT DISTINCT num, company
				FROM route
				JOIN stops ON stop = id
				WHERE name='Lochend')) T2

			on T1.stop = T2.stop

		JOIN stops on stops.id = T1.stop
		order by fn, fc, transfer, tn
