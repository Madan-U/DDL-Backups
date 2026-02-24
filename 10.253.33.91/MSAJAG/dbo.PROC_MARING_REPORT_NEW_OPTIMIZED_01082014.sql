-- Object: PROCEDURE dbo.PROC_MARING_REPORT_NEW_OPTIMIZED_01082014
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
--    EXEC PROC_MARING_REPORT_NEW_01082014 'JUL 31 2014'
    
CREATE PROC [dbo].[PROC_MARING_REPORT_NEW_OPTIMIZED_01082014]                
(                          
 @SAUDA_DATE VARCHAR(11),@REPORT_DATE VARCHAR(11)=''                             
)                          
AS                          
                          
DECLARE @COLLDATE VARCHAR(11),                          
  @MARGINDATE VARCHAR(11),                          
  @CL_DATE VARCHAR(11)                          
                
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                
                          
SELECT @COLLDATE = MAX(EFFDATE) FROM COLLATERALDETAILS                          
WHERE EFFDATE <= @SAUDA_DATE + ' 23:59'                          
                          
SELECT @MARGINDATE = MAX(SYSDATE) FROM CLOSING                          
WHERE SYSDATE <= @COLLDATE --+ ' 23:59:59'                  
                  
SELECT @CL_DATE = MAX(SYSDATE) FROM CLOSING                          
WHERE SYSDATE < @COLLDATE                          
                
                
CREATE TABLE #TPARTY                
 (                
 PARTY_CODE VARCHAR(15)                
 )                
                
INSERT INTO #TPARTY                
SELECT                
 PARTY_CODE                
FROM                
 (                
 SELECT                 
  DISTINCT PARTY_CODE                
 FROM                
  CMBILLVALAN (NOLOCK)                
 WHERE                 
  SAUDA_DATE BETWEEN @MARGINDATE AND @MARGINDATE + ' 23:59:59'                
  AND TRADETYPE NOT IN ( 'SCF','ICF','IR' )                
                 
 UNION                
 SELECT                 
  DISTINCT PARTY_CODE                
 FROM                
  ANAND.BSEDB_AB.DBO.CMBILLVALAN WITH (NOLOCK)                
 WHERE                 
  SAUDA_DATE BETWEEN @MARGINDATE AND @MARGINDATE + ' 23:59:59'                
  AND TRADETYPE NOT IN ( 'SCF','ICF','IR' )                
 UNION                
 SELECT                 
  DISTINCT PARTY_CODE                
 FROM                
  ANGELFO.NSEFO.DBO.FOBILLVALAN WITH (NOLOCK)                
 WHERE                 
  SAUDA_DATE BETWEEN @MARGINDATE AND @MARGINDATE + ' 23:59:59'                
  AND TRADETYPE = 'BT'                
 UNION                
 SELECT                 
  DISTINCT PARTY_CODE                
 FROM                
  ANGELFO.NSECURFO.DBO.FOBILLVALAN WITH (NOLOCK)                
 WHERE                 
  SAUDA_DATE BETWEEN @MARGINDATE AND @MARGINDATE + ' 23:59:59'                
  AND TRADETYPE = 'BT' 
   UNION                
 SELECT                 
  DISTINCT PARTY_CODE                
 FROM                
  ANGELCOMMODITY.MCDXCDS.DBO.FOBILLVALAN WITH (NOLOCK)                
 WHERE                 
  SAUDA_DATE BETWEEN @MARGINDATE AND @MARGINDATE + ' 23:59:59'                
  AND TRADETYPE = 'BT'                
 ) A                
GROUP BY                
 PARTY_CODE                
                
                
/*--- NSE CAPITAL ---*/                
                
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='ACCOUNT') > 0                     
--BEGIN                
 SELECT EXCHANGE = 'NSE', SEGMENT = 'CAPITAL', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 INTO #MAR_REPORT                          
 FROM ACCOUNT.DBO.LEDGER L, #TPARTY C, ACCOUNT.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.PARTY_CODE AND L.EDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND EDT <= @SAUDA_DATE + ' 23:59'                   
--AND EDT <= (CASE WHEN DRCR = 'D' THEN @SAUDA_DATE + ' 23:59' ELSE EDT END)                  
 GROUP BY PARTY_CODE   
   
 --SELECT * FROM #MAR_REPORT WHERE party_code='VB60'                       
             
