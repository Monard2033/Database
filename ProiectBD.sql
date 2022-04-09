set linesize 300;
set autocommit on;
set serveroutput on;
set nls_date_format='dd-mm-yyyy';

create table curs_valutar (
Data DATE PRIMARY KEY,
Rata NUMBER(1,2) NOT NULL CHECK(Rata>=1 and Rata<=4)
);

create table parteneri (
Nume VARCHAR PRIMARY KEY NOT NULL CHECK(Nume<=10),
CUI VARCHAR(6) NOT NULL,
Adresa VARCHAR(20) NOT NULL
);

create table tranzactii(
Data_tranzactiei DATE PRIMARY KEY REFERENCES curs_valutar(Data),
CUI VARCHAR(6) NOT NULL REFERENCES parteneri(CUI) ON DELETE CASCADE,
Valuta NUMBER(3,2),
Suma NUMBER(3,2) 
);

create table bilant_zilnic(
Data DATE PRIMARY KEY REFERENCES curs_valutar(Data) ON DELETE CASCADE,
Sold_initial NUMBER(7,3) DEFAULT '0',
Total_intrari INTEGER,
Total_iesiri INTEGER,
Sold_final NUMBER(7,3) NOT NULL,
);
INSERT INTO curs_valutar VALUES ('03-09-2022',2.37);
INSERT INTO curs_valutar VALUES ('04-09-2022',2.35);
INSERT INTO curs_valutar VALUES ('05-09-2022',2.39);
INSERT INTO tranzactii VALUES ('04-09-2022','1547066',1250,-2937.5);
INSERT INTO tranzactii VALUES ('04-09-2022','1823412',3500,-8225);
INSERT INTO tranzactii VALUES ('04-09-2022','1950718',-5000,11750);
INSERT INTO tranzactii VALUES ('05-09-2022','1547066',800,1912);
INSERT INTO tranzactii VALUES ('05-09-2022','1823412',-2300,5497);
INSERT INTO parteneri VALUES ('ECODOR SRL','1547066','Str. Sipotului 5');
INSERT INTO parteneri VALUES ('NICOTRANS SRL','1823412','Sos. Giurgiului 269');
INSERT INTO parteneri VALUES ('ROMEXPO SRL','1950718','Bdul. Marasti 65-2');

CREATE OR REPLACE VIEW Raport(CUI)
as SELECT
