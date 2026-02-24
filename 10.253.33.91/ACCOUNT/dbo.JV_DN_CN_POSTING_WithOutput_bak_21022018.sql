-- Object: PROCEDURE dbo.JV_DN_CN_POSTING_WithOutput_bak_21022018
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROC [dbo].[JV_DN_CN_POSTING_WithOutput_bak_21022018]        
	@SESSIONID VARCHAR(20),
	@UNAME VARCHAR(20)        
AS          
        
 SET NOCOUNT ON          
          
 DECLARE          
  @@ERROR_COUNT AS INT,          
  @@SQL AS VARCHAR(2000),          
  @@BACKDAYS INT,          
  @@BACKDATE DATETIME,
  @@BRANCHFLAG TINYINT,
  @VTYP INT, 
  @BOOKTYPE VARCHAR(10)

       
   
BEGIN TRAN          
        
          
CREATE TABLE #RECPAY_TABLE_TMP          
(          
	SRNO INT,          
	VVDT VARCHAR(10),          
	EEDT VARCHAR(10),          
	CLTCODE VARCHAR(10),          
	DRCR VARCHAR(1),          
	AMOUNT MONEY,          
	NARRATION VARCHAR(500),          
	BRANCHCODE VARCHAR(10),        
	L1_SRNO VARCHAR(5)            
) 

SELECT TOP 1 @VTYP = VTYPE, @BOOKTYPE = BOOKTYPE FROM JV_CN_DN_DETAILS
WHERE SESSIONID = @SESSIONID      

INSERT INTO #RECPAY_TABLE_TMP
SELECT SRNO, VVDT, EEDT, CLTCODE, DRCR, AMOUNT, NARRATION, BRANCHCODE, L1_SRNO
FROM JV_CN_DN_DETAILS
WHERE SESSIONID = @SESSIONID  


DECLARE @ClientCode VARCHAR(12)
SELECT @ClientCode = cltcode
FROM JV_CN_DN_DETAILS
WHERE SESSIONID = @SESSIONID  
		AND L1_SRNO = 1

  
          
 CREATE TABLE [#RECPAY_TABLE]          
 (          
  SRNO INT,          
  VVDT VARCHAR(10),          
  EEDT VARCHAR(10),          
  CLTCODE VARCHAR(10),          
  DRCR VARCHAR(1),          
  AMOUNT MONEY,          
  NARRATION VARCHAR(500),          
  BRANCHCODE VARCHAR(10),          
  L1_SRNO VARCHAR(5),        
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
          
        
--NEW        
SELECT @@ERROR_COUNT = COUNT(1) FROM    
    
(        
        
SELECT R.SRNO, R.L1_SRNO, CLTCODE, R1_COUNT        
FROM         
#RECPAY_TABLE_TMP R,         
(SELECT SRNO, L1_SRNO, R1_COUNT = COUNT(1) FROM #RECPAY_TABLE_TMP GROUP BY SRNO, L1_SRNO HAVING COUNT(1) > 1) R1        
WHERE R.SRNO = R1.SRNO     
AND R.L1_SRNO = R1.L1_SRNO        
GROUP BY R.SRNO, R.L1_SRNO, CLTCODE, R1_COUNT        
HAVING COUNT(1) <> R1_COUNT        
) A        
        
    
IF  @@ERROR_COUNT > 0         
BEGIN    
   
   ROLLBACK TRAN    
   DELETE JV_CN_DN_DETAILS WHERE SESSIONID = @SESSIONID	       
   INSERT INTO GST_REVERSAL_OutputData(Result)    
   SELECT RESULT =@ClientCode +  ' : CLIENT CODE SHOULD NOT DIFFERENCE WHETHER COST CENTER BREAK UP! '           
   PRINT ' : CLIENT CODE SHOULD NOT DIFFERENCE WHETHER COST CENTER BREAK UP! '           
   RETURN        
END         
        
        
--NEW        
        
     
      
          
 INSERT INTO #RECPAY_TABLE          
  (SRNO,          
  VVDT,          
  EEDT,          
  CLTCODE,          
  DRCR,          
  AMOUNT,          
  NARRATION,          
  BRANCHCODE,        
  L1_SRNO)          
 SELECT          
  SRNO,          
  VVDT,          
  EEDT,          
  UPPER(CLTCODE),          
  DRCR,          
  AMOUNT,          
  LEFT(NARRATION, 234),          
  BRANCHCODE,        
  L1_SRNO          
 FROM #RECPAY_TABLE_TMP 

SELECT @@BRANCHFLAG = BRANCHFLAG FROM PARAMETER WHERE CURYEAR = 1
          

IF @@BRANCHFLAG = 1
BEGIN
 UPDATE          
  #RECPAY_TABLE          
  SET          
   VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),          
   EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),          
   FYSTART = P.SDTCUR,          
   FYEND = P.LDTCUR,          
   UPDFLAG = 'Y',          
   ACNAME = LONGNAME,          
   #RECPAY_TABLE.COSTCODE = C.COSTCODE          
      FROM ACMAST A, PARAMETER P, COSTMAST C          
      WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE          
      AND P.CURYEAR = 1          
      AND A.ACCAT IN ('3','4','104')          
      AND A.BRANCHCODE = C.COSTNAME          
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
   #RECPAY_TABLE.COSTCODE = C.COSTCODE          
FROM ACMAST A, PARAMETER P, COSTMAST C          
WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE          
      AND P.CURYEAR = 1          
      AND A.ACCAT IN ('3','4','104')  
        
      AND #RECPAY_TABLE.BRANCHCODE = C.COSTNAME          
      AND A.BRANCHCODE = 'ALL'          
      AND #RECPAY_TABLE.BRANCHCODE <> 'ALL'          
      AND #RECPAY_TABLE.COSTCODE IS NULL          
          
          
          
 UPDATE    
  #RECPAY_TABLE          
  SET          
   VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),          
   EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),          

   FYSTART = P.SDTCUR,          
   FYEND = P.LDTCUR,          
   UPDFLAG = 'Y',          
   ACNAME = LONGNAME,          
   #RECPAY_TABLE.COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')          
      FROM ACMAST A, PARAMETER P 
         
      WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE          
      AND P.CURYEAR = 1          
      AND A.ACCAT IN ('3','4','104')          
      AND A.BRANCHCODE = 'ALL'          
      AND #RECPAY_TABLE.BRANCHCODE = 'ALL'          
      AND #RECPAY_TABLE.COSTCODE IS NULL
