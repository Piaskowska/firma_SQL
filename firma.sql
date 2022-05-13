/*
Tabela przechowujaca id, nazwe oraz id_kierownika oddzialu firmy. 
Polaczona jest z tabela PRACOWNICY zwiazkiem 1 do 1, co daje nam kierownika danego oddzialu firmy.
*/

CREATE TABLE oddzialy_firmy
  (
    id    			  NUMBER(2) CONSTRAINT oddzialy_firmy_PK PRIMARY KEY,
    nazwa 			  VARCHAR2(50) NOT NULL,
    id_kierownika	NUMBER(4) CONSTRAINT oddzialy_firmy_kierow_U UNIQUE,
	  CONSTRAINT oddzialy_firmy_CH CHECK (INITCAP(nazwa)=nazwa)
  );

/*
Tabela przechowujaca dane pracownikow. 
Znajduje sie tu rekurencyjny zwiazek jeden do wielu, poniewaz pracownik moze byc kierownikiem, a wtedy moze posiadac wielu podwladnych.
Dzieki zwiazkowi jeden do wielu z tabela ODDZIALY FIRMY mozemy znalezc w jakim oddziale pracuje dany pracownik.
*/

CREATE TABLE pracownicy
  (
    id                NUMBER(4) CONSTRAINT pracownicy_PK PRIMARY KEY,
    pierwsze_imie     VARCHAR2(15) NOT NULL,
    drugie_imie       VARCHAR2(15),
    nazwisko          VARCHAR2(30) NOT NULL,
    pesel             VARCHAR2(11) NOT NULL 
	                     CONSTRAINT pracownicy_pesel_CH CHECK(length(pesel)=11) 
	                     CONSTRAINT pracownicy_pesel_U UNIQUE,
    plec              CHAR(1) NOT NULL CONSTRAINT pracownicy_plec_CH CHECK ( plec IN ('K', 'M')),
    data_urodzenia    DATE NOT NULL,
    data_zatrudnienia DATE DEFAULT SYSDATE NOT NULL,
    id_oddzialu       NUMBER(2) NOT NULL CONSTRAINT pracownicy_oddzialy_FK REFERENCES oddzialy_firmy(id),
	  id_przelozonego   NUMBER(4) CONSTRAINT pracownicy_przelozony_FK REFERENCES pracownicy (id),
	CONSTRAINT pracownicy_daty_CH CHECK (data_zatrudnienia>data_urodzenia),
	CONSTRAINT pracownicy_nazwisko_CH CHECK (INITCAP(nazwisko)=nazwisko),
	CONSTRAINT pracownicy_p_imie_CH CHECK (INITCAP(pierwsze_imie)=pierwsze_imie),
	CONSTRAINT pracownicy_d_imie_CH CHECK (INITCAP(drugie_imie)=drugie_imie)
  );
  
  ALTER TABLE oddzialy_firmy ADD CONSTRAINT oddzialy_firmy_pracownicy_FK FOREIGN KEY (id_kierownika) REFERENCES pracownicy(id);

/*
Tabela przechowujaca dane o czlonkach rodzin pracownikow.
Dzieki zwiazkowi identyfikujacemu na klucz glowny tej tabeli sklada sie pierwsze imie czlonka rodziny i id pracownika.
Mozemy znalezc informacje kogo na utrzymaniu ma dany pracownik.
*/

CREATE TABLE CZLONKOWIE_RODZIN
  (
    pierwsze_imie         VARCHAR2(15),
    plec                  CHAR(1) NOT NULL 
	                         CONSTRAINT czlonkowie_rodzin_plec_CH CHECK (plec IN ('K', 'M')),
    data_urodzenia        DATE NOT NULL ,
    stopien_pokrewienstwa VARCHAR2(30) NOT NULL,
  	id_pracownika         NUMBER(4) CONSTRAINT czlonkowie_rodzin_prac_FK REFERENCES pracownicy(id),
	CONSTRAINT czlonkowie_rodzin_PK PRIMARY KEY (id_pracownika, pierwsze_imie),
	CONSTRAINT czlonkowie_rodzin_imie_CH CHECK (INITCAP(pierwsze_imie)=pierwsze_imie)
  );

