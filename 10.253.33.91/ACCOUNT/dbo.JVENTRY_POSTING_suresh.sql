-- Object: PROCEDURE dbo.JVENTRY_POSTING_suresh
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE   PROC [dbo].[JVENTRY_POSTING_suresh]                
 @FNAME VARCHAR(100),                  
 @UNAME VARCHAR(25),                  
 @VTYP SMALLINT,                  
 @BOOKTYPE VARCHAR(2),                  
 @USERCAT INT,    
 @REF_NO VARCHAR(50) = ''    
AS                  
    
SET XACT_ABORT ON    
-- EXEC JVENTRY_POSTING '', 'ANI', '8', '01', 1, 'INE022I010191201090000011183Dividend'    
/*           select * from ledger where vno = '200904150003' and vtyp = 6      
 DELETE FROM V2_UPLOADED_FILES WHERE U_FILENAME = 'D:\Backoffice\DrCrNotes\CR TAMMANA2.csv'                  
 EXEC DRCRNOTEUPLOAD_BULK 'e:\Backoffice\DrCrNotes\JV5_BRANCH.csv', 'TEST', 6, '01', 388                  
commit      
 EXEC DRCRNOTEUPLOAD_BULK 'd:\Backoffice\DrCrNotes\CR TAMMANA2.csv', 'TEST', 6, '01'                  
*/                  
 SET NOCOUNT ON                  
                  
 DECLARE                  
  @@ERROR_COUNT AS INT,                  
  @@SQL AS VARCHAR(2000),                  
  @@BACKDAYS INT,    
  @@BACKDATE DATETIME,        
  @@FUTUREDATE DATETIME,        
  @@BRANCHFLAG TINYINT        
        
IF @REF_NO <> ''    
BEGIN    
 IF (SELECT ISNULL(COUNT(1),0) FROM TBL_JV_LOG    
 WHERE PROESSDATE LIKE LEFT(GETDATE(),11) + '%'    
 AND REFNO = @REF_NO) > 0     
 BEGIN    
  RETURN    
 END    
END    
    
IF @REF_NO = ''    
BEGIN                  
/* '--------------------------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR ------------------------*/                  
 IF LTRIM(RTRIM(@FNAME)) = ''                  
  BEGIN                  
   SELECT RESULT = 'INVALID FILENAME SPECIFIED. PLEASE TRY AGAIN.'                  
   RETURN                  
  END                  
                  
 CREATE TABLE #FEXIST                  
  (F1 INT, F2 INT, F3 INT)                  
                   
 SELECT @@SQL = "INSERT INTO #FEXIST EXEC MASTER.DBO.XP_FILEEXIST  '" + @FNAME + "' "                  
 EXEC (@@SQL)                  
                  
 SELECT @@ERROR_COUNT = F1 FROM #FEXIST                  
 IF @@ERROR_COUNT = 0                  
  BEGIN                  
   SELECT RESULT = 'THE FILE SPECIFIED DOES NOT EXIST. PLEASE TYPE CORRECT FILENAME.'                  
   DROP TABLE #FEXIST                  
   RETURN                  
  END                  
                  
                  
 SELECT                   
  @@ERROR_COUNT = COUNT(1)                   
 FROM                  
  (SELECT                   
   U_FILENAME                   
  FROM                   
   V2_UPLOADED_FILES                  
  WHERE                   
   U_FILENAME = @FNAME                   
   AND U_MODULE = 'DRCR NOTE UPLOAD') A                  
                  
 IF @@ERROR_COUNT > 0                  
  BEGIN                  
   SELECT 'THE FILE YOU ARE UPLOADING IS ALREADY UPLOADED. PLEASE UPLOAD ANOTHER FILE.' + @FNAME                  
   ROLLBACK TRAN                  
   RETURN                  
  END       
END    
    
      
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
     
     
IF @REF_NO = ''    
BEGIN                          
                  
 SELECT @@SQL = "BULK INSERT #RECPAY_TABLE_TMP FROM '"+ @FNAME + "' WITH (FIELDTERMINATOR = ',', FIRSTROW = 2) "                  
 EXEC(@@SQL)    
