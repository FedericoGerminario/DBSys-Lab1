drop table pub;
drop table field;

create table Pub(k text, p text);
create table Field(k text, i text, p text, v text);

\copy Pub from '/home/fede/Desktop/Eurecom/DBSys/pubFile.txt';
\copy Field from '/home/fede/Desktop/Eurecom/DBSys/fieldFile.txt';