--END                 
                  
            
/*--- BSE CAPITAL ---*/                
                         
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='ACCOUNT_AB') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                  
 SELECT EXCHANGE = 'BSE', SEGMENT = 'CAPITAL', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANAND.ACCOUNT_AB.DBO.LEDGER L, #TPARTY C, ANAND.ACCOUNT_AB.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND EDT <= @SAUDA_DATE + ' 23:59'                   
--AND EDT <= (CASE WHEN DRCR = 'D' THEN @SAUDA_DATE + ' 23:59' ELSE EDT END)                         
 GROUP BY PARTY_CODE, CL_TYPE                          
--END                 
  
-- SELECT * FROM #MAR_REPORT WHERE party_code='VB60'   
                          
/*--- BSE FUTURES ---*/                
                
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='ACCOUNTBFO') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                
 SELECT EXCHANGE = 'BSE', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELCOMMODITY.ACCOUNTBFO.DBO.LEDGER L, #TPARTY C, ANGELCOMMODITY.ACCOUNTBFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND EDT <= @SAUDA_DATE + ' 23:59'                  
 --AND EDT <= (CASE WHEN DRCR = 'D' THEN @SAUDA_DATE + ' 23:59' ELSE EDT END)                          
 AND VTYP <> '15'                
 GROUP BY PARTY_CODE, CL_TYPE                          
                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'BSE', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELCOMMODITY.ACCOUNTBFO.DBO.LEDGER L, #TPARTY C, ANGELCOMMODITY.ACCOUNTBFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                 
 AND VDT < @SAUDA_DATE                 
 AND VTYP = '15'                
 GROUP BY PARTY_CODE, CL_TYPE                          
                   
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'BSE', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(VAMT),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELCOMMODITY.ACCOUNTBFO.DBO.LEDGER L, #TPARTY C, ANGELCOMMODITY.ACCOUNTBFO.DBO.PARAMETER P                         
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT < P.SDTCUR AND EDT >= P.SDTCUR                     
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT <= @SAUDA_DATE + ' 23:59'     
 AND EDT > @SAUDA_DATE + ' 23:59'                  
 AND DRCR = 'D'                  
 GROUP BY PARTY_CODE, CL_TYPE                
--END                
                
/*--- NSE FUTURES ---*/                
             
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='ACCOUNTFO') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                
 SELECT EXCHANGE = 'NSE', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L, #TPARTY C, ANGELFO.ACCOUNTFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT <= @SAUDA_DATE + ' 23:59'                  
 AND EDT <= (CASE WHEN DRCR = 'D' THEN @SAUDA_DATE + ' 23:59' ELSE EDT END)                          
 AND VTYP <> '15'                
 GROUP BY PARTY_CODE, CL_TYPE                          
                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'NSE', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L, #TPARTY C, ANGELFO.ACCOUNTFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT < @SAUDA_DATE                 
 AND VTYP = '15'                
 GROUP BY PARTY_CODE, CL_TYPE                          
                   
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'NSE', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(VAMT),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L, #TPARTY C, ANGELFO.ACCOUNTFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT < P.SDTCUR AND EDT >= P.SDTCUR                     
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT <= @SAUDA_DATE + ' 23:59'                   
 AND EDT > @SAUDA_DATE + ' 23:59'                  
 AND DRCR = 'D'                  
 GROUP BY PARTY_CODE, CL_TYPE                
--END                 
                
/*--- NSX FUTURES ---*/                
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='ACCOUNTCURFO') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'NSX', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L, #TPARTY C, ANGELFO.ACCOUNTCURFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT <= @SAUDA_DATE + ' 23:59'                  
 AND EDT <= (CASE WHEN DRCR = 'D' THEN @SAUDA_DATE + ' 23:59' ELSE EDT END)                          
 AND VTYP <> '15'                
 GROUP BY PARTY_CODE, CL_TYPE                          
                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'NSX', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                     
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L, #TPARTY C, ANGELFO.ACCOUNTCURFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT < @SAUDA_DATE                
 AND VTYP = '15'                
 GROUP BY PARTY_CODE, CL_TYPE                   
                
 INSERT INTO #MAR_REPORT                
 SELECT EXCHANGE = 'NSX', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(VAMT),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L, #TPARTY C, ANGELFO.ACCOUNTCURFO.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT < P.SDTCUR AND EDT >= P.SDTCUR                 
 AND @SAUDA_DATE BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT <= @SAUDA_DATE + ' 23:59'                   
 AND EDT > @SAUDA_DATE + ' 23:59'                  
 AND DRCR = 'D'                  
 GROUP BY PARTY_CODE, CL_TYPE                  
