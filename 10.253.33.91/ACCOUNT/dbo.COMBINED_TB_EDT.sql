-- Object: PROCEDURE dbo.COMBINED_TB_EDT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

        
 ---COMBINED_TB_EDT 'JUL 28 2021'        
         
         
 CREATE PROCEDURE [dbo].[COMBINED_TB_EDT]        
 (        
 @FROMDATE VARCHAR(20)        
 )        
 AS         
 BEGIN         
        
----NSEBLBS        
select cltcode,SUM(vamt)as vamt  INTO #SLBS from (        
select CLTCODE,SUM(BALAMT)vamt   from ACCOUNTSLBS..ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   ACCOUNTSLBS..ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
------------MTF        
        
        
        
select cltcode,SUM(vamt)as vamt  INTO #MTF from (        
select CLTCODE,SUM(BALAMT)vamt   from MTFTRADE..ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   MTFTRADE..ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
------------nse        
        
select cltcode,SUM(vamt)as vamt  INTO #NSE from (        
select CLTCODE,SUM(BALAMT)vamt   from ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
        
 ------------bse        
 select cltcode,SUM(vamt)as vamt  INTO #BSE from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelBSECM].account_ab.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelBSECM].account_ab.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
        
 ------------nsefo        
 select cltcode,SUM(vamt)as vamt  INTO #NSEFO from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelFO].accountfo.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelFO].accountfo.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
        
  ------------nsx        
 select cltcode,SUM(vamt)as vamt  INTO #NSX from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelFO].accountcurfo.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelFO].accountcurfo.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
        
        
  ------------mcd         
 select cltcode,SUM(vamt)as vamt  INTO #MCD from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelCommodity].accountmcdxcds.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountmcdxcds.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
  ------------mcX         
 select cltcode,SUM(vamt)as vamt  INTO #MCX from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelCommodity].accountmcdx.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountmcdx.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
   ------------NCX         
 select cltcode,SUM(vamt)as vamt  INTO #NCX from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelCommodity].accountNcdx.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountNcdx.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
    ------------BSEFO         
 select cltcode,SUM(vamt)as vamt  INTO #BSEFO from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelCommodity].accountBFO.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountBFO.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
        
        
     ------------BSX         
 select cltcode,SUM(vamt)as vamt  INTO #BSX from (        
select CLTCODE,SUM(BALAMT)vamt   from [AngelCommodity].accountCURBFO.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021 'and         
edt<=@FROMDATE  + ' 23:59'   and VTYP='18' group by cltcode        
union all        
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountCURBFO.dbo.ledger WITH(NOLOCK)        
where        
edt>='apr  1 2021'and        
 edt<=@FROMDATE  + ' 23:59'   and VTYP<>'18' group by cltcode)a        
 group by cltcode        
        
        
 CREATE TABLE #FINAL        
(CLTCODE VARCHAR(10),        
NSE MONEY,        
BSE MONEY,        
FO MONEY,        
NSX MONEY,        
MCD MONEY,        
MCX MONEY,        
NCX MONEY,        
BSEFO MONEY,        
BSX MONEY,        
MTF MONEY,        
SLBS MONEY)        
        
        
 INSERT INTO #FINAL        
SELECT DISTINCT CLTCODE,0,0,0,0,0,0,0,0,0,0,0 FROM (        
SELECT * FROM #NSE        
UNION ALL        
SELECT * FROM #BSE          
UNION ALL        
SELECT * FROM #NSEFO        
UNION ALL        
SELECT * FROM #NSX        
UNION ALL        
SELECT * FROM #MCD        
UNION ALL        
SELECT * FROM #MCX        
UNION ALL        
SELECT * FROM #NCX        
UNION ALL        
SELECT * FROM #BSEFO        
UNION ALL        
SELECT * FROM #BSX        
UNION ALL        
SELECT * FROM #MTF        
UNION ALL        
SELECT * FROM #SLBS        
 )A        
        
        
UPDATE #FINAL SET NSE =VAMT FROM #NSE A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET BSE =VAMT FROM #BSE A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET FO =VAMT FROM #NSEFO A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET NSX =VAMT FROM #NSX A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET MCD =VAMT FROM #MCD A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET MCX =VAMT FROM #MCX A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET NCX =VAMT FROM #NCX A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET BSEFO =VAMT FROM #BSEFO A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET BSX =VAMT FROM #BSX A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET MTF =VAMT FROM #MTF A WHERE A.CLTCODE =#FINAL.CLTCODE         
UPDATE #FINAL SET SLBS =VAMT FROM #SLBS A WHERE A.CLTCODE =#FINAL.CLTCODE         
        