END    
ELSE    
BEGIN    
   
  INSERT INTO #RECPAY_TABLE_TMP                  
  SELECT SRNO,                  
  CONVERT(VARCHAR(10), VVDT, 103),                  
  CONVERT(VARCHAR(10), EEDT, 103),                  
  CLTCODE,                  
  DRCR,                  
  AMOUNT,                  
  NARRATION,                  
  BRANCHCODE,                
  L1_SRNO=0    
 FROM TBL_AUTO_JV_UPLOAD  WHERE REFNO = @REF_NO AND POSTFLAG = 99   
--AND VVDT LIKE LEFT(GETDATE(),11) + '%'  
  AND VVDT LIKE  '%oct  3 2017%'
    
 CREATE TABLE #LNO  
 (  
 LNO INT IDENTITY(1,1),  
 CLTCODE VARCHAR(10),   
 SRNO NUMERIC(18,0)  
 )  
   
 INSERT INTO #LNO  
 SELECT CLTCODE, SRNO FROM #RECPAY_TABLE_TMP  
   
 UPDATE #RECPAY_TABLE_TMP SET L1_SRNO = LNO  
 FROM #LNO   
 WHERE #RECPAY_TABLE_TMP.SRNO = #LNO.SRNO  
 AND #RECPAY_TABLE_TMP.CLTCODE = #LNO.CLTCODE  
   
 DROP TABLE #LNO  
END     
        
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
   SELECT RESULT = 'CLIENT CODE SHOULD NOT DIFFERENCE WHETHER COST CENTER BREAK UP! '                   
   ROLLBACK TRAN               
   RETURN                
END                 
                
                
--NEW                
                
IF @REF_NO = ''    
BEGIN                                   
  INSERT INTO V2_UPLOADED_FILES                  
  SELECT                  
  @FNAME,                  
  @FNAME,                  
  COUNT(1),                  
  'B',                  
  GETDATE(),                  
  @UNAME,                  
  'DRCR NOTE UPLOAD'      
 END            
                  
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
        
SELECT @@BRANCHFLAG = BRANCHFLAG FROM PARAMETER, #RECPAY_TABLE WHERE       
CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)) BETWEEN SDTCUR AND LDTCUR      
                  
        
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
      AND CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)) BETWEEN SDTCUR AND LDTCUR                 
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
      AND CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)) BETWEEN SDTCUR AND LDTCUR         
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
      AND CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)) BETWEEN SDTCUR AND LDTCUR             
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
 AND CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)) BETWEEN SDTCUR AND LDTCUR             
      AND A.ACCAT IN ('3','4','104')                  
END       
    
 ---------------------------VALIDATION FOR INACTIVE CLIENTS FROM CLIENT5---------------------      
 /*  
 UPDATE       
  #RECPAY_TABLE       
  SET UPDFLAG = 'N'       
 FROM ( SELECT       
  PARTY_CODE,       
  INACTIVEFROM       
 FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK),       
  MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)       
 WHERE C2.CL_CODE = C5.CL_CODE       
  AND C2.PARTY_CODE IN (SELECT CLTCODE FROM #RECPAY_TABLE)       
  AND INACTIVEFROM <= GETDATE()) C       
 WHERE CLTCODE = C.PARTY_CODE      
*/                  
/* '--------------------------DECLARATION OF VARIABLES FOR VALIDATIONS ------------------------*/                  
                  
 DECLARE                 
  @@STD_DATE VARCHAR(11),                  
  @@LST_DATE VARCHAR(11),                  
  @@VNOMETHOD INT,                  
  @@ACNAME CHAR(100),                  
  @@MICRNO VARCHAR(10),                  
  @@DRCR VARCHAR(1)                  
                  
                  
/* '--------------------------VALIDATION FOR VOUCHER DATE NOT IN CURRENT FIN YEAR ------------------------*/                  
      
DECLARE                  
  @@NEWVNO AS VARCHAR(12),                  
  @@VDT AS VARCHAR(11),                  
  @@LNOCUR AS CURSOR,                  
  @@LNOVNO AS INT,                  
  @@NOREC AS INT                  
                  
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
  
 SELECT @@ERROR_COUNT = COUNT(1) FROM #RECPAY_TABLE WHERE VDT NOT BETWEEN @@STD_DATE AND @@LST_DATE                  
                  
 IF @@ERROR_COUNT > 0                  
  BEGIN                  
   SELECT 'DATE MISMATCH'                  
   DROP TABLE #RECPAY_TABLE_TMP                  
   DROP TABLE #RECPAY_TABLE                  
   ROLLBACK TRAN                  
   DELETE FROM V2_UPLOADED_FILES                  
    WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                  
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
   SELECT 'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES'                  
   DROP TABLE #RECPAY_TABLE_TMP                  
   DROP TABLE #RECPAY_TABLE                  
   ROLLBACK TRAN              
   DELETE FROM V2_UPLOADED_FILES                  
   WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                  
   RETURN                  
  END        
    
