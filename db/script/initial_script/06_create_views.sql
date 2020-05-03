set serveroutput on size 100000
spool 06_create_views.log

prompt currently installing...
prompt ../../struct/view/V_FAKTURA_ROK.vw
@../../struct/view/V_FAKTURA_ROK.vw

prompt currently installing...
prompt ../../struct/view/V_INFO_Z_SYSTEMU.vw
@../../struct/view/V_INFO_Z_SYSTEMU.vw

SET DEFINE ON
spool off
