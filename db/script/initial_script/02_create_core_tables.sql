set serveroutput on size 100000
spool 02_create_core_tables.log

prompt currently installing...
prompt ../../struct/table/KLIENT.tab
@../../struct/table/KLIENT.tab

prompt currently installing...
prompt ../../struct/table/ZAMOWIENIE.tab
@../../struct/table/ZAMOWIENIE.tab

prompt currently installing...
prompt ../../struct/table/ELEMENT_ZAMOWIENIA.tab
@../../struct/table/ELEMENT_ZAMOWIENIA.tab

prompt currently installing...
prompt ../../struct/table/FAKTURA.tab
@../../struct/table/FAKTURA.tab

prompt currently installing...
prompt ../../struct/table/ELEMENT_FAKTURY.tab
@../../struct/table/ELEMENT_FAKTURY.tab

prompt currently installing...
prompt ../../struct/table/WYSYLKA.tab
@../../struct/table/WYSYLKA.tab

prompt currently installing...
prompt ../../struct/table/FAKTURA_LOG.tab
@../../struct/table/FAKTURA_LOG.tab

SET DEFINE ON
spool off
