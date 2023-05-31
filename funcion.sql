--FUNKCJA POMOCNICZA konieczna przy wywoływaniu końcowej funkcji
create or replace function
wyborbuf(rodzaj text) returns text as
$body$
declare 
resultt integer;
begin
	if rodzaj = 'poc'
    	then resultt := 50;		
	elsif rodzaj = 'mtr'
		then resultt := 100;
	elsif rodzaj = 'trm' 
		then resultt := 10;
	end if;
	RETURN resultt;
	end;
$body$ 
language plpgsql cost 100; --w mili sekundach

----DOCELOWA FUNKCJA LICZACA POSZCZEGOLNE ETAPY ZADANIA------------------
create or replace function tor_konfliktty(poligon geometry(polygon, 2180)) returns text as
$$
begin
DROP TABLE IF EXISTS obszary_konflikty; 
CREATE TABLE obszary_konflikty ( 
	id serial primary key,
	geom geometry(polygon, 2180) not null,
	rodzaj text
);
CREATE TABLE wewnatrz as --temporary
SELECT * 
FROM BDZ_Tor as t
where ST_Within(t.geometria, poligon);

create table zbuforowane as
select ST_Buffor(w.geometria, wyborbuf(w.idrodzajtoru)) as geom, w.idrodzajtoru as rodzaj
from wewnatrz as w;

create table zbuforowane2 as
select *
from zbuforowane;

insert into obszary_konflikty
select ST_Intersects(z.geom, zz.geom) as geom, z.rodzaj + zz.rodzaj as rodzaj
from zbuforowane as z , zbuforowane2 as zz
where z.rodzaj <> zz.rodzaj;

DROP TABLE wewnatrz;
DROP TABLE zbuforowane;
DROP TABLE zbuforowane2;
end;
$$
