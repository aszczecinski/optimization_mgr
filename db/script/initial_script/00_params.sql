set serveroutput on size 100000
spool 00_params.log

/*
 * Fill your database parameters.
 * There is no need to use quotation marks
**/

def SCHEMA_NAME=ASZ_TEST_USER_DB
def SCHEMA_PASSWORD=examplePassword
def TABLESPACE=exampleTablespace

spool off 