--tworzenie indeksu na parze kolumn (nazwisko, pierwsze_imie)  
CREATE INDEX PRACOWNICY_NPI_IND ON PRACOWNICY(NAZWISKO, PIERWSZE_IMIE);

--tworzenie sekwencji zaczynaj¹c¹ siê od 1 i generuj¹c¹ kolejne liczby naturalne
CREATE SEQUENCE pracownicy_SEKW
START WITH 1
INCREMENT BY 1;


INSERT INTO ODDZIALY_FIRMY VALUES (
1, 'Oddzial Lodz', NULL);


INSERT INTO ODDZIALY_FIRMY VALUES (
2, 'Oddzial Krakow', NULL);

INSERT INTO ODDZIALY_FIRMY VALUES (
3, 'Oddzial Gdansk', NULL);



INSERT INTO PRACOWNICY VALUES(
PRACOWNICY_SEKW.NEXTVAL, 'Jan', 'Piotr', 'Nowak', '67110512816', 'M', TO_DATE('05/11/1967','DD/MM/YYYY'), TO_DATE('01/01/2021','DD/MM/YYYY'), 1, NULL);

INSERT INTO PRACOWNICY VALUES(
PRACOWNICY_SEKW.NEXTVAL, 'Alicja', NULL, 'Tracz', '76071509449', 'K', TO_DATE('15/07/1976','DD/MM/YYYY'), TO_DATE('01/01/2021','DD/MM/YYYY'), 1, 1);

INSERT INTO PRACOWNICY VALUES(
PRACOWNICY_SEKW.NEXTVAL, 'Wojciech', 'Jakub', 'Sosnowski', '58122478773', 'M', TO_DATE('24/12/1958','DD/MM/YYYY'), TO_DATE('01/01/2021','DD/MM/YYYY'), 2, 1);

INSERT INTO PRACOWNICY VALUES(
PRACOWNICY_SEKW.NEXTVAL, 'Anna', 'Maria', 'Wojcik', '68032723801', 'K', TO_DATE('27/03/1968','DD/MM/YYYY'), TO_DATE(' 01/02/2021','DD/MM/YYYY'), 3, 1);

INSERT INTO PRACOWNICY VALUES(
PRACOWNICY_SEKW.NEXTVAL, 'Mariola', 'Ewa', 'Zimnicka', '74071335781', 'K', TO_DATE('13/07/1974','DD/MM/YYYY'), TO_DATE('01/02/2021','DD/MM/YYYY'), 3, 4);

INSERT INTO PRACOWNICY VALUES(
PRACOWNICY_SEKW.NEXTVAL, 'Jakub', NULL, 'Kot', '78101908736', 'M', TO_DATE('19/10/1978','DD/MM/YYYY'), DEFAULT, 2, 3);

INSERT INTO CZLONKOWIE_RODZIN VALUES(
'Zofia','K',TO_DATE('05/11/2009','DD/MM/YYYY'),'corka',
(SELECT ID FROM PRACOWNICY 
WHERE PESEL='74071335781'));

INSERT INTO CZLONKOWIE_RODZIN VALUES(
'Maciej','M',TO_DATE('12/04/2011','DD/MM/YYYY'),'syn',
(SELECT ID FROM PRACOWNICY 
WHERE PESEL='74071335781'));

INSERT INTO CZLONKOWIE_RODZIN VALUES(
'Michalina','K',TO_DATE('22/05/2012','DD/MM/YYYY'),'corka',
(SELECT ID FROM PRACOWNICY 
WHERE PESEL='68032723801'));

COMMIT;

CREATE UNIQUE INDEX ODDZIALY_FIRMY_N_U_IND ON ODDZIALY_FIRMY(NAZWA);


--wstawianie do bazy informacji kto jest kierownikiem oddzialu
UPDATE oddzialy_firmy 
SET id_kierownika=(SELECT id FROM pracownicy WHERE pesel='67110512816')
WHERE id=1;

