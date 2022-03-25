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

--a)
select * from studenti where Stare_civila='N';

--b)
create view Date_studenti_M as (select * from studenti where Sex='M');

--c)
select * from Medii;
select Nume_student from Medii
where Nr_note>=2;

--d)
create  view Note_Studenti (Marca, Numele, An, Grupa, Denumirea_Disciplina, Nota)
as select C.Marca, A.Nume, A.An, A.Grupa, B.Denumire_disciplina, C.Nota
from studenti A, discipline B, note C
where A.Marca=C.Marca and C.Cod_disciplina=B.Cod_disciplina
group by C.Marca, A.Nume, A.An, A.Grupa, B.Denumire_disciplina,C.Nota;

select * from Note_Studenti
order by Marca;

select * from Note_Studenti
where Denumirea_Disciplina like 'Baze de%';

select Marca, Numele, An, Grupa, AVG(Nota)
from Note_Studenti
group by Marca, Numele, An, Grupa
having AVG(Nota)>7.5;


select An, AVG(Nota) as Media
from Note_Studenti
group by An;

--e)
create view Medii_restantieri (Marca, Numele, An, Grupa, Media)
as select B.Marca, A.Nume, A.An, A.Grupa, AVG(B.Nota)
from studenti A, note B
where A.Marca=B.Marca and Nota<5
group by B.Marca, A.Nume, A.An, A.Grupa;

select * from Medii_restantieri;

--f)
create view NoteBD (Marca, Note) as select B.Marca, B.Nota from discipline A,note B
where A.Cod_disciplina=B.Cod_disciplina and A.Denumire_disciplina='Baze de date';
update NoteBD
set Nota=Nota-1;
select * from NoteBD;
delete from NoteBD where Marca='111111';

--insert into NoteBd values('111111',8);

--g)
create view NoteAll (Marca, Note, Codul) as select B.Marca, B.Nota, B.Cod_disciplina
from note B
group by B.Marca, B.Nota, B.Cod_disciplina
having Min(Nota)>4;
select * from NoteAll;