--END                
                          
----                  
                
/*--- MCD FUTURES ---*/                
                
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='ACCOUNTMCDXCDS') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'MCD', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L, #TPARTY C, ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND GETDATE() BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT <= @SAUDA_DATE + ' 23:59'                  
 AND EDT <= (CASE WHEN DRCR = 'D' THEN @SAUDA_DATE + ' 23:59' ELSE EDT END)                          
 AND VTYP <> '15'                
 GROUP BY PARTY_CODE, CL_TYPE               
                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'MCD', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(CASE WHEN DRCR = 'C' THEN VAMT ELSE -VAMT END),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                         
 FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L, #TPARTY C, ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND GETDATE() BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT < @SAUDA_DATE                
 AND VTYP = '15'                
 GROUP BY PARTY_CODE, CL_TYPE                          
                   
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'MCD', SEGMENT = 'FUTURES', PARTY_CODE, CL_TYPE='',                          
 CASH = SUM(VAMT),                          
 NONCASH = CONVERT(NUMERIC(18,4),0), FD_BG = CONVERT(NUMERIC(18,4),0),                          
 INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
 ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                           
 FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L, #TPARTY C, ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.PARAMETER P                          
 WHERE L.CLTCODE = C.CL_CODE AND L.VDT < P.SDTCUR AND EDT >= P.SDTCUR                     
 AND GETDATE() BETWEEN P.SDTCUR AND P.LDTCUR                           
 AND VDT <= @SAUDA_DATE + ' 23:59'                   
 AND EDT > @SAUDA_DATE + ' 23:59'                  
 AND DRCR = 'D'                  
 GROUP BY PARTY_CODE, CL_TYPE                  
--END                
                
----                  
                  
INSERT INTO #MAR_REPORT                          
SELECT EXCHANGE, SEGMENT, D.PARTY_CODE, CL_TYPE='',                           
CASH = SUM(CASE WHEN COLL_TYPE IN ('MARGIN') THEN FINALAMOUNT ELSE 0 END),                          
--CASH=0,                
NONCASH = SUM(CASE WHEN COLL_TYPE = 'SEC'  THEN FINALAMOUNT ELSE 0 END),                          
FD_BG = SUM(CASE WHEN COLL_TYPE IN ('FD', 'BG') THEN FINALAMOUNT ELSE 0 END),                          
INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                            
FROM COLLATERALDETAILS D, #TPARTY C                          
WHERE EFFDATE BETWEEN  @COLLDATE AND @COLLDATE  +' 23:59'                          
AND D.PARTY_CODE = C.CL_CODE                          
AND EXCHANGE <> 'NSE'           
AND SEGMENT <> 'FUTURES'          
--AND COLL_TYPE <> 'SEC'                          
GROUP BY EXCHANGE, SEGMENT, D.PARTY_CODE, CL_TYPE   
  
-- SELECT * FROM #MAR_REPORT WHERE party_code='VB60'                          
                          
          
/*--------*/          
          
INSERT INTO #MAR_REPORT                          
SELECT EXCHANGE='NSE', SEGMENT='FUTURES', D.PARTY_CODE, CL_TYPE='',                           
CASH = SUM(CASH_COLL),                          
NONCASH = SUM(MRG_REP_COLL_NCASH),                           
FD_BG = 0,                          
INIT_MARGIN = CONVERT(NUMERIC(18,4),0),           
EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                            
FROM ANGELFO.NSEFO.DBO.TBL_CLIENTMARGIN D, #TPARTY C                          
WHERE MARGINDATE BETWEEN  @COLLDATE AND @COLLDATE  +' 23:59'                          
AND D.PARTY_CODE = C.CL_CODE                          
GROUP BY D.PARTY_CODE, CL_TYPE          
        
