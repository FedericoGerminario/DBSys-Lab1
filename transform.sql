--Dropping tables
/*
DROP TABLE Author CASCADE;
DROP TABLE Publication CASCADE;
DROP TABLE Authored;
DROP TABLE Article;
DROP TABLE Book;
DROP TABLE Incollection;
DROP TABLE Inproceedings;
*/

--Views necessary for the insertion on the different tables
CREATE VIEW AuthorDuplicateView AS
    SELECT DISTINCT f.k as pubkey, f.v as nameview
    FROM Field f
    WHERE f.p = 'author';

CREATE VIEW DistinctPubKey AS
    SELECT DISTINCT f.k as pubkey
    FROM Field f;

CREATE VIEW PublicationTitleView AS
    SELECT DISTINCT f.k as pubkey, f.v as title
    FROM Field f
    WHERE f.p = 'title';

CREATE VIEW PublicationYearView AS
    SELECT f.k as pubkey, MIN(f.v) as year
    FROM Field f
    WHERE f.p = 'year'
    GROUP BY f.k;

CREATE VIEW AuthorView AS
    SELECT DISTINCT nameview 
    FROM AuthorDuplicateView;

CREATE VIEW PubTitleView AS 
    SELECT DistinctPubKey.pubkey, title
    FROM DistinctPubKey
    LEFT OUTER JOIN PublicationTitleView ON DistinctPubkey.pubkey = PublicationTitleView.pubkey;

CREATE VIEW PublicationView AS
    SELECT DISTINCT PubTitleView.pubkey, title, year
    FROM PubTitleView
    LEFT OUTER JOIN PublicationYearView ON PubTitleView.pubkey = PublicationYearView.pubkey;


CREATE VIEW ArticleView AS
    SELECT p.k as pubkey
    FROM Pub p 
    WHERE p.p = 'article';

CREATE VIEW ArticleMonth AS
    SELECT f.k as pubkey, f.v AS month
    FROM Field f 
    WHERE f.p = 'month';

CREATE VIEW ArticleVolume AS
    SELECT f.k as pubkey, f.v as volume
    FROM Field f 
    WHERE f.p ='volume';

CREATE VIEW ArticleJournal AS
    SELECT f.k as pubkey, f.v as journal
    FROM Field f
    WHERE f.p = 'journal';

CREATE VIEW ArticleNumber AS
    SELECT f.k as pubkey, f.v as number
    FROM Field f
    WHERE f.p = 'number';

CREATE VIEW Bookview AS
    SELECT DISTINCT p.k as pubkey
    FROM Pub p
    WHERE p.p = 'book';

CREATE VIEW Incollectionview as
    SELECT DISTINCT p.k as pubkey 
    FROM Pub p
    WHERE p.p = 'incollection';

CREATE VIEW Inproceedingsview as
    SELECT DISTINCT p.k as pubkey 
    FROM Pub p
    WHERE p.p = 'inproceedings';

-- Used both for book and incollection
CREATE VIEW Publisherview AS
    SELECT DISTINCT f.k as pubkey, MIN(f.v) as publisher
    FROM Field f
    WHERE f.p = 'publisher'
    GROUP BY (pubkey);

CREATE VIEW isbnview AS
    SELECT DISTINCT f.k as pubkey, MIN(f.v) as isbn
    FROM Field f
    WHERE f.p = 'isbn'
    GROUP BY(pubkey);

CREATE VIEW booktitleView AS
    SELECT DISTINCT f.k as pubkey, MIN(f.v) as booktitle
    FROM Field f
    WHERE f.p = 'booktitle'
    GROUP BY(pubkey);

CREATE VIEW editorview as
    SELECT DISTINCT f.k as pubkey, MIN(f.v) as editor
    FROM Field f
    WHERE f.p = 'editor'
    GROUP BY(pubkey);

--Insertion of data over the different tables: Author, Publication, Authored, Article, Book, Inproceedings and Incollection
CREATE SEQUENCE q;
INSERT INTO Author(id, name)(
    SELECT nextval('q') as id, nameview FROM AuthorView
);
DROP SEQUENCE q;


CREATE SEQUENCE q;
INSERT INTO Publication(pubid, pubkey, title, year)(
    SELECT nextval('q') as pubid, pubkey, title, year::INT FROM PublicationView
);
DROP SEQUENCE q;

--An added view to help in the creation of the table authored
CREATE VIEW AuthorToPublication AS
    SELECT Author.id as id, AuthorDuplicateView.pubkey
    FROM AuthorDuplicateView 
    LEFT OUTER JOIN Author ON Author.name = AuthorDuplicateView.nameview;


