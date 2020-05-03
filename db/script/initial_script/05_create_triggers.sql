set serveroutput on size 100000
spool 05_create_triggers.log

prompt currently installing...
prompt ../../struct/trigger/TRG_ADD_FAKTURA_LOG.trg
@../../struct/trigger/TRG_ADD_FAKTURA_LOG.trg

SET DEFINE ON
spool off
