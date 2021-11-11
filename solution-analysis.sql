--Ex 4.1.1 Find the top 20 authors with the largest number of publications 

SELECT name, SUM(1) AS numberOfPubblication
    FROM Author a, Authored au, Publication p
    WHERE a.id = au.id and p.pubid = au.pubid
    GROUP BY (name)
    ORDER BY numberOfPubblication DESC
    LIMIT 20;

/*
         name         | numberofpubblication 
----------------------+----------------------
 H. Vincent Poor      |                 2317
 Mohamed-Slim Alouini |                 1766
 Philip S. Yu         |                 1631
 Wei Zhang            |                 1592
 Wei Wang             |                 1561
 Yu Zhang             |                 1504
 Lajos Hanzo          |                 1486
 Yang Liu             |                 1481
 Lei Zhang            |                 1387
 Lei Wang             |                 1337
 Xin Wang             |                 1337
 Zhu Han              |                 1337
 Victor C. M. Leung   |                 1323
 Wen Gao 0001         |                 1317
 Dacheng Tao          |                 1279
 Hai Jin 0001         |                 1274
 Witold Pedrycz       |                 1263
 Wei Li               |                 1250
 Jun Wang             |                 1229
 Luca Benini          |                 1199
(20 rows)
*/



--EX 4.1.2 Find the top 20 authors with the largest number of publications in STOC. Repeat this for one more
--conferences of your choice (e.g.: SIGMOD or VLDB, careful with spelling the name of the conference)
--Here I assume to consider a stoc conference every pub key with the value conf/stoc in it
SELECT name, SUM(1) as totalNumberOfPublication
FROM Author a, Authored au, Publication p
WHERE a.id = au.id and p.pubid = au.pubid and p.pubkey LIKE 'conf/stoc%' 
GROUP BY (name)
ORDER BY totalNumberOfPublication DESC
LIMIT 20;

/*
           name            | totalnumberofpublication 
---------------------------+--------------------------
 Avi Wigderson             |                       58
 Robert Endre Tarjan       |                       33
 Ran Raz                   |                       30
 Noam Nisan                |                       29
 Moni Naor                 |                       29
 Uriel Feige               |                       28
 Rafail Ostrovsky          |                       27
 Santosh S. Vempala        |                       27
 Venkatesan Guruswami      |                       26
 Mihalis Yannakakis        |                       26
 Frank Thomson Leighton    |                       25
 Oded Goldreich 0001       |                       25
 Prabhakar Raghavan        |                       24
 Mikkel Thorup             |                       24
 Christos H. Papadimitriou |                       24
 Moses Charikar            |                       23
 Yin Tat Lee               |                       23
 Rocco A. Servedio         |                       22
 Madhu Sudan               |                       22
 Noga Alon                 |                       22
(20 rows)

*/

SELECT name, SUM(1) as totalNumberOfPublication
FROM Author a, Authored au, Publication p
WHERE a.id = au.id and p.pubid = au.pubid and p.pubkey LIKE 'conf/vldb%'
GROUP BY (name)
ORDER BY totalNumberOfPublication DESC
LIMIT 20;

/*
         name          | totalnumberofpublication 
-----------------------+--------------------------
 H. V. Jagadish        |                       35
 Raghu Ramakrishnan    |                       30
 David J. DeWitt       |                       29
 Michael Stonebraker   |                       28
 Rakesh Agrawal 0001   |                       27
 Hector Garcia-Molina  |                       27
 Jeffrey F. Naughton   |                       27
 Surajit Chaudhuri     |                       26
 Michael J. Carey 0001 |                       26
 Christos Faloutsos    |                       25
 Gerhard Weikum        |                       25
 Divesh Srivastava     |                       24
 Nick Koudas           |                       22
 Abraham Silberschatz  |                       22
 Michael J. Franklin   |                       22
 Alfons Kemper         |                       22
 Philip A. Bernstein   |                       21
 Jiawei Han 0001       |                       21
 Philip S. Yu          |                       21
 Jennifer Widom        |                       20
(20 rows)
*/


--Ex4.1.3
--Two of the major database conferences are ‘PODS’ (theory) and ‘SIGMOD Conference’ (systems).
--Find (a) all authors who published at least 10 SIGMOD papers but never published a PODS paper,
--and (b) all authors who published at least 5 PODS papers but never published a SIGMOD paper [2
--points].

