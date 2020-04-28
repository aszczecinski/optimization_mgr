CREATE OR REPLACE FORCE VIEW V_FAKTURA_ROK AS
select NVL(SUBSTR(f.NR_FAKTURY, 0, INSTR(f.NR_FAKTURY, '/') - 1), '0')                  as MAX_NUM,
       NVL(SUBSTR(f.NR_FAKTURY, INSTR(f.NR_FAKTURY, '/') +1), TO_CHAR(sysdate, 'YYYY')) as ROK
 from FAKTURA f
 group by NVL(SUBSTR(f.NR_FAKTURY, 0, INSTR(f.NR_FAKTURY, '/') - 1), 0),
          NVL(SUBSTR(f.NR_FAKTURY, INSTR(f.NR_FAKTURY, '/') +1), TO_CHAR(sysdate, 'YYYY'))
union all
select '0'    as MAX_NUM,
       '2009' as ROK
 from DUAL
order by MAX_NUM,
         ROK;