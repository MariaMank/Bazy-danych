
CREATE TABLE BT_OznaczenieZasobu(
	nazwa text NOT NULL,
	ID char UNIQUE PRIMARY KEY
);
INSERT INTO BT_OznaczenieZasobu (nazwa, ID) VALUES ('centralny', 'C'),
						('wojewodzki', 'W'),
						('powiatowy', 'P');

CREATE TABLE BDZ_Zrodlo (
	nazwa text NOT NULL,
	ID char UNIQUE PRIMARY KEY
	);
Insert into BDZ_Zrodlo (nazwa, ID) VALUES ('pomiarNaOsnowe', 'O'),
						('digitalizacjaWektoryzacja', 'D'),
						('fotogrametria', 'F'),
						('pomiarWOparciOElementyMapy', 'M'),
						('inne', 'I'),
						('nieokreslone', 'X'),
						('niepoprawne', 'N');
						
CREATE TABLE BDZ_Poziom (
	nazwa text NOT NULL,
	ID integer UNIQUE PRIMARY KEY
	);
INSERT INTO BDZ_Poziom (nazwa, ID) VALUES ('drugiPoziomPodPowierzchniaGruntu', -2),
						('pierwszyPoziomPodPowierzchniaGruntu', -1),
						('naPowierzchniGruntu', 0),
						('pierwszyPoziomPonadPowierzchniaGruntu', 1),
						('drugiPoziomPonadPowierzchniaGruntu', 2),
						('trzeciPoziomPonadPowierzchniaGruntu', 3),
						('czwartyPoziomPonadPowierzchniaGruntu', 4);
CREATE TABLE BDZ_RodzajTor (
	nazwa text NOT NULL,
	ID text UNIQUE PRIMARY KEY
	);
INSERT INTO BDZ_RodzajTor (nazwa, ID) VALUES ('torKolejowy', 'poc'),
						('torMetra', 'mtr'),
						('torTramwajowy', 'trm');
CREATE TABLE BDZ_RodzajPrzepr (
	nazwa text NOT NULL,
	ID text UNIQUE PRIMARY KEY
	);
INSERT INTO BDZ_RodzajPrzepr (nazwa, ID) VALUES ('brod', 'br'),
						('przeprawaLodziami', 'ld'),
						('przeprawaPromowa', 'pr');
						
CREATE TABLE BDZ_RodzajObKomun (
	nazwa text NOT NULL,
	ID text UNIQUE PRIMARY KEY
	);
INSERT INTO BDZ_RodzajObKomun (nazwa, ID) VALUES ('barieraDrogowaOchronna', 'bd'),
						('brama', 'b'),
						('ekranAkustyczny', 'e'),
						('furtka', 'f'),
						('ogrodzenieTrwale', 'o'),
						('schodyWCiaguKomunikacyjnym', 's');


CREATE TABLE BDZ_Kraweznik (
	ID serial PRIMARY KEY,
	lokalnyId text NOT NULL,
	przestrzenNazw text NOT NULL,
	wersjaId timestamp,
	startObiekt Date NOT NULL,
	koniecWersjiObiektu timestamp,
 	poczatekWersjiObiektu timestamp NOT NULL,
	koniecObiekt Date,
	IdZrodlo char NOT NULL, 
	IdPierwszyCzlon char NOT NULL, 
	drugiCzlon text NOT NULL, 
	trzeciCzlon integer NOT NULL,
	czwartyCzlon integer NOT NULL,
	Dokument text,
	Informacja text,
	dataPomiaru Date check((IdZrodlo <> 'o')<>(IdZrodlo = 'o' and dataPomiaru is not null)),
	geometria  geometry(linestring, 2180) NOT NULL,
	FOREIGN KEY (IdZrodlo) REFERENCES BDZ_Zrodlo (ID),
	FOREIGN KEY (IdPierwszyCzlon) REFERENCES BT_OznaczenieZasobu (ID)
);

