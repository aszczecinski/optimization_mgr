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
  procedure FILL_ORDER_TABLE(pNumberOfOrders number, pMaxNumberOfElements number default null);

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
                  where ed1.KEY = pKey1 ORDER BY dbms_random.value),
                 cities as
                 (select ed2.KEY as KEY2, ed2.VALUE as VALUE2, 2 as prio, rownum as ord2 from CONF_EXAMPLE_DICT ed2
                  where ed2.KEY = pKey2 ORDER BY dbms_random.value)
                 select streets.KEY1, streets.VALUE1, cities.KEY2, cities.VALUE2 from dual
                   join streets on 1=1
                   join cities on streets.ord1 = cities.ord2
         where ROWNUM <= pNumOfRec;

 CURSOR rInvoice is
                select f.id,
                       f.id_klient,
                       f.id_zamowienia,
                       f.nazwa_klienta,
                       f.nr_faktury,
                       f.data_wystawienia,
                       f.data_platnosci,
                       f.data_wykonania_uslugi,
                       f.opis from FAKTURA f order by f.ID asc;

 CURSOR rInvoiceClientOrd is
                select f.id,
                       f.id_klient,
                       f.id_zamowienia,
                       f.nazwa_klienta,
                       k.kod_miasto,
                       k.ulica_numer,
                       k.miasto
                       from FAKTURA f
                       join ZAMOWIENIE z on f.Id_Zamowienia = z.ID
                       join KLIENT k on f.Id_Klient = k.ID 
                       where not exists (select 1 from WYSYLKA where ID_FAKTURA = f.ID) order by f.ID asc;


  /**
  * Creates entries in KLIENT table.
  *  @param pNumberOfClients should represent the number of individual
  *  clients that will be created by the procedure
  */
  procedure FILL_CLIENT_TABLE(pNumberOfClients number) is
    vCnt number;
    vId number(10,0);
    vSql varchar2(4000);
    vColumns varchar2(1000);
    vValues varchar2(1000);
    vIter number(10);
  begin
    select nvl(max(ID), 0) into vId from KLIENT;
    vIter := vId;

    vId := vId + 1;
	while vIter+pNumberOfClients >= vId loop	
      for r in rConfDict('ULICA', 'MIEJSCOWOSC', pNumberOfClients) loop
        vSql := 'INSERT INTO KLIENT (ID, ULICA_NUMER, KOD_MIASTO, MIASTO, NIP, REGON, DATA_UTWORZENIA, DATA_MODYFIKACJI)
        VALUES (' || vId || ', ''' || r.VALUE1 || ' ' || (floor(dbms_random.value(1, 1*vId/2)+1)) || ''', ''' || (floor(dbms_random.value(10, 99)))|| '-' || (floor(dbms_random.value(100, 999))) || ''', ''' || r.VALUE2 || ''', ' || floor(dbms_random.value(1000000000, 9999999999)) || ', ' || floor(dbms_random.value(100000000, 999999999)) || ', ' || 'TO_DATE(''' ||TO_CHAR(SYSDATE - ROUND(DBMS_RANDOM.VALUE(5,300),1), 'YYYY-MM-DD HH24:MI:SS') || ''', ''YYYY-MM-DD HH24:MI:SS'')' || ', null)';
        execute immediate vSql;
        vId := vId + 1;
      end loop;
	end loop;
    commit;
  end;

  /**
  * Creates entries in ELEMENT_ZAMOWIENIA table.
  *  @param pNumberOfElements stands for rows in ELEMENT_ZAMOWIENIA
  */
  procedure fill_elem_of_order_table(pMinIdOrder number, pIdOrder number, pMaxNumberOfElements number) is
    vSql VARCHAR2(4000);
    vMaxNumberOfElements number;
    vProductName VARCHAR2(200);
    vIdOrder NUMBER(10,0);
    vCount NUMBER(6,0);
    vPrice NUMBER(24,2);
    vTax NUMBER(3,2);
    vDiscount NUMBER(3,2);
  begin
    vMaxNumberOfElements := pMaxNumberOfElements;
    for r in pMinIdOrder..pIdOrder loop
      vMaxNumberOfElements := ROUND(DBMS_RANDOM.VALUE(1,vMaxNumberOfElements));--more random!
      for rr in 1..vMaxNumberOfElements loop
        vIdOrder := r;
        vTax := 0.23;
        vDiscount := 0;
        if mod(rr,10) = 0 then
          vProductName := 'H_' || DBMS_RANDOM.string('x',3);
          vCount := ROUND(DBMS_RANDOM.VALUE(1,14));
          vPrice := ROUND(DBMS_RANDOM.VALUE(5000,12000), 2);
        elsif mod(rr,7) = 0 then
          vProductName := 'M_' || DBMS_RANDOM.string('x',3);
          vCount := ROUND(DBMS_RANDOM.VALUE(3,300));
          vPrice := ROUND(DBMS_RANDOM.VALUE(1,15), 2);
        elsif mod(rr,5) = 0 then
          vProductName := 'S_' || DBMS_RANDOM.string('x',3);
          vCount := ROUND(DBMS_RANDOM.VALUE(2,24));
          vPrice := ROUND(DBMS_RANDOM.VALUE(134,777), 2);
        elsif mod(rr,3) = 0 then
          vProductName := 'B_' || DBMS_RANDOM.string('x',3);
          vCount := ROUND(DBMS_RANDOM.VALUE(1,100));
          vPrice := ROUND(DBMS_RANDOM.VALUE(5000,12000), 2);
        elsif mod(rr,2) = 0 then
          vProductName := 'O_' || DBMS_RANDOM.string('x',3);
          vCount := ROUND(DBMS_RANDOM.VALUE(1,5));
          vPrice := ROUND(DBMS_RANDOM.VALUE(1000,5000), 2);
        else
          vProductName := 'I_' || DBMS_RANDOM.string('x',3);
          vCount := ROUND(DBMS_RANDOM.VALUE(1,134));
          vPrice := ROUND(DBMS_RANDOM.VALUE(0.50,956.99), 2);
        end if;
        
        vSql := 'INSERT INTO ELEMENT_ZAMOWIENIA (ID, ID_ZAMOWIENIE, NAZWA_PRODUKTU, LICZBA, CENA_JEDNOSTKOWA_NETTO, STAWKA_VAT, UPUST) 
        SELECT ' || ELEM_ZAM_SEQ.nextval || ', ' || vIdOrder || ', ''' || vProductName || ''', ' ||  vCount || ', ' || vPrice || ', ' || vTax || ', ' || vDiscount || ' from dual
        where not exists (select 1 from ELEMENT_ZAMOWIENIA where ID_ZAMOWIENIE = ' || vIdOrder || ' and NAZWA_PRODUKTU = ''' || vProductName || ''')';
		
        execute immediate vSql;

      end loop;
    end loop;
    commit;
  end;

  /**
  * Creates entries in ZAMOWIENIE table.
  *  @param pNumberOfOrders should represent the number of individual
  *  orders that will be created by the procedure
  */
  procedure FILL_ORDER_TABLE(pNumberOfOrders number, pMaxNumberOfElements number default null) is
    CURSOR vClientCurr is
      select ID from (select ID from KLIENT order by dbms_random.value)
      where rownum <= pNumberOfOrders;
    CURSOR vOrderCurr is
      select max(ID) from ZAMOWIENIE;
    vSql VARCHAR2(4000);
    vId number;
    vMinIdOrder number;
    vIdOrder number;
  begin
    open vClientCurr;
    select max(ID) into vMinIdOrder from ZAMOWIENIE;
    loop
      fetch vClientCurr into vId;
      EXIT WHEN vClientCurr%NOTFOUND;
      vIdOrder := ZAMOWIENIE_SEQ.nextval;
      vSql := 'INSERT INTO ZAMOWIENIE (ID, ID_KLIENT, ID_FAKTURA, DATA_UTWORZENIA)
      VALUES (' || vIdOrder || ', ' || vId || ', null, TO_DATE(''' || TO_CHAR(SYSDATE - DBMS_RANDOM.VALUE(5,300), 'YYYY-MM-DD HH24:MI:SS') || ''', ''YYYY-MM-DD HH24:MI:SS'')' || ')';
      execute immediate vSql;
      fill_elem_of_order_table(vIdOrder, vIdOrder, nvl(pMaxNumberOfElements, ROUND(DBMS_RANDOM.VALUE(5,30))));
    end loop;
    close vClientCurr;
    commit;

    --create entries in elements of order table
    --if pMaxNumberOfElements is null then use random value
    /*open vOrderCurr;
    loop
      fetch vOrderCurr into vId;
      EXIT when vOrderCurr%NOTFOUND;
      fill_elem_of_order_table(vMinIdOrder, vId, nvl(pMaxNumberOfElements, ROUND(DBMS_RANDOM.VALUE(5,30))));
    end loop;
    close vOrderCurr;
    commit;*/
  end;

  /**
  * Creates entries in ELEMENT_FAKTURY table.
  *  @param pIdInvoice stands for ID_FAKTURA in ELEMENT_FAKTURY
  */
  procedure fill_elem_of_invoice_table(pIdInvoice number) is
  begin
    INSERT INTO ELEMENT_FAKTURY (ID, ID_FAKTURA, NAZWA_PRODUKTU, LICZBA, CENA_JEDNOSTKOWA_NETTO, STAWKA_VAT, UPUST)
    SELECT ELEM_FAK_SEQ.nextval, f.ID as ID_FAKTURA, ez.NAZWA_PRODUKTU, ez.LICZBA, ez.CENA_JEDNOSTKOWA_NETTO, ez.STAWKA_VAT, ez.UPUST FROM DUAL d
    JOIN FAKTURA f on 1 = 1
    JOIN ELEMENT_ZAMOWIENIA ez on f.ID_ZAMOWIENIA = ez.ID_ZAMOWIENIE
    WHERE f.ID = pIdInvoice and not exists (select 1 from ELEMENT_FAKTURY where ID_FAKTURA = pIdInvoice and NAZWA_PRODUKTU = ez.NAZWA_PRODUKTU);
    
  end;

  /**
  * Updates entries in ZAMOWIENIE table.
  *  @param pIdInvoice stands for ID_FAKTURA in ZAMOWIENIE
  */
  procedure fill_order_info_invoice(pIdInvoice number) is
  begin
    MERGE INTO ZAMOWIENIE z
    USING FAKTURA f
    ON (z.ID = f.ID_ZAMOWIENIA and z.ID_KLIENT = f.ID_KLIENT)
    WHEN MATCHED THEN
      UPDATE SET z.ID_FAKTURA = f.ID
       WHERE z.ID = f.ID_ZAMOWIENIA
       and z.ID_KLIENT = f.ID_KLIENT
       and z.ID_FAKTURA is null;
  end;

  /**
  * Creates entries in FAKTURA table.
  *  @param pNumberOfInvoices should represent the number of individual
  *  invoices that will be created by the procedure
  */
  procedure FILL_INVOICE_TABLE(pNumberOfInvoices number) is
    CURSOR vClientCurr is
      select ID_KLIENT, ID_ZAMOWIENIA from (select k.ID as ID_KLIENT, z.ID as ID_ZAMOWIENIA from KLIENT k
      join ZAMOWIENIE z on z.ID_KLIENT = k.ID
      where not exists (select ID_ZAMOWIENIA FROM FAKTURA where ID_ZAMOWIENIA = z.ID) order by dbms_random.value)
      where rownum <= pNumberOfInvoices;

    vMaxNum   VARCHAR2(10);
    vMaxYear  VARCHAR2(4) := TO_CHAR(sysdate, 'YYYY');
    vSql      VARCHAR2(1000);
    vIdC      NUMBER;
    vIdZ      NUMBER;
    vName     VARCHAR2(100);
    vSurname  VARCHAR2(100);
    vParam1   VARCHAR2(50);
    vParam2   VARCHAR2(50);
    vCreationDate DATE;
  begin
    open vClientCurr;

    loop
      FETCH vClientCurr into vIdC, vIdZ;
      EXIT when vClientCurr%NOTFOUND;
      vCreationDate := SYSDATE - ROUND(DBMS_RANDOM.VALUE(1,300),1);
      SELECT nvl(max(vMaxNum), '0') into vMaxNum from V_FAKTURA_ROK where ROK = TO_CHAR(vCreationDate, 'YYYY');
      vMaxNum := to_number(vMaxNum) + 1;
      if mod(vMaxNum,2) = 0 then
        vParam1 := 'IMIE_M';
        vParam2 := 'NAZWISKO_M';
      else
        vParam1 := 'IMIE_Z';
        vParam2 := 'NAZWISKO_Z';
      end if;
      for r in rConfDict(vParam1, vParam2, 1) loop
        vName := r.VALUE1;
        vSurname := r.VALUE2;
      end loop;
      insert into FAKTURA (ID, ID_KLIENT, ID_ZAMOWIENIA, NAZWA_KLIENTA, NR_FAKTURY, DATA_WYSTAWIENIA, DATA_PLATNOSCI, DATA_WYKONANIA_USLUGI, OPIS)
          values (FAKTURA_SEQ.nextval, vIdC, vIdZ, vName || ' ' || vSurname, vMaxNum || '/' || TO_CHAR(vCreationDate, 'YYYY'), vCreationDate, vCreationDate + 2 , vCreationDate, null);
    end loop;
    close vClientCurr;
    commit;

    for r in rInvoice loop
        fill_order_info_invoice(r.ID);
        fill_elem_of_invoice_table(r.ID);
    end loop;
    commit;

  end;

  /**
  * Updates entries in ZAMOWIENIE table.
  *  @param pIdInvoice stands for ID_FAKTURA in ZAMOWIENIE
  */
  procedure fill_order_info_shipment(pIdInvoice number) is
  begin
    MERGE INTO ZAMOWIENIE z
    USING WYSYLKA w
    ON (z.ID = w.ID_ZAMOWIENIE and z.ID_FAKTURA = w.ID_FAKTURA)
    WHEN MATCHED THEN
      UPDATE SET z.DATA_WYSLANIA = SYSDATE
       WHERE z.ID = w.ID_ZAMOWIENIE
       and z.ID_FAKTURA = w.ID_FAKTURA
       and z.DATA_WYSLANIA is null;
  end;

  /**
  * Creates entries in WYSYLKA table.
  *  @param pNumberOfShipments should represent the number of individual
  *  invoices that will be created by the procedure
  */
  procedure FILL_SHIPMENT_TABLE(pNumberOfShipments number) is
    vType number := 1;--'Typ wysyłki: 0 - odbiór w punkcie, 1 - kurier, 2 - listy, 3 - dowóz własny';
  begin
    for r in rInvoiceClientOrd loop
      if mod(r.ID,2) = 0
        then vType := 2;
      elsif mod(r.ID,3) = 0
        then vType := 2;
      else vType := 1;
      end if;
      insert into WYSYLKA
        (ID,
         ID_ZAMOWIENIE,
         ID_FAKTURA,
         ULICA_NUMER,
         KOD_MIASTO,
         MIASTO,
         ID_DOSTAWCA,
         TYP)
      values
        (WYSYLKA_SEQ.nextval,
         r.Id_Zamowienia,
         r.Id,
         r.ulica_numer,
         r.kod_miasto,
         r.miasto,
         vType,
         vType);
       fill_order_info_shipment(r.ID);
    end loop;
    commit;
  end;
END;
/