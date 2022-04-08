CREATE TABLE studenti ( 
Marca char(6) PRIMARY KEY, 
Nume varchar(30) NOT NULL, 
An integer NOT NULL CHECK (An>0 and An<5), 
Grupa integer NOT NULL, 
Media_generala NUMBER(4,2)); 

CREATE TABLE discipline ( 
Cod_disciplina integer PRIMARY KEY, 
Denumire_disciplina varchar(30) NOT NULL); 

CREATE TABLE note( 
Marca char(6) NOT NULL REFERENCES studenti (Marca) ON DELETE CASCADE, 
Nota integer NOT NULL CHECK (Nota >0 AND Nota <=10), 
Cod_disciplina integer NOT NULL REFERENCES discipline(Cod_disciplina) 
ON DELETE CASCADE);

SET AUTOCOMMIT ON; 
INSERT INTO studenti VALUES('111111', 'Rosu Alina', 1,1,NULL); 
INSERT INTO studenti VALUES('222222', 'Vlad Simona',1,2, NULL); 
INSERT INTO studenti VALUES('333333', 'Lung Ionut', 2,1, NULL); 
INSERT INTO discipline VALUES(1, 'Programare WEB'); 
INSERT INTO discipline VALUES(2, 'Baze de date'); 
INSERT INTO discipline VALUES(3, 'Retele neuronale'); 
INSERT INTO discipline VALUES(4, 'Java'); 
INSERT INTO note VALUES('111111',8, 1); 
INSERT INTO note VALUES('111111',10, 2); 
INSERT INTO note VALUES('222222',4, 2); 

INSERT INTO note VALUES('333333',7, 3); 
INSERT INTO note VALUES('333333',8, 4);
set linesize 300;

SELECT * from studenti;
SELECT * from discipline;
SELECT * from note;

select table_name from user_tables;

--a)
set SERVEROUTPUT on; 
create or replace procedure Medie(AN_student integer) as Med number;
begin
select avg(Nota) into Med from note a, studenti b
where AN_student=b.An and a.Marca=b.Marca;
DBMS_OUTPUT.PUT_LINE('Media studentilor este: ');
DBMS_OUTPUT.PUT_LINE(Med);
exception
when others then 
RAISE_APPLICATION_ERROR(-20000,'Nu exista note');
end;
/
execute medie(1);
execute medie(2);


--b)
INSERT INTO note VALUES('222222',10,1);
select marca from note group by having avg(nota) >= 5; 
select marca from note group by marca having min (nota)>4;
set SERVEROUTPUT on; 
create or replace procedure Medie_Int(AN_student integer) as Med number;
begin
select avg(Nota) into Med from note a, studenti b
where AN_student=b.An and a.Marca=b.Marca and b.marca in 
(Select marca from note group by marca having min(nota)>4);
DBMS_OUTPUT.PUT_LINE('Media studentilor integralistieste: ');
DBMS_OUTPUT.PUT_LINE(Med);
exception
when others then
RAISE_APPLICATION_ERROR(-20000, 'Nu exista note');
end;
/
execute Medie_Int(1);
delete from note where Marca='222222' and Nota='10';

--c)
set SERVEROUTPUT on; 
create or replace procedure Medie3(Marca_student char ) as var float;
begin
select avg(nota) into var from Note 
inner join Studenti using (marca)
where marca=marca_student;
update Studenti set Media_generala =var
where marca=marca_student;
DBMS_OUTPUT.PUT_LINE('Media: '||var);
exception
when others then
raise_application_error(-20000,'Actualizare nereusita!');
end;
/
execute Medie3('111111');
execute Medie3('222222');
execute Medie3('333333');

--d)
create or replace procedure media_recalculata(marca_p char, nota_p integer, cod_p integer) as
begin
insert into note values(marca_p, nota_p, cod_p);
media_student (marca_p);
end;
/
execute media_recalculata('111111',5,2);