SELECT name FROM 
    (SELECT name, CASE 
    WHEN p.pubkey LIKE '%conf/pods%' THEN 1 
    ELSE 0 END AS pods,
    CASE
    WHEN p.pubkey LIKE '%conf/sigmod%' THEN 1
    ELSE 0 END AS sigmod
    FROM Author a, Authored au, Publication p 
    WHERE a.id = au.id AND p.pubid = au.pubid) AS tablenew
GROUP BY (name)
HAVING (SUM(pods) >= 5 AND SUM(sigmod) = 0);

/*
         name           
-------------------------
 Alan Nash
 Andreas Pieris
 Cristian Riveros
 David P. Woodruff
 Domagoj Vrgoc
 Eljas Soisalon-Soininen
 Francesco Scarcello
 Giuseppe De Giacomo
 Hubie Chen
 Jef Wijsen
 Kari-Jouko Räihä
 Kobbi Nissim
 Marco A. Casanova
 Marco Console
 Martin Grohe
 Matthias Niewerth
 Michael Mitzenmacher
 Miguel Romero 0001
 Mikolaj Bojanczyk
 Nancy A. Lynch
 Nicole Schweikardt
 Nofar Carmeli
 Rasmus Pagh
 Reinhard Pichler
 Srikanta Tirthapura
 Stavros S. Cosmadakis
 Thomas Schwentick
 Vassos Hadzilacos
(28 rows)
*/

SELECT name FROM 
    (SELECT name, CASE 
    WHEN p.pubkey LIKE 'conf/pods%' THEN 1 
    ELSE 0 END AS pods,
    CASE
    WHEN p.pubkey LIKE '%conf/sigmod%' THEN 1
    ELSE 0 END AS sigmod
    FROM Author a, Authored au, Publication p 
    WHERE a.id = au.id AND p.pubid = au.pubid) AS tablenew
GROUP BY (name)
HAVING (SUM(sigmod) >= 10 AND SUM(pods) =0);

/*
          name            
---------------------------
 Aaron J. Elmore
 Abolfazl Asudeh
 Aditya G. Parameswaran
 Ahmed K. Elmagarmid
 Alexandros Labrinidis
 Alfons Kemper
 Alvin Cheung
 Anastasia Ailamaki
 Andrew Pavlo
 AnHai Doan
 Anisoara Nica
 Anthony K. H. Tung
 Arash Termehchy
 Arun Kumar 0001
 Ashraf Aboulnaga
 Badrish Chandramouli
 Barzan Mozafari
 Bin Cui 0001
 Bingsheng He
 Bolin Ding
 Boon Thau Loo
 Boris Glavic
 Bruce G. Lindsay 0001
 Byron Choi
 Carlo Curino
 Carlos Ordonez 0001
 Carsten Binnig
 Ce Zhang 0001
 Chee Yong Chan
 Chengkai Li
 Christian S. Jensen
 Clement T. Yu
 Cong Yu 0001
 Daniel J. Abadi
 David B. Lomet
 Dimitrios Tsoumakos
 Dirk Habich
 Donald Kossmann
 Elke A. Rundensteiner
 Eric Lo 0001
 Eugene Wu 0002
 Fatma Özcan
 Feifei Li 0001
 Gang Chen 0001
 Gao Cong
 Gautam Das 0001
 Georgia Koutrika
 Goetz Graefe
 Guoliang Li 0001
 Guy M. Lohman
 Hans-Arno Jacobsen
 Ihab F. Ilyas
 Immanuel Trummer
 Ioana Manolescu
 Ion Stoica
 James Cheng
 Jayavel Shanmugasundaram
 Jeffrey Xu Yu
 Jens Teubner
 Jianhua Feng
 Jianliang Xu
 Jiannan Wang
 Jian Pei
 Jiawei Han 0001
 Jignesh M. Patel
 Jim Gray 0001
 Jingren Zhou
 Jorge-Arnulfo Quiané-Ruiz
 José A. Blakeley
 Juliana Freire
 Jun Yang 0001
 Kaushik Chakrabarti
 Kevin Chen-Chuan Chang
 Kevin S. Beyer
 Krithi Ramamritham
 K. Selçuk Candan
 Lawrence A. Rowe
 Lei Chen 0002
 Lei Zou 0001
 Lijun Chang
 Louiqa Raschid
 Luis Gravano
 Lu Qin
 Martin L. Kersten
 Meihui Zhang
 Michael J. Cafarella
 Michael Stonebraker
 Mohamed F. Mokbel
 Mourad Ouzzani
 M. Tamer Özsu
 Nan Tang 0001
 Nan Zhang 0004
 Nectarios Koziris
 Nick Roussopoulos
 Nicolas Bruno
 Olga Papaemmanouil
 Peter A. Boncz
 Peter Bailis
 Qiong Luo 0001
 Rajasekar Krishnamurthy
 Raymond Chi-Wing Wong
 Sailesh Krishnamurthy
 Samuel Madden
 Sanjay Krishnan
 Sebastian Schelter
 Shuigeng Zhou
 Sihem Amer-Yahia
 Sourav S. Bhowmick
 Stanley B. Zdonik
 Stefano Ceri
 Stratos Idreos
 Sudipto Das
 Suman Nath
 Themis Palpanas
 Theodoros Rekatsinas
 Tilmann Rabl
 Tim Kraska
 Torsten Grust
 Ugur Çetintemel
 Vasilis Vassalos
 Viktor Leis
 Vladislav Shkapenyuk
 Volker Markl
 Wei Wang 0011
 Wook-Shin Han
 Xiaofang Zhou 0001
 Xiaokui Xiao
 Xifeng Yan
 Xin Luna Dong
 Xu Chu
 Yanlei Diao
 Yinan Li
 Yinghui Wu
 Zhenjie Zhang
 Zhifeng Bao
(135 rows)

*/




