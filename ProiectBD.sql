set linesize 300;
set autocommit on;
set serveroutput on;
set nls_date_format='dd-mm-yyyy';

create table curs_valutar (
Data DATE PRIMARY KEY,
Rata NUMBER(1,1) NOT NULL CHECK(Rata>=1.00 and Rata<=4.00)
);

create table parteneri (
Nume VARCHAR(16) PRIMARY KEY NOT NULL CHECK(Nume<=10),
CUI VARCHAR(6) UNIQUE NOT NULL,
Adresa VARCHAR(20) NOT NULL
);

create table tranzactii(
Data_tranzactiei DATE PRIMARY KEY REFERENCES curs_valutar(Data),
CUI VARCHAR(6) REFERENCES parteneri(CUI) ON DELETE CASCADE,
Valuta NUMBER(5,2),
Lei NUMBER(5,2) 
);

create table bilant_zilnic(
Data DATE UNIQUE REFERENCES curs_valutar(Data) ON DELETE CASCADE,
Sold_initial NUMBER(7,2) DEFAULT '0',
Total_intrari INTEGER,
Total_iesiri INTEGER,
Sold_final NUMBER(7,3) NOT NULL
);
--3
INSERT INTO curs_valutar VALUES ('03-09-2022',2.3);
INSERT INTO curs_valutar VALUES ('04-09-2022',2.5);
INSERT INTO curs_valutar VALUES ('05-09-2022',2.2);

INSERT INTO tranzactii VALUES ('04-09-2022','154706',1250,-3125);
INSERT INTO tranzactii VALUES ('04-09-2022','182341',-2200,5500);
INSERT INTO tranzactii VALUES ('04-09-2022','195071',950,-2375);
INSERT INTO tranzactii VALUES ('05-09-2022','182341',800,-1760);
INSERT INTO tranzactii VALUES ('05-09-2022','154706',-500,1100);

INSERT INTO parteneri VALUES ('ECODOR SRL','1547066','Str. Sipotului 5');
INSERT INTO parteneri VALUES ('NICOTRANS SRL','1823412','Sos. Giurgiului 269');
INSERT INTO parteneri VALUES ('ROMEXPO SRL','1950718','Bdul. Marasti 65-2');

INSERT INTO bilant_zilnic VALUES ('04-09-2022',0,-50,125,75);
INSERT INTO bilant_zilnic VALUES ('05-09-2022',75,300,-660,-360);

--4
create or replace trigger T1
before update on curs_valutar
for each row
declare
a numeric(3);
e exception;
begin
select count(Data_tranzactiei) into a from tranzactii where Data_tranzactiei=:new.data;
if x<>0 then :new.Rata:=:old.Rata;
dbms_output.put_line('Nu se poate modifica cursul valutar deoarece in data de '||:new.data||' exista tranzactii efectuate');
end if;
end;
/
update curs set Rata=1.1 where Data='05-09-2022';

--5
create or replace procedure Raport(cui varchar) 
as 
n varchar(10);
in numeric(8) default 0;
out numeric(8) default 0;
begin
select Nume into n from parteneri where CUI=cui;
select abs(sum(Valuta)) into in from tranzactii where CUI=cui and Valuta<0;
select sum(Valuta) into out from tranzactii where CUI=cui and Valuta>=0;
DBMS_OUTPUT.PUT_LINE('---------------|Raport|-----------------');
DBMS_OUTPUT.PUT_LINE('NUME:'||n);
DBMS_OUTPUT.PUT_LINE('CUI:'||cui);
DBMS_OUTPUT.PUT_LINE('INTRARI:'||in);
DBMS_OUTPUT.PUT_LINE('IESIRI:'||out);
DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
exception
when others then 
RAISE_APPLICATION_ERROR(-20000,'NU exista date.');
end;
/
execute Raport(154706);
--6
Create or Replace view Raport(Nume,CUI,Data_Tranzactie,Tip_Tranzactie,Suma_Valuta,Suma_Lei)
as SELECT B.Nume,B.CUI,C.Data_tranzactiei,'Intrare' as Tip,C.Valuta,C.Lei
from parteneri B, tranzactii C
where B.CUI=C.CUI and Valuta>=0
group by B.Nume,C.Data_tranzactiei;

--7
insert into tranzactii values('05-09-2022','182341',300,NULL);

create or replace trigger T2
before insert on tranzactii
for each row
declare
a numeric(6,2);
begin
select Rata into a from curs_valutar where Data =:new.Data_tranzactiei;
if a <> 0 then
   :new.Lei:=:new.Valuta*a; 
else
   raise_application_error(-20000,'Nu s-a efectuat inserarea');
end if;
end;
/
insert into tranzactii values('05-09-2022','182341',450,NULL);
select * from tranzactii;

--8 

create or replace function F8(cui char)
return numeric as x numeric;
begin
select sum(abs(Valuta)) into x from tranzactii where CUI=cui;
return x;
end;
/
select F8('154706') from dual;

--9
select CUI,F9((select extract( year from Data_tranzactiei) as year from tranzactii),CUI) from tranzactii;
create or replace function F9(an numeric,c char)
return numeric as a numeric(8);
begin
select count(sumavaluta) into a from tranzactii where sumavaluta>=0 and c=CUI and 
(select extract( year from Data_tranzactiei) as year from tranzactii where c=CUI)=an;
return a;
end;
/

--10
create or replace function Part(cui char)
return numeric as
a numeric(8);
b numeric(8);
c numeric(8);
begin
select sum(sumavaluta) into b from tranzactii where Valuta<0 and cui=CUI;
select sum(sumavaluta) into c from tranzactii where Valuta>0 and cui=CUI;
a:=(abs(b)*100)/(abs(b)+c);
return a;
end;
/
select Nume,CUI,count(CUI) as nr_tranz,Part(CUI) as Rata from tranzactii
group by Nume,CUI having count(CUI)=(select max(count(CUI)) from tranzactii group by Nume);
