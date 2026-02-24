-- Object: PROCEDURE dbo.DP_OS_RECOVERY
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

     
    
    
CREATE PROCEDURE [dbo].[DP_OS_RECOVERY]    
    
AS BEGIN     
--------INACTIVE CLIENT FRO----------M BO    
    
SELECT DISTINCT(CL_CODE)INTO #INACTIVECLIENT    
 FROM CLIENT_BROK_DETAILS  WITH(NOLOCK)    
 WHERE Deactive_value IN ('B','C','I')    
 AND CL_cODE BETWEEN 'A00'AND 'ZZ9999'    
    
    
 ---------EFF LEDGER NSE-------    
select cltcode,SUM(vamt)as vamt  INTO #NSE from (    
select CLTCODE,SUM(BALAMT)vamt   from  ACCOUNT..ledger WITH(NOLOCK)    
where    
edt>='apr  1 2020'and     
  VTYP='18' group by cltcode    
union all    
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   ACCOUNT..ledger WITH(NOLOCK)    
where    
edt>='apr  1 2020'and    
  VTYP<>'18' group by cltcode)a    
 group by cltcode    
    
 ---------EFF LEDGER BSE-------    
 select cltcode,SUM(vamt)as vamt  INTO #BSE from (    
select CLTCODE,SUM(BALAMT)vamt   from [AngelBSECM].ACCOUNT_AB.DBO.ledger WITH(NOLOCK)    
where    
edt>='apr  1 2020'and     
  VTYP='18' group by cltcode    
union all    
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from  [AngelBSECM].ACCOUNT_AB.DBO.ledger WITH(NOLOCK)    
where    
edt>='apr  1 2020'and    
  VTYP<>'18' group by cltcode)a    
 group by cltcode    
    
    
 ---------EFF LEDGER NSEFO-------    
 select cltcode,SUM(vamt)as vamt  INTO #NSEFO from (    
select CLTCODE,SUM(BALAMT)vamt   from [AngelFO].ACCOUNTFO.DBO.ledger WITH(NOLOCK)    
where    
edt>='apr  1 2020'and     
  VTYP='18' group by cltcode    
union all    
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from  [AngelFO].ACCOUNTFO.DBO.ledger WITH(NOLOCK)    
where    
edt>='apr  1 2020'and    
   VTYP<>'18' group by cltcode)a    
 group by cltcode    
    
    
 CREATE TABLE #FINAL    
(CLTCODE VARCHAR(10),    
NSE MONEY,    
BSE MONEY,    
FO MONEY    
)    
    
INSERT INTO #FINAL    
SELECT DISTINCT ClTcode,0,0,0 FROM (    
SELECT * FROM #NSE    
UNION ALL    
SELECT * FROM #BSE      
UNION ALL    
SELECT * FROM #NSEFO    
 )A    
    
    
UPDATE #FINAL SET NSE =VAMT FROM #NSE A WHERE A.CLTCODE =#FINAL.CLTCODE     
UPDATE #FINAL SET BSE =VAMT FROM #BSE A WHERE A.CLTCODE =#FINAL.CLTCODE     
UPDATE #FINAL SET FO =VAMT FROM #NSEFO A WHERE A.CLTCODE =#FINAL.CLTCODE     
    
    
------FINAL LEDGER DETAILS---------    
 SELECT CLTCODE,LONG_NAME,SUM(NSE)NSE,SUM(BSE)BSE,SUM(FO)FO,    
      SUM(NSE+BSE+FO) AS TOTAL    
  INTO #LEDDATA    
    FROM #FINAL A    
   LEFT OUTER JOIN    
   CLIENT_DETAILS B WITH(NOLOCK)    
    ON A.CLTCODE=B.CL_CODE     
   WHERE     
   CLTCODE IN (SELECT * FROM #INACTIVECLIENT )    
       
      GROUP BY CLTCODE,LONG_NAME ORDER BY CLTCODE ASC    
    
   ----------FROM DP CLOSED CLIENTS-------    
   SELECT A.*,B.CLIENT_CODE,STATUS    
   INTO #DPOS    
    FROM #LEDDATA A ,AGMUBODPL3.DMAT.CITRUS_USR.TBL_CLIENT_MASTER B WITH(NOLOCK)    
   WHERE A.CLTCODE=B.NISE_PARTY_cODE    
   AND STATUS LIKE '%CLOSED%'    
   AND TOTAL<0    
     
 ------------------OUTSTANDING RECOVERY DATA FROM DP---------    
 SELECT A.*,B.ACTUAL_AMOUNT FROM #DPOS  A    
 LEFT OUTER JOIN    
 AGMUBODPL3.DMAT.CITRUS_USR.VW_ACC_CURR_BAL B WITH(NOLOCK)    
 ON A.CLIENT_cODE=B.CLIENT_CODE    
 WHERE ACTUAL_AMOUNT>0    
     
    
    
 END

GO
