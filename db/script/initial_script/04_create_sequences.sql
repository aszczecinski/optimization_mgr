set serveroutput on size 100000
spool 04_create_sequences.log

prompt currently installing...
prompt ../../struct/sequences.sql
@../../struct/struct/sequences.sql

prompt currently installing...
prompt ../../struct/table/CONF_EXAMPLE_DICT.tab
@../../struct/table/CONF_EXAMPLE_DICT.tab

SET DEFINE ON
spool off
