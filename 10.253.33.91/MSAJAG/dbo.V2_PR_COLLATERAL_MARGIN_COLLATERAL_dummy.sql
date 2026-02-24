-- Object: PROCEDURE dbo.V2_PR_COLLATERAL_MARGIN_COLLATERAL_dummy
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


  
-- EXEC V2_PR_COLLATERAL_MARGIN_COLLATERAL 'JUL 29 2019'        
        
CREATE PROCEDURE [dbo].[V2_PR_COLLATERAL_MARGIN_COLLATERAL_dummy]        
(              
  @EFFDATE VARCHAR(11),              
  @UNAME VARCHAR(15) ='SANTOSHB'        
)              
              
AS              
            
          
/*=====================================================================================================================          
PROC TO RECOMPUTE COLLATERAL ACCORDING TO THE MARGIN REQUREMENT          
          
PROCESS TEMP TABLE : V2_TBL_COLLATERAL_MARGIN          
PROCESS SETTING    : V2_TBL_COLLATERAL_MARGIN_EXCHANGES_COMM          
          
RECORD TYPE 1 - ORGINAL RECORD          
RECORD TYPE 2 - SYSTEM SPLITTED RECORD          
RECORD TYPE 3 - FINAL RECORD          
=====================================================================================================================*/          
          
DECLARE                
 @MRGCUR CURSOR,          
 @STRSQL VARCHAR(2000),          
 @ACCOUNTSRVR VARCHAR(100),          
 @ACCOUNTDB VARCHAR(100),          
 @EXCHANGE VARCHAR(3),          
 @SEGMENT VARCHAR(7),          
 @ILOOP INT          
             
              
 CREATE TABLE #TBL_COLLATERAL_MARGIN_ALL              
 (              
   [EXCHANGE]  [VARCHAR] (3),          
   [SEGMENT]  [VARCHAR] (7),          
   [PARTY_CODE] [VARCHAR](10) ,          
   [COLL_TYPE]  [VARCHAR](6) ,          
   [SCRIP_CD]  [VARCHAR](12) ,          
   [SERIES]  [VARCHAR](3) ,          
   [ISIN]   [VARCHAR](20) ,          
   [QTY]   [NUMERIC](18, 4) ,          
   [FD_TYPE]  [VARCHAR](1) ,          
   [FD_BG_NO]  [VARCHAR](20) ,          
   [AMOUNT] [MONEY],          
   [FINALAMOUNT] [MONEY],          
   [BANK_CODE]  [VARCHAR](15) ,          
   [MRG_CL_RATE]  [MONEY] ,          
   [MRG_AMOUNT]  [MONEY] ,           
   [MRG_HAIRCUT]  [MONEY] ,           
   [MRG_VAR_MARGIN] [MONEY] ,           
   [MRG_FINALAMOUNT] [MONEY] ,           
   [RMS_CL_RATE]  [MONEY] ,          
   [RMS_HAIRCUT]  [MONEY] ,           
   [RMS_AMOUNT] [MONEY] ,           
   [RMS_FINALAMOUNT] [MONEY],          
   [CASH_NCASH]  [VARCHAR](2) ,          
   [PERCENTAGECASH] [NUMERIC](18, 2)  ,          
   [PERECNTAGENONCASH] [NUMERIC](18, 2)  ,          
   [MRG_CASH] [NUMERIC](18, 2)  ,          
   [MRG_NONCASH] [NUMERIC](18, 2)  ,          
   [RMS_CASH] [NUMERIC](18, 2)  ,          
   [RMS_NONCASH] [NUMERIC](18, 2) ,          
   [MRG_EFFECTIVECOLL] [NUMERIC](18, 2) ,          
   [RMS_EFFECTIVECOLL] [NUMERIC](18, 2) ,          
   [MARGIN_CALL]  [MONEY] ,          
   [LEDGER_AMT]  [MONEY]          
 )              
              
              
 CREATE TABLE #TBL_CLIENT_DATA          
 (              
  [SRNO] INT  IDENTITY NOT NULL,          
  [EXCHANGE]  [VARCHAR] (3),          
  [SEGMENT]  [VARCHAR] (7),          
  [PARTY_CODE] [VARCHAR](10) ,          
  [AMT]  [MONEY]           
 )          
 CREATE CLUSTERED INDEX IDXPARTY ON #TBL_CLIENT_DATA (PARTY_CODE,EXCHANGE,SEGMENT)              
/*--------------------------------------------    FETCHING THE DATA TO PROCESS  ------------------------------------------------------*/               
        
 INSERT INTO #TBL_COLLATERAL_MARGIN_ALL              
 SELECT          
  EXCHANGE,              
  SEGMENT,              
  PARTY_CODE,              
  COLL_TYPE,              
  SCRIP_CD,              
  SERIES,              
  ISIN,              
  ABS(QTY),          
  FD_TYPE,              
  FD_BG_NO,              
  AMOUNT,          
  FINALAMOUNT,          
  BANK_CODE,              
  MRG_CL_RATE = 0 ,              
  MRG_AMOUNT = 0 ,              
  MRG_HAIRCUT = CASE WHEN COLL_TYPE ='SEC' THEN 100 ELSE HAIRCUT END,              
  MRG_VAR_MARGIN = CASE WHEN COLL_TYPE ='SEC' THEN 100 ELSE HAIRCUT END ,              
  MRG_FINALAMOUNT = 0 ,              
  RMS_CL_RATE = CL_RATE,          
  RMS_HAIRCUT = HAIRCUT,          
  RMS_AMOUNT = AMOUNT,          
  RMS_FINALAMOUNT = FINALAMOUNT,          
  CASH_NCASH = CASE WHEN ISNULL(CASH_NCASH,'') ='' THEN 'C' ELSE CASH_NCASH END,          
  PERCENTAGECASH,              
  PERECNTAGENONCASH,               
  MRG_CASH = 0 ,              
  MRG_NONCASH = 0 ,          
  RMS_CASH =0,          
  RMS_NONCASH=0,          
  MRG_EFFECTIVECOLL = 0,          
  RMS_EFFECTIVECOLL = 0,          
  MARGIN_CALL = 0,            
  LEDGER_AMT = 0          
 FROM              
  COLLATERALDETAILS  A   (NOLOCK)          
 WHERE               
  EFFDATE BETWEEN @EFFDATE AND @EFFDATE+ ' 23:59:59'          
  AND EXISTS (SELECT EXCHANGE FROM V2_TBL_EXCHANGE_MARGIN_REPORT B          
  WHERE A.EXCHANGE = B.EXCHANGE AND A.SEGMENT = B.SEGMENT)          
                  
