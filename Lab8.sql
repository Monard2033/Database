set linesize 350;
drop table Evidenta_angajati; 
CREATE TABLE Evidenta_angajati( 
cnp char(13) PRIMARY KEY, 
nume varchar(20), 
data_nasterii date);

--1
alter session set nls_date_format='dd-mm-yyyy';
create or replace trigger trigger_data
before insert on Evidenta_angajati
for each row
declare
data_nas char(2);
zi integer;
luna integer;
an integer;
pref integer;
er exception;
begin
pref:=substr(:new.cnp,1,1);
an:=substr(:new.cnp,2,2);
luna:=substr(:new.cnp,4,2);
zi:=substr(:new.cnp,6,2);
if pref=1 or pref=2 then an:=1900+an;
else
if pref=5 or pref=6 then an:=2000+an;
else
raise er;
end if;
end if;
:new.data_nasterii:=zi||'/'||luna||'/'||an;
exception
when er then
raise_application_error(-20000,'Eroare');
end;
/
INSERT INTO Evidenta_angajati VALUES(’2830823350077’, ’vali’, NULL);
INSERT INTO Evidenta_angajati VALUES(’1990307410084’, ’Mihail’, NULL);
INSERT INTO Evidenta_angajati VALUES(’5990307410084’, ’Smecheru’, NULL);
INSERT INTO Evidenta_angajati VALUES(’7990307410084’, ’Mihai’, NULL);
SELECT * FROM Evidenta_angajati;


--2a

CREATE TABLE produse( 
id_produs integer PRIMARY KEY, 
nume_produs varchar(30) NOT NULL, 
pret_bucata number(5,2) NOT NULL,
stoc integer NOT NULL); 

CREATE TABLE vanzari( 
id_produs integer NOT NULL REFERENCES produse(id_produs), 
cantitate integer, 
cost_total number (7,2)); 
 
INSERT INTO produse VALUES (1, ’paine’, 5, 1); 
INSERT INTO produse VALUES (2, ’lapte’, 8, 5); 
INSERT INTO produse VALUES (3, ’iaurt’, 6, 7); 
INSERT INTO produse VALUES (4, ’kefir’, 7, 7);

--2b  
create or replace trigger trig_vanzari
before insert on vanzari 
for each row declare 
er exception
pret_bucata_ext number(5,2);
stoc_ext integer;
begin
select stoc into stoc_ext from produse where
id_produs:=new.id_produs;

if	:new.cantitate>stoc_ext then
	raise error;
else
	select pret_bucata into pret_bucata_ext from produse where id_produs=:new.id_produs;
	:new.cost_total:=:new.cantitate*pret_bucata_ext;
	update produse set stoc=stoc-:new.cantitate where
	id_produs:=:new.id_produs;
end if;
exception when error then
raise_application_error(-20000,'Stoc insuficient!');
end;
/

INSERT INTO vanzari VALUES (1,3,NULL); 
INSERT INTO vanzari VALUES (2,4,NULL); 
SELECT * FROM produse; 
SELECT * FROM vanzari; 

--3

CREATE TABLE useri( 
id_user integer PRIMARY KEY, 
username varchar(20) NOT NULL, 
email varchar(30) NOT NULL, 
pasaport_nr varchar(10), 
permis_conducere_nr varchar(10)); 

CREATE TABLE remindere( 
id_user integer NOT NULL REFERENCES useri(id_user), 
text_reminder varchar(200), 
data_reminder date, 
status varchar(10));

INSERT INTO useri VALUES(1, 'adi', 'adi@yahoo.com', '224477', '333555'); 
SELECT * FROM useri; 
SELECT * FROM remindere; 

INSERT INTO useri VALUES(2, 'adina', 'adina@yahoo.com', '', '333555'); 
SELECT * FROM useri; 
SELECT * FROM remindere; 

INSERT INTO useri VALUES(3, 'maria', 'maria@yahoo.com', '224477', NULL); 
SELECT * FROM useri; 
SELECT * FROM remindere; 

INSERT INTO useri VALUES(4, 'vali', 'vali@yahoo.com', NULL, NULL); 
SELECT * FROM useri; 
SELECT * FROM remindere; 

DROP TABLE remindere; 
DROP TABLE useri;
