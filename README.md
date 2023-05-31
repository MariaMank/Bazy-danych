# Bazy danych przestrzennych 
Projekt końcowy z przedmiotu Bazy i Modele Danych Przestrzennych


Repozytorium zawiera dwa pliki.
W pliku data base creation znajduje się kod w języku PostgreSQL z wykorzystaniem PostGIS umożliwiający utworzenie części bazy BDOT500. Kod tworzy między innymi większość z tabel z poniższego schematu, a także wszystkie powiązane z nimi słowniki i klasy po których dziedziczą. W pliku tym znajduje się także implementacja mechanizmów (trigger), które po wykryciu próby aktualizacji w tabeli bdz_tor sprawdzą, czy aktualizacja dotyczy atrybutu poziom. Jeżeli tak, to w dodatkowy atrybut x_zmiana wprowadzona będzie odpowiednio wartość ‘w górę’ lub ‘w dół’.

![image](https://github.com/MariaMank/Bazy-danych-przestrzennych/assets/92314221/9c7c148d-5e59-4ba2-80eb-cd31cbc39b3b)

W drugim pliku (funcion.txt) znajdują się funkcje, które tworzą tabelę obszary_konflikty (id (serial) PK, geom (geometria), rodzaj (tekst)). Następnie wyszukują wszystkie rekordy z tabeli bdz_tor, które są całkowicie wewnątrz poligonu przekazanego do funkcji jako parametr funkcji. Wszystkie znalezione w ten sposób osie toru zostają zbuforowane w zalęzności od wartości atrybutu rodzajtor (torKolejowy = 50m, torMetra = 100m, torTramwajowy=10m).
Dla wszystkich tak powstałych geometrii  funkcja wykonuje analizę, która polega na znalezieniu obszarów przecięcia buforów różnych rodzajów. Efekty analizy wprowadza do tabeli obszary_konflikty.


Repozytorium zawiera dwa pliki. Repository has two files
W pliku data base creation znajduje się kod w języku PostgreSQL z wykorzystaniem PostGIS umożliwiający utworzenie części bazy BDOT500. Kod tworzy między innymi większość z tabel z poniższego schematu, a także wszystkie powiązane z nimi słowniki i klasy po których dziedziczą. W pliku tym znajduje się także implementacja mechanizmów (trigger), które po wykryciu próby aktualizacji w tabeli bdz_tor sprawdzą, czy aktualizacja dotyczy atrybutu poziom. Jeżeli tak, to w dodatkowy atrybut x_zmiana wprowadzona będzie odpowiednio wartość ‘w górę’ lub ‘w dół’.