UPDATE #FINAL SET CLTCODE =FAMILY FROM MSAJAG.DBO.CLIENT_DETAILS WHERE Cl_code =CLTCODE         
     AND CLTCODE LIKE '98%'        
        
  --drop table #TEMP        
  --drop table #TEMP1         
        
 SELECT CLTCODE,LONG_NAME,pan_gir_no,SUM(NSE)NSE,SUM(BSE)BSE,SUM(FO)FO,SUM(NSX)NSX,        
 SUM(MCD)MCD ,SUM(MCX)MCX,SUM(NCX)NCX,SUM(BSEFO)BSEFO,SUM(BSX)BSX,SUM(MTF)MTF,SUM(SLBS)SLBS,        
      SUM(NSE+BSE+FO+NSX+MCD+MCX+NCX+BSEFO+BSX+MTF+SLBS) AS TOTAL        
  into #TEMP        
    FROM #FINAL  A        
   LEFT OUTER JOIN        
   MSAJAG..CLIENT_DETAILS B        
    ON A.CLTCODE=B.CL_CODE         
   WHERE         
         
   cltcode LIKE '98%'        
      GROUP BY CLTCODE,LONG_NAME,pan_gir_no ORDER BY CLTCODE ASC        
        
        
    SELECT CLTCODE,LONG_NAME,pan_gir_no,SUM(NSE)NSE,SUM(BSE)BSE,SUM(FO)FO,SUM(NSX)NSX,        
 SUM(MCD)MCD ,SUM(MCX)MCX,SUM(NCX)NCX,SUM(BSEFO)BSEFO,SUM(BSX)BSX,SUM(MTF)MTF,SUM(SLBS)SLBS,        
      SUM(NSE+BSE+FO+NSX+MCD+MCX+NCX+BSEFO+BSX+MTF+SLBS) AS TOTAL        
 into #TEMP1        
    FROM #FINAL  A          
   LEFT OUTER JOIN        
   MSAJAG..CLIENT_DETAILS B        
    ON A.CLTCODE=B.CL_CODE         
   WHERE         
    cltcode not LIKE '98%'and        
    cltcode not LIKE '05%'and        
    cltcode not LIKE '7%' and        
    cltcode not LIKE '06%' AND        
    cltcode not LIKE '0%'  AND         
    cltcode not LIKE '1%' AND        
    cltcode not LIKE '2%' AND        
    cltcode not LIKE '3%' AND        
    cltcode not LIKE '4%'AND        
    cltcode not LIKE '5%'AND        
    cltcode not LIKE '6%'AND        
    cltcode not LIKE '8%'AND        
    cltcode not LIKE '9%'        
    ---AND CLTCODE IN ('ZZZU1002','ZZZW1012','ZZZW1044','ZZZW1042')        
          
      GROUP BY CLTCODE,LONG_NAME,pan_gir_no ORDER BY CLTCODE ASC        
        
          
     SELECT * into #d FROM #TEMP1  WHERE   TOTAL<>0 and cltcode between 'a0'and 'zzz999'  and long_name is not null      
              
        
        
           
SELECT * into #d1 FROM #TEMP        
union        
  SELECT * FROM #TEMP1 WHERE NSE<>0 AND TOTAL=0        
 UNION         
 SELECT * FROM #TEMP1 WHERE BSE<>0 AND TOTAL=0        
 UNION         
  SELECT * FROM #TEMP1 WHERE FO<>0 AND TOTAL=0        
 UNION         
 SELECT * FROM #TEMP1 WHERE NSX<>0 AND TOTAL=0        
 UNION          
 SELECT * FROM #TEMP1 WHERE MCD<>0 AND TOTAL=0        
  UNION          
 SELECT * FROM #TEMP1 WHERE MCX<>0 AND TOTAL=0        
  UNION          
 SELECT * FROM #TEMP1 WHERE NCX<>0 AND TOTAL=0        
 UNION          
 SELECT * FROM #TEMP1 WHERE BSEFO<>0 AND TOTAL=0        
 UNION          
 SELECT * FROM #TEMP1 WHERE BSX<>0 AND TOTAL=0        
 UNION          
 SELECT * FROM #TEMP1 WHERE MTF<>0 AND TOTAL=0        
 UNION          
 SELECT * FROM #TEMP1 WHERE SLBS<>0 AND TOTAL=0        
         
 SELECT * INTO #FINAL_DATA FROM #d        
 UNION          
  SELECT * FROM #d1        
          
  SELECT * FROM #FINAL_DATA WHERE cltcode BETWEEN 'A0'AND 'HZZZ999'        
  SELECT * FROM #FINAL_DATA WHERE cltcode BETWEEN 'I0'AND 'PZZZ999'        
  SELECT * FROM #FINAL_DATA WHERE cltcode BETWEEN 'Q0'AND 'UZZZ999'        
   SELECT * FROM #FINAL_DATA WHERE cltcode BETWEEN 'V0'AND 'zZZZ999'        
   END

GO