/*--------------------------VALIDATION FOR EDT SHOULD NOT BE LESS THAN VDT ------------------------*/                  
                  
 SELECT @@ERROR_COUNT = COUNT(DISTINCT VDT) FROM  #RECPAY_TABLE WHERE EDT < VDT    
 IF @@ERROR_COUNT > 0                  
  BEGIN                  
   SELECT 'SOME OF THE VOUCHERS ARE HAVING EFFECTIVE DATE LESS THAN VOUCHER DATE'    
   DROP TABLE #RECPAY_TABLE_TMP                  
   DROP TABLE #RECPAY_TABLE                  
   ROLLBACK TRAN              
   DELETE FROM V2_UPLOADED_FILES                  
   WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                  
   RETURN                  
  END       
    
/*--------------------------VALIDATION FOR AMOUNT LESS THAN OT EQUAL TO 0 ------------------------*/                  
                  
 SELECT @@ERROR_COUNT = COUNT(1) FROM  #RECPAY_TABLE WHERE AMOUNT <= 0     
 IF @@ERROR_COUNT > 0                  
  BEGIN                  
   SELECT 'SOME OF THE ENTRIES HAVING AMOUNT LESS THAN OR EQUAL TO 0.'    
   DROP TABLE #RECPAY_TABLE_TMP                
   DROP TABLE #RECPAY_TABLE                  
   ROLLBACK TRAN              
   DELETE FROM V2_UPLOADED_FILES                  
   WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                  
   RETURN                  
  END         
    
/*--------------------------NARRATION SHOULD NOT BE BLANK ------------------------*/                  
                  
 SELECT @@ERROR_COUNT = COUNT(1) FROM  #RECPAY_TABLE WHERE ISNULL(NARRATION, '') = ''    
 IF @@ERROR_COUNT > 0                  
  BEGIN                  
   SELECT 'SOME OF THE ENTRIES HAVING BLANK NARRATION.'    
   DROP TABLE #RECPAY_TABLE_TMP                  
   DROP TABLE #RECPAY_TABLE                  
   ROLLBACK TRAN              
   DELETE FROM V2_UPLOADED_FILES                  
   WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                  
   RETURN                  
  END            
                  
/*--------------------------VALIDATION FOR DRCR MISMATCH IN SAME VOUCHER ------------------------*/                  
                  
 ----SELECT @@ERROR_COUNT = COUNT(1) FROM                  
 ---- (SELECT AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END)                  
 ---- FROM #RECPAY_TABLE                  
 ---- GROUP BY SRNO                  
 ---- HAVING SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) <> 0) A                  
 ----IF @@ERROR_COUNT > 0                  
 ---- BEGIN                  
 ----  SELECT 'DEBIT AND CREDIT TOTALS DO NOT MATCH IN SOME VOUCHERS.'                  
 ----  DROP TABLE #RECPAY_TABLE_TMP                  
 ----  DROP TABLE #RECPAY_TABLE                  
 ----  ROLLBACK TRAN                  
 ----  DELETE FROM V2_UPLOADED_FILES                  
 ----  WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                  
 ----  RETURN                  
 ---- END                  
                  
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
   DROP TABLE #RECPAY_TABLE_TMP                  
   DROP TABLE #RECPAY_TABLE                  
   ROLLBACK TRAN                  
   DELETE FROM V2_UPLOADED_FILES                  
    WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                
   RETURN                  
  END                  
                  
