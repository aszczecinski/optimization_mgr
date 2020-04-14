CREATE OR REPLACE PACKAGE "CREATE_DATA_ENGINE" IS
  /**
  * Creates entries in KLIENT table.
  *  @param pNumberOfClients should represent the number of individual
  *  clients that will be created by the procedure
  */
  procedure FILL_CLIENT_TABLE(pNumberOfClients number);

  /**
  * Creates entries in ZAMOWIENIE table.
  *  @param pNumberOfOrders should represent the number of individual
  *  orders that will be created by the procedure
  */
  procedure FILL_ORDER_TABLE(pNumberOfOrders number);

  /**
  * Creates entries in FAKTURA table.
  *  @param pNumberOfInvoices should represent the number of individual
  *  invoices that will be created by the procedure
  */
  procedure FILL_INVOICE_TABLE(pNumberOfInvoices number);

  /**
  * Creates entries in WYSYLKA table.
  *  @param pNumberOfShipments should represent the number of individual
  *  invoices that will be created by the procedure
  */
  procedure FILL_SHIPMENT_TABLE(pNumberOfShipments number);

END;
/

CREATE OR REPLACE PACKAGE BODY "CREATE_DATA_ENGINE" IS

  CURSOR rObjCols(pObjectName varchar2, pObjectType varchar2 default 'TABLE') is
                  select c.TABLE_NAME, c.COLUMN_NAME from USER_OBJECTS o
                  join USER_TAB_COLUMNS c
                  on o.OBJECT_NAME = c.TABLE_NAME
                  where o.OBJECT_NAME = pObjectName
                  and o.OBJECT_TYPE = pObjectType
                  order by o.OBJECT_NAME, c.COLUMN_ID;

 CURSOR rConfDict(pKey1 varchar2, pKey2 varchar2, pNumOfRec number) is 
                 with streets as
                 (select ed1.KEY as KEY1, ed1.VALUE as VALUE1, 1 as prio, rownum as ord1 from CONF_EXAMPLE_DICT ed1
                  where ed1.KEY = pKey1 and ROWNUM <= pNumOfRec),
                 cities as
                 (select ed2.KEY as KEY2, ed2.VALUE as VALUE2, 2 as prio, rownum as ord2 from CONF_EXAMPLE_DICT ed2
                  where ed2.KEY = pKey2 and ROWNUM <= pNumOfRec)
                 select streets.KEY1, streets.VALUE1, cities.KEY2, cities.VALUE2 from dual
                   left join streets on 1=1
                   left join cities on streets.ord1 = cities.ord2;


  /**
  * Creates entries in KLIENT table.
  *  @param pNumberOfClients should represent the number of individual
  *  clients that will be created by the procedure
  */
  procedure FILL_CLIENT_TABLE(pNumberOfClients number, pSex varchar2 := 'M') is
    vCnt number;
    vId number(10,0);
    vSql varchar2(4000);
    vColumns varchar2(1000);
    vValues varchar2(1000);
    vIter number(10);
  begin
    select nvl(max(ID), 1) into vId from KLIENT;
    vIter := 0;
    /*for r in rObjCols('KLIENT') loop
      if vIter > 0 then
        vColumns := vColumns || ', ';
      end if;
      vColumns := vColumns || r.COLUMN_NAME;
      vIter := vIter + 1;
    end loop;*/
    for r in rConfDict('ULICA', 'MIEJSCOWOSC', pNumberOfClients) loop
      vSql := 'INSERT INTO KLIENT (ID, ULICA_NUMER, KOD_MIASTO, MIASTO, NIP, REGON, DATA_UTWORZENIA, DATA_MODYFIKACJI)
      VALUES (' || vId || ', ''' || r.VALUE1 || ' ' || (floor(dbms_random.value(1, 10*vId/2)+1)) || ''', ''' || (floor(dbms_random.value(10, 99)))|| '-' || (floor(dbms_random.value(100, 999))) || ''', ''' || r.VALUE2 || ''', ' || floor(dbms_random.value(1000000000, 9999999999)) || ', ' || floor(dbms_random.value(100000000, 999999999)) || ', ' || 'TO_DATE(''' ||TO_CHAR((SYSDATE - 10), 'YYYY-MM-DD HH24:MI:SS') || ''', ''YYYY-MM-DD HH24:MI:SS'')' || ', null)';
      DBMS_OUTPUT.PUT_LINE(vSql);
	  execute immediate vSql;
      vId := vId + 1;
    end loop;
  end;

  /**
  * Creates entries in ZAMOWIENIE table.
  *  @param pNumberOfOrders should represent the number of individual
  *  orders that will be created by the procedure
  */
  procedure FILL_ORDER_TABLE(pNumberOfOrders number) is
  begin 
    null;  
  end;

  /**
  * Creates entries in ELEMENT_ZAMOWIENIA table.
  *  @param pNumberOfElements stands for rows in ELEMENT_ZAMOWIENIA
  */
  procedure fill_elem_of_order_table(pNumberOfElements number) is
  begin 
    null;  
  end;

  /**
  * Creates entries in FAKTURA table.
  *  @param pNumberOfInvoices should represent the number of individual
  *  invoices that will be created by the procedure
  */
  procedure FILL_INVOICE_TABLE(pNumberOfInvoices number) is
  begin 
    null;  
  end;
  /**
  * Creates entries in ELEMENT_FAKTURY table.
  *  @param pNumberOfElements stands for rows in ELEMENT_FAKTURY
  */
  procedure fill_elem_of_invoice_table(pNumberOfElements number) is
  begin 
    null;  
  end;
  /**
  * Creates entries in WYSYLKA table.
  *  @param pNumberOfShipments should represent the number of individual
  *  invoices that will be created by the procedure
  */
  procedure FILL_SHIPMENT_TABLE(pNumberOfShipments number) is
  begin 
    null;  
  end;
END;
