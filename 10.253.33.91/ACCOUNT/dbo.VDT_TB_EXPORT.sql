-- Object: PROCEDURE dbo.VDT_TB_EXPORT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------







CREATE PROCEDURE [dbo].[VDT_TB_EXPORT] (@TODATE VARCHAR(11))      
      
AS --- EXEC VDT_TB_EXPORT 'SEP 27 2021'      
      
DECLARE @FINSTDT Datetime       
Select @FINSTDT = sdtcur from Parameter where @TODATE between sdtcur and ldtcur      
       
----NSEBLBS          
select cltcode,SUM(vamt)as vamt  INTO #SLBS from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   ACCOUNTSLBS..ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT  and          
 VDT<=@TODATE  + ' 23:59' group by cltcode)a          
 group by cltcode          
 Having SUM(vamt) <>0      
          
------------MTF          
          
select cltcode,SUM(vamt)as vamt  INTO #MTF from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   MTFTRADE..ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT  and          
 VDT<=@TODATE  + ' 23:59' group by cltcode)a          
 group by cltcode          
  Having SUM(vamt) <>0         
------------nse          
          
select cltcode,SUM(vamt)as vamt  INTO #NSE from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE + ' 23:59'  group by cltcode)a          
 group by cltcode          
  Having SUM(vamt) <>0         
          
 ------------bse          
 select cltcode,SUM(vamt)as vamt  INTO #BSE from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelBSECM].account_ab.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59' group by cltcode)a          
 group by cltcode          
  Having SUM(vamt) <>0         
          
 ------------nsefo          
 select cltcode,SUM(vamt)as vamt  INTO #NSEFO from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelFO].accountfo.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59'  group by cltcode)a          
 group by cltcode          
  Having SUM(vamt) <>0         
          
  ------------nsx          
 select cltcode,SUM(vamt)as vamt  INTO #NSX from (          
      
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelFO].accountcurfo.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59'  group by cltcode)a          
 group by cltcode          
   Having SUM(vamt) <>0        
          
          
  ------------mcd           
 select cltcode,SUM(vamt)as vamt  INTO #MCD from (          
      
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountmcdxcds.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59'  group by cltcode)a          
 group by cltcode          
  Having SUM(vamt) <>0         
  ------------mcX           
 select cltcode,SUM(vamt)as vamt  INTO #MCX from (          
       
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountmcdx.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59'  group by cltcode)a          
 group by cltcode          
   Having SUM(vamt) <>0        
   ------------NCX           
 select cltcode,SUM(vamt)as vamt  INTO #NCX from (          
      
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountNcdx.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59'  group by cltcode)a          
 group by cltcode          
   Having SUM(vamt) <>0        
    ------------BSEFO           
 select cltcode,SUM(vamt)as vamt  INTO #BSEFO from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountBFO.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59'  group by cltcode)a          
 group by cltcode          
  Having SUM(vamt) <>0         
          
          
     ------------BSX           
 select cltcode,SUM(vamt)as vamt  INTO #BSX from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].accountCURBFO.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59' group by cltcode)a          
 group by cltcode          
   Having SUM(vamt) <>0   
   
        ------------NCE          
 select cltcode,SUM(vamt)as vamt  INTO #NCE from (          
select CLTCODE,SUM(case when drcr='D'then vamt else -vamt end)vamt from   [AngelCommodity].ACCOUNTNCE.dbo.ledger WITH(NOLOCK)          
where          
VDT>=@FINSTDT and          
 VDT<=@TODATE  + ' 23:59' group by cltcode)a          
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
SLBS MONEY,
NCE MONEY)          
          
       
          
