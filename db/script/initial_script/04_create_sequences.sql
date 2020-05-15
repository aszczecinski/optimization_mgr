set serveroutput on size 100000
spool 04_create_sequences.log

prompt currently installing...
prompt ../../struct/sequences.sql
@../../struct/sequences.sql

SET DEFINE ON
spool off
