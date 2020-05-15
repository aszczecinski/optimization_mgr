CREATE OR REPLACE PACKAGE "STAT_ENGINE" is

  /**
   * Procedure is responsible for refreshing statistics on table
   *
  */
  procedure CALCULATE_STATISTICS(pTabName VARCHAR2);

  /**
   * Calculates statistics for all user tables
   *
  */
  procedure CALCULATE_ALL_TAB_STAT;

END;
/
CREATE OR REPLACE PACKAGE BODY "STAT_ENGINE" is
  /**
   * Procedure is responsible for refreshing statistics on table
   *
  */
  procedure CALCULATE_STATISTICS(pTabName VARCHAR2) is
    begin
      dbms_stats.gather_table_stats(ownname          => user,
                                    tabname          => '"'||pTabName||'"',
                                    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                    degree           => null,
                                    cascade          => true,
                                    options          => 'GATHER AUTO');
    end;

  /**
   * Calculates statistics for all user tables
   *
  */
  procedure CALCULATE_ALL_TAB_STAT is
    cursor curTabs is
      select TABLE_NAME from user_tables;

    begin
      for r in curTabs loop
        CALCULATE_STATISTICS(r.TABLE_NAME);
      end loop;
    end;

END;
/