UPDATE oddzialy_firmy 
SET id_kierownika=(SELECT id FROM pracownicy WHERE pesel='58122478773')
WHERE id=2;

UPDATE oddzialy_firmy 
SET id_kierownika=(SELECT id FROM pracownicy WHERE pesel='68032723801')
WHERE id=3;
  
COMMIT;


--zmiana, aby id_kieronika w oddzialy_firmy byla kolumn¹ wymagan¹
ALTER TABLE oddzialy_firmy MODIFY id_kierownika NOT NULL;

--w przypadku dodawania córki plec musi byæ 'K', a w przypadku syna 'M', inne stopnie pokrewieñstwa te¿ s¹ akceptowane
ALTER TABLE czlonkowie_rodzin add CONSTRAINT czlonkowie_rodzin_CH CHECK ((stopien_pokrewienstwa='córka' AND plec='K') OR (stopien_pokrewienstwa='syn' AND plec='M') OR stopien_pokrewienstwa not in ('córka', 'syn'));

--wyœwietlanie pracowników wraz z ich przelozonymi, a tak¿e oddzialu firmy, w któwrym pracuj¹
SELECT p.pierwsze_imie || ' ' || p.nazwisko "Pracownik", k.pierwsze_imie || ' ' || k.nazwisko "Przelozony", o.nazwa "Nazwa oddzialu"
FROM pracownicy p LEFT JOIN pracownicy k ON k.id = p.id_przelozonego JOIN oddzialy_firmy o ON o.id=p.id_oddzialu
ORDER BY 2 DESC;


--wyswietlanie nazwiska, imienia, poziomu w hierarchii pracownikow i wieku
SELECT nazwisko "Nazwisko", pierwsze_imie "Pierwsze imiê", LEVEL "Poziom w hierarchii", FLOOR(MONTHS_BETWEEN(sysdate, data_urodzenia)/12) "Wiek"
FROM pracownicy
START WITH ID_PRZELOZONEGO IS NULL
CONNECT BY ID_PRZELOZONEGO=PRIOR id
ORDER BY LEVEL;

--wyswietlanie ilu jest pracowników w ka¿dym z oddzialów
SELECT o.nazwa "Nazwa", COUNT(p.id) "Liczba pracownikow"
FROM PRACOWNICY p JOIN ODDZIALY_FIRMY o ON o.id=p.id_oddzialu
GROUP BY o.nazwa
ORDER BY 1 ASC;

--wyswietlanie pracowników, którzy s¹ przelozonymi
SELECT nazwisko
FROM pracownicy
WHERE id IN (SELECT DISTINCT id_przelozonego
                        FROM pracownicy)
ORDER BY 1;

--zmiana nazwy tabeli czlonkowie_rodzin na osoby_na_utrzymaniu
RENAME czlonkowie_rodzin to osoby_na_utrzymaniu;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_PK TO osoby_na_utrzymaniu_PK;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_plec_CH TO osoby_na_utrzymaniu_plec_CH;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_imie_CH TO osoby_na_utrzymaniu_imie_CH;
ALTER TABLE osoby_na_utrzymaniu RENAME CONSTRAINT czlonkowie_rodzin_prac_FK TO osoby_na_utrzymaniu__prac_FK;

--utworzenie widoku przechowuj¹cego imie i nazwisko polaczone spacja oraz plec
CREATE VIEW V_PRACOWNICY AS
SELECT pierwsze_imie || ' ' || nazwisko dane, DECODE(plec, 'K', 'Kobieta', 'M', 'Mê¿czyzna') plec
FROM PRACOWNICY;

--zapytanie wyswietlajace dane kobiet na widoku V_PRACOWNICY
SELECT dane
FROM V_PRACOWNICY
WHERE plec = 'Kobieta';

--wyswietlanie za pomoc¹ perspektywy systemowej informacji o kolumnach w tabeli pracownicy
SELECT column_name, data_type, data_precision, data_scale,
       data_length, nullable, data_default  
FROM USER_TAB_COLUMNS
WHERE table_name='PRACOWNICY';