INSERT INTO #MAR_REPORT                          
SELECT EXCHANGE='MCD', SEGMENT='FUTURES', D.PARTY_CODE, CL_TYPE='',                           
CASH = SUM(CASH_COLL),                          
NONCASH = SUM(MRG_REP_COLL_NCASH),                           
FD_BG = 0,                          
INIT_MARGIN = CONVERT(NUMERIC(18,4),0),           
EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                            
FROM ANGELCOMMODITY.MCDXCDS.DBO.TBL_CLIENTMARGIN D, #TPARTY C                          
WHERE MARGINDATE BETWEEN  @COLLDATE AND @COLLDATE  +' 23:59'         
AND D.PARTY_CODE = C.CL_CODE                          
GROUP BY D.PARTY_CODE, CL_TYPE          
          
        
INSERT INTO #MAR_REPORT                          
SELECT EXCHANGE, SEGMENT, D.PARTY_CODE, CL_TYPE='',                           
CASH = SUM(CASE WHEN COLL_TYPE IN ('MARGIN') THEN FINALAMOUNT ELSE 0 END),                          
--CASH=0,                
NONCASH = SUM(CASE WHEN COLL_TYPE = 'SEC'  THEN FINALAMOUNT ELSE 0 END),                           
FD_BG = SUM(CASE WHEN COLL_TYPE IN ('FD', 'BG') THEN FINALAMOUNT ELSE 0 END),                          
INIT_MARGIN = CONVERT(NUMERIC(18,4),0), EXP_MARGIN = CONVERT(NUMERIC(18,4),0),                          
ADD_MARGIN = CONVERT(NUMERIC(18,4),0)                            
FROM COLLATERALDETAILS D, #TPARTY C                          
WHERE EFFDATE BETWEEN  @COLLDATE AND @COLLDATE  +' 23:59'                          
AND D.PARTY_CODE = C.CL_CODE                          
AND EXCHANGE <> 'NSE'           
AND SEGMENT <> 'FUTURES'          
--AND COLL_TYPE <> 'SEC'                          
GROUP BY EXCHANGE, SEGMENT, D.PARTY_CODE, CL_TYPE     
  
 --SELECT * FROM #MAR_REPORT WHERE party_code='VB60'       
        
/*--------*/          
          
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='BSEFO') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'BSE', SEGMENT = 'FUTURES', M.PARTY_CODE, CL_TYPE='',                          
 CASH = 0, NONCASH = 0, FD_BG = 0,                           
 INIT_MARGIN = SUM(SPAN_MARGIN), EXP_MARGIN = SUM(EXTREME_LOSS_MARGIN),                          
 ADD_MARGIN = 0                          
 FROM ANGELCOMMODITY.BSEFO.DBO.BFOMARGIN M, #TPARTY C                          
 WHERE M.MARGIN_DATE BETWEEN  @MARGINDATE AND @MARGINDATE  +' 23:59'                          
 AND M.PARTY_CODE = C.PARTY_CODE                          
 GROUP BY M.PARTY_CODE, C.CL_TYPE                
--END                 
                
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='NSEFO') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'NSE', SEGMENT = 'FUTURES', M.PARTY_CODE, CL_TYPE='',                          
 CASH = 0, NONCASH = 0, FD_BG = 0,                           
 INIT_MARGIN = SUM(PSPANMARGIN)+SUM(NONSPREADMARGIN), EXP_MARGIN = SUM(MTOM),                          
 ADD_MARGIN = 0                 
 FROM ANGELFO.NSEFO.DBO.FOMARGINNEW M, #TPARTY C                          
 WHERE M.MDATE BETWEEN  @MARGINDATE AND @MARGINDATE  +' 23:59'                          
 AND M.PARTY_CODE = C.PARTY_CODE                          
 GROUP BY M.PARTY_CODE, C.CL_TYPE                
