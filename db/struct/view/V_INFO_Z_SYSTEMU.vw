/*
 * Podstawowy widok, który łączy się ze wszystkimi tabelami przechowującymi 
 * dane powstałe przy wykorzystywaniu systemu
**/
select k.id                      as K_ID,
       k.ulica_numer             as K_ULICA_NUMER,
       k.kod_miasto              as K_KOD_MIASTO,
       k.miasto                  as K_MIASTO,
       k.nip                     as K_NIP,
       k.regon                   as K_REGON,
       k.data_utworzenia         as K_DATA_UTWORZENIA,
       k.data_modyfikacji        as K_DATA_MODYFIKACJI,
       z.id                      as Z_ID,
       z.id_klient               as Z_ID_KLIENT,
       z.id_faktura              as Z_ID_FAKTURA,
       z.data_utworzenia         as Z_DATA_UTWORZENIA,
       z.data_wyslania           as Z_DATA_WYSLANIA,
       z.opis                    as Z_OPIS,
       ez.id                     as EZ_ID,
       ez.id_zamowienie          as EZ_ID_ZAMOWIENIE,
       ez.nazwa_produktu         as EZ_NAZWA_PRODUKTU,
       ez.liczba                 as EZ_LICZBA,
       ez.cena_jednostkowa_netto as EZ_CENA_JEDN_NETTO,
       ez.stawka_vat             as EZ_STAWKA_VAT,
       ez.upust                  as EZ_UPUST,
       ef.id                     as EF_ID,
       ef.id_faktura             as EF_ID_FAKTURA,
       ef.nazwa_produktu         as EF_NAZWA_PRODUKTU,
       ef.liczba                 as EF_LICZBA,
       ef.cena_jednostkowa_netto as EF_CENA_JEDN_NETTO,
       ef.stawka_vat             as EF_STAWKA_VAT,
       ef.upust                  as EF_UPUST,
       w.id                      as W_ID,
       w.id_zamowienie           as W_ID_ZAMOWIENIE,
       w.id_faktura              as W_ID_FAKTURA,
       w.ulica_numer             as W_ULICA_NUMER,
       w.kod_miasto              as W_KOD_MIASTO,
       w.miasto                  as W_MIASTO,
       w.id_dostawca             as W_ID_DOSTAWCA,
       w.typ                     as W_TYP,
       fl.id_log                 as FL_ID_LOG,
       fl.data_utworzenia        as FL_DATA_UTWORZENIA,
       fl.id_faktura             as FL_ID_FAKUTRA
  from KLIENT k
  full join ZAMOWIENIE z
    on z.ID_KLIENT = k.ID
  full join ELEMENT_ZAMOWIENIA ez
    on ez.ID_Zamowienie = z.ID
  full join FAKTURA f
    on f.ID_zamowienia = z.ID
   and f.ID_klient = k.ID
  full join ELEMENT_FAKTURY ef
    on ef.ID_Faktura = f.ID
  full join wysylka w
    on w.ID_faktura = f.ID
  full join FAKTURA_LOG fl
    on fl.ID_faktura = f.ID
 order by k.ID,
          k.data_utworzenia,
          f.ID,
          f.data_wystawienia,
          z.data_utworzenia,
          ez.liczba;
