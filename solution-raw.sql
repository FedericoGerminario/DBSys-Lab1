--Ex. 2.4.1 
--For each type of publication, count the total number of publications of that type. Your query should
--return a set of (publication-type, count) pairs. For example (article, 20000), (inproceedings, 30000),
--... (not the real answer) 

SELECT p AS Publication, count(p) AS totPublication FROM Pub GROUP BY p;

/*
  publication  | totpublication 
---------------+----------------
 article       |        2685596
 book          |          19019
 incollection  |          67439
 inproceedings |        2904087
 mastersthesis |             12
 phdthesis     |          81781
 proceedings   |          48670
 www           |        2854130
(8 rows)
*/



--Ex. 2.4.2 
--We say that a field ‘occurs’ in a publication type, if there exists at least one publication of that type
--having that field. For example, ‘publisher occurs in incollection’, but ‘publisher does not occur in
--inproceedings’ (because no inproceedings entry has a publisher field). Find the fields that occur in
--all publications types. Your query should return a set of field names: for example it may return title,
--if title occurs in all publication types (article, inproceedings, etc. notice that title does not have to
--occur in every publication instance, only in some instance of every type), but it should not return
--publisher (since the latter does not occur in any publication of type inproceedings) 

SELECT tables.fields AS Fields
FROM( SELECT DISTINCT p.p AS publication, f.p AS fields FROM Pub p, Field f WHERE p.k = f.k
      ) AS tables
GROUP BY tables.fields
HAVING count(*) >= (SELECT count(distinct p.p) FROM Pub p);

/*
 fields 
--------
 author
 ee
 note
 title
 year
(5 rows)
*/