--END                 
                
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='NSECURFO') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                
 SELECT EXCHANGE = 'NSX', SEGMENT = 'FUTURES', M.PARTY_CODE, CL_TYPE='',                          
 CASH = 0, NONCASH = 0, FD_BG = 0,                           
 INIT_MARGIN = SUM(PSPANMARGIN)+SUM(NONSPREADMARGIN), EXP_MARGIN = SUM(MTOM),                          
 ADD_MARGIN = 0                          
 FROM ANGELFO.NSECURFO.DBO.FOMARGINNEW M, #TPARTY C                          
 WHERE M.MDATE BETWEEN  @MARGINDATE AND @MARGINDATE  +' 23:59'                          
 AND M.PARTY_CODE = C.PARTY_CODE                          
 GROUP BY M.PARTY_CODE, C.CL_TYPE                  
--END                 
                
--IF (SELECT COUNT(1) FROM SYS.DATABASES WHERE NAME='MCDXCDS') > 0                     
--BEGIN                
 INSERT INTO #MAR_REPORT                          
 SELECT EXCHANGE = 'MCD', SEGMENT = 'FUTURES', M.PARTY_CODE, CL_TYPE='',                          
 CASH = 0, NONCASH = 0, FD_BG = 0,                           
-- INIT_MARGIN = SUM(TOTALMARGIN)+SUM(NONSPREADMARGIN), EXP_MARGIN = SUM(MTOM),                          
 INIT_MARGIN = SUM(TOTALMARGIN), EXP_MARGIN = SUM(MTOM),                          
 ADD_MARGIN = 0                          
 FROM ANGELCOMMODITY.MCDXCDS.DBO.FOMARGINNEW M, #TPARTY C                          
 WHERE M.MDATE BETWEEN  @MARGINDATE AND @MARGINDATE  +' 23:59'                          
 AND M.PARTY_CODE = C.PARTY_CODE                          
 GROUP BY M.PARTY_CODE, C.CL_TYPE                
--END                 
                
                
INSERT INTO #MAR_REPORT                          
SELECT                
 EXCHANGE = 'NSE', SEGMENT = 'CAPITAL',                 
 PARTY_CODE,                 
 CL_TYPE='',                          
 CASH = 0, NONCASH = 0, FD_BG = 0,                           
 INIT_MARGIN = SUM(VARAMT)+SUM(MTOM),                
 EXP_MARGIN = 0,                          
 ADD_MARGIN = 0                
FROM                
 (                
 SELECT                
  M.PARTY_CODE,                
  CL_TYPE='',                
  SETT_NO,                
  SETT_TYPE,                
  VARAMT = SUM(VARAMT),                
  MTOM = (CASE WHEN SUM(MTOM) > 0 THEN 0 ELSE ABS(SUM(MTOM)) END)     
 FROM TBL_MG02 M, #TPARTY C                          
 WHERE M.MARGIN_DATE BETWEEN  @MARGINDATE AND @MARGINDATE  +' 23:59'                          
 AND M.PARTY_CODE = C.PARTY_CODE                          
 GROUP BY                
  M.PARTY_CODE,                
  --C.CL_TYPE,                
  SETT_NO,                
  SETT_TYPE                
 ) M                
GROUP BY                
 PARTY_CODE,                 
CL_TYPE                
                
INSERT INTO #MAR_REPORT                       
SELECT                
 EXCHANGE = 'BSE', SEGMENT = 'CAPITAL',                 
 PARTY_CODE,                 
 CL_TYPE='',                          
 CASH = 0, NONCASH = 0, FD_BG = 0,                           
 INIT_MARGIN = SUM(MARGIN),                
 EXP_MARGIN = 0,                          
 ADD_MARGIN = 0                
FROM                
 (                
 SELECT                
  M.PARTY_CODE,                
  CL_TYPE = '',                
  SETT_NO,                
--  MARGIN = SUM(VARAMT + ELM) - (CASE WHEN SUM(MTOM) > 0 THEN 0 ELSE SUM(MTOM) END)                
  MARGIN = SUM(VARAMT + ELM) - (CASE WHEN SUM(MTOM) > 0 THEN SUM(MTOM) ELSE 0 END)                
 FROM ANAND.BSEDB_AB.DBO.TBL_MG02 M, #TPARTY C                          
 WHERE M.MARGIN_DATE BETWEEN  @MARGINDATE AND @MARGINDATE  +' 23:59'                           
 AND M.PARTY_CODE = C.PARTY_CODE                          
 GROUP BY                
  M.PARTY_CODE,                
  --C.CL_TYPE,                
  SETT_NO                
 ) M                
