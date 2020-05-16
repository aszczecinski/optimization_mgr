/*
 * Podstawowy widok, który łączy się ze wszystkimi tabelami przechowującymi 
 * dane powstałe przy wykorzystywaniu systemu
 * zmiany: statystyki, inner join zamiast full, usunięte nadmiarowe kolumny, usunięty FAKTURA_LOG join i kolumny.
**/
CREATE OR REPLACE FORCE VIEW V_INFO_Z_SYSTEMU_INNER_COL_2 AS
select k.id                      as K_ID,
       k.ulica_numer             as K_ULICA_NUMER,
       k.kod_miasto              as K_KOD_MIASTO,
       k.miasto                  as K_MIASTO,
       k.nip                     as K_NIP,
       k.regon                   as K_REGON,
       k.data_utworzenia         as K_DATA_UTWORZENIA,
       k.data_modyfikacji        as K_DATA_MODYFIKACJI,
       z.id                      as Z_ID,
       z.id_faktura              as Z_ID_FAKTURA,
       z.data_utworzenia         as Z_DATA_UTWORZENIA,
       z.data_wyslania           as Z_DATA_WYSLANIA,
       z.opis                    as Z_OPIS,
       ez.id                     as EZ_ID,
       ez.nazwa_produktu         as EZ_NAZWA_PRODUKTU,
       ez.liczba                 as EZ_LICZBA,
       ez.cena_jednostkowa_netto as EZ_CENA_JEDN_NETTO,
       ez.stawka_vat             as EZ_STAWKA_VAT,
       ez.upust                  as EZ_UPUST,
       f.nazwa_klienta           as F_NAZWA_KLIENTA,
       f.nr_faktury              as F_NR_FAKTURY,
       f.data_wystawienia        as F_DATA_WYSTAWIENIA,
       f.data_platnosci          as F_DATA_PLATNOSCI,
       f.data_wykonania_uslugi   as F_DATA_WYKONANIA_USLUGI,
       f.opis                    as F_OPIS,
       ef.id                     as EF_ID,
       ef.nazwa_produktu         as EF_NAZWA_PRODUKTU,
       ef.liczba                 as EF_LICZBA,
       ef.cena_jednostkowa_netto as EF_CENA_JEDN_NETTO,
       ef.stawka_vat             as EF_STAWKA_VAT,
       ef.upust                  as EF_UPUST,
       w.id                      as W_ID,
       w.ulica_numer             as W_ULICA_NUMER,
       w.kod_miasto              as W_KOD_MIASTO,
       w.miasto                  as W_MIASTO,
       w.id_dostawca             as W_ID_DOSTAWCA,
       w.typ                     as W_TYP
  from klient k
  join zamowienie z
    on z.id_klient = k.id
  join element_zamowienia ez
    on ez.id_zamowienie = z.id
  join faktura f
    on f.id_zamowienia = z.id
   and f.id_klient = k.id
  join element_faktury ef
    on ef.id_faktura = f.id
  join wysylka w
    on w.id_faktura = f.id
 order by k.id,
          k.data_utworzenia,
          f.id,
          f.data_wystawienia,
          z.data_utworzenia,
          ez.liczba;