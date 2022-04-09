CREATE TABLE studenti ( 
Marca char(6) PRIMARY KEY, 
Nume varchar(30) NOT NULL, 
Stare_civila char(1) NOT NULL, 
Sex char(1) NOT NULL, 
An integer NOT NULL CHECK (An>0 and An<5), 
Grupa integer NOT NULL); 
CREATE TABLE discipline ( 
Cod_disciplina integer PRIMARY KEY, 
Denumire_disciplina varchar(30) NOT NULL); 
CREATE TABLE note( 
Marca char(6) NOT NULL REFERENCES studenti (Marca) ON DELETE CASCADE, 
Nota integer NOT NULL CHECK (Nota >0 AND Nota <=10), 
Cod_disciplina integer NOT NULL REFERENCES discipline(Cod_disciplina) 
ON DELETE CASCADE);

SET AUTOCOMMIT ON; 
INSERT INTO studenti VALUES('111111', 'Rosu Alina', 'N', 'F', 1,1); 
INSERT INTO studenti VALUES('222222', 'Vlad Simona','N', 'F', 1,2); 
INSERT INTO studenti VALUES('333333', 'Lung Ionut', 'C', 'M', 2,1); 
INSERT INTO discipline VALUES(1, 'Programare WEB'); 
INSERT INTO discipline VALUES(2, 'Baze de date'); 
INSERT INTO discipline VALUES(3, 'Retele neuronale');
INSERT INTO discipline VALUES(4, 'Java'); 
INSERT INTO note VALUES('111111',8, 1); 
INSERT INTO note VALUES('111111',10, 2); 
INSERT INTO note VALUES('222222',4, 2); 
INSERT INTO note VALUES('333333',7, 3); 
INSERT INTO note VALUES('333333',8, 4);

--a
select * from studenti where Stare_civila='N';
--b
CREATE VIEW Date_studenti_M as select* from studenti where Sex='M';
select* from Date_studenti_M order by Stare_civila;
--c 
Create or Replace VIEW Medii(Marca,Nume,An,Grupa,Media_Note,Nr_Note) 
as select C.Marca, A.Nume, A.An, A.Grupa,AVG(Nota), Count(Nota)
from studenti A , discipline B,note C
where A.Marca=C.Marca and B.Cod_disciplina=C.Cod_disciplina
group by C.Marca,A.Nume,A.An,A.Grupa,C.Nota;
select* from Medii;

--d
Create or Replace view Note_studenti(Marca,Nume,An,Grupa,Denumire_disciplina,Nota)
as select A.Marca,A.Nume,A.An,A.Grupa,B.Denumire_disciplina,C.Nota
from studenti A,discipline B,note C
Where A.Marca=C.Marca and B.Cod_disciplina=C.Cod_disciplina;
select* from Note_studenti order by Marca;

select* from Note_studenti where Denumire_disciplina like 'Baze de%';

select B.Marca,A.Nume,A.An,A.Grupa,B.Medie from Note_studenti A
where A.Marca=B.Marca and C.Medie>7.5;
--e
Create or Replace view Medii_restantieri (Marca,Nume,An,Grupa,Media_Note)
as select C.Marca,A.Nume,A.An,A.Grupa,Avg(Nota)
from studenti A,note C
where A.Marca=C.Marca
group by C.Marca,A.Nume,A.An,A.Grupa;


select A.Marca,A.Nume,A.An,A.Grupa,A.Medie from Medii_restantieri A
 having 