INSERT INTO Authored(
    SELECT id, pubid
    FROM AuthorToPublication 
    LEFT OUTER JOIN Publication ON AuthorToPublication.pubkey= Publication.pubkey
);


INSERT INTO Article
    (SELECT p.pubid, t.month, t.volume, t.journal, t.number
    FROM Publication p, ((SELECT ArticleView.pubkey, month, volume, journal, number
                        FROM ( 
                            SELECT ArticleView.pubkey, volume, journal, number
                            FROM (      
                                SELECT ArticleView.pubkey, journal, number
                                FROM (
                                     SELECT ArticleView.pubkey, number  
                                     FROM ArticleView
                                     LEFT OUTER JOIN ArticleNumber ON ArticleView.pubkey = ArticleNumber.pubkey 

                                ) as ArticleView
                            LEFT OUTER JOIN ArticleJournal ON ArticleView.pubkey = ArticleJournal.pubkey

                            ) as ArticleView
                            LEFT OUTER JOIN ArticleVolume ON ArticleView.pubkey = ArticleVolume.pubkey

                            ) as ArticleView
                        LEFT OUTER JOIN ArticleMonth ON ArticleView.pubkey = ArticleMonth.pubkey
                        )) AS t
    WHERE p.pubkey = t.pubkey);


INSERT INTO Book 
    (SELECT p.pubid, t.publisher, t.isbn
    FROM Publication p, (
            SELECT t.pubkey, publisher, isbn
            FROM (
                SELECT b.pubkey, isbn
                FROM Bookview b
                LEFT OUTER JOIN isbnview ON b.pubkey = isbnview.pubkey
            ) as t
            LEFT OUTER JOIN publisherview ON t.pubkey = publisherview.pubkey
    ) as t
    WHERE p.pubkey = t.pubkey);


INSERT INTO Incollection 
    (SELECT p.pubid, t.publisher, t.isbn, t.booktitle
    FROM Publication p, (
            SELECT t.pubkey, publisher, isbn, booktitle
            FROM (
                SELECT b.pubkey, isbn, booktitle
                FROM (
                    SELECT i.pubkey, booktitle
                    FROM Incollectionview i
                    LEFT OUTER JOIN booktitleview on i.pubkey = booktitleview.pubkey
                ) as b
                LEFT OUTER JOIN isbnview ON b.pubkey = isbnview.pubkey
            ) as t
            LEFT OUTER JOIN publisherview ON t.pubkey = publisherview.pubkey
    ) as t
    WHERE p.pubkey = t.pubkey);

INSERT INTO Inproceedings
    (SELECT p.pubid, t.booktitle, t.editor
    FROM Publication p, (
            SELECT t.pubkey, booktitle, editor
            FROM (
                SELECT i.pubkey, editor
                FROM Inproceedingsview i
                LEFT OUTER JOIN editorview ON i.pubkey = editorview.pubkey
            ) as t
            LEFT OUTER JOIN booktitleview ON t.pubkey = booktitleview.pubkey
    ) as t
    WHERE p.pubkey = t.pubkey);


--ADDING Foreign Keys
ALTER TABLE Authored
ADD FOREIGN KEY (id) REFERENCES Author,
ADD FOREIGN KEY (pubid) REFERENCES Publication;

ALTER TABLE Article
ADD FOREIGN KEY (pubid) REFERENCES Publication;

ALTER TABLE Book 
ADD FOREIGN KEY (pubid) REFERENCES Publication;

ALTER TABLE Incollection
ADD FOREIGN KEY (pubid) REFERENCES Publication;

ALTER TABLE Inproceedings
ADD FOREIGN KEY (pubid) REFERENCES Publication;

ALTER TABLE Publication
ADD CONSTRAINT uniquePubid UNIQUE(pubid);


--Dropping views
DROP VIEW AuthorView;
DROP VIEW AuthorduplicateView CASCADE;
DROP VIEW DistinctPubKey CASCADE;

DROP VIEW PublicationTitleView;
DROP VIEW PublicationYearView;
DROP VIEW PublicationView; 
DROP VIEW PubTitleView;


DROP VIEW ArticleView CASCADE;
DROP VIEW ArticleJournal CASCADE;
DROP VIEW ArticleMonth;
DROP VIEW ArticleNumber;
DROP VIEW ArticleVolume;

DROP VIEW Inproceedingsview;
DROP VIEW Incollectionview;

DROP VIEW PublisherView;
DROP VIEW BookView;
DROP VIEW IsbnView;
DROP VIEW EditorView;
DROP VIEW BookTitleView;
