/*
 * Podstawowy wIDok, który łączy się ze wszystkimi tabelami przechowującymi 
 * dane powstałe przy wykorzystywaniu systemu
**/
CREATE OR REPLACE FORCE VIEW V_INFO_Z_SYSTEMU
select k.*,
       z.*,
       ez.*,
       f.*,
       ef.*,
       w.*,
       fl.*
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