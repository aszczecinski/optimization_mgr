set serveroutput on size 100000
spool 00_create_full_database.log

/*
 * This very script allows you to create schema
 * on which tests were performed. Please remember
 * to modify data in 00_params.sql file. 
**/

prompt Hello!
prompt Installation of schema is in progress...
prompt Please wait...

prompt Reading configuration file...
prompt 00_params.sql
@00_params.sql

prompt ...
prompt 01_create_user.sql
@01_create_user.sql

prompt ...
prompt 02_create_core_tables.sql
@02_create_core_tables.sql

prompt ...
prompt 03_create_engine_tables.sql
@03_create_engine_tables.sql

prompt ...
prompt 04_create_sequences.sql
@04_create_sequences.sql

prompt ...
prompt 05_create_triggers.sql
@05_create_triggers.sql

prompt ...
prompt 06_create_views.sql
@06_create_views.sql

prompt ...
prompt 07_create_engine_packages.sql
@07_create_engine_packages.sql

prompt Installation has successfully ended!
prompt Please check logs and login to the installed schema.


spool off 