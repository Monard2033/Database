set linesize 300;
set autocommit on;
set serveroutput on;
set nls_date_format='dd-mm-yyyy';

create table curs_valutar (
Data DATE PRIMARY KEY,
Rata NUMBER(1,2) NOT NULL CHECK(Rata>=1.00 and Rata<=4.00)
);

create table parteneri (
Nume VARCHAR PRIMARY KEY NOT NULL CHECK(Nume<=10),
CUI VARCHAR(6) UNIQUE NOT NULL,
Adresa VARCHAR(20) NOT NULL
);

create table tranzactii(
Data_tranzactiei DATE PRIMARY KEY REFERENCES curs_valutar(Data),
CUI VARCHAR(6) UNIQUE NOT NULL REFERENCES parteneri(CUI) ON DELETE CASCADE,
Valuta NUMBER(3,2),
Lei NUMBER(3,2) 
);

create table bilant_zilnic(
Data DATE PRIMARY KEY REFERENCES curs_valutar(Data) ON DELETE CASCADE,
Sold_initial NUMBER(7,3) DEFAULT '0',
Total_intrari INTEGER,
Total_iesiri INTEGER,
Sold_final NUMBER(7,3) NOT NULL,
);
--3
INSERT INTO curs_valutar VALUES ('03-09-2022',2.37);
INSERT INTO curs_valutar VALUES ('04-09-2022',2.35);
INSERT INTO curs_valutar VALUES ('05-09-2022',2.39);
INSERT INTO tranzactii VALUES ('04-09-2022','154706',1250,-2937.5);
INSERT INTO tranzactii VALUES ('04-09-2022','182341',3500,-8225);
INSERT INTO tranzactii VALUES ('04-09-2022','195071',-5000,11750);
INSERT INTO tranzactii VALUES ('05-09-2022','154706',800,1912);
INSERT INTO tranzactii VALUES ('05-09-2022','182341',-2300,5497);
INSERT INTO parteneri VALUES ('ECODOR SRL','1547066','Str. Sipotului 5');
INSERT INTO parteneri VALUES ('NICOTRANS SRL','1823412','Sos. Giurgiului 269');
INSERT INTO parteneri VALUES ('ROMEXPO SRL','1950718','Bdul. Marasti 65-2');
--5
create or replace procedure Raport(CUI varchar) as raport varchar;
begin
select Nume,CUI into raport from parteneri B, tranzactii C
where Nume=B.Nume,CUI=B.CUI and B.CUI=C.CUI;
DBMS_OUTPUT.PUT_LINE('|Raport| ');
DBMS_OUTPUT.PUT_LINE(raport);
exception
when others then 
RAISE_APPLICATION_ERROR(-20000,'NU exista date.');
end;
/
execute Raport(1);
--6
Create or Replace view Raport(Nume,CUI,Data_Tranzactie,Tip_Tranzactie,Suma_Valuta,Suma_Lei)
as SELECT B.Nume,B.CUI,C.Data_tranzactiei,C.Valuta,C.Lei
from parteneri B, tranzactii C
where B.CUI=C.CUI
group by B.Nume,C.Data_tranzactiei;