END

IF @@BRANCHFLAG = 0
BEGIN
 UPDATE          
  #RECPAY_TABLE          
  SET          
   VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),          
   EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),          
   FYSTART = P.SDTCUR,          
   FYEND = P.LDTCUR,          
   UPDFLAG = 'Y',          
   ACNAME = LONGNAME,          
   #RECPAY_TABLE.COSTCODE = 0
 FROM ACMAST A, PARAMETER P
 WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE          
      AND P.CURYEAR = 1          
 AND A.ACCAT IN ('3','4','104')          
END
          
/* '--------------------------DECLARATION OF VARIABLES FOR VALIDATIONS ------------------------*/          
 
         
 DECLARE          
  @@STD_DATE VARCHAR(11),          
  @@LST_DATE VARCHAR(11),          
  @@VNOMETHOD INT,          
  @@ACNAME CHAR(100),          
  @@MICRNO VARCHAR(10),          
  @@DRCR VARCHAR(1)          
          
          
/* '---
-----------------------VALIDATION FOR VOUCHER DATE NOT IN CURRENT FIN YEAR ------------------------*/          
          
 SELECT @@ERROR_COUNT = COUNT(1) FROM #RECPAY_TABLE WHERE VDT NOT BETWEEN FYSTART AND FYEND          
          
 IF @@ERROR_COUNT > 0          
  BEGIN          
  
   DROP TABLE #RECPAY_TABLE_TMP          
   DROP TABLE #RECPAY_TABLE          
   ROLLBACK TRAN  
   INSERT INTO GST_REVERSAL_OutputData(Result)    
    SELECT @ClientCode +  ' : DATE MISMATCH'    
	PRINT      ' : DATE MISMATCH'    
   DELETE JV_CN_DN_DETAILS WHERE SESSIONID = @SESSIONID           
   RETURN          
  END          
          
/* '--------------------------UPDATE OF COST CODE ------------------------*/          
IF @@BRANCHFLAG = 1
BEGIN
 UPDATE #RECPAY_TABLE          
  SET COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')          
 WHERE COSTCODE IS NULL          
END
          
