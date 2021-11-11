CREATE TABLE Author(
    id INT PRIMARY KEY,
    name TEXT,
    homepage TEXT
);

CREATE TABLE Publication(
    pubid INT PRIMARY KEY,
    pubkey TEXT, -- UNIQUE,
    title TEXT,
    year INT
);

CREATE TABLE Authored(
    id INT,
    pubid INT,
    PRIMARY KEY (id, pubid)
    --FOREIGN KEY(id) REFERENCES Author,
    --FOREIGN KEY(pubid) REFERENCES Publication
);

CREATE TABLE Article(
    pubid INT PRIMARY KEY,
    volume TEXT,
    month TEXT,
    journal TEXT,
    number TEXT
    --FOREIGN KEY(pubid) REFERENCES Publication
);

CREATE TABLE Book(
    pubid INT PRIMARY KEY,
    publisher TEXT,
    isbn TEXT
    --FOREIGN KEY(pubid) REFERENCES Publication
);

CREATE TABLE Incollection(
    pubid INT PRIMARY KEY,
    booktitle TEXT,
    publisher TEXT,
    isbn TEXT
    --FOREIGN KEY(pubid) REFERENCES Publication
);

CREATE TABLE Inproceedings(
    pubid INT PRIMARY KEY,
    booktitle TEXT,
    editor TEXT
    --FOREIGN KEY (pubid) REFERENCES Publication
);

