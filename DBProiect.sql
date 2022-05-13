
--2)
create table curs(
data date PRIMARY KEY,
rata_schimb numeric(3,2)  CHECK( rata_schimb BETWEEN 1.00 and 4.00)
);
create table parteneri(
cui char(6) CHECK(length(cui)=6) PRIMARY KEY,
nume varchar(10),
adreasa varchar(10)
);
create table tranzactii(
cui char(6) CHECK(length(cui)=6) REFERENCES parteneri(cui),
data_efectuarii date default NULL,
partener varchar(10),
sumavaluta numeric(8),
sumalei numeric(8)
);
create table bilant(
data date unique,
sold_initial numeric(8) DEFAULT 0,
total_intrari numeric(8),
total_iesiri numeric(8),
sold_final numeric(8)
);
--3)
set autocommit on;
insert into curs values('18-06-2007',3);
insert into curs values('16-05-2008',3.5);
insert into curs values('17-05-2008',3);
insert into curs values('18-05-2008',4);

insert into parteneri  values('12345a','P1','Satu Mare');
insert into parteneri  values('12345b','P2','Timis');
insert into parteneri  values('12345c','P3','Oradea');
insert into parteneri  values('12345d','P4','Zalau');

insert into tranzactii values('12345a','16-05-2008','P1',10,35);
insert into tranzactii values('12345c','16-05-2008','P3',-20,-70);
insert into tranzactii values('12345a','17-05-2008','P1',-5,-15);
insert into tranzactii values('12345b','17-05-2008','P2',15,45);
insert into tranzactii values('12345c','17-05-2008','P3',30,90);


insert into tranzactii values('12345d','18-06-2007','P4',20,60);
insert into tranzactii values('12345d','18-06-2007','P4',-30,90);
insert into tranzactii values('12345d','16-05-2008','P4',-10,-35);
insert into tranzactii values('12345d','17-05-2008','P4',-30,-90);

insert into bilant values('16-05-2008',0,10,-20,-10);
insert into bilant values('17-05-2008',-10,45,-5,30);

--4)
create or replace trigger tr1 
before update on curs
for each row
DECLARE
x numeric(3);
a exception;
begin
select count(data_efectuarii) into  x from tranzactii where data_efectuarii=:new.data;
if x<>0  then :new.rata_schimb:=:old.rata_schimb;
dbms_output.put_line('Nu se poate modifica rata deoarece in data de '||:new.data||' exista tranzactii efectuate');
end if;   
end;
/
update curs set rata_schimb=2 where data='17-05-2008';
--5)
create or replace procedure pro(c varchar)
as 
a varchar(10);
n numeric(8) default 0;
no numeric(8) default 0;
begin
select nume into a from parteneri where cui=c;
select abs(sum(sumavaluta)) into n from tranzactii where cui=c and sumavaluta<0;
select sum(sumavaluta) into no from tranzactii where cui=c and sumavaluta>=0;
dbms_output.put_line('---------------------------------------------------------------------------- ');
dbms_output.put_line('NUME:'||a);
dbms_output.put_line('CUI:'||c);
dbms_output.put_line('INTRARI:'||n);
dbms_output.put_line('IESIRI:'||no);
dbms_output.put_line('---------------------------------------------------------------------------- ');
end;
/
exec pro('12345a');
--6) 

select partener,cui,data_efectuarii,sumavaluta,sumalei, 'Intrare' as Tip  from tranzactii
where sumavaluta<0
group by partener,cui,data_efectuarii,sumavaluta ,sumalei
union
select partener,cui,data_efectuarii,sumavaluta,sumalei, 'Iesire' as Tip  from tranzactii 
where sumavaluta>=0
group by partener,cui,data_efectuarii,sumavaluta,sumalei
order by partener,data_efectuarii;

 --7) 

insert into tranzactii values('12345b','16-05-2008','P2',60,NULL);

create or replace trigger tr7
before insert on tranzactii
for each row
declare
x numeric(6,2);
begin
select rata_schimb into x from curs where data =:new.data_efectuarii;
if x <> 0 then
  :new.sumalei:=:new.sumavaluta*x; 
else
   raise_application_error(-20000,'nu s-a realizat inseararea');
end if;
end;
/
insert into tranzactii values('12345b','17-05-2008','P2',60,NULL);
 select * from tranzactii;
--8)
create or replace function fc8(c char)
return numeric as
x numeric;
begin
select sum(abs(sumavaluta)) into x from tranzactii where cui=c;
return x;
end;
/
select fc8('12345b') from dual;
--9)
select partener,cui,fct9((select extract( year from data_efectuarii) as year from tranzactii),cui) from tranzactii ;
create or replace function fct9(an numeric,c char)
return numeric as
x numeric(8);
begin
select count(sumavaluta) into x from tranzactii where sumavaluta>=0 and c=cui and 
(select extract( year from data_efectuarii) as year from tranzactii where c=cui)=an;
return x;
end;
/

--10)
create or replace function rent(c char)
return numeric as
x numeric(8);
y numeric(8);
z numeric(8);
begin
select sum(sumavaluta) into y from tranzactii where sumavaluta<0 and c=cui;
select sum(sumavaluta) into z from tranzactii where sumavaluta>0 and c=cui;
x:=(abs(y)*100)/(abs(y)+z);
return x;
end;
/
select partener,cui,count(cui) as nr_tranz,rent(cui) as rata from tranzactii group by partener,cui having count(cui)=(select max(count(cui)) from tranzactii group by partener);