/*--------------------------VALIDATION FOR DIFFERENT VDTS IN SAME VOUCHER ------------------------*/          
          
 SELECT @@ERROR_COUNT = COUNT(DISTINCT VDT) FROM  #RECPAY_TABLE WHERE SRNO IN (SELECT DISTINCT SRNO FROM #RECPAY_TABLE)          
 GROUP BY SRNO HAVING COUNT(DISTINCT VDT) > 1          
 IF @@ERROR_COUNT > 0          
  BEGIN          
   
   DROP TABLE #RECPAY_TABLE_TMP          
   DROP TABLE #RECPAY_TABLE          
   ROLLBACK TRAN   
   INSERT INTO GST_REVERSAL_OutputData(Result)    
   SELECT @ClientCode +  ' : SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES'   
   PRINT ' : SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES'   
   DELETE JV_CN_DN_DETAILS WHERE SESSIONID = @SESSIONID 
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
	DROP TABLE #RECPAY_TABLE_TMP          
   DROP TABLE #RECPAY_TABLE          
   ROLLBACK TRAN          
   DELETE JV_CN_DN_DETAILS WHERE SESSIONID = @SESSIONID
   INSERT INTO GST_REVERSAL_OutputData(Result)    
    SELECT @ClientCode +  ' : DEBIT AND CREDIT TOTALS DO NOT MATCH IN SOME VOUCHERS.'  
	 PRINT ' : DEBIT AND CREDIT TOTALS DO NOT MATCH IN SOME VOUCHERS.'  
	--SELECT Result FROM GST_REVERSAL_OutputData
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
       
   
  
   
  
   --SELECT DISTINCT          
   -- CLTCODE          
   --FROM #RECPAY_TABLE          
   --WHERE UPDFLAG = 'N'          
   DROP TABLE #RECPAY_TABLE_TMP          
   DROP TABLE #RECPAY_TABLE  
   PRINT ' : FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS OR GLCODE DO NOT EXIST'    
   ROLLBACK TRAN      
    INSERT INTO GST_REVERSAL_OutputData(Result)     
    SELECT @ClientCode +  ' : FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS OR GLCODE DO NOT EXIST' 
  
  DELETE JV_CN_DN_DETAILS WHERE SESSIONID = @SESSIONID   
 
   RETURN          
  END          
          
          

          
          
          
 DECLARE          
  @@NEWVNO AS VARCHAR(12),          
  @@VDT AS VARCHAR(11),          
  @@LNOCUR AS CURSOR,          
  @@LNOVNO AS INT,          
  @@NOREC AS INT          
       
   
          
/* '--------------------------AUTO GENERATION OF VNO (FULL LOGIC)------------------------*/          
 DECLARE          
  @@MAXVNO AS VARCHAR(12),          
  @@VNO AS VARCHAR(12),          
  @@RCOUNT AS INT          
 
 SELECT TOP 1   @@VDT = CONVERT(VARCHAR(11), VDT, 109)          
 FROM #RECPAY_TABLE          
          
 SELECT TOP 1          
  @@VNOMETHOD = VNOFLAG,          
  @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109),          
  @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109)          
 FROM          
  PARAMETER          
 WHERE          
  @@VDT BETWEEN SDTCUR AND LDTCUR          
          
 SELECT          
  @@NOREC = COUNT(DISTINCT SRNO)          
 FROM #RECPAY_TABLE 

 CREATE TABLE #VNO

 (
	LASTVNO VARCHAR(12)
 )         

 INSERT INTO #VNO 
 EXEC ACC_GENVNO_NEW @@VDT, @VTYP, @BOOKTYPE, @@STD_DATE, @@LST_DATE, @@NOREC

 SELECT @@VNO = LASTVNO FROM #VNO
          
 UPDATE          
  #RECPAY_TABLE          
 SET VNO = CONVERT(VARCHAR(12),
 CONVERT(NUMERIC,@@VNO) + SRNO - 1)          
          
          
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
--return        
          
/* '--------------------------BEGIN POSTING TO TRANSACTION TABLES ----------------
--------*/          
/*==============================          
      LEDGER RECORD          
==============================*/          
          
 INSERT          
 INTO LEDGER          
 SELECT          
  VTYP = @VTYP,          
  VNO,          
  EDT,          
  L1_SRNO,          
  ACNAME,          
  DRCR,          
  VAMT = SUM(AMOUNT),          
  VDT,          
  VNO1 = VNO,          
  REFNO = 0,          
  BALAMT = SUM(AMOUNT),          
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
 GROUP BY        
  VNO,          
  EDT,          
  L1_SRNO,          
  ACNAME,          
  DRCR,        
  VDT,          
  CLTCODE,        
  NARRATION        
        
        
/*==============================          
 LEDGER3 RECORD          
===================
===========*/          
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
          
          
          
IF @@BRANCHFLAG = 1
BEGIN
 DELETE FROM TEMPLEDGER2          
  WHERE SESSIONID = '9999999999'          
 INSERT INTO TEMPLEDGER2          
 SELECT          
  'BRANCH',          
  C.COSTNAME,     
     
  AMOUNT,          
  VTYP = @VTYP,          
  VNO,          
  L1_SRNO,          
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
  DELETE FROM TEMPLEDGER2          
   WHERE SESSIONID = '9999999999'          
  CLOSE @@L2CUR          
  DEALLOCATE @@L2CUR
END          
 COMMIT TRAN          
  
 INSERT INTO #POSTING_DATA       
 SELECT CLTCODE, AMOUNT, VNO, @VTYP, @BOOKTYPE FROM #RECPAY_TABLE  
         
 DROP TABLE #RECPAY_TABLE_TMP  
 DROP TABLE #RECPAY_TABLE

GO