CREATE TABLE BDZ_Tor (
	ID serial PRIMARY KEY,
	lokalnyId text NOT NULL,
	przestrzenNazw text NOT NULL,
	wersjaId timestamp,
	startObiekt Date NOT NULL,
	koniecWersjiObiektu timestamp,
 	poczatekWersjiObiektu timestamp NOT NULL,
	koniecObiekt Date,
	IdZrodlo char NOT NULL, 
	IdPierwszyCzlon char NOT NULL, 
	drugiCzlon text NOT NULL, 
	trzeciCzlon integer NOT NULL,
	czwartyCzlon integer NOT NULL,
	Dokument text,
	Informacja text,
	dataPomiaru Date check((IdZrodlo <> 'o')<>(IdZrodlo = 'o' and dataPomiaru is not null)),
	geometria geometry(linestring, 2180) NOT NULL,
	IdRodzajToru text NOT NULL REFERENCES BDZ_RodzajTor (ID), 
	IdPoziom integer NOT NULL REFERENCES BDZ_Poziom (ID),
	x_zmiana text,
	FOREIGN KEY (IdZrodlo) REFERENCES BDZ_Zrodlo (ID),
	FOREIGN KEY (IdPierwszyCzlon) REFERENCES BT_OznaczenieZasobu (ID)
);

CREATE TABLE BDZ_Przeprawa (
	ID serial PRIMARY KEY,
	lokalnyId text NOT NULL,
	przestrzenNazw text NOT NULL,
	wersjaId timestamp,
	startObiekt Date NOT NULL,
	koniecWersjiObiektu timestamp,
 	poczatekWersjiObiektu timestamp NOT NULL,
	koniecObiekt Date,
	IdZrodlo char NOT NULL, 
	IdPierwszyCzlon char NOT NULL, 
	drugiCzlon text NOT NULL, 
	trzeciCzlon integer NOT NULL,
	czwartyCzlon integer NOT NULL,
	Dokument text,
	Informacja text,
	dataPomiaru Date check((IdZrodlo <> 'o')<>(IdZrodlo = 'o' and dataPomiaru is not null)),
	geometria geometry(linestring, 2180) NOT NULL,
	IdRodzajPrzeprawy text REFERENCES BDZ_RodzajPrzepr (ID),
	FOREIGN KEY (IdZrodlo) REFERENCES BDZ_Zrodlo (ID),
	FOREIGN KEY (IdPierwszyCzlon) REFERENCES BT_OznaczenieZasobu (ID)
);

CREATE TABLE BDZ_ObiektZwiazanyZKomunikacja (
	ID serial PRIMARY KEY,
	lokalnyId text NOT NULL,
	przestrzenNazw text NOT NULL,
	wersjaId timestamp,
	startObiekt Date NOT NULL,
	koniecWersjiObiektu timestamp,
 	poczatekWersjiObiektu timestamp NOT NULL,
	koniecObiekt Date,
	IdZrodlo char NOT NULL, 
	IdPierwszyCzlon char NOT NULL, 
	drugiCzlon text NOT NULL, 
	trzeciCzlon integer NOT NULL,
	czwartyCzlon integer NOT NULL,
	Dokument text,
	Informacja text,
	dataPomiaru Date check((IdZrodlo <> 'o')<>(IdZrodlo = 'o' and dataPomiaru is not null)), 
	IdRodzajObKomun text NOT NULL REFERENCES BDZ_RodzajObKomun (ID), 
	geometria geometry NOT NULL check((bdz_obiektzwiazanyzkomunikacja.idrodzajobkomun <> 'o')<>
									  (bdz_obiektzwiazanyzkomunikacja.idrodzajobkomun = 'o' and 
									   (GeometryType(geometria) = 'LINESTRING' or GeometryType(geometria) = 'MULTIPOLYGON' ))),
	poliliniaKierunkowa geometry(linestring, 2180),	
	FOREIGN KEY (IdZrodlo) REFERENCES BDZ_Zrodlo (ID),
	FOREIGN KEY (IdPierwszyCzlon) REFERENCES BT_OznaczenieZasobu (ID)
);


