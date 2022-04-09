set linesize 300;
create table Evidenta_produse(
Cod_produs varchar(10) primary key,
Produs varchar(30) not null,
Marca varchar(20) not null,
Stoc integer not null,
Pret number(7,2) not null check(Pret between 0 and 10000),
Discount number (3,2)  default '0');
--1
--select sysdate from dual;
--alter session set nls_date_format='dd-mm-yyyy';

set autocommit on;

insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('DX11', 'Frigider', 'Bosch', 40, 1680.99, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('DX12', 'Frigider', 'Electrolux', 30, 1730.00, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('DX13', 'Frigider', 'Whirlpool', 30, 1500.99, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('PX11', 'Cuptor', 'Arctic', 10, 1000.00, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('PX12', 'Cuptor', 'Samsung', 20, 1567.99, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('MX11', 'Plita', 'Gorenje', 50, 870.99, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('MX12', 'Plita', 'Electrolux', 80, 980.00, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('NX11', 'Masina de spalat vase', 'Gorenje', 30, 1799.00, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('NX12', 'Masina de spalat vase', 'Electrolux', 50, 2020.99, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('NX13', 'Masina de spalat vase', 'AEG', 70, 2257.99, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('CX11', 'Cuptor cu microunde', 'Bosch', 90, 1200.99, 0);
insert into Evidenta_produse (Cod_produs,Produs, Marca, Stoc, Pret, Discount)values('CX12', 'Cuptor cu microunde', 'Electrolux', 30, 1500.99, 0);

--2
Select * from Evidenta_produse;

--3
select * from Evidenta_produse
where Marca='Whirlpool';

--4
update Evidenta_produse Set Stoc = Stoc-30 where Cod_produs='DX11';

--5
select distinct Marca from Evidenta_produse where Marca is not null;

--6
update Evidenta_produse set Discount = 0.3 where Produs='Masina de spalat vase';
Select Cod_produs, Produs, Marca, Stoc, Pret, Discount, round(pret-pret*discount,2) as pret_nou from Evidenta_produse where Produs='Masina de spalat vase';

--7
Alter table Evidenta_produse ADD constraint Discount check (Discount>=0 and Discount<=1);

--8
--Daca discountul este de peste 100%, pretul devine negativ. Pretul are constrangerea de a nu fi mai mic decat 0, motiv din care apare eroarea

--9
alter table Evidenta_produse Modify Produs varchar(40);

--10
alter table Evidenta_produse add Garantie integer default 2;

--11
create table Reduceri as
SELECT Cod_produs,Produs,Marca,Stoc,Pret,Discount,Garantie from Evidenta_produse where 1=0;

--12
describe Reduceri;

--13
insert into Reduceri
Select Cod_produs,Produs,Marca,Stoc,Pret,Discount,Garantie from Evidenta_produse where Discount>0;
Delete from Evidenta_produse where Discount>0;
 
--14
select * from Reduceri;

--15
alter table Evidenta_produse drop column Discount;

--16
describe Reduceri;

--17
Create table Frigidere as
Select Cod_produs,Produs, Marca,Stoc, Pret,Garantie
from Evidenta_produse
where Produs='Frigider';

--18
describe Frigidere;

--19
select * from Frigidere;

--20
drop table Evidenta_produse;
drop table Reduceri;
drop table Frigidere;
