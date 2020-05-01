DECLARE
  vNumberOfClients     NUMBER := 10;
  vNumberOfOrders      NUMBER := 70;
  vNumberOfInvoices    NUMBER := 50;
  vNumberOfShipments   NUMBER := 50;
  vMaxNumberOfElements NUMBER := 150;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Data rozpoczęcia: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
  CREATE_DATA_ENGINE.FILL_CLIENT_TABLE(pNumberOfClients => vNumberOfClients);
  CREATE_DATA_ENGINE.FILL_ORDER_TABLE(pNumberOfOrders      => vNumberOfOrders, 
                                      pMaxNumberOfElements => vMaxNumberOfElements);
  CREATE_DATA_ENGINE.FILL_INVOICE_TABLE(pNumberOfInvoices => vNumberOfInvoices);
  CREATE_DATA_ENGINE.FILL_SHIPMENT_TABLE(pNumberOfShipments => vNumberOfShipments);
  DBMS_OUTPUT.PUT_LINE('Data zakończenia: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/