IF @REF_NO = ''    
BEGIN                  
--------------------------VALIDATION WITH USERRIGHTS TABLE ------------------------                      
    SELECT                            
   @@BACKDAYS = ISNULL(MAX(NODAYS), -1)                            
    FROM                            
     USERWRITESTABLE                            
    WHERE                            
     USERCATEGORY = @USERCAT                            
     AND VTYP = @VTYP                            
     AND BOOKTYPE = @BOOKTYPE     
                 
    IF @@BACKDAYS >= 0    
 BEGIN              
    SELECT                            
     @@BACKDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), GETDATE(), 109)) - @@BACKDAYS,                            
  @@FUTUREDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), GETDATE(), 109))    
    
    SELECT                            
     @@ERROR_COUNT = ISNULL(COUNT(VDT), 0)                            
    FROM                            
     #RECPAY_TABLE                            
    WHERE                            
     VDT < @@BACKDATE OR VDT > @@FUTUREDATE    
    
    IF @@ERROR_COUNT > 0                            
     BEGIN                            
      SELECT                            
       'SOME OF THE VOUCHERS ARE HAVING BACK DATED OR FUTURE DATED VOUCHER DATES FOR WHICH RIGHTS HAVE NOT BEEN SET', 'NA','NA'                            
      DROP TABLE #RECPAY_TABLE_TMP                            
      DROP TABLE #RECPAY_TABLE                            
      ROLLBACK TRAN                            
      DELETE FROM V2_UPLOADED_FILES                            
      WHERE                            
       U_FILENAME = @FNAME                            
       AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                            
      RETURN                            
     END    
 END    
 ELSE    
 BEGIN    
 SELECT                            
      'THE USER WHO IS TRYING TO UPLOAD THE FILE DOSENT HAVE PERMISSION', 'NA','NA'    
      DROP TABLE #RECPAY_TABLE_TMP                            
      DROP TABLE #RECPAY_TABLE                            
      ROLLBACK TRAN                            
      DELETE FROM V2_UPLOADED_FILES        
      WHERE                            
       U_FILENAME = @FNAME                            
       AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                            
      RETURN       
 END     
END         
    
/* -------------Reset SNO -----------------------------*/    
    
CREATE TABLE #SNO    
(    
 SRNO INT,    
 SNO INT IDENTITY(1,1)    
)    
    
INSERT INTO #SNO(SRNO)    
SELECT DISTINCT SRNO FROM #RECPAY_TABLE    
ORDER BY SRNO    
    
UPDATE R SET R.SRNO = S.SNO FROM #RECPAY_TABLE R, #SNO S    
WHERE R.SRNO = S.SRNO    
/* '--------------------------AUTO GENERATION OF VNO (FULL LOGIC)------------------------*/                  
                
 SELECT                  
  @@NOREC = COUNT(DISTINCT SRNO)                  
 FROM                  
  #RECPAY_TABLE         
        
 CREATE TABLE #VNO        
 (        
    LASTVNO VARCHAR(12)        
 )                 
        
 INSERT INTO #VNO         
 EXEC ACC_GENVNO_NEW @@VDT, @VTYP, @BOOKTYPE, @@STD_DATE, @@LST_DATE, @@NOREC        
        
 SELECT @@VNO = LASTVNO FROM #VNO        
                  
 UPDATE                  
  #RECPAY_TABLE                  
 SET VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC,@@VNO) + SRNO - 1)                  
                  
                  
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
                  
/* '--------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------*/                  
/*==============================                  
      LEDGER RECORD                  
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
  LNO,                  
  ACNAME,                  
  DRCR,                
  VDT,                  
  CLTCODE,                
  NARRATION                
                
                
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
    
--UPDATE  [192.168.100.245].ACCOUNT.DBO.TBL_AUTO_JV_UPLOAD SET POSTFLAG = 1 WHERE REFNO = @REF_NO AND POSTFLAG = 0     


UPDATE TBL_AUTO_JV_UPLOAD SET POSTFLAG = 1 WHERE REFNO = @REF_NO AND POSTFLAG = 0
 AND VVDT LIKE LEFT(GETDATE(),11) + '%'    
    
 INSERT INTO TBL_JV_LOG SELECT @REF_NO, PROCESSDATE=GETDATE()     
    
 COMMIT TRAN                  
                  
 SELECT RESULT = 'Data Uploaded Successfully'                  
 UNION ALL                  
 SELECT RESULT = CLTCODE + ', ' + CONVERT(VARCHAR, AMOUNT) + ', ' + VNO FROM #RECPAY_TABLE                  
 DROP TABLE #RECPAY_TABLE_TMP                  
 DROP TABLE #RECPAY_TABLE     
    
SET XACT_ABORT OFF

GO
