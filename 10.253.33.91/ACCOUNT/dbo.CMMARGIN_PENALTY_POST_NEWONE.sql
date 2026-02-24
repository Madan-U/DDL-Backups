-- Object: PROCEDURE dbo.CMMARGIN_PENALTY_POST_NEWONE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





CREATE PROC [dbo].[CMMARGIN_PENALTY_POST]        
(                  
  @UNAME VARCHAR(25),                    
  @VTYP SMALLINT,                    
  @BOOKTYPE VARCHAR(2),                  
  @TRADEDATE VARCHAR(11),                  
  @GLCODE VARCHAR(10),                  
  @LEDGERVNO VARCHAR(12),      
  @LEDGERDATE VARCHAR(11)      
)      
AS                    
                   
 SET NOCOUNT ON                    
              
              
 DECLARE                    
  @@ERROR_COUNT AS INT                  
          
           
 CREATE TABLE [#RECPAY_TABLE]                    
 (                    
   SRNO INT,                    
   VVDT VARCHAR(10),                    
   EEDT VARCHAR(10),                    
   CLTCODE VARCHAR(10),                    
   DRCR VARCHAR(1),                    
   AMOUNT MONEY,                    
   NARRATION VARCHAR(500),                    
   SNO INT IDENTITY (1, 1) NOT NULL ,                    
   VDT DATETIME NULL ,                    
   UPDFLAG VARCHAR (1)  NOT NULL DEFAULT('N'),                    
   EDT DATETIME NULL ,                    
   VNO VARCHAR (12)  NULL ,                    
   ACNAME VARCHAR (100)  NULL ,                    
   FYSTART DATETIME NULL,                    
   FYEND DATETIME NULL,                    
   COSTCODE SMALLINT NULL,                    
   LNO SMALLINT NOT NULL DEFAULT(0)                    
 ) ON [PRIMARY]                    
                    
 CREATE TABLE [#RECPAY_TABLE_LNO]                    
 (                    
  SNO INT ,                    
  LNO INT IDENTITY (1, 1) NOT NULL                    
 ) ON [PRIMARY]                    
                    
          
 DECLARE                
  @TRDATE  VARCHAR(10),              
  @EDATE VARCHAR(10)       
        
SELECT @TRDATE = CONVERT(VARCHAR,CONVERT(DATETIME,@LEDGERDATE),103)              
SELECT @EDATE =  CONVERT(VARCHAR,CONVERT(DATETIME,@LEDGERDATE),103)              
                 
/*======================== MARGIN PENALTY PLUG IN  ============================================*/      
         
      CREATE TABLE #TMPDATA   
(   
 PCODE VARCHAR(10)  
)  
   
if convert(datetime,@TRADEDATE) >= convert(datetime,'jun 22 2017')  
begin  
 alter table #TMPDATA  
 add RECNO INT IDENTITY(1,1)  
  
INSERT INTO #TMPDATA  
SELECT PARTY_CODE FROM MSAJAG.DBO.CMMARGIN_PENALTY(NOLOCK)     
WHERE   
 MARGIN_DATE =  @TRADEDATE     
 AND LEDGER_POST_FLAG = 99  
 AND PENALTY_AMT + SERVICE_TAX > 0    
end  
else  
begin  
 alter table #TMPDATA  
 add RECNO INT   
  
INSERT INTO #TMPDATA  
SELECT PARTY_CODE, 1 FROM MSAJAG.DBO.CMMARGIN_PENALTY(NOLOCK)     
WHERE   
 MARGIN_DATE =  @TRADEDATE     
 AND LEDGER_POST_FLAG = 99  
 AND PENALTY_AMT + SERVICE_TAX > 0    
end  
  
  
INSERT INTO #RECPAY_TABLE (SRNO,CLTCODE,VVDT,EEDT,DRCR,AMOUNT,NARRATION)          
SELECT       
 RECNO,PARTY_CODE ,      
 @TRDATE, @EDATE,'D',      
 AMT = PENALTY_AMT + SERVICE_TAX,        
 NARRATION = 'MARGIN SHORTAGE PENALTY - ' + @TRADEDATE     
FROM       
 MSAJAG.DBO.CMMARGIN_PENALTY(NOLOCK), #TMPDATA    
WHERE   
 MARGIN_DATE =  @TRADEDATE     
 AND LEDGER_POST_FLAG = 99  
 AND PENALTY_AMT + SERVICE_TAX > 0  
 AND PARTY_CODE = PCODE   
          
INSERT INTO #RECPAY_TABLE (SRNO,CLTCODE,VVDT,EEDT,DRCR,AMOUNT,NARRATION)          
SELECT       
 RECNO,@GLCODE ,      
 @TRDATE, @EDATE,'C',      
 AMT = SUM(PENALTY_AMT),      
 NARRATION = 'MARGIN SHORTAGE PENALTY - ' + @TRADEDATE  
FROM       
 MSAJAG.DBO.CMMARGIN_PENALTY(NOLOCK), #TMPDATA      
WHERE   
 MARGIN_DATE =  @TRADEDATE     
 AND LEDGER_POST_FLAG = 99 AND PCODE = PARTY_CODE   
GROUP BY RECNO  


	
  
INSERT INTO #RECPAY_TABLE (SRNO,CLTCODE,VVDT,EEDT,DRCR,AMOUNT,NARRATION)          
SELECT       
	RECNO,ACCODE ,    
 @TRDATE, @EDATE,'C',      
 AMT = SUM(SERVICE_TAX),      
 NARRATION = 'MARGIN SHORTAGE PENALTY - ' + @TRADEDATE  
FROM       
 MSAJAG.DBO.CMMARGIN_PENALTY(NOLOCK), #TMPDATA      
WHERE 
	MARGIN_DATE =  @TRADEDATE   
	AND LEDGER_POST_FLAG = 99
	AND ACNAME = 'SPLIT TAX'
	AND SERVICE_TAX > 0 AND PCODE = PARTY_CODE 
GROUP BY ACCODE, RECNO
--GROUP BY ACCODE, RECNO  
   
                
/*=============================================================================================*/              
    
    
  DECLARE                  
  @@NEWVNO AS VARCHAR(12),                  
  @@VDT AS VARCHAR(11),                  
  @@LNOCUR AS CURSOR,                  
  @@LNOVNO AS INT,           
  @@NOREC AS INT                  
  
SELECT TOP 1                  
  @@VDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)), 109)  
 FROM                  
  #RECPAY_TABLE  
                
  UPDATE              
   #RECPAY_TABLE              
	SET 
    VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),              
    EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),              
    FYSTART = P.SDTCUR,              
    FYEND = P.LDTCUR,              
    UPDFLAG = 'Y',              
    ACNAME = LONGNAME,              
    COSTCODE = 0        
    FROM ACMAST A, PARAMETER P        
 --, COSTMAST C              
    WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE              
    AND P.CURYEAR = 1              
    AND A.ACCAT IN ('3','4','104')              
    --AND A.BRANCHCODE = C.COSTNAME              
    AND A.BRANCHCODE <> 'ALL'        
                    
    UPDATE              
   #RECPAY_TABLE              
   SET              
    VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),              
    EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),              
    FYSTART = P.SDTCUR,              
    FYEND = P.LDTCUR,              
    UPDFLAG = 'Y',              
    ACNAME = LONGNAME,              
    COSTCODE = 0        
    FROM ACMAST A, PARAMETER P              
    WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE              
    AND P.CURYEAR = 1              
    AND A.ACCAT IN ('3','4','104')     
    AND A.BRANCHCODE = 'ALL'              
                   
