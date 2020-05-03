CREATE OR REPLACE TRIGGER "TRG_ADD_AUDIT_LOG"
AFTER INSERT ON
"FAKTURA" for each row
--declare
-- pragma autonomous_transaction; --caused deadlock...
BEGIN
  INSERT INTO FAKTURA_LOG (ID_LOG, DATA_UTWORZENIA, ID_FAKTURA) VALUES
  (FAKTURA_SEQ_LOG.nextval, sysdate, :new.ID);
END;
/