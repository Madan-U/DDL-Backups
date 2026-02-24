-- Object: PROCEDURE dbo.RPT_VDT_DRCR_SUMMARY
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE RPT_VDT_DRCR_SUMMARY (@RUNDATE DATETIME)      
        
AS ---- EXEC RPT_VDT_DRCR_SUMMARY 'OCT 19 2021'      
      
DECLARE @FINSTDT Datetime       
      
Select @FINSTDT = sdtcur from Parameter where @RUNDATE between sdtcur and ldtcur      
       
         
----NSEBLBS          
select cltcode,SUM(vamt)as vamt  INTO #SLBS from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   ACCOUNTSLBS..ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT  and          
VDT<=@RUNDATE  + ' 23:59' group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0      
          
------------MTF          
select cltcode,SUM(vamt)as vamt  INTO #MTF from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   MTFTRADE..ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT  and          
VDT<=@RUNDATE  + ' 23:59' group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0         
------------nse          
          
select cltcode,SUM(vamt)as vamt  INTO #NSE from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE + ' 23:59'  group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0         
          
------------bse          
select cltcode,SUM(vamt)as vamt  INTO #BSE from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelBSECM].account_ab.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59' group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0         
          
------------nsefo          
select cltcode,SUM(vamt)as vamt  INTO #NSEFO from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelFO].accountfo.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59'  group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0         
          
------------nsx          
select cltcode,SUM(vamt)as vamt  INTO #NSX from (          
      
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelFO].accountcurfo.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59'  group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0        
          
          
------------mcd           
select cltcode,SUM(vamt)as vamt  INTO #MCD from (          
      
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountmcdxcds.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59'  group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0         
------------mcX           
select cltcode,SUM(vamt)as vamt  INTO #MCX from (          
       
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountmcdx.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59'  group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0        
------------NCX           
select cltcode,SUM(vamt)as vamt  INTO #NCX from (          
      
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountNcdx.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59'  group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0        
------------BSEFO           
select cltcode,SUM(vamt)as vamt  INTO #BSEFO from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountBFO.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59'  group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0         
          
        
------------BSX           
select cltcode,SUM(vamt)as vamt  INTO #BSX from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountCURBFO.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
VDT<=@RUNDATE  + ' 23:59' group by cltcode)a          
group by cltcode          
Having SUM(vamt) <>0        
          
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
SELECT *  FROM #NSE         
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
          
         
SELECT REPORT_DATE=CONVERT(VARCHAR(11),@RUNDATE,105),CLTCODE,LONG_NAME,PAN_GIR_NO,SUM(NSE)NSE,SUM(BSE)BSE,SUM(FO)FO,SUM(NSX)NSX,          
SUM(MCD)MCD ,SUM(MCX)MCX,SUM(NCX)NCX,SUM(BSEFO)BSEFO,SUM(BSX)BSX,SUM(MTF)MTF,SUM(SLBS)SLBS,          
SUM(NSE+BSE+FO+NSX+MCD+MCX+NCX+BSEFO+BSX+MTF+SLBS) AS TOTAL          
INTO #TEMP_VDT         
FROM #FINAL  A          
INNER JOIN        
MSAJAG..CLIENT_DETAILS B          
ON A.CLTCODE=B.CL_CODE        
WHERE CLTCODE <>'BBBB'   AND CL_CODE >='A0' AND CL_CODE <='ZZZZZZZZZZZZ'      
GROUP BY CLTCODE,LONG_NAME,PAN_GIR_NO ORDER BY CLTCODE ASC          
      
      
SELECT Report_Date,'TB-Debtors' AS [TB Report VDT],      
ABS(SUM(TOTAL)/10000000) as [Balance In CR],ABS(SUM(TOTAL)) as [Balance In Rs]      
FROM #TEMP_VDT WHERE TOTAL > 0 GROUP BY REPORT_DATE      
UNION ALL      
SELECT Report_Date,'TB-Creditors' AS [TB Report VDT],      
ABS(SUM(TOTAL)/10000000) as [Balance In CR],ABS(SUM(TOTAL)) as [Balance In Rs]      
FROM #TEMP_VDT WHERE TOTAL < 0 GROUP BY REPORT_DATE

GO