CREATE INDEX ix_bdz_kraweznik1
ON BDZ_Kraweznik (koniecObiekt);
CREATE INDEX ix_bdz_kraweznik2
ON BDZ_Kraweznik (koniecWersjiObiektu);
CREATE INDEX ix_bdz_kraweznik5
ON BDZ_Kraweznik (poczatekWersjiObiektu);
CREATE INDEX ix_bdz_kraweznik3
ON BDZ_Kraweznik (Idzrodlo);
CREATE INDEX ix_bdz_kraweznik4
ON BDZ_Kraweznik (IdpierwszyCzlon);
CREATE INDEX ssix_bdz_kraweznik
ON BDZ_Kraweznik USING gist (geometria);

CREATE INDEX ix_bdz_tor1
ON BDZ_Tor (koniecObiekt);
CREATE INDEX ix_bdz_tor2
ON BDZ_Tor (koniecWersjiObiektu);
CREATE INDEX ix_bdz_bdz_tor5
ON BDZ_Tor (poczatekWersjiObiektu);
CREATE INDEX ix_bdz_bdz_tor3
ON BDZ_Tor (Idzrodlo);
CREATE INDEX ix_bdz_bdz_tor4
ON BDZ_Tor (IdpierwszyCzlon);
CREATE INDEX six_bdz_bdz_tor
ON BDZ_Tor USING gist (geometria);
CREATE INDEX ix_bdz_bdz_tor6
ON BDZ_Tor (IdRodzajToru);
CREATE INDEX ix_bdz_bdz_tor7
ON BDZ_Tor (IdPoziom);

CREATE INDEX ix_BDZ_Przeprawa1
ON BDZ_Przeprawa (koniecObiekt);
CREATE INDEX ix_BDZ_Przeprawa2
ON BDZ_Przeprawa (koniecWersjiObiektu);
CREATE INDEX ix_BDZ_Przeprawa5
ON BDZ_Przeprawa (poczatekWersjiObiektu);
CREATE INDEX ix_BDZ_Przeprawa3
ON BDZ_Przeprawa (Idzrodlo);
CREATE INDEX ix_BDZ_Przeprawa4
ON BDZ_Przeprawa (IdpierwszyCzlon);
CREATE INDEX six_BDZ_Przeprawa
ON BDZ_Przeprawa USING gist (geometria);
CREATE INDEX ix_bdz_BDZ_Przeprawa6
ON BDZ_Przeprawa (IdRodzajPrzeprawy);

CREATE INDEX ix_BDZ_ObKom1
ON BDZ_ObiektZwiazanyZKomunikacja (koniecObiekt);
CREATE INDEX ix_BDZ_ObKom2
ON BDZ_ObiektZwiazanyZKomunikacja (koniecWersjiObiektu);
CREATE INDEX ix_BDZ_ObKom5
ON BDZ_ObiektZwiazanyZKomunikacja (poczatekWersjiObiektu);
CREATE INDEX ix_BDZ_OBKom3
ON BDZ_ObiektZwiazanyZKomunikacja (Idzrodlo);
CREATE INDEX ix_BDZ_ObKom4
ON BDZ_ObiektZwiazanyZKomunikacja (IdpierwszyCzlon);
CREATE INDEX six_BDZ_ObKom
ON BDZ_ObiektZwiazanyZKomunikacja USING gist (poliliniaKierunkowa);
CREATE INDEX ix_bdz_BDZ_ObKom6
ON BDZ_ObiektZwiazanyZKomunikacja (IdRodzajObKomun);

---TRIGGER
create or replace function
newzmiana() returns trigger as
$body$
begin
	if old.idpoziom < new.idpoziom
    	then NEW.x_zmiana := 'w górę';		
	elsif old.idpoziom > new.idpoziom then 
		new.x_zmiana := 'w dół' ;		
	end if;
	RETURN NEW;
	end;
$body$ 

language plpgsql cost 100; --w mili sekundach

create trigger trg_change
before UPDATE of Idpoziom 
on bdz_tor
for each row
--when (old.poziom IS DISTINCT new.poziom)
execute procedure newzmiana()
