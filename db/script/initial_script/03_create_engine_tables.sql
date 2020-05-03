set serveroutput on size 100000
spool 03_create_engine_tables.log

prompt currently installing...
prompt ../../struct/_engine/table/CONF_COL_PATTERNS.tab
@../../struct/table/CONF_COL_PATTERNS.tab

prompt currently installing...
prompt ../../struct/_engine/table/CONF_EXAMPLE_DICT.tab
@../../struct/_engine/table/CONF_EXAMPLE_DICT.tab

SET DEFINE ON
spool off