/* '--------------------------DECLARATION OF VARIABLES FOR VALIDATIONS ------------------------*/                    
                    
 DECLARE                    
  @@STD_DATE VARCHAR(11),                    
  @@LST_DATE VARCHAR(11),                    
  @@VNOMETHOD INT,                    
  @@ACNAME CHAR(100),                    
  @@MICRNO VARCHAR(10),                    
  @@DRCR VARCHAR(1)                    
                    
                    
/* '--------------------------VALIDATION FOR VOUCHER DATE NOT IN CURRENT FIN YEAR ------------------------*/                    
                    
 SELECT @@ERROR_COUNT = COUNT(1) FROM #RECPAY_TABLE WHERE VDT NOT BETWEEN FYSTART AND FYEND                    
                    
 IF @@ERROR_COUNT > 0                    
  BEGIN      
   RAISERROR('DATE MISMATCH', 16, 1)          
   DROP TABLE #RECPAY_TABLE                    
                       
   RETURN                    
  END                    
                
                 
/*--------------------------VALIDATION FOR DIFFERENT VDTS IN SAME VOUCHER ------------------------*/                    
                    
 SELECT @@ERROR_COUNT = COUNT(DISTINCT VDT) FROM  #RECPAY_TABLE WHERE SRNO IN (SELECT DISTINCT SRNO FROM #RECPAY_TABLE)                    
 GROUP BY SRNO HAVING COUNT(DISTINCT VDT) > 1                    
 IF @@ERROR_COUNT > 0                    
  BEGIN           
     RAISERROR('SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES', 16, 1)          
   DROP TABLE #RECPAY_TABLE                    
                       
   RETURN                    
  END                    
        
              
              
