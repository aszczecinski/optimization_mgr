set serveroutput on size 100000
spool 08_create_engine_entries.log

prompt currently installing...
prompt ../../../other/FILL_CONF_EXAMPLE_DICT.sql
@../../../other/FILL_CONF_EXAMPLE_DICT.sql


SET DEFINE ON
spool off