/*-------------------------------------------------- INCLUDING POA BALANCE --STARTS HERE ------------------------------------------------*/        
        
 CREATE TABLE #POA_BALANCE        
 (        
  PARTY_CODE VARCHAR(10),        
  SCRIP_CD VARCHAR(12),        
  SERIES VARCHAR(3),        
  ISIN VARCHAR(20),        
  QTY NUMERIC(18,4),        
  EX_SEG VARCHAR(7)        
 )          
  


 IF LEFT(GETDATE(),11) = @EFFDATE        
 BEGIN        
 	SELECT * INTO #SCRIP_TYPE  
	FROM  ANGELFO.NSEFO.DBO.SCRIP_TYPE  
  
	SELECT DISTINCT C.* INTO #CLIENT_NEWPOA FROM  ANGELFO.NSEFO.DBO.CLIENT_NEWPOA C 
  
	DELETE FROM #CLIENT_NEWPOA 
	WHERE CLIENT_CODE IN (SELECT PARTY_CODE FROM ABVSCITRUS.NBFC.DBO.TBLCLIENTMARGIN 
	WHERE @EFFDATE BETWEEN FROM_DATE AND TO_DATE)

	CREATE CLUSTERED INDEX CLTID_IDX ON #CLIENT_NEWPOA (DPID)  
	CREATE CLUSTERED INDEX ISIN_IDX ON #SCRIP_TYPE (ISIN)  
   
	TRUNCATE TABLE DELCDSLBALANCE     
    
	INSERT INTO DELCDSLBALANCE            
	SELECT              
	PARTY_CODE=CLIENT_CODE,DPID = LEFT(DPAM_SBA_NO,8),CLTDPID=DPAM_SBA_NO,SCRIP_CD='',SERIES='',  
	ISIN=DPHMCD_ISIN,FREEBAL=FLOOR(DPHMCD_FREE_QTY),            
	CURRBAL=FLOOR(DPHMCD_CURR_QTY),FREEZEBAL=0,LOCKINBAL=0,PLEDGEBAL=0,DPVBAL=0,DPCBAL=0,RPCBAL=0,            
	ELIMBAL=0,EARMARKBAL=0,REMLOCKBAL=0,TOTALBALANCE=FLOOR(DPHMCD_FREE_QTY),TRDATE=LEFT(DPHMCD_HOLDING_DT,11)  
	FROM AGMUBODPL3.DMAT.CITRUS_USR.HOLDINGALLFORVIEW, AGMUBODPL3.DMAT.CITRUS_USR.DP_ACCT_MSTR, #CLIENT_NEWPOA C  
	WHERE DPAM_ID = DPHMCD_DPAM_ID   
	AND DPAM_SBA_NO = C.DPID  
	AND FLOOR(DPHMCD_FREE_QTY) <> 0   
     
	DELETE FROM DELCDSLBALANCE  
	WHERE ISIN NOT IN (SELECT ISIN FROM #SCRIP_TYPE)   
  
	DELETE FROM DELCDSLBALANCE WHERE PARTY_CODE = ''  
	          
  IF (SELECT COUNT(1) FROM DELCDSLBALANCE_7DAYS WHERE TRDATE = @EFFDATE ) = 0        
  BEGIN        
    DECLARE @TDATE DATETIME        
    SELECT DISTINCT TOP 7 TRDATE INTO #TDATE FROM DELCDSLBALANCE_7DAYS ORDER BY 1 DESC        
    SELECT @TDATE = MIN(TRDATE) FROM #TDATE         
    DELETE DELCDSLBALANCE_7DAYS WHERE TRDATE < @TDATE            
  END        
  ELSE        
  BEGIN        
   DELETE FROM DELCDSLBALANCE_7DAYS WHERE TRDATE = @EFFDATE    
  END        
  IF (SELECT COUNT(1) FROM DELCDSLBALANCE WHERE TRDATE BETWEEN @EFFDATE AND @EFFDATE + ' 23:59' ) > 0          
  BEGIN        
 
  SELECT * INTO #VW_MULTIISIN_MF FROM VW_MULTIISIN_MF

  CREATE INDEX #ISIN ON #VW_MULTIISIN_MF (ISIN ,VALID)

   UPDATE DELCDSLBALANCE SET SCRIP_CD = LEFT(M.SCRIP_CD,12),SERIES= M.SERIES        
   FROM #VW_MULTIISIN_MF M        
   WHERE M.ISIN = DELCDSLBALANCE.ISIN AND VALID = 1        
           
   INSERT INTO DELCDSLBALANCE_7DAYS        
   SELECT M.PARTY_CODE,D.DPID,CLTDPID,SCRIP_CD,SERIES,ISIN,ABS(TOTALBALANCE),LEFT(TRDATE,11)        
   FROM DELCDSLBALANCE D (NOLOCK) ,MULTICLTID  M (NOLOCK)        
   WHERE TRDATE BETWEEN @EFFDATE AND @EFFDATE+ ' 23:59'         
   AND M.DPID = D.DPID        
   AND M.CLTDPNO = D.CLTDPID        
   AND LEFT(ISIN,3) <> 'INF'        
   AND DEF = 1          
             
   INSERT INTO DELCDSLBALANCE_7DAYS        
   SELECT M.PARTY_CODE,D.DPID,CLTDPID,SCRIP_CD,SERIES,ISIN,ABS(TOTALBALANCE),LEFT(TRDATE,11)        
   FROM DELCDSLBALANCE D (NOLOCK) ,MULTICLTID  M (NOLOCK)        
   WHERE TRDATE BETWEEN @EFFDATE AND @EFFDATE+ ' 23:59'         
   AND M.DPID = D.DPID        
   AND M.CLTDPNO = D.CLTDPID        
   AND LEFT(ISIN,3) = 'INF'        
   AND DEF = 1         
   AND ISIN IN (SELECT ISIN FROM SCRIP_APPROVED_MF)       
        
  END        
 END         

/* -- FOR MOSL ONLY         
 INSERT INTO DELCDSLBALANCE_7DAYS          
 SELECT '', BOID = LEFT(BOID,8), BOID, SCRIP_CD = '', SERIES = '', [ISIN CODE],         
 TOTALBALANCE = SUM(CONVERT(NUMERIC(18,3),[PLEDGE QUANTITY])), @EFFDATE, 'PLEDGE'        
 FROM  [192.168.100.30].DMAT.CITRUS_USR.VW_PLEDGE_DTLS         
 WHERE [PLEDGEE'S DP ID]+[PLEDGEE'S CLIENT ID]='1201090000252528'        
 AND DT <= @EFFDATE + ' 23:59'        
 GROUP BY BOID, [ISIN CODE]        
*/
        
 UPDATE DELCDSLBALANCE_7DAYS SET PARTY_CODE = M.PARTY_CODE        
 FROM MULTICLTID M        
 WHERE TRDATE = @EFFDATE AND M.DPID = DELCDSLBALANCE_7DAYS.DPID        
 AND M.CltDpNo = CLTDPID         
 AND DEF = 1 AND DELCDSLBALANCE_7DAYS.PARTY_CODE = ''     
        
 INSERT INTO #POA_BALANCE        
 SELECT         
  PARTY_CODE,        
  SCRIP_CD,SERIES,ISIN,              
  TOTALBALANCE,        
  EX_SEG ='POA'       
 FROM DELCDSLBALANCE_7DAYS        
 WHERE TRDATE = @EFFDATE         
 CREATE CLUSTERED INDEX IDXSCR ON #POA_BALANCE (ISIN)         
        
 UPDATE #POA_BALANCE SET SCRIP_CD = M.SCRIP_CD,SERIES= M.SERIES        
 FROM MULTIISIN M        
 WHERE M.ISIN = #POA_BALANCE.ISIN AND VALID = 1         
        
 UPDATE #POA_BALANCE SET SCRIP_CD = LEFT(M.SCRIP_CD,12),SERIES= M.SERIES        
 FROM VW_MULTIISIN_MF M        
 WHERE M.ISIN = #POA_BALANCE.ISIN AND VALID = 1         
             
 SELECT PARTY_CODE,SCRIP_CD,SERIES,ISIN,QTY = SUM(QTY),EX_SEG        
 INTO #POA_BALANCE_FINAL        
 FROM #POA_BALANCE        
 GROUP BY PARTY_CODE,SCRIP_CD,SERIES,ISIN,EX_SEG        
 HAVING SUM(QTY) > 0         
        
 TRUNCATE TABLE #POA_BALANCE        
        
 INSERT INTO #POA_BALANCE        
 SELECT * FROM #POA_BALANCE_FINAL        
        
 DROP TABLE #POA_BALANCE_FINAL        
          
  INSERT INTO #TBL_COLLATERAL_MARGIN_ALL              
  SELECT          
    EXCHANGE ='POA',              
    SEGMENT =EX_SEG,              
    PARTY_CODE,              
    COLL_TYPE='SEC',              
    SCRIP_CD,              
    SERIES,              
    ISIN,              
    QTY,          
    FD_TYPE='',              
    FD_BG_NO='',              
    AMOUNT=0,          
    FINALAMOUNT=0,          
    BANK_CODE='',              
    MRG_CL_RATE = 0 ,              
    MRG_AMOUNT = 0 ,              
    MRG_HAIRCUT = 0,              
    MRG_VAR_MARGIN = 0,              
    MRG_FINALAMOUNT = 0 ,              
    RMS_CL_RATE = 0,          
    RMS_HAIRCUT = 0,          
    RMS_AMOUNT = 0,          
    RMS_FINALAMOUNT = 0,          
    CASH_NCASH = 'N',          
    PERCENTAGECASH=0,              
    PERECNTAGENONCASH=100,               
    MRG_CASH = 0 ,              
    MRG_NONCASH = 0 ,          
    RMS_CASH =0,          
    RMS_NONCASH=0,          
    MRG_EFFECTIVECOLL = 0,          
    RMS_EFFECTIVECOLL = 0,         
    MARGIN_CALL = 0,            
    LEDGER_AMT = 0          
  FROM         
  #POA_BALANCE        
         
 DROP TABLE #POA_BALANCE  
 











 EXEC PR_GET_CASH_HOLDING @EFFDATE
 
 INSERT INTO #TBL_COLLATERAL_MARGIN_ALL              
  SELECT          
    EXCHANGE,              
    SEGMENT = 'CAPITAL',              
    PARTY_CODE,              
    COLL_TYPE='SEC',              
    SCRIP_CD,              
    SERIES,              
    ISIN,              
    QTY,          
    FD_TYPE='',              
    FD_BG_NO='',              
    AMOUNT=0,          
    FINALAMOUNT=0,          
    BANK_CODE='',              
    MRG_CL_RATE = 0 ,              
    MRG_AMOUNT = 0 ,              
    MRG_HAIRCUT = 0,              
    MRG_VAR_MARGIN = 0,              
    MRG_FINALAMOUNT = 0 ,              
    RMS_CL_RATE = 0,          
    RMS_HAIRCUT = 0,          
    RMS_AMOUNT = 0,          
    RMS_FINALAMOUNT = 0,          
    CASH_NCASH = 'N',          
    PERCENTAGECASH=0,              
    PERECNTAGENONCASH=100,               
    MRG_CASH = 0 ,              
    MRG_NONCASH = 0 ,          
    RMS_CASH =0,          
    RMS_NONCASH=0,          
    MRG_EFFECTIVECOLL = 0,          
    RMS_EFFECTIVECOLL = 0,         
    MARGIN_CALL = 0,            
    LEDGER_AMT = 0          
  FROM         
  DELHOLD_COLL WHERE TRANSDATE = @EFFDATE    

	UPDATE #TBL_COLLATERAL_MARGIN_ALL SET SCRIP_CD = LEFT(M.SCRIP_CD,12),SERIES= M.SERIES        
	FROM ANAND.BSEDB_AB.DBO.MULTIISIN M        
	WHERE M.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN AND VALID = 1 

	UPDATE #TBL_COLLATERAL_MARGIN_ALL SET SCRIP_CD = LEFT(M.SCRIP_CD,12),SERIES= M.SERIES        
	FROM MULTIISIN M        
	WHERE M.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN AND VALID = 1 
	
   select top 10 * ,'1' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037' and party_code='ALWR1977'
  
 
 CREATE INDEX IDXDT ON #TBL_COLLATERAL_MARGIN_ALL  (EXCHANGE,SEGMENT,PARTY_CODE)              
 CREATE CLUSTERED INDEX IDXSCR ON #TBL_COLLATERAL_MARGIN_ALL  (SCRIP_CD, SERIES)              
 CREATE INDEX IDXPARTY ON #TBL_COLLATERAL_MARGIN_ALL  (PARTY_CODE, COLL_TYPE,MRG_CL_RATE)               
        
/*-------------------------------------------------- INCLUDING POA BALANCE --END HERE ------------------------------------------------*/        
        
/*--------------------------------------------    UPDATING PREV DAYS CLOSING DATE    ------------------------------------------------------*/               
 DECLARE @PRV_DATE VARCHAR(11)              
         
 ----SELECT @PRV_DATE = MAX(SYSDATE) FROM CLOSING (NOLOCK)  WHERE SYSDATE < @EFFDATE   
 
 SELECT @PRV_DATE = MAX(Start_date) FROM SETT_MST WHERE Start_date < @EFFDATE AND SETT_TYPE ='N' 
 

 /*FETCHING NSE RATES*/              
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_CL_RATE =  CLOSING.CL_RATE              
 FROM CLOSING CLOSING(NOLOCK)               
 WHERE               
 LEFT(CLOSING.SYSDATE,11) = @PRV_DATE         
 AND CLOSING.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD              
 AND CLOSING.SERIES = #TBL_COLLATERAL_MARGIN_ALL.SERIES             
 AND CLOSING.SERIES NOT IN ('BE', 'EQ', 'BZ')   
 
 select top 10 * ,'2' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037'    and party_code='ALWR1977' 
           
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_CL_RATE =  CLOSING.CL_RATE              
 FROM CLOSING CLOSING(NOLOCK)               
 WHERE               
 LEFT(CLOSING.SYSDATE,11) = @PRV_DATE        
 AND CLOSING.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD               
 AND CLOSING.SERIES IN ('BE', 'EQ', 'BZ')        
 AND #TBL_COLLATERAL_MARGIN_ALL.SERIES IN ('BE', 'EQ', 'BZ')   
 
 select top 10 * ,'3' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037'  and party_code='ALWR1977'              
              
 UPDATE #TBL_COLLATERAL_MARGIN_ALL          
 SET #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = C.CL_RATE          
 FROM (          
  SELECT CL_RATE, M.ISIN, C.SCRIP_CD, C.SERIES          
  FROM CLOSING C (NOLOCK), MULTIISIN M (NOLOCK)          
  WHERE SYSDATE = @PRV_DATE        
  AND M.VALID = 1 AND C.SCRIP_CD = M.SCRIP_CD AND C.SERIES IN ('BE', 'EQ', 'BZ')        
  AND M.SERIES  IN ('BE', 'EQ', 'BZ')        
 ) C           
 WHERE C.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN             
 AND  #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0   
 
 select top 10 * ,'4' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037' and party_code='ALWR1977'      
        
 UPDATE #TBL_COLLATERAL_MARGIN_ALL          
 SET #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = C.CL_RATE          
 FROM (          
  SELECT CL_RATE, M.ISIN, C.SCRIP_CD, C.SERIES          
  FROM CLOSING C (NOLOCK), MULTIISIN M (NOLOCK)          
  WHERE SYSDATE = @PRV_DATE        
  AND M.VALID = 1 AND C.SCRIP_CD = M.SCRIP_CD AND C.SERIES = M.SERIES         
  AND C.SERIES NOT IN ('BE', 'EQ', 'BZ')         
 ) C           
 WHERE C.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN             
 AND  #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0   
 
 select top 10 * ,'5' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037'   and party_code='ALWR1977'    
              
 /*FETCHING BSE RATES*/          
 UPDATE #TBL_COLLATERAL_MARGIN_ALL                  
 SET             
  MRG_CL_RATE =  CLOSING.CL_RATE                  
 FROM             
  ANAND.BSEDB_AB.DBO.CLOSING CLOSING (NOLOCK)                
 WHERE                   
  left(CLOSING.SYSDATE,11) = @PRV_DATE        
  AND CLOSING.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD                  
  AND #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0                 
  --AND #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE <> 'POA'    
  
  select top 10 * ,'6' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037'   and party_code='ALWR1977' 
        
 UPDATE #TBL_COLLATERAL_MARGIN_ALL                                             
 SET #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = C.CL_RATE                                        
 FROM (              
  SELECT CL_RATE, M.ISIN, C.SCRIP_CD, C.SERIES                                          
  FROM ANAND.BSEDB_AB.DBO.CLOSING C (NOLOCK), ANAND.BSEDB_AB.DBO.MULTIISIN M (NOLOCK)              
  WHERE SYSDATE = @PRV_DATE        
  AND M.VALID = 1 AND C.SCRIP_CD = M.SCRIP_CD AND C.SERIES = M.SERIES               
 ) C                                    
 WHERE C.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN               
 AND  #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0  
 
   select top 10 *,'7' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037' and party_code='ALWR1977'
    
          
            
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_CL_RATE =  NAV_VALUE, MRG_HAIRCUT = 15, RMS_HAIRCUT = 15        
 FROM MFSS_NAV01 MFSS_NAV01(nolock)        
 --WHERE MFSS_NAV01.NAV_DATE BETWEEN @EFFDATE AND  @EFFDATE + ' 23:59'        
WHERE MFSS_NAV01.NAV_DATE BETWEEN @PRV_DATE AND  @PRV_DATE + ' 23:59:59'        
 AND MFSS_NAV01.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN        
 AND #TBL_COLLATERAL_MARGIN_ALL.SERIES='MF'        
 --AND #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0   
    select top 10 *,'8' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037' and party_code='ALWR1977'     

 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_CL_RATE =  NAV_VALUE, MRG_HAIRCUT = 15, RMS_HAIRCUT = 15        
 FROM ANGELFO.BSEMFSS.DBO.MFSS_NAV MFSS_NAV01(nolock)        
 --WHERE MFSS_NAV01.NAV_DATE BETWEEN @EFFDATE AND  @EFFDATE + ' 23:59'        
WHERE MFSS_NAV01.NAV_DATE BETWEEN @PRV_DATE AND  @PRV_DATE + ' 23:59:59'        
 AND MFSS_NAV01.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN        
 AND #TBL_COLLATERAL_MARGIN_ALL.SERIES='MF'        
 AND #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0  
 select top 10 *,'9' from   #TBL_COLLATERAL_MARGIN_ALL   where ISIN = 'INF732E01037' and party_code='ALWR1977'   
 
 return    
          
 -- IF STILL NOT AVL, CHECKING FOR LAST 3 MONTHS        
UPDATE #TBL_COLLATERAL_MARGIN_ALL              
SET MRG_CL_RATE =  CLOSING.CL_RATE              
FROM CLOSING CLOSING(NOLOCK)               
WHERE               
LEFT(CLOSING.SYSDATE,11) = (SELECT LEFT(MAX(SYSDATE),11) FROM CLOSING C (NOLOCK) WHERE SYSDATE < @EFFDATE            
      AND C.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD              
      AND C.SERIES IN ('EQ', 'BE', 'BZ')         
      AND #TBL_COLLATERAL_MARGIN_ALL.SERIES IN ('EQ', 'BE', 'BZ')         
      AND C.SYSDATE > DATEADD(M,-3,CONVERT(DATETIME,@EFFDATE))         
      )        
AND CLOSING.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD              
AND CLOSING.SERIES IN ('EQ', 'BE', 'BZ')         
AND #TBL_COLLATERAL_MARGIN_ALL.SERIES IN ('EQ', 'BE', 'BZ')         
AND #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0               
        
UPDATE #TBL_COLLATERAL_MARGIN_ALL              
SET MRG_CL_RATE =  CLOSING.CL_RATE              
FROM CLOSING CLOSING(NOLOCK)               
WHERE               
LEFT(CLOSING.SYSDATE,11) =         
      (         
       SELECT LEFT(MAX(SYSDATE),11) FROM CLOSING C (NOLOCK) WHERE SYSDATE < @EFFDATE            
       AND C.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD              
       AND C.SERIES = #TBL_COLLATERAL_MARGIN_ALL.SERIES         
       AND C.SERIES NOT IN ('EQ', 'BE', 'BZ')         
       AND C.SYSDATE > DATEADD(M,-3,CONVERT(DATETIME,@EFFDATE))         
       )        
AND CLOSING.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD              
AND CLOSING.SERIES = #TBL_COLLATERAL_MARGIN_ALL.SERIES         
AND #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0        
        
SELECT DISTINCT ISIN,  MRG_CL_RATE, SCRIP_CD = CONVERT(VARCHAR(12),'') INTO #CLDATA         
FROM #TBL_COLLATERAL_MARGIN_ALL        
WHERE MRG_CL_RATE = 0         
--AND #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE <> 'POA'         
        
UPDATE #CLDATA SET SCRIP_CD = M.SCRIP_CD        
FROM ANAND.BSEDB_AB.DBO.MULTIISIN M (NOLOCK)           
WHERE M.ISIN = #CLDATA.ISIN         
AND VALID = 1         
        
UPDATE  #CLDATA SET MRG_CL_RATE = CLOSING.CL_RATE        
FROM ANAND.BSEDB_AB.DBO.CLOSING CLOSING(NOLOCK)               
WHERE               
LEFT(CLOSING.SYSDATE,11) = (SELECT LEFT(MAX(SYSDATE),11) FROM ANAND.BSEDB_AB.DBO.CLOSING C (NOLOCK) WHERE SYSDATE < @EFFDATE            
      AND C.SCRIP_CD = #CLDATA.SCRIP_CD              
      AND C.SYSDATE > DATEADD(M,-3,CONVERT(DATETIME,@EFFDATE))         
      )        
AND CLOSING.SCRIP_CD = #CLDATA.SCRIP_CD               
        
 UPDATE #TBL_COLLATERAL_MARGIN_ALL                                             
 SET #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = C.MRG_CL_RATE                                        
 FROM #CLDATA C                                             
 WHERE C.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN               
 AND  #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0         
 --AND #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE <> 'POA'         
        
         
 /*RETRIEVING THE OLD RATES FROM VALUATIONS FOR THE MISSING*/              
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_CL_RATE =  CLOSING.CL_RATE              
 FROM C_VALUATION CLOSING (NOLOCK)              
 WHERE               
  CLOSING.SYSDATE = (SELECT MAX(SYSDATE) FROM C_VALUATION               
    WHERE SYSDATE < @EFFDATE )              
  AND CLOSING.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD              
  AND CLOSING.SERIES IN ('EQ', 'BE', 'BZ')        
  AND #TBL_COLLATERAL_MARGIN_ALL.SERIES IN ('EQ', 'BE', 'BZ')             
  AND CLOSING.EXCHANGE = #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE              
  AND CLOSING.SEGMENT = #TBL_COLLATERAL_MARGIN_ALL.SEGMENT              
  AND #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0                 
        
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_CL_RATE =  CLOSING.CL_RATE              
 FROM C_VALUATION CLOSING (NOLOCK)              
 WHERE               
  CLOSING.SYSDATE = (SELECT MAX(SYSDATE) FROM C_VALUATION               
    WHERE SYSDATE < @EFFDATE )              
  AND CLOSING.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD              
  AND CLOSING.SERIES = #TBL_COLLATERAL_MARGIN_ALL.SERIES              
  AND CLOSING.SERIES NOT IN ('EQ', 'BE', 'BZ')         
  AND CLOSING.EXCHANGE = #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE              
  AND CLOSING.SEGMENT = #TBL_COLLATERAL_MARGIN_ALL.SEGMENT              
  AND #TBL_COLLATERAL_MARGIN_ALL.MRG_CL_RATE = 0          
         
 -- REMOVING THE NON NSE POA HOLDINGS        
/*        
 SELECT * FROM #TBL_COLLATERAL_MARGIN_ALL        
 WHERE PARTY_CODE = 'NW0153'        
        
 SELECT * FROM DELCDSLBALANCE_7DAYS WHERE TRDATE = @EFFDATE AND PARTY_CODE = 'NW0153'        
*/        
        
SELECT DISTINCT ISIN INTO #ISIN FROM #TBL_COLLATERAL_MARGIN_ALL         
WHERE EXCHANGE ='POA' --AND SEGMENT ='POA'        
AND MRG_CL_RATE =0        
        
CREATE CLUSTERED INDEX IDXISIN ON #ISIN        
(        
 ISIN        
)        
        
 DELETE DELCDSLBALANCE_7DAYS WHERE TRDATE = @EFFDATE AND EXISTS (SELECT ISIN FROM #ISIN         
           WHERE #ISIN.ISIN = DELCDSLBALANCE_7DAYS.ISIN)        
        
 DELETE DELCDSLBALANCE_7DAYS WHERE TRDATE = @EFFDATE AND EXISTS (SELECT ISIN FROM #ISIN         
           WHERE #ISIN.ISIN = DELCDSLBALANCE_7DAYS.ISIN)        
         
 DELETE #TBL_COLLATERAL_MARGIN_ALL WHERE EXCHANGE ='POA' --AND SEGMENT ='POA'        
 AND MRG_CL_RATE =0        
/*        
 SELECT * FROM #TBL_COLLATERAL_MARGIN_ALL        
 WHERE PARTY_CODE = 'NW0153'        
        
 SELECT * FROM DELCDSLBALANCE_7DAYS WHERE TRDATE = @EFFDATE AND PARTY_CODE = 'NW0153'        
*/        
 -- ZERO RATE FOR NSE DE-LISTED SCRIPS 
       
 UPDATE #TBL_COLLATERAL_MARGIN_ALL SET MRG_CL_RATE = 0            
 FROM MSAJAG.DBO.SCRIP2 C              
 WHERE           
 C.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD AND              
 C.SERIES = #TBL_COLLATERAL_MARGIN_ALL.SERIES              
 AND C.STATUS='3' 
                
        
 UPDATE #TBL_COLLATERAL_MARGIN_ALL SET MRG_CL_RATE = 0               
 FROM ANAND.BSEDB_AB.DBO.SCRIP2 C, ANAND.BSEDB_AB.DBO.MULTIISIN M                   
 WHERE               
 M.SCRIP_CD = C.BSECODE        
 AND M.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN         
 AND M.VALID = 1                  
 AND C.STATUS='S'                   
 AND LEFT(C.BSECODE,1) <> '6'   
               
/*-----------------------------------------------  GETIING T-1 DAY'S VAR MARGIN  -----------------------------------------------*/               
              
 /*FETCHING FROM NSE*/              
 SELECT  V.*              
 INTO    #VAR              
 FROM    VARDETAIL V (NOLOCK),              
   VARCONTROL C (NOLOCK)              
 WHERE   V.DETAILKEY = C.DETAILKEY              
  AND C.RECDATE   =             
   (          
    SELECT MAX(C1.RECDATE)              
    FROM  VARCONTROL C1 (NOLOCK)              
    WHERE C1.RECDATE  <= @PRV_DATE + ' 23:59'    -- CHANGED 30 JUN 2015        
 --WHERE C1.RECDATE  <= @EFFDATE + ' 23:59'    -- CHANGED 17 JUL 2014        
   )           
          
              
 /*FETCHING FROM BSE*/              
 INSERT INTO  #VAR                 
 SELECT             
  RECTYPE=1,SCRIP_CD,SERIES='BSE',ISIN,SECVAR=MARGIN,INDEXVAR=MARGIN,APPVAR=MARGIN,              
  SECSPECVAR=MARGIN,VARMARGINRATE=MARGIN,DETAILKEY=1                    
  FROM    ANAND.BSEDB_AB.DBO.VARDETAIL V                  
  WHERE   V.FDATE   =                  
    (            
    SELECT MAX(FDATE)                  
    FROM  ANAND.BSEDB_AB.DBO.VARDETAIL V1               
    WHERE V1.FDATE  <= @PRV_DATE + ' 23:59'     -- CHANGED 30 JUN 2015        
    --WHERE V1.FDATE  <= @EFFDATE + ' 23:59'    -- CHANGED 17 JUL 2014            
    )                  
                       
/*        
 CHANGED ON 6 FEB 2015 VARMARGINRATE TO APPVAR        
 EXAMPLE VARMARGINRATE = 12.5 AND APPVAR IS 705 FOR INFY        
*/        
        
CREATE CLUSTERED INDEX IDXSERIES ON #VAR (SERIES)              
CREATE NONCLUSTERED INDEX IDXISIN ON #VAR (ISIN)              
            
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_VAR_MARGIN = VARMARGINRATE              
 FROM              
 (            
  SELECT SCRIP_CD,              
  VARMARGINRATE = MAX(AppVar) -- MAX(VARMARGINRATE)              
  FROM    #VAR              
  WHERE   SERIES IN ('EQ', 'BE','BZ')              
  GROUP BY SCRIP_CD              
 ) A              
 WHERE   #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD = A.SCRIP_CD              
 AND SERIES    IN ('EQ', 'BE','BZ')              
 AND #TBL_COLLATERAL_MARGIN_ALL.COLL_TYPE ='SEC'              
              
               
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET     MRG_VAR_MARGIN = VARMARGINRATE              
 FROM              
 (            
  SELECT SCRIP_CD,              
  SERIES  ,              
  VARMARGINRATE = MAX(AppVar) -- MAX(VARMARGINRATE)           
  FROM    #VAR              
  WHERE   SERIES NOT IN ('EQ', 'BE','BZ')              
  GROUP BY SCRIP_CD,SERIES              
 ) A              
 WHERE   #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD = A.SCRIP_CD              
 AND #TBL_COLLATERAL_MARGIN_ALL.SERIES   = A.SERIES              
 AND #TBL_COLLATERAL_MARGIN_ALL.COLL_TYPE ='SEC'      
              
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET MRG_VAR_MARGIN = VARMARGINRATE              
 FROM              
  (            
  SELECT ISIN,              
  VARMARGINRATE=MAX(AppVar) -- MAX(VARMARGINRATE)        
  FROM #VAR              
  GROUP BY ISIN              
 ) A              
 WHERE #TBL_COLLATERAL_MARGIN_ALL.ISIN = A.ISIN              
 AND (MRG_VAR_MARGIN = 0 OR MRG_VAR_MARGIN = 100)        
 AND #TBL_COLLATERAL_MARGIN_ALL.COLL_TYPE ='SEC'          


 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET     MRG_VAR_MARGIN = 15        
 WHERE  SERIES = 'MF'
         
 UPDATE #TBL_COLLATERAL_MARGIN_ALL              
 SET     MRG_VAR_MARGIN = 100        
 WHERE     MRG_VAR_MARGIN = 0        
        
 DROP TABLE #VAR              
          
   /* APPLYING VAR HAIRCUT ACROSS ALL AND IF HAIRCUT NOT AVAILABLE THEN TAKING THE GLOBAL HAIRCUT */                        
                
--COMMENTED  17 JUL 2014          
        
/*        
UPDATE #TBL_COLLATERAL_MARGIN_ALL                            
SET MRG_VAR_MARGIN = VARPERC        
FROM MSAJAG.DBO.SCRIP_APPROVED_MF MF        
WHERE #TBL_COLLATERAL_MARGIN_ALL.SERIES = 'MF'        
AND MF.SCRIP_CD = #TBL_COLLATERAL_MARGIN_ALL.SCRIP_CD        
AND MF.SERIES = #TBL_COLLATERAL_MARGIN_ALL.SERIES        
AND MF.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN        
AND (#TBL_COLLATERAL_MARGIN_ALL.MRG_VAR_MARGIN= 0 OR #TBL_COLLATERAL_MARGIN_ALL.MRG_VAR_MARGIN = 100)        
*/        
                                     
 UPDATE #TBL_COLLATERAL_MARGIN_ALL                            
 SET MRG_VAR_MARGIN = SECURITYHAIRCUT.HAIRCUT                            
 FROM SECURITYHAIRCUT  (NOLOCK)                           
 WHERE SECURITYHAIRCUT.PARTY_CODE = ''                            
  AND SECURITYHAIRCUT.SCRIP_CD = ''                            
  AND CLIENT_TYPE = ''                            
  AND #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE = SECURITYHAIRCUT.EXCHANGE                             
  AND #TBL_COLLATERAL_MARGIN_ALL.SEGMENT = SECURITYHAIRCUT.SEGMENT                             
  AND ACTIVE = 1                             
  AND EFFDATE = (SELECT MAX(EFFDATE) FROM SECURITYHAIRCUT   (NOLOCK)                                  
                  WHERE EFFDATE <= @PRV_DATE + ' 23:59'                             
                  AND SECURITYHAIRCUT.PARTY_CODE = ''                      
                  AND SECURITYHAIRCUT.SCRIP_CD = ''                             
                  AND CLIENT_TYPE = ''                            
                  AND #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE = SECURITYHAIRCUT.EXCHANGE                             
                  AND #TBL_COLLATERAL_MARGIN_ALL.SEGMENT = SECURITYHAIRCUT.SEGMENT                             
                  AND ACTIVE = 1)                               
 AND (MRG_VAR_MARGIN =0 OR MRG_VAR_MARGIN = 100)        
 AND #TBL_COLLATERAL_MARGIN_ALL.SERIES = 'MF'        
 AND (#TBL_COLLATERAL_MARGIN_ALL.MRG_VAR_MARGIN= 0 OR #TBL_COLLATERAL_MARGIN_ALL.MRG_VAR_MARGIN = 100)  --- CHANGED 17 JUL 2014          
                           
 UPDATE #TBL_COLLATERAL_MARGIN_ALL                            
 SET MRG_VAR_MARGIN = SECURITYHAIRCUT.HAIRCUT                            
 FROM SECURITYHAIRCUT  (NOLOCK)                           
 WHERE SECURITYHAIRCUT.PARTY_CODE = ''                       
  AND SECURITYHAIRCUT.SCRIP_CD = ''                            
  AND CLIENT_TYPE = ''                            
  AND #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE = 'POA'        
  AND SECURITYHAIRCUT.EXCHANGE = 'NSE'                            
  --AND #TBL_COLLATERAL_MARGIN_ALL.SEGMENT = 'POA'        
  AND SECURITYHAIRCUT.SEGMENT = 'FUTURES'          
  AND ACTIVE = 1                             
  AND EFFDATE = (SELECT MAX(EFFDATE) FROM SECURITYHAIRCUT   (NOLOCK)                                  
                  WHERE EFFDATE <= @PRV_DATE + ' 23:59'                             
                  AND SECURITYHAIRCUT.PARTY_CODE = ''                             
                  AND SECURITYHAIRCUT.SCRIP_CD = ''                             
                  AND CLIENT_TYPE = ''           
      AND #TBL_COLLATERAL_MARGIN_ALL.EXCHANGE = 'POA'        
      AND SECURITYHAIRCUT.EXCHANGE = 'NSE'                            
      --AND #TBL_COLLATERAL_MARGIN_ALL.SEGMENT = 'POA'        
      AND SECURITYHAIRCUT.SEGMENT = 'FUTURES'                         
                  AND ACTIVE = 1)                               
 AND (MRG_VAR_MARGIN =0 OR MRG_VAR_MARGIN = 100)        
 AND #TBL_COLLATERAL_MARGIN_ALL.SERIES = 'MF'        
 AND (#TBL_COLLATERAL_MARGIN_ALL.MRG_VAR_MARGIN= 0 OR #TBL_COLLATERAL_MARGIN_ALL.MRG_VAR_MARGIN = 100)  --- CHANGED 17 JUL 2014          
        
IF (SELECT COUNT(1) FROM MSAJAG.DBO.SCRIP_UNAPPROVED WITH(NOLOCK)) > 0          
BEGIN          
 UPDATE  #TBL_COLLATERAL_MARGIN_ALL SET MRG_VAR_MARGIN = 100          
 WHERE EXISTS ( SELECT ISIN FROM MSAJAG.DBO.SCRIP_UNAPPROVED S (NOLOCK)          
 WHERE S.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN)          
END               
        
 UPDATE #TBL_COLLATERAL_MARGIN_ALL SET RMS_CL_RATE = MRG_CL_RATE, RMS_HAIRCUT = MRG_VAR_MARGIN         
        
DECLARE @HAIRCUTDATE DATETIME        
SELECT @HAIRCUTDATE=MAX(TRADE_DATE) FROM TBL_SCRIP_HAIRCUT A (NOLOCK)        
     WHERE A.TRADE_DATE <= @EFFDATE + ' 23:59'         
        
/* APPLYING SCRIPT LEVEL VAR MARGING, IF AVAILABLE  */        
UPDATE #TBL_COLLATERAL_MARGIN_ALL SET RMS_HAIRCUT = TBL_SCRIP_HAIRCUT.HAIRCUT                       
FROM TBL_SCRIP_HAIRCUT (NOLOCK)                        
WHERE #TBL_COLLATERAL_MARGIN_ALL.ISIN = TBL_SCRIP_HAIRCUT.ISIN        
AND TRADE_DATE = @HAIRCUTDATE        
AND #TBL_COLLATERAL_MARGIN_ALL.RMS_HAIRCUT < TBL_SCRIP_HAIRCUT.HAIRCUT            
        
UPDATE #TBL_COLLATERAL_MARGIN_ALL SET RMS_HAIRCUT = 100        
WHERE NOT EXISTS (SELECT ISIN FROM TBL_SCRIP_HAIRCUT (NOLOCK)        
     WHERE TRADE_DATE = @HAIRCUTDATE        
     AND #TBL_COLLATERAL_MARGIN_ALL.ISIN = TBL_SCRIP_HAIRCUT.ISIN)        
AND #TBL_COLLATERAL_MARGIN_ALL.SERIES NOT LIKE 'N%'        
AND #TBL_COLLATERAL_MARGIN_ALL.SERIES <> 'MF'        
        
 UPDATE #TBL_COLLATERAL_MARGIN_ALL                      
 Set RMS_HAIRCUT = CASE WHEN  RMS_HAIRCUT = 0 THEN   100 ELSE RMS_HAIRCUT END        
        
IF (SELECT COUNT(1) FROM SCRIP_UNAPPROVED with (NOLOCK)) > 0            
BEGIN            
 UPDATE  #TBL_COLLATERAL_MARGIN_ALL SET RMS_HAIRCUT = 100            
 WHERE EXISTS ( SELECT ISIN FROM SCRIP_UNAPPROVED S with (NOLOCK)            
 WHERE S.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN)            
END

---added by suresh---
	 IF @EFFDATE >='2019-07-31'
	 BEGIN  

	 UPDATE  #TBL_COLLATERAL_MARGIN_ALL SET MRG_VAR_MARGIN = 100            
	 WHERE EXISTS ( SELECT ISIN FROM ANGELFO.NSEFO.DBO.SCRIP_TYPE S WITH (NOLOCK)            
	 WHERE S.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN  AND STATUS='POOR'  )
	 AND  #TBL_COLLATERAL_MARGIN_ALL.SEGMENT IN ('CAPITAL', 'POA')
	 
	  UPDATE  #TBL_COLLATERAL_MARGIN_ALL SET MRG_VAR_MARGIN = 100            
	 WHERE EXISTS ( SELECT ISIN FROM ANGELFO.NSEFO.DBO.SCRIP_TYPE S WITH (NOLOCK)            
	 WHERE S.ISIN = #TBL_COLLATERAL_MARGIN_ALL.ISIN  AND STATUS='POOR'  )
	 AND  #TBL_COLLATERAL_MARGIN_ALL.SEGMENT IN ('CAPITAL', 'POA')
	 AND SERIES='MF'
	 
	 --PRINT @EFFDATE

	 -- RETURN

	END 
 
 -----end---              
            
 UPDATE #TBL_COLLATERAL_MARGIN_ALL SET         
 FINALAMOUNT =CASE         
     WHEN COLL_TYPE ='SEC' THEN ((QTY) * MRG_CL_RATE) - ((QTY) * MRG_CL_RATE*MRG_VAR_MARGIN/100)         
     ELSE (AMOUNT) END,        
 RMS_FINALAMOUNT = CASE         
     WHEN COLL_TYPE ='SEC' THEN ((QTY) * RMS_CL_RATE) - ((QTY) * RMS_CL_RATE*RMS_HAIRCUT/100)         
     ELSE (AMOUNT) END,
 MRG_FINALAMOUNT =CASE         
     WHEN COLL_TYPE ='SEC' THEN ((QTY) * MRG_CL_RATE) - ((QTY) * MRG_CL_RATE*MRG_VAR_MARGIN/100)         
     ELSE (AMOUNT) END 	
     
     
        
         
 TRUNCATE TABLE V2_TBL_COLLATERAL_MARGIN          
           
 INSERT INTO V2_TBL_COLLATERAL_MARGIN          
 SELECT *,RELEASE_QTY=0,RELEASE_AMT=0,RECORD_TYPE= 1,EXCHANGE_ORG = EXCHANGE,SEGMENT_ORG=SEGMENT          
 FROM #TBL_COLLATERAL_MARGIN_ALL          
             
  DELETE FROM V2_TBL_COLLATERAL_MARGIN_COMBINE WHERE EFFDATE = @EFFDATE        
          
  INSERT INTO V2_TBL_COLLATERAL_MARGIN_COMBINE         
  SELECT EXCHANGE,SEGMENT,PARTY_CODE,COLL_TYPE,SCRIP_CD,SERIES,ISIN,QTY,FD_TYPE,FD_BG_NO,AMOUNT,FINALAMOUNT,        
  BANK_CODE,MRG_CL_RATE,MRG_AMOUNT,MRG_HAIRCUT,MRG_VAR_MARGIN,MRG_FINALAMOUNT,RMS_CL_RATE,RMS_HAIRCUT,RMS_AMOUNT,        
  RMS_FINALAMOUNT,CASH_NCASH,PERCENTAGECASH,PERECNTAGENONCASH,MRG_CASH,MRG_NONCASH,RMS_CASH,RMS_NONCASH,        
  MRG_EFFECTIVECOLL,RMS_EFFECTIVECOLL,MARGIN_CALL,LEDGER_AMT,RELEASE_QTY,RELEASE_AMT,RECORD_TYPE,        
  @EFFDATE,GETDATE(),EXCHANGE_ORG,SEGMENT_ORG FROM V2_TBL_COLLATERAL_MARGIN      
        
/*================================================= END OF THE PROC =====================================*/

GO