/*--------------------------VALIDATION FOR DRCR MISMATCH IN SAME VOUCHER ------------------------*/                   
                    
 SELECT @@ERROR_COUNT = COUNT(1) FROM                    
  (SELECT AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END)                    
  FROM #RECPAY_TABLE                    
  GROUP BY SRNO                    
  HAVING SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) <> 0) A                    
 IF @@ERROR_COUNT > 0                    
  BEGIN              
    RAISERROR('DEBIT AND CREDIT TOTALS DO NOT MATCH IN SOME VOUCHERS', 16, 1)                
   DROP TABLE #RECPAY_TABLE                    
                 
   RETURN                    
  END                    
                    
/* '--------------------------FINAL VALIDATION BASED ON UPDFLAG ------------------------*/                    
                    
 SELECT @@ERROR_COUNT = COUNT(1) FROM                    
 (       
  SELECT DISTINCT                    
   CLTCODE                    
  FROM #RECPAY_TABLE                 
  WHERE UPDFLAG = 'N'                    
 ) A                    
             
 IF @@ERROR_COUNT > 0                    
  BEGIN                    
   SELECT 'FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS DO NOT EXIST' UNION ALL                    
   SELECT DISTINCT                    
    CLTCODE                    
   FROM #RECPAY_TABLE                    
   WHERE UPDFLAG = 'N'                    
   DROP TABLE #RECPAY_TABLE                    
                       
   RETURN                    
  END                    
                    
 --DECLARE                    
  --@@NEWVNO AS VARCHAR(12),                    
 -- @@VDT AS VARCHAR(11),                    
  --@@LNOCUR AS CURSOR,                    
  --@@LNOVNO AS INT,             
  --@@NOREC AS INT                    
                    
 CREATE TABLE #VNO  
 (  
 LASTVNO VARCHAR(12)  
 )  
     
/* '--------------------------AUTO GENERATION OF VNO (FULL LOGIC)------------------------*/                    
 DECLARE                    
  @@MAXVNO AS VARCHAR(12),                    
  @@VNO AS VARCHAR(12),                    
  @@RCOUNT AS INT         
 SELECT TOP 1                    
  @@VDT = CONVERT(VARCHAR(11), VDT, 109)                    
 FROM                    
  #RECPAY_TABLE                    
                    
 SELECT TOP 1                    
  @@VNOMETHOD = VNOFLAG,                    
  @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109),                    
  @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109)                    
 FROM                    
  PARAMETER                    
 WHERE               
  @@VDT BETWEEN SDTCUR AND LDTCUR                    
                    
IF @LEDGERVNO = ''  
BEGIN  
                     
SELECT                    
  @@NOREC = COUNT(DISTINCT SRNO)                    
 FROM                    
  #RECPAY_TABLE                    
                    
     
      
 INSERT INTO #VNO      
 EXEC ACC_GENVNO_NEW @@VDT, @VTYP, @BOOKTYPE, @@STD_DATE, @@LST_DATE, @@NOREC      
      
 SELECT @@VNO = LASTVNO FROM #VNO      
          
           
 UPDATE                    
  #RECPAY_TABLE                    
 SET VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC,@@VNO) + SRNO - 1)        