--My assumption in this exercise is that every year is present at least one publication otherwise the code should be changed with a sequence of elements and that the I consider all decades
--also the one not already finished, which gives a partial result over the next year, with the current data
--if there were two different authors for the same year I keep both of them in the final ranking
CREATE TABLE years AS
    SELECT MIN(year) as beginYear, year + 9 as end_year FROM PUBLICATION GROUP BY (year);



CREATE TABLE authorYear AS
SELECT name, year, 1 as numPublication
    FROM  Author a, Authored au, Publication p 
    WHERE a.id = au.id AND p.pubid = au.pubid;

SELECT name, beginyear, end_year, totPublication
FROM( SELECT name, beginyear, end_year, MAX(totPublication) OVER( PARTITION BY beginyear, end_year) as maxTotPublication, totPublication 
    FROM(
        SELECT name, beginyear, end_year, SUM(numpublication) AS totPublication
        FROM (SELECT * 
            FROM authoryear CROSS JOIN years
            WHERE authoryear.year >= years.beginyear AND authoryear.year <= years.end_year) AS tablenew
        GROUP BY (name, beginyear, end_year)) AS tablenewnew
    GROUP BY (beginyear, end_year, name, totPublication)) AS tablenewnewnew
WHERE maxTotPublication = totPublication;

