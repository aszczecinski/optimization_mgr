set serveroutput on size 100000
spool 07_create_engine_packages.log

prompt currently installing...
prompt ../../struct/_engine/package/CREATE_DATA_ENGINE.pck
@../../struct/_engine/package/CREATE_DATA_ENGINE.pck


SET DEFINE ON
spool off