END      
ELSE      
BEGIN        
 SELECT @@VNO = @LEDGERVNO        
      
 SELECT TOP 1                      
  @@VDT = CONVERT(VARCHAR(11), VDT, 109)                      
 FROM                      
  #RECPAY_TABLE                      
      
 UPDATE                      
 #RECPAY_TABLE                      
 SET VNO = LEDGER_VNO  
 FROM  MSAJAG.DBO.CMMARGIN_PENALTY_POST_STAT_DETAIL  
WHERE MARGIN_DATE = @TRADEDATE  
AND PARTY_CODE = CLTCODE   
UPDATE #RECPAY_TABLE SET VNO = L.VNO  
FROM (SELECT SRNO, VNO FROM #RECPAY_TABLE   
   WHERE CLTCODE IN (SELECT CLTCODE FROM ACMAST WHERE ACCAT = 4)  
   AND ISNULL(VNO,'') <> ''  
   GROUP BY SRNO, VNO) L  
WHERE #RECPAY_TABLE.SRNO = L.SRNO   
create table #recno  
(  
 sno int identity(1,1),  
 CLTCODE varchar(10),  
 vno  varchar(12)  
)  
insert into #recno  
SELECT CLTCODE, vno FROM #RECPAY_TABLE  
WHERE CLTCODE IN (SELECT CLTCODE FROM ACMAST WHERE ACCAT = 4)
and isnull(vno,'') = ''  
SELECT                
  @@NOREC = COUNT(DISTINCT SNO)                
 FROM                
  #recno  
 INSERT INTO #VNO  
 EXEC ACC_GENVNO_NEW @@VDT, @VTYP, @BOOKTYPE, @@STD_DATE, @@LST_DATE, @@NOREC  
  
 SELECT @@VNO = LASTVNO FROM #VNO  
UPDATE                
  #recno                
 SET VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC,@@VNO) + SNO - 1)  
update #RECPAY_TABLE set vno = l.vno   
from #recno l  
where l.CLTCODE = #RECPAY_TABLE.cltcode  
  
UPDATE #RECPAY_TABLE SET VNO = L.VNO  
FROM (SELECT SRNO, VNO FROM #RECPAY_TABLE   
   WHERE CLTCODE IN (SELECT CLTCODE FROM ACMAST WHERE ACCAT = 4)  
   AND ISNULL(VNO,'') <> ''  
   GROUP BY SRNO, VNO) L  
WHERE #RECPAY_TABLE.SRNO = L.SRNO  
SELECT @@VNO = @LEDGERVNO    
END  
                        
                    
DELETE FROM MSAJAG.DBO.CMMARGIN_PENALTY_POST_STAT_DETAIL  
WHERE MARGIN_DATE = @TRADEDATE  
  
INSERT INTO MSAJAG.DBO.CMMARGIN_PENALTY_POST_STAT_DETAIL  
SELECT DISTINCT @TRADEDATE, 1, VNO, @LEDGERDATE, CLTCODE  
FROM #RECPAY_TABLE  
WHERE CLTCODE IN (SELECT CLTCODE FROM ACMAST WHERE ACCAT = 4)  
/* '--------------------------AUTO GENERATION OF LNO ------------------------*/                    
                    
 SET @@LNOCUR = CURSOR FOR                    
  SELECT DISTINCT SRNO FROM #RECPAY_TABLE                    
 OPEN @@LNOCUR                    
  FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO                    
 WHILE @@FETCH_STATUS = 0                    
  BEGIN                    
   INSERT INTO #RECPAY_TABLE_LNO                    
    (SNO)                    
   SELECT SNO FROM #RECPAY_TABLE WHERE SRNO = @@LNOVNO                    
   UPDATE RP                    
    SET LNO = RL.LNO                    
   FROM #RECPAY_TABLE RP, #RECPAY_TABLE_LNO RL                    
   WHERE RP.SNO = RL.SNO                    
   TRUNCATE TABLE #RECPAY_TABLE_LNO       
   FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO                    
  END                   
 CLOSE @@LNOCUR                    
 DEALLOCATE @@LNOCUR                    
 DROP TABLE #RECPAY_TABLE_LNO                    

