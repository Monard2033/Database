SET SERVEROUTPUT ON;
SET AUTOCOMMIT ON; 
SET linesize 300;
CREATE TABLE Salarii ( 
CNP char(13) PRIMARY KEY, 
Nume varchar(30) NOT NULL, 
Functie varchar(20) NOT NULL, 
Venit_brut numeric NOT NULL, 
Venit_net numeric); 
INSERT INTO Salarii VALUES(’111’, ’Vali’, ’inginer’,4400, NULL); 
INSERT INTO Salarii VALUES(’222’, ’Alina’, ’inginer’,2200, NULL);
---1
Create or Replace function Salariu_net(cnp char)
return numeric is
nume varchar(30);
functie varchar(20);
cnp_sub char(6);
venit_brut numeric;
salariu_brut_impozitabil numeric;
impozit numeric;
venit_net numeric;
CAS numeric;
CASS numeric;
begin
select Nume into nume from Salarii Where CNP=cnp;
select Functie into functie from Salarii where CNP=cnp;
select Venit_brut into venit_brut from Salarii where CNP=cnp;
CAS:=venit_brut/4;
CASS:= venit_brut/10;
salariu_brut_impozitabil:=venit_brut-CAS-CASS;
impozit:=salariu_brut_impozitabil/10;
venit_net:=salariu_brut_impozitabil-impozit;
dbms_output.put_line('CNP '||cnp);
dbms_output.put_line('Nume '||nume);
dbms_output.put_line('Functie '||functie);
dbms_output.put_line('Venit Brut '||venit_brut);
dbms_output.put_line('CAS '||CAS);
dbms_output.put_line('CASS '||CASS);
dbms_output.put_line('Venitul brut impozitabil '||venit_brut);
dbms_output.put_line('Impozit '||impozit);
dbms_output.put_line('Venit Net '||venit_net);
return venit_net;
exception 
when no_data_found then
dbms_output.put_line('Nu exista astfel de date!');
return 0;
when others then
dbms_output.put_line('A aparut o alta exceptie');
return 0;
end;
/
column Venit_net format a30;
SELECT CNP, Nume, Functie, Venit_brut, salariu_net(CNP) AS Venit_net FROM Salarii;
--2
CREATE TABLE Produse ( 
Id_produs integer PRIMARY KEY, 
Nume_produs varchar(30) NOT NULL, 
Pret numeric NOT NULL, 
Cantitate integer NOT NULL CHECK (Cantitate >=0)); 
INSERT INTO Produse VALUES(1, ’Iaurt’, 15, 20); 
INSERT INTO Produse VALUES(2, ’Lapte’, 20,4); 
INSERT INTO Produse VALUES(3, ’Paine’, 10,0);

Create or Replace function Stoc(ID char)
return varchar is
stoc numeric;
begin
select Cantitate into Stoc from Produse Where ID=id_produs;
if(stoc>=5) then 
return 'Produsul se afla in stoc!';
elsif (stoc>0 and stoc <5) then
return 'Stoc limitat(sub 5 bucati)!';
else
return 'Stoc epuizat!';
end if;

EXCEPTION
WHEN NO_DATA_FOUND THEN
dbms_output.put_line('Nu exista astfel de date!');
RETURN 0;
WHEN OTHERS THEN
dbms_output.put_line('S-a strecurat o alta exceptie!');
RETURN 0;
END;
/
column Status format a30;
SELECT Id_produs, Nume_produs, Pret, Stoc(Id_produs) AS Status FROM Produse;