/*
         name           | beginyear | end_year | totpublication 
-------------------------+-----------+----------+----------------
 Willard Van Orman Quine |      1936 |     1945 |             12
 Willard Van Orman Quine |      1937 |     1946 |             12
 Willard Van Orman Quine |      1938 |     1947 |             12
 J. C. C. McKinsey       |      1939 |     1948 |             10
 Willard Van Orman Quine |      1939 |     1948 |             10
 Willard Van Orman Quine |      1940 |     1949 |             10
 Frederic Brenton Fitch  |      1941 |     1950 |             10
 Willard Van Orman Quine |      1941 |     1950 |             10
 Frederic Brenton Fitch  |      1942 |     1951 |             10
 Willard Van Orman Quine |      1943 |     1952 |             10
 Willard Van Orman Quine |      1944 |     1953 |             11
 Willard Van Orman Quine |      1945 |     1954 |             14
 Willard Van Orman Quine |      1946 |     1955 |             13
 Willard Van Orman Quine |      1947 |     1956 |             13
 Hao Wang 0001           |      1948 |     1957 |             14
 Hao Wang 0001           |      1949 |     1958 |             14
 Hao Wang 0001           |      1950 |     1959 |             14
 Alan J. Perlis          |      1951 |     1960 |             12
 Hao Wang 0001           |      1951 |     1960 |             12
 Harry D. Huskey         |      1952 |     1961 |             17
 Harry D. Huskey         |      1953 |     1962 |             24
 Henry C. Thacher Jr.    |      1954 |     1963 |             29
 Henry C. Thacher Jr.    |      1955 |     1964 |             33
 Henry C. Thacher Jr.    |      1956 |     1965 |             33
 Henry C. Thacher Jr.    |      1957 |     1966 |             37
 Henry C. Thacher Jr.    |      1958 |     1967 |             39
 Henry C. Thacher Jr.    |      1959 |     1968 |             39
 Henry C. Thacher Jr.    |      1960 |     1969 |             39
 Bernard A. Galler       |      1961 |     1970 |             37
 Henry C. Thacher Jr.    |      1961 |     1970 |             37
 Stephen D. Crocker      |      1962 |     1971 |             40
 Jeffrey D. Ullman       |      1963 |     1972 |             47
 Jeffrey D. Ullman       |      1964 |     1973 |             57
 Jeffrey D. Ullman       |      1965 |     1974 |             63
 Jeffrey D. Ullman       |      1966 |     1975 |             73
 Jeffrey D. Ullman       |      1967 |     1976 |             80
 Jeffrey D. Ullman       |      1968 |     1977 |             85
 Jeffrey D. Ullman       |      1969 |     1978 |             79
 Azriel Rosenfeld        |      1970 |     1979 |             80
 Jeffrey D. Ullman       |      1970 |     1979 |             80
 Grzegorz Rozenberg      |      1971 |     1980 |             99
 Grzegorz Rozenberg      |      1972 |     1981 |            122
 Grzegorz Rozenberg      |      1973 |     1982 |            138
 Azriel Rosenfeld        |      1974 |     1983 |            151
 Azriel Rosenfeld        |      1975 |     1984 |            157
 Azriel Rosenfeld        |      1976 |     1985 |            157
 Azriel Rosenfeld        |      1977 |     1986 |            158
 Azriel Rosenfeld        |      1978 |     1987 |            158
 Azriel Rosenfeld        |      1979 |     1988 |            164
 Azriel Rosenfeld        |      1980 |     1989 |            172
 Azriel Rosenfeld        |      1981 |     1990 |            183
 Azriel Rosenfeld        |      1982 |     1991 |            175
 Azriel Rosenfeld        |      1983 |     1992 |            165
 Micha Sharir            |      1984 |     1993 |            161
 Micha Sharir            |      1985 |     1994 |            180
 Micha Sharir            |      1986 |     1995 |            190
 Micha Sharir            |      1987 |     1996 |            198
 David J. Evans 0001     |      1988 |     1997 |            220
 David J. Evans 0001     |      1989 |     1998 |            235
 Toshio Fukuda           |      1990 |     1999 |            256
 Toshio Fukuda           |      1991 |     2000 |            284
 Toshio Fukuda           |      1992 |     2001 |            293
 Toshio Fukuda           |      1993 |     2002 |            301
 Thomas S. Huang         |      1994 |     2003 |            300
 Thomas S. Huang         |      1995 |     2004 |            327
 Thomas S. Huang         |      1996 |     2005 |            351
 Thomas S. Huang         |      1997 |     2006 |            386
 Wen Gao 0001            |      1998 |     2007 |            440
 Wen Gao 0001            |      1999 |     2008 |            502
 Wen Gao 0001            |      2000 |     2009 |            564
 H. Vincent Poor         |      2001 |     2010 |            625
 H. Vincent Poor         |      2002 |     2011 |            717
 H. Vincent Poor         |      2003 |     2012 |            798
 H. Vincent Poor         |      2004 |     2013 |            879
 H. Vincent Poor         |      2005 |     2014 |            961
 H. Vincent Poor         |      2006 |     2015 |           1004
 H. Vincent Poor         |      2007 |     2016 |           1108
 H. Vincent Poor         |      2008 |     2017 |           1152
 H. Vincent Poor         |      2009 |     2018 |           1181
 H. Vincent Poor         |      2010 |     2019 |           1214
 H. Vincent Poor         |      2011 |     2020 |           1401
 H. Vincent Poor         |      2012 |     2021 |           1492
 H. Vincent Poor         |      2013 |     2022 |           1389
 H. Vincent Poor         |      2014 |     2023 |           1288
 H. Vincent Poor         |      2015 |     2024 |           1182
 H. Vincent Poor         |      2016 |     2025 |           1065
 Yang Liu                |      2017 |     2026 |            953
 Yang Liu                |      2018 |     2027 |            862
 Yang Liu                |      2019 |     2028 |            735
 Yang Liu                |      2020 |     2029 |            542
 Yang Liu                |      2021 |     2030 |            302
 Aaron D. Ames           |      2022 |     2031 |              6
(92 rows)

*/