GROUP BY                
 PARTY_CODE,                 
 CL_TYPE        
   
  --SELECT * FROM #MAR_REPORT WHERE party_code='VB60'   
 -- RETURN          
                
                
UPDATE #MAR_REPORT SET INIT_MARGIN =PREV_VAR + MAR_ADJUST      
,NONCASH=PREV_SEC+CURR_SEC      
FROM ANAND.BSEDB_AB.DBO.MARGIN_REPORTING T      
WHERE #MAR_REPORT.PARTY_CODE=T.PARTY_CODE      
AND CONVERT(VARCHAR(11),SAUDA_DATE,109)=@SAUDA_DATE      
AND EXCHANGE='BSE'      
AND SEGMENT='CAPITAL'      
AND INIT_MARGIN <> 0      
      
UPDATE #MAR_REPORT SET INIT_MARGIN =PREV_VAR + MAR_ADJUST      
,NONCASH=PREV_SEC+CURR_SEC     
FROM MSAJAG.DBO.MARGIN_REPORTING T      
WHERE #MAR_REPORT.PARTY_CODE=T.PARTY_CODE      
AND CONVERT(VARCHAR(11),SAUDA_DATE,109)=@SAUDA_DATE      
AND EXCHANGE='NSE'      
AND SEGMENT='CAPITAL'      
and init_margin <> 0       
                          
DELETE FROM TBL_MAR_REPORT                          
WHERE TRADE_DAY=@SAUDA_DATE                          
                
/*                
DELETE FROM #MAR_REPORT                    
WHERE PARTY_CODE NOT IN (SELECT PARTY_CODE FROM #MAR_REPORT                 
GROUP BY PARTY_CODE                 
--HAVING ROUND(SUM(INIT_MARGIN+EXP_MARGIN+CASH+NONCASH+FD_BG),2) <> 0)                    
HAVING ROUND(SUM(INIT_MARGIN+EXP_MARGIN),2) <> 0)                
*/                
                
                
DELETE FROM #MAR_REPORT                
WHERE NOT EXISTS (                
 SELECT DISTINCT PARTY_CODE                
 FROM                
 (                
 SELECT PARTY_CODE FROM #TPARTY (NOLOCK) GROUP BY PARTY_CODE                
 UNION                
 SELECT PARTY_CODE FROM #MAR_REPORT                 
 GROUP BY PARTY_CODE                 
 HAVING ROUND(SUM(INIT_MARGIN+EXP_MARGIN),2) <> 0                
 ) A                
 WHERE A.PARTY_CODE = #MAR_REPORT.PARTY_CODE                
)                
                
                          
INSERT INTO TBL_MAR_REPORT                          
SELECT PARTY_CODE,CL_TYPE=C.CL_TYPE,TRADE_DAY=@SAUDA_DATE,EXCHANGE,SEGMENT,                          
CASH=SUM(CASH),                          
NONCASH=SUM(NONCASH),                          
FD_BG=SUM(FD_BG),                          
ANY_OTHER_COLL=0,                          
TOTALCOLL=SUM(CASH+NONCASH+FD_BG),                          
INIT_MARGIN=SUM(INIT_MARGIN),                          
EXP_MARGIN=SUM(EXP_MARGIN),                          
TOTALMARGIN=SUM(INIT_MARGIN+EXP_MARGIN),                          
EXG_MAR_SHORT=SUM(CASH+NONCASH+FD_BG)-SUM(INIT_MARGIN+EXP_MARGIN),                          
ADD_MARGIN=SUM(ADD_MARGIN),                          
MARGIN_STATUS=SUM(CASH+NONCASH+FD_BG)-SUM(INIT_MARGIN+EXP_MARGIN)-SUM(ADD_MARGIN)                
FROM #MAR_REPORT A ,CLIENT_DETAILS C   WHERE C.CL_CODE=A.PARTY_CODE                      
GROUP BY EXCHANGE,SEGMENT,PARTY_CODE,CL_TYPE                     
ORDER BY PARTY_CODE,CL_TYPE,EXCHANGE,SEGMENT                          
                          
DROP TABLE #MAR_REPORT                   
                  
SELECT @SAUDA_DATE  '  PROCESS COMPLETED'

GO