--select * from #RECPAY_TABLE                    
/* '--------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------*/                    
/*==============================          LEDGER RECORD                    
==============================*/                    
 INSERT                    
 INTO LEDGER                    
 SELECT            
  VTYP = @VTYP,                    
  VNO,                    
  EDT,                    
  LNO,                    
  ACNAME,                    
  DRCR,                    
  VAMT = AMOUNT,                    
  VDT,                    
  VNO1 = VNO,                    
  REFNO = 0,                    
  --BALAMT = AMOUNT,
  BALAMT = isnull(AMOUNT,0),                
  NODAYS = 0,                    
  CDT = GETDATE(),         
  CLTCODE,                    
  BOOKTYPE = @BOOKTYPE,                    
  ENTEREDBY = @UNAME,                    
  PDT = GETDATE(),                    
  CHECKEDBY = @UNAME,                    
  ACTNODAYS = 0,             
  NARRATION                    
 FROM                    
  #RECPAY_TABLE                    
                    
/*==============================                    
 LEDGER3 RECORD                    
==============================*/                    
 INSERT                    
 INTO LEDGER3                    
 SELECT                    
  NARATNO = LNO,                    
  NARRATION,                    
  REFNO = 0,                    
  VTYP = @VTYP,                    
  VNO,                    
  BOOKTYPE = @BOOKTYPE                    
  FROM        
  #RECPAY_TABLE         
        
 DELETE FROM TEMPLEDGER2 WHERE SESSIONID = '9999999999'      
       
 INSERT INTO TEMPLEDGER2      
 SELECT      
  'BRANCH',      
  C.COSTNAME,      
  AMOUNT,      
  VTYP = @VTYP,      
  VNO,      
  LNO,      
  DRCR,      
  '0',     
  BOOKTYPE = @BOOKTYPE,      
  SESSIONID = '9999999999',      
  CLIENT_CODE = CLTCODE,      
  'A',      
  '0'      
 FROM      
  #RECPAY_TABLE RP,      
  COSTMAST C      
 WHERE      
  RP.COSTCODE = C.COSTCODE      
      
 DECLARE @@L2CUR AS CURSOR,      
  @@L2VNO AS VARCHAR(12)      
        
 SET @@L2CUR = CURSOR FOR      
 SELECT DISTINCT VNO FROM #RECPAY_TABLE ORDER BY VNO      
 OPEN @@L2CUR      
 FETCH NEXT FROM @@L2CUR INTO @@L2VNO      
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
  EXEC INSERTTOLEDGER2 '9999999999', @@L2VNO, '1', '1', '1', 'BROKER', 'BROKER'      
  FETCH NEXT FROM @@L2CUR INTO @@L2VNO      
 END      
 DELETE FROM TEMPLEDGER2 WHERE SESSIONID = '9999999999'      
       
 CLOSE @@L2CUR      
 DEALLOCATE @@L2CUR      
              
/*=========================  MARGIN SHORTAGE PENALTY PLUG IN ==========================*/              
UPDATE MSAJAG.DBO.CMMARGIN_PENALTY      
SET LEDGER_POST_FLAG = 1      
WHERE       
 MARGIN_DATE =  @TRADEDATE         
 AND LEDGER_POST_FLAG = 99      
       
UPDATE MSAJAG.DBO.CMMARGIN_PENALTY_POST_STAT      
SET POST_FLAG = 1,LEDGER_VNO=@@VNO, LEDGER_VDT = @@VDT      
WHERE       
 MARGIN_DATE =  @TRADEDATE         
/*============================== MARGIN SHORTAGE PENALTY PLUG IN  =====================*/                  
               
 DROP TABLE #RECPAY_TABLE       
   
exec  GST_SERVICE_TAX_SPLIT_TEST

GO