INSERT INTO #FINAL          
SELECT DISTINCT CLTCODE,0,0,0,0,0,0,0,0,0,0,0,0 FROM (          
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
UNION ALL          
SELECT * FROM #NCE 
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
UPDATE #FINAL SET NCE =VAMT FROM #NCE A WHERE A.CLTCODE =#FINAL.CLTCODE 
          
UPDATE #FINAL SET CLTCODE =FAMILY FROM MSAJAG.DBO.CLIENT_DETAILS  WITH (NOLOCK) WHERE Cl_code =CLTCODE           
AND CLTCODE LIKE '98%'      
        
TRUNCATE TABLE TB_VDT_EXPORT      
      
INSERT INTO TB_VDT_EXPORT      
SELECT RPORT_DATE=@TODATE,CLTCODE,LONG_NAME,PAN_GIR_NO,SUM(NSE)NSE,SUM(BSE)BSE,SUM(FO)FO,SUM(NSX)NSX,          
SUM(MCD)MCD ,SUM(MCX)MCX,SUM(NCX)NCX,SUM(BSEFO)BSEFO,SUM(BSX)BSX,SUM(MTF)MTF,SUM(SLBS)SLBS, SUM(NCE)NCE,         
SUM(NSE+BSE+FO+NSX+MCD+MCX+NCX+BSEFO+BSX+MTF+SLBS+NCE) AS TOTAL,REPORT='VDT',RUNTIME=GETDATE()         
FROM #FINAL A INNER JOIN MSAJAG..CLIENT_DETAILS B WITH (NOLOCK) ON A.CLTCODE=B.CL_CODE        
WHERE CLTCODE <>'BBBB' AND CL_CODE >='A0' AND CL_CODE <='ZZZZZZZZ'      
GROUP BY CLTCODE,LONG_NAME,PAN_GIR_NO       
ORDER BY CLTCODE ASC          
      
DECLARE @VDTFILENAME1 VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'TB_VDT_' + CONVERT(VARCHAR, CONVERT(DATETIME,@TODATE), 112) + '_1.CSV'      
DECLARE @VDT1 VARCHAR(MAX)                                  
SET @VDT1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''REPORT DATE'''',''''CLTCODE'''',''''CLIENT NAME'''',''''PAN NO'''',''''NSECM'''',''''BSECM'''',''''NSEFO'''',''''NSEFO'''',''''MCXCD'''',''''MCDX'''',''''NCDX'''',''''BSEFO'''',''''BSECD'''',''''MTF'''',''''SLBM'''',''''NCE'''',''''TOTAL'''''       
SET @VDT1 = @VDT1 + ' UNION ALL SELECT CONVERT(VARCHAR(11),RPORT_DATE,105),LTRIM(RTRIM(CLTCODE)),LONG_NAME,PAN_GIR_NO,CONVERT(VARCHAR,NSE),CONVERT(VARCHAR,BSE),CONVERT(VARCHAR,FO),CONVERT(VARCHAR,NSX),CONVERT(VARCHAR,MCD),CONVERT(VARCHAR,MCX),   CONVERT(VARCHAR,NCX),CONVERT(VARCHAR,BSEFO),CONVERT(VARCHAR,BSX),CONVERT(VARCHAR,MTF),CONVERT(VARCHAR,SLBS),CONVERT(VARCHAR,NCE),CONVERT(VARCHAR,TOTAL) FROM ACCOUNT.DBO.TB_VDT_EXPORT WHERE CLTCODE BETWEEN ''''A0''''AND ''''CZZZZZZZZZZ'''' AND LONG_NAME IS NOT NULL" QUERYOUT ' +@VDTFILENAME1+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'          
EXEC(@VDT1)      
      
DECLARE @VDTFILENAME2 VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'TB_VDT_' + CONVERT(VARCHAR, CONVERT(DATETIME,@TODATE), 112) + '_2.CSV'      
DECLARE @VDT2 VARCHAR(MAX)                                  
SET @VDT2 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''REPORT DATE'''',''''CLTCODE'''',''''CLIENT NAME'''',''''PAN NO'''',''''NSECM'''',''''BSECM'''',''''NSEFO'''',''''NSEFO'''',''''MCXCD'''',''''MCDX'''',''''NCDX'''',''''BSEFO'''',''''BSECD'''',''''MTF'''',''''SLBM'''',''''NCE'''',''''TOTAL'''''       
SET @VDT2 = @VDT2 + ' UNION ALL SELECT CONVERT(VARCHAR(11),RPORT_DATE,105),LTRIM(RTRIM(CLTCODE)),LONG_NAME,PAN_GIR_NO,CONVERT(VARCHAR,NSE),CONVERT(VARCHAR,BSE),CONVERT(VARCHAR,FO),CONVERT(VARCHAR,NSX),CONVERT(VARCHAR,MCD),CONVERT(VARCHAR,MCX),CONVERT(VARCHAR,NCX),CONVERT(VARCHAR,BSEFO),CONVERT(VARCHAR,BSX),CONVERT(VARCHAR,MTF),CONVERT(VARCHAR,SLBS),CONVERT(VARCHAR,NCE),CONVERT(VARCHAR,TOTAL) FROM ACCOUNT.DBO.TB_VDT_EXPORT WHERE CLTCODE BETWEEN ''''D0'''' AND ''''GZZZZZZZZZZ'''' AND LONG_NAME IS NOT NULL" QUERYOUT ' +@VDTFILENAME2+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'        
EXEC(@VDT2)      
      
DECLARE @VDTFILENAME3 VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'TB_VDT_' + CONVERT(VARCHAR, CONVERT(DATETIME,@TODATE), 112) + '_3.CSV'      
DECLARE @VDT3 VARCHAR(MAX)                                  
SET @VDT3 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''REPORT DATE'''',''''CLTCODE'''',''''CLIENT NAME'''',''''PAN NO'''',''''NSECM'''',''''BSECM'''',''''NSEFO'''',''''NSEFO'''',''''MCXCD'''',''''MCDX'''',''''NCDX'''',''''BSEFO'''',''''BSECD'''',''''MTF'''',''''SLBM'''',''''NCE'''',''''TOTAL'''''       
SET @VDT3 = @VDT3 + ' UNION ALL SELECT CONVERT(VARCHAR(11),RPORT_DATE,105),LTRIM(RTRIM(CLTCODE)),LONG_NAME,PAN_GIR_NO,CONVERT(VARCHAR,NSE),CONVERT(VARCHAR,BSE),CONVERT(VARCHAR,FO),CONVERT(VARCHAR,NSX),CONVERT(VARCHAR,MCD),CONVERT(VARCHAR,MCX),CONVERT(VARCHAR,NCX),CONVERT(VARCHAR,BSEFO),CONVERT(VARCHAR,BSX),CONVERT(VARCHAR,MTF),CONVERT(VARCHAR,SLBS),CONVERT(VARCHAR,NCE),CONVERT(VARCHAR,TOTAL) FROM ACCOUNT.DBO.TB_VDT_EXPORT WHERE CLTCODE BETWEEN ''''H0'''' AND ''''LZZZZZZZZZ'''' AND LONG_NAME IS NOT NULL" QUERYOUT ' +@VDTFILENAME3+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'        
EXEC(@VDT3)      
      
DECLARE @VDTFILENAME4 VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'TB_VDT_' + CONVERT(VARCHAR, CONVERT(DATETIME,@TODATE), 112) + '_4.CSV'      
DECLARE @VDT4 VARCHAR(MAX)                                  
SET @VDT4 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''REPORT DATE'''',''''CLTCODE'''',''''CLIENT NAME'''',''''PAN NO'''',''''NSECM'''',''''BSECM'''',''''NSEFO'''',''''NSEFO'''',''''MCXCD'''',''''MCDX'''',''''NCDX'''',''''BSEFO'''',''''BSECD'''',''''MTF'''',''''SLBM'''',''''NCE'''',''''TOTAL'''''       
SET @VDT4 = @VDT4 + ' UNION ALL SELECT CONVERT(VARCHAR(11),RPORT_DATE,105),LTRIM(RTRIM(CLTCODE)),LONG_NAME,PAN_GIR_NO,CONVERT(VARCHAR,NSE),CONVERT(VARCHAR,BSE),CONVERT(VARCHAR,FO),CONVERT(VARCHAR,NSX),CONVERT(VARCHAR,MCD),CONVERT(VARCHAR,MCX),CONVERT(VARCHAR,NCX),CONVERT(VARCHAR,BSEFO),CONVERT(VARCHAR,BSX),CONVERT(VARCHAR,MTF),CONVERT(VARCHAR,SLBS),CONVERT(VARCHAR,NCE),CONVERT(VARCHAR,TOTAL) FROM ACCOUNT.DBO.TB_VDT_EXPORT WHERE CLTCODE BETWEEN ''''M0'''' AND ''''QZZZZZZZZZZZZ'''' AND LONG_NAME IS NOT NULL" QUERYOUT ' +@VDTFILENAME4+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'      
EXEC(@VDT4) 

DECLARE @VDTFILENAME5 VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'TB_VDT_' + CONVERT(VARCHAR, CONVERT(DATETIME,@TODATE), 112) + '_5.CSV'      
DECLARE @VDT5 VARCHAR(MAX)                                  
SET @VDT5 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''REPORT DATE'''',''''CLTCODE'''',''''CLIENT NAME'''',''''PAN NO'''',''''NSECM'''',''''BSECM'''',''''NSEFO'''',''''NSEFO'''',''''MCXCD'''',''''MCDX'''',''''NCDX'''',''''BSEFO'''',''''BSECD'''',''''MTF'''',''''SLBM'''',''''NCE'''',''''TOTAL'''''       
SET @VDT5 = @VDT5 + ' UNION ALL SELECT CONVERT(VARCHAR(11),RPORT_DATE,105),LTRIM(RTRIM(CLTCODE)),LONG_NAME,PAN_GIR_NO,CONVERT(VARCHAR,NSE),CONVERT(VARCHAR,BSE),CONVERT(VARCHAR,FO),CONVERT(VARCHAR,NSX),CONVERT(VARCHAR,MCD),CONVERT(VARCHAR,MCX),CONVERT(VARCHAR,NCX),CONVERT(VARCHAR,BSEFO),CONVERT(VARCHAR,BSX),CONVERT(VARCHAR,MTF),CONVERT(VARCHAR,SLBS),CONVERT(VARCHAR,NCE),CONVERT(VARCHAR,TOTAL) FROM ACCOUNT.DBO.TB_VDT_EXPORT WHERE CLTCODE BETWEEN ''''R0'''' AND ''''RZZZZZZZZZ'''' AND LONG_NAME IS NOT NULL" QUERYOUT ' +@VDTFILENAME5+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'        
EXEC(@VDT5)      
      
DECLARE @VDTFILENAME6 VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'TB_VDT_' + CONVERT(VARCHAR, CONVERT(DATETIME,@TODATE), 112) + '_6.CSV'      
DECLARE @VDT6 VARCHAR(MAX)                                  
SET @VDT6 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''REPORT DATE'''',''''CLTCODE'''',''''CLIENT NAME'''',''''PAN NO'''',''''NSECM'''',''''BSECM'''',''''NSEFO'''',''''NSEFO'''',''''MCXCD'''',''''MCDX'''',''''NCDX'''',''''BSEFO'''',''''BSECD'''',''''MTF'''',''''SLBM'''',''''NCE'''',''''TOTAL'''''       
SET @VDT6 = @VDT6 + ' UNION ALL SELECT CONVERT(VARCHAR(11),RPORT_DATE,105),LTRIM(RTRIM(CLTCODE)),LONG_NAME,PAN_GIR_NO,CONVERT(VARCHAR,NSE),CONVERT(VARCHAR,BSE),CONVERT(VARCHAR,FO),CONVERT(VARCHAR,NSX),CONVERT(VARCHAR,MCD),CONVERT(VARCHAR,MCX),CONVERT(VARCHAR,NCX),CONVERT(VARCHAR,BSEFO),CONVERT(VARCHAR,BSX),CONVERT(VARCHAR,MTF),CONVERT(VARCHAR,SLBS),CONVERT(VARCHAR,NCE),CONVERT(VARCHAR,TOTAL) FROM ACCOUNT.DBO.TB_VDT_EXPORT WHERE CLTCODE BETWEEN ''''S0'''' AND ''''SZZZZZZZZZZZZ'''' AND LONG_NAME IS NOT NULL" QUERYOUT ' +@VDTFILENAME6+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'      
EXEC(@VDT6) 

DECLARE @VDTFILENAME7 VARCHAR(100) = 'J:\BACKOFFICE\EXPORT\' +'TB_VDT_' + CONVERT(VARCHAR, CONVERT(DATETIME,@TODATE), 112) + '_7.CSV'      
DECLARE @VDT7 VARCHAR(MAX)                                  
SET @VDT7 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''REPORT DATE'''',''''CLTCODE'''',''''CLIENT NAME'''',''''PAN NO'''',''''NSECM'''',''''BSECM'''',''''NSEFO'''',''''NSEFO'''',''''MCXCD'''',''''MCDX'''',''''NCDX'''',''''BSEFO'''',''''BSECD'''',''''MTF'''',''''SLBM'''',''''NCE'''',''''TOTAL'''''       
SET @VDT7 = @VDT7 + ' UNION ALL SELECT CONVERT(VARCHAR(11),RPORT_DATE,105),LTRIM(RTRIM(CLTCODE)),LONG_NAME,PAN_GIR_NO,CONVERT(VARCHAR,NSE),CONVERT(VARCHAR,BSE),CONVERT(VARCHAR,FO),CONVERT(VARCHAR,NSX),CONVERT(VARCHAR,MCD),CONVERT(VARCHAR,MCX),CONVERT(VARCHAR,NCX),CONVERT(VARCHAR,BSEFO),CONVERT(VARCHAR,BSX),CONVERT(VARCHAR,MTF),CONVERT(VARCHAR,SLBS),CONVERT(VARCHAR,NCE),CONVERT(VARCHAR,TOTAL) FROM ACCOUNT.DBO.TB_VDT_EXPORT WHERE CLTCODE BETWEEN ''''T0'''' AND ''''ZZZZZZZZZZZZZ'''' AND LONG_NAME IS NOT NULL" QUERYOUT ' +@VDTFILENAME7+ ' -c -t"," -c -t"," -r"\n" -T'', NO_OUTPUT'      
EXEC(@VDT7)

GO
