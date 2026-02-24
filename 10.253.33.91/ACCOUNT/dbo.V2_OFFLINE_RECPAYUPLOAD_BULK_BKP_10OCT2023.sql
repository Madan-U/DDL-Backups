-- Object: PROCEDURE dbo.V2_OFFLINE_RECPAYUPLOAD_BULK_BKP_10OCT2023
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROC [dbo].[V2_OFFLINE_RECPAYUPLOAD_BULK_BKP_10OCT2023]                      
 @FNAME VARCHAR(100),                      
 @UNAME VARCHAR(25),                      
 @USERCAT SMALLINT,                  
 @EXCHANGE VARCHAR(3),                    
 @SEGMENT  VARCHAR(10),                    
 @STATUSID VARCHAR(15),                    
 @STATUSNAME VARCHAR(15)                      
                      
AS                      
/*                      
BEGIN DISTRIBUTED TRANSACTION --BEGIN TRAN                      
Exec V2_OFFLINE_RECPAYUPLOAD_BULK 'D:\BackOffice\RecPayFiles\Recpay.csv', 'DEMO', 120,'NSE', 'CAPITAL','broker','broker'                 
ROLLBACK                      
*/                      
set xact_abort on            
            
            
SET NOCOUNT ON                      
/*-------------------------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR ------------------------*/                      
DECLARE                      
 @@STD_DATE VARCHAR(11),                      
 @@LST_DATE VARCHAR(11),                      
 @@BRANCHFLAG AS TINYINT,                      
 @@VNOFLAG AS TINYINT,                      
 @@VNOMETHOD INT,                      
 @@ACNAME CHAR(100),                      
 @@BOOKTYPE CHAR(2),                      
 @@MICRNO VARCHAR(10),                      
 @@DRCR VARCHAR(1),                      
 @@VTYP SMALLINT,                      
 @@BANK_CODE VARCHAR(100),                      
 @@BACKDAYS INT,                      
 @@BACKDATE VARCHAR(11),                      
 @@BRNCOUNT   TINYINT,                      
 @@MonthlyVdt VARCHAR(11),                      
 @@SERIAL_NO INT,                      
 @@COSTCODECOUNT TINYINT,                      
 @@COSTCODEUPDATES CURSOR,                      
 @@NEWVNO AS VARCHAR(12),                      
 @@MAXCOUNT AS INT,                      
 @@VDT AS VARCHAR(11),                      
 @@BANKBRANCH AS VARCHAR(10),                      
 @@BANKCOST AS NUMERIC,                      
 @@LNOCUR AS CURSOR,                      
 @@VNOCUR AS CURSOR,                      
 @@LNOVNO AS VARCHAR(12),                      
 @@MAXVNO AS INT,                      
 @@L2CUR AS CURSOR,                      
 @@L2VNO AS VARCHAR(12),                      
 @@ERROR_COUNT AS INT,                      
 @@FILEEXISTS AS INT,                      
 @@SQL AS VARCHAR(2000),                  
 @@MyTempVno AS VARCHAR(12)                        
                      
SELECT                      
 @@ERROR_COUNT = COUNT(1)                      
FROM                      
 (                      
  SELECT                      
   U_FILENAME                      
  FROM                      
   V2_UPLOADED_FILES                      
  WHERE                      
   U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
 ) A                      
IF @@ERROR_COUNT > 0                      
 BEGIN                      
  SELECT                      
   'THE FILE YOU ARE UPLOADING IS ALREADY UPLOADED. PLEASE UPLOAD ANOTHER FILE.', @FNAME, 'NA'                      
  RETURN                      
 END                      
CREATE TABLE #FEXIST                      
(                      
 F1 SMALLINT,                      
 F2 SMALLINT,                      
 F3 SMALLINT                      
)                      
SELECT @@SQL = "INSERT INTO "                      
SELECT @@SQL = @@SQL + " #FEXIST "                      
SELECT @@SQL = @@SQL + " (F1, F2, F3) "                      
SELECT @@SQL = @@SQL + "EXEC MASTER.DBO.XP_FILEEXIST '" + @FNAME + "' "                      
                      
EXEC(@@SQL)                      
                      
SELECT                      
 @@FILEEXISTS = F1                      
FROM                      
 #FEXIST                      
                      
IF @@FILEEXISTS = 0                      
 BEGIN                      
  DROP TABLE #FEXIST                      
  SELECT                      
   'THE FILE YOU ARE UPLOADING DOES NOT EXIST. PLEASE VERIFY THE PATH AND FILENAME.'                      
  RETURN                      
 END                      
DROP TABLE #FEXIST                      
                      
BEGIN DISTRIBUTED TRANSACTION --BEGIN TRAN                 
CREATE TABLE #RECPAY_TABLE_TMP                      
(                      
 SERIAL_NO INT,                      
 EDATE VARCHAR(20),                      
 VOUCHER_DATE VARCHAR(20),                      
 CLIENT_CODE VARCHAR(50),                      
 AMOUNT MONEY,                      
 DRCR VARCHAR(1),                      
 NARRATION VARCHAR(234),                      
 BANK_CODE VARCHAR(10),                      
 BANK_NAME VARCHAR(100),                  
 REF_NO VARCHAR(30),                      
 BRANCHCODE VARCHAR(20),                      
 BRANCH_NAME VARCHAR(50),                      
 CHQ_MODE VARCHAR(1),                      
 CHQ_DATE VARCHAR(20),                      
 CHQ_NAME VARCHAR(100),                      
 CL_MODE VARCHAR(1),                          
 ACCOUNTNO VARCHAR(25)                  
)                   
                    
CREATE TABLE [#RECPAY_TABLE]                      
 (                      
  SERIAL_NO INT,                      
  EDATE VARCHAR(20),                      
  VOUCHER_DATE VARCHAR(20),                      
  CLIENT_CODE VARCHAR(50),                      
  AMOUNT MONEY,                      
  DRCR VARCHAR(1),                      
  NARRATION VARCHAR(234),                      
  BANK_CODE VARCHAR(10),                      
  BANK_NAME VARCHAR(100),                      
  REF_NO VARCHAR(30),                      
  BRANCHCODE VARCHAR(20),                      
  BRANCH_NAME VARCHAR(50),                      
  CHQ_MODE VARCHAR(1),                      
  CHQ_DATE VARCHAR(20),                      
  CHQ_NAME VARCHAR(100),                      
  CL_MODE VARCHAR(1),                      
  SNO INT IDENTITY (1, 1) NOT NULL ,                      
  VDT DATETIME NULL ,                      
  FYSTART DATETIME NULL ,                      
  FYEND DATETIME NULL ,                      
  UPDFLAG VARCHAR (1) NOT NULL DEFAULT('N'),                      
  EDT DATETIME NULL ,                      
  DDDT DATETIME NULL ,                      
  VNO VARCHAR (12) NULL ,                      
  VTYP SMALLINT NULL ,                      
  ACNAME VARCHAR (100) NULL ,                      
  COSTCODE SMALLINT NULL,                      
  BANKCOST SMALLINT NULL,                      
  LNO SMALLINT NOT NULL DEFAULT(0),                      
  BANKNAME VARCHAR(100) NULL,                    
  MICRNO INT NULL,                      
  BOOKTYPE VARCHAR(2) NULL,                   
  ACCOUNTNO VARCHAR(25),                
  TPFLAG INT                   
 ) ON [PRIMARY]                    
                  
SELECT @@SQL = "BULK INSERT #RECPAY_TABLE_TMP FROM '" + @FNAME + "' WITH (FIELDTERMINATOR = ',', FIRSTROW = 2, KEEPNULLS) "                      
EXEC (@@SQL)                      
                      
IF @@ERROR <> 0                      
 BEGIN                      
  DROP TABLE #RECPAY_TABLE_TMP                      
  DROP TABLE #RECPAY_TABLE                      
  ROLLBACK TRANSACTION                      
  SELECT 'DUE TO SOME ERROR IN BULK INSERT, THE FILE COULD NOT BE UPLOADED...'                      
  RETURN                      
 END                      
INSERT INTO                      
 V2_UPLOADED_FILES                      
SELECT                      
 @FNAME,                      
 @FNAME,                      
 CNT = COUNT(1),                      
 'B',                      
 GETDATE(),                      
 @UNAME,                      
 'RECEIPT/PAYMENT UPLOAD'                      
                      
INSERT INTO                      
 #RECPAY_TABLE                      
 (                      
  SERIAL_NO,                      
  EDATE,                      
  VOUCHER_DATE,                      
  CLIENT_CODE,                      
  AMOUNT,                      
  DRCR,                      
  NARRATION,                      
  BANK_CODE,                 
  BANK_NAME,                      
  REF_NO,                      
  BRANCHCODE,                      
  BRANCH_NAME,                      
  CHQ_MODE,                      
  CHQ_DATE,                      
  CHQ_NAME,                      
  CL_MODE,                  
  ACCOUNTNO,                
  TPFLAG                      
 )                      
SELECT                      
 SERIAL_NO,                      
 EDATE,                      
 VOUCHER_DATE,                      
 UPPER(LTRIM(RTRIM(CLIENT_CODE))),                      
 AMOUNT,                      
 UPPER(LTRIM(RTRIM(DRCR))),                      
 NARRATION,                      
 UPPER(LTRIM(RTRIM(BANK_CODE))),                      
 UPPER(LTRIM(RTRIM(BANK_NAME))),                      
 REF_NO,                      
 UPPER(LTRIM(RTRIM(BRANCHCODE))),                      
 UPPER(LTRIM(RTRIM(BRANCH_NAME))),                      
 UPPER(LTRIM(RTRIM(CHQ_MODE))),                      
 CHQ_DATE,                      
 CHQ_NAME,                      
 CL_MODE,                  
 ACCOUNTNO,                
 TPFLAG = 1                  
FROM                      
 #RECPAY_TABLE_TMP                      
                      
UPDATE                      
 #RECPAY_TABLE                      
SET                      
 VDT = CONVERT(DATETIME, RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),                      
 DDDT = CONVERT(DATETIME, RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),                      
 EDT = CONVERT(DATETIME, RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2))                      
                      
                     
SELECT                      
 @@ERROR_COUNT = COUNT(DISTINCT VDT)                      
FROM                      
 #RECPAY_TABLE                      
                      
IF @@ERROR_COUNT > 1                      
 BEGIN                      
  DROP TABLE #RECPAY_TABLE_TMP                      
  DROP TABLE #RECPAY_TABLE                      
  ROLLBACK TRANSACTION                      
  SELECT 'FILE CANNOT BE UPLOADED WITH MULTIPLE VDTs.'                      
  RETURN                      
 END                      
                      
SELECT TOP 1                      
 @@VDT = CONVERT(VARCHAR(11), VDT, 109)                      
FROM                      
 #RECPAY_TABLE                      
                      
SELECT                      
 @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109),                      
 @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109),                      
 @@BRANCHFLAG = BRANCHFLAG,             @@VNOFLAG = VNOFLAG                      
FROM                      
 PARAMETER                      
WHERE                      
 @@VDT BETWEEN SDTCUR AND LDTCUR                      
                  
DECLARE @@VDTNEW VARCHAR(11)
SELECT TOP 1 @@VDTNEW = CONVERT(VARCHAR(11),CONVERT(DATETIME, RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),109)  
FROM #RECPAY_TABLE

                      
IF @@BRANCHFLAG = 1                      
 BEGIN                     
  UPDATE                      
   #RECPAY_TABLE                      
  SET                      
   BRANCHCODE = A.BRANCHCODE,                      
   FYSTART = P.SDTCUR,                      
   FYEND = P.LDTCUR,                      
   UPDFLAG = 'Y',                      
   ACNAME = A.LONGNAME,                      
   COSTCODE = C.COSTCODE,                      
   BANKNAME = B.LONGNAME,                      
   BOOKTYPE = B.BOOKTYPE,                      
   MICRNO = ISNULL(B.MICRNO, 0)                      
  FROM                      
   ACMAST A, PARAMETER P, COSTMAST C, ACMAST B                      
  WHERE                      
   A.CLTCODE = CLIENT_CODE                      
   AND B.CLTCODE = BANK_CODE                      
-- AND P.CURYEAR = 1                      
   AND @@VDTNEW BETWEEN P.SDTCUR AND P.LDTCUR
   AND A.ACCAT IN ('3','4','18')                      
   AND B.ACCAT = '2'                      
   AND A.BRANCHCODE = COSTNAME                      
                        
  UPDATE                      
   #RECPAY_TABLE                      
  SET                      
   VDT = CONVERT(DATETIME, RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),                      
   DDDT = CONVERT(DATETIME, RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),                      
   EDT = CONVERT(DATETIME, RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),                      
   FYSTART = P.SDTCUR,                      
   FYEND = P.LDTCUR,                      
   UPDFLAG = 'Y',                      
   ACNAME = A.LONGNAME,                      
   COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = #RECPAY_TABLE.BRANCHCODE)  ,                      
   BANKNAME = B.LONGNAME,                      
   BOOKTYPE = B.BOOKTYPE,                      
   MICRNO = ISNULL(B.MICRNO, 0)                      
  FROM                      
   ACMAST A, PARAMETER P, COSTMAST C, ACMAST B                      
  WHERE                      
   A.CLTCODE = CLIENT_CODE                      
   AND B.CLTCODE = BANK_CODE                      
-- AND P.CURYEAR = 1                      
   AND @@VDTNEW BETWEEN P.SDTCUR AND P.LDTCUR
   AND A.ACCAT IN ('3','4','18')                      
   AND B.ACCAT = '2'                      
   AND A.BRANCHCODE = 'ALL'                      
   AND #RECPAY_TABLE.BRANCHCODE <> 'ALL'                      
                    
  UPDATE                      
   #RECPAY_TABLE                      
  SET                      
   BRANCHCODE = 'HO',                      
   VDT = CONVERT(DATETIME, RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),                      
   DDDT = CONVERT(DATETIME, RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),                      
   EDT = CONVERT(DATETIME, RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),                      
   FYSTART = P.SDTCUR,                      
   FYEND = P.LDTCUR,                      
   UPDFLAG = 'Y',                      
   ACNAME = A.LONGNAME,                    
   COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')  ,                      
   BANKNAME = B.LONGNAME,                      
   BOOKTYPE = B.BOOKTYPE,                      
   MICRNO = ISNULL(B.MICRNO, 0)                      
  FROM                      
   ACMAST A, PARAMETER P, COSTMAST C, ACMAST B                      
  WHERE                      
   A.CLTCODE = CLIENT_CODE                      
   AND B.CLTCODE = BANK_CODE                      
-- AND P.CURYEAR = 1                      
   AND @@VDTNEW BETWEEN P.SDTCUR AND P.LDTCUR
   AND A.ACCAT IN ('3','4','18')                      
   AND B.ACCAT = '2'                      
   AND A.BRANCHCODE = 'ALL'                      
   AND #RECPAY_TABLE.BRANCHCODE = 'ALL'                      
 END                      
ELSE                
 BEGIN                      
  UPDATE                      
   #RECPAY_TABLE                      
  SET                      
   FYSTART = @@STD_DATE,                      
   FYEND = @@LST_DATE + ' 23:59:59',                      
   UPDFLAG = 'Y',                      
   ACNAME = A.LONGNAME,                      
   BANKNAME = B.LONGNAME,                      
   BOOKTYPE = B.BOOKTYPE,                      
   MICRNO = ISNULL(B.MICRNO, 0)                      
  FROM                      
   ACMAST A, ACMAST B                      
  WHERE                      
   A.CLTCODE = CLIENT_CODE                      
   AND B.CLTCODE = BANK_CODE                      
   AND A.ACCAT IN ('3','4','18')                      
   AND B.ACCAT = '2'                      
 END 
 
  
 UPDATE R SET UPDFLAG = 'B'     
 FROM #RECPAY_TABLE R    
 WHERE BANK_CODE  IN (SELECT CLTCODE FROM ACMAST_DETAILS WHERE INACTIVE_FLAG = 'N')                      
                      
/* -------------- VALIDATION FOR MULTIPLE VOUCHER DATES-------------------------- */                      
                      
 SELECT                      
  @@ERROR_COUNT = COUNT(DISTINCT VDT)                      
 FROM                      
  #RECPAY_TABLE                      
 IF @@ERROR_COUNT > 1                      
  BEGIN                      
   SELECT                      
    'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES', 'NA', 'NA'                      
   DROP TABLE #RECPAY_TABLE_TMP                      
   DROP TABLE #RECPAY_TABLE                      
   ROLLBACK TRAN                      
   DELETE                      
   FROM                      
    V2_UPLOADED_FILES                      
   WHERE                      
    U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
   RETURN                      
  END                      
                  
                  
/*--------------------------VALIDATION FOR DIFFERENT SERIAL_NO IN SAME VOUCHER ------------------------*/                      
/*SELECT @@ERROR_COUNT = COUNT(SERIAL_NO) FROM  #RECPAY_TABLE                   
GROUP BY SERIAL_NO, VDT HAVING COUNT(SERIAL_NO) > 1                  
 IF @@ERROR_COUNT > 1                     
  BEGIN                      
   SELECT 'SOME OF THE VOUCHERS ARE HAVING SAME SERIAL_NO ', 'NA', 'NA'                      
   DROP TABLE #RecPay_Table_Tmp                      
   DROP TABLE #RecPay_Table                      
   ROLLBACK TRAN                      
   DELETE FROM V2_Uploaded_Files                      
   WHERE U_FILENAME = ' & FName & ' AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
   RETURN                      
  END        */          
                      
/*  --------------------------VALIDATION FOR MULTIPLE BANK CODES IN SINGLE VOUCHER------------------------ */                      
 SELECT                      
  @@ERROR_COUNT = COUNT(1)                      
 FROM                      
  (                      
   SELECT                      
    BANK_CNT = ISNULL(COUNT(DISTINCT BANK_CODE), 0),                      
    SERIAL_NO                      
   FROM                      
    #RECPAY_TABLE                      
   GROUP BY                    
    SERIAL_NO                      
   HAVING                      
    COUNT(DISTINCT BANK_CODE) > 1                      
  ) A                      
 IF @@ERROR_COUNT > 0                      
  BEGIN                      
   SELECT                      
    RESULT = 'MULTIPLE BANK CODES CAN NOT BE SPECIFIED IN ONE TRANSACTIONS. PLEASE REFER TO THE FOLLOWING ROWS.'                      
   UNION ALL                      
   SELECT                      
    RESULT = 'SR.NO.:' + LTRIM(RTRIM(CONVERT(VARCHAR, SERIAL_NO))) + ', BANK CODES:' + CONVERT(VARCHAR, ISNULL(COUNT(DISTINCT BANK_CODE), 0))                      
   FROM                      
    #RECPAY_TABLE                      
   GROUP BY                      
    SERIAL_NO                      
   HAVING                      
    COUNT(DISTINCT BANK_CODE) > 1                      
                      
   DROP TABLE #RECPAY_TABLE_TMP                      
   DROP TABLE #RECPAY_TABLE                      
   ROLLBACK TRAN                      
   DELETE                      
   FROM                      
    V2_UPLOADED_FILES                      
   WHERE                      
    U_FILENAME = @FNAME                      
    AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
   RETURN                      
 END                      
/*  --------------------------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR ------------------------ */                      
SELECT                      
 @@ERROR_COUNT = COUNT(1)                      
FROM                      
 (                      
 SELECT DISTINCT                      
  DRCR                      
 FROM                      
  #RECPAY_TABLE                      
 ) A                      
IF @@ERROR_COUNT > 1                      
 BEGIN                      
  SELECT                      
   'PLEASE ENSURE THAT THERE IS EITHER RECIEPT OR PAYMENT ENTRY. BOTH TYPES OF ENTRY ARE NOT ALLOWED IN THE SAME FILE.', 'NA', 'NA'                      
  DROP TABLE #RECPAY_TABLE_TMP                      
  DROP TABLE #RECPAY_TABLE                      
  ROLLBACK TRAN                      
  DELETE                      
  FROM                      
   V2_UPLOADED_FILES                      
  WHERE                      
   U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
  RETURN                      
 END                      
ELSE                      
 BEGIN                      
  SELECT TOP 1                      
   @@DRCR = DRCR,                      
   @@VTYP =                      
    (                      
    CASE                      
     WHEN DRCR = 'D'                      
     THEN 3                      
     ELSE 2                      
    END                      
    )                      
  FROM                      
   #RECPAY_TABLE                      
  UPDATE                      
   #RECPAY_TABLE                      
  SET VTYP =                      
   (                      
   CASE                      
     WHEN DRCR = 'D'                      
     THEN 3                      
     ELSE 2                      
    END                 
   )                      
 END                      
/*--------------------------VALIDATION FOR VOUCHER DATE GRATER THAN EFFECTIVE DATE ------------------------*/                      
 SELECT @@ERROR_COUNT = COUNT(1)                      
 FROM #RECPAY_TABLE                      
 WHERE VDT > EDT                      
            IF @@ERROR_COUNT > 0                      
             BEGIN                      
              SELECT 'VOUHER DATE CAN NOT BE GRATER THAT EFFECTIVE DATE.'                      
     DROP TABLE #RECPAY_TABLE_TMP                      
     DROP TABLE #RECPAY_TABLE                      
     ROLLBACK TRAN                      
     DELETE FROM                      
      V2_UPLOADED_FILES                      
     WHERE                      
      U_FILENAME = @FNAME                      
     AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
     RETURN                      
             END                      
            /*--------------------------VALIDATION FOR ZERO AMOUNT ------------------------*/                      
 SELECT @@ERROR_COUNT = COUNT(1)                      
 FROM #RECPAY_TABLE                      
 WHERE AMOUNT <= 0                      
 IF @@ERROR_COUNT > 0                      
  BEGIN                      
     SELECT 'VOUHER AMOUNT SHOULD BE ALWAY GRATER THAN 0'                      
     DROP TABLE #RECPAY_TABLE_TMP                      
     DROP TABLE #RECPAY_TABLE                      
     ROLLBACK TRAN                      
     DELETE FROM                      
      V2_UPLOADED_FILES                      
     WHERE                      
      U_FILENAME = @FNAME                      
     AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
     RETURN                      
  END        
            
--------------------------VALIDATION WITH USERRIGHTS TABLE ------------------------                            
   SELECT                                  
     @@BACKDAYS = ISNULL(MIN(NODAYS), 0)                                  
    FROM                                  
     USERWRITESTABLE            
    WHERE                                  
     USERCATEGORY = @USERCAT                                  
     AND VTYP = @@VTYP                                  
     AND BOOKTYPE = '01'            
                               
    SELECT                                  
     @@BACKDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), GETDATE(), 109)) - @@BACKDAYS                                  
    SELECT                                  
     @@ERROR_COUNT = ISNULL(COUNT(VDT), 0)                                  
    FROM                                  
     #RECPAY_TABLE                                  
    WHERE                                  
     VDT < @@BACKDATE    
                                 
    IF @@ERROR_COUNT > 0                                  
     BEGIN                                  
  SELECT 'FEW OF THE VOUCHRS ARE BACKDATED WHICH IS NOT ALLOWED.'                  
  DROP TABLE #RECPAY_TABLE_TMP            
  DROP TABLE #RECPAY_TABLE            
  ROLLBACK TRAN            
  IF @@VTYP = 2     
   BEGIN            
    DELETE FROM V2_UPLOADED_FILES            
     WHERE U_FILENAME = @FNAME AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'            
   END            
  ELSE            
   BEGIN            
    DELETE FROM V2_UPLOADED_FILES            
     WHERE U_FILENAME = @FNAME AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'            
   END            
  RETURN                          
     END               
        
/*--------VALIDATION OF FUTURE DATE WITH HARDCODE 2 DAYS -----*/  
        
 SELECT                
  @@ERROR_COUNT = COUNT(DISTINCT VDT)                
 FROM        
  #RECPAY_TABLE where vdt > getdate()+2     
  
IF @@ERROR_COUNT > 0                                  
   BEGIN                                  
  SELECT 'FEW OF THE VOUCHRS ARE FUTURE DATED WHICH IS NOT ALLOWED.'                  
  DROP TABLE #RECPAY_TABLE_TMP            
  DROP TABLE #RECPAY_TABLE            
  ROLLBACK TRAN            
  IF @@VTYP = 2            
   BEGIN            
    DELETE FROM V2_UPLOADED_FILES            
     WHERE U_FILENAME = @FNAME AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'            
   END            
  ELSE            
   BEGIN            
    DELETE FROM V2_UPLOADED_FILES            
     WHERE U_FILENAME = @FNAME AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'            
   END            
  RETURN                          
 END                 
           
/*------------ */          
  
             
/*   --------------------------VALIDATION FOR CHEQUE NUMBER ------------------------ */   
SELECT                          
 @@ERROR_COUNT = COUNT(1)                          
FROM                          
 (                          
   SELECT DISTINCT              
   DDNO  = RP.REF_NO             
  FROM              
   #RECPAY_TABLE RP,              
   LEDGER1 L1 WITH (NOLOCK),LEDGER L              
    WITH(NOLOCK)              
  WHERE              
   L1.DDNO = RP.REF_NO    
   AND L.VNO=L1.VNO
   AND L.VTYP=L1.VTYP
   AND L.BOOKTYPE=L1.BOOKTYPE  
   AND L.VDT>= CONVERT(VARCHAR(11),GETDATE()-45,120)    
    AND  L.CLTCODE=RP.CLIENT_CODE    
  -- AND L1.BNKNAME = RP.BANK_NAME            
   --AND L1.DD = RP.CHQ_MODE              
   AND L1.DRCR = @@DRCR              
   AND L1.VTYP = @@VTYP              
   AND RP.REF_NO <> '0'   
   
   UNION 

   SELECT DISTINCT              
   DDNO  = RP.REF_NO             
  FROM              
   #RECPAY_TABLE RP,              
   AngelBSECM.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES L1    WITH(NOLOCK)          
                  
  WHERE              
   L1.DDNO = RP.REF_NO    
   --AND L.VTYP=L1.VTYP
   ---AND L.BOOKTYPE=L1.BOOKTYPE  
   AND L1.vdate>= CONVERT(VARCHAR(11),GETDATE()-45,120)    
    AND  L1.CLTCODE=RP.CLIENT_CODE    
  -- AND L1.BNKNAME = RP.BANK_NAME            
   --AND L1.DD = RP.CHQ_MODE              
   --AND L1.DRCR = @@DRCR              
   --AND L1.VTYP = @@VTYP              
   AND RP.REF_NO <> '0'   
          
 ) A              
IF @@ERROR_COUNT > 0              
 BEGIN              
  SELECT              
   'FILE CANNOT BE UPLOADED AS THE FOLLOWING CHEQUE NUMBER ALREADY EXISTS', 'NA','NA'              
  UNION ALL              
  SELECT DISTINCT              
   RP.REF_NO, 'NA','NA'              
  FROM              
   #RECPAY_TABLE RP,              
    LEDGER1 L1 WITH (NOLOCK),LEDGER L              
    WITH(NOLOCK)              
  WHERE              
   L1.DDNO = RP.REF_NO    
   AND L.VNO=L1.VNO
   AND L.VTYP=L1.VTYP
   AND L.BOOKTYPE=L1.BOOKTYPE  
   AND L.VDT>= CONVERT(VARCHAR(11),GETDATE()-45,120)   
   AND  L.CLTCODE=RP.CLIENT_CODE    
  -- AND L1.BNKNAME = RP.BANK_NAME            
   --AND L1.DD = RP.CHQ_MODE              
   AND L1.DRCR = @@DRCR              
   AND L1.VTYP = @@VTYP                
   AND RP.CHQ_MODE <> 'N'  
   
   
   
    UNION 

   SELECT DISTINCT              
   DDNO  = RP.REF_NO , 'NA','NA'                    
  FROM              
   #RECPAY_TABLE RP,              
   AngelBSECM.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES L1    WITH(NOLOCK)          
                
  WHERE              
   L1.DDNO = RP.REF_NO    
   --AND L.VTYP=L1.VTYP
   ---AND L.BOOKTYPE=L1.BOOKTYPE  
   AND L1.Vdate>= CONVERT(VARCHAR(11),GETDATE()-45,120)    
    AND  L1.CLTCODE=RP.CLIENT_CODE    
  -- AND L1.BNKNAME = RP.BANK_NAME            
   --AND L1.DD = RP.CHQ_MODE              
   --AND L1.DRCR = @@DRCR              
   --AND L1.VTYP = @@VTYP   
   
                          
  DROP TABLE #RECPAY_TABLE_TMP                   
   DROP TABLE #RECPAY_TABLE                          
  ROLLBACK TRAN                          
  DELETE FROM                          
   V2_UPLOADED_FILES                          
  WHERE                          
   U_FILENAME = @FNAME                          
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                          
  RETURN                          
 END                 
                
/*   --------------------------VALIDATION FOR ACCOUNT NUMBER ------------------------ */                      
/*SELECT                      
 @@ERROR_COUNT = COUNT(1)                      
FROM                      
 (                      
  SELECT DISTINCT                      
   RP.ACCOUNTNO                    
  FROM                      
   #RECPAY_TABLE RP,                      
   MULTIBANKID M                      
    WITH(NOLOCK)                     
  WHERE                      
   M.ACCNO = RP.ACCOUNTNO                      
 ) A                      
IF @@ERROR_COUNT <= 0                      
 BEGIN                      
  SELECT                      
   'FILE CANNOT BE UPLOADED AS THE FOLLOWING ACCOUNT NUMBER DOEST NOT EXISTS', 'NA','NA'                      
  UNION ALL                      
  SELECT DISTINCT                      
   RP.ACCOUNTNO, 'NA','NA'                      
  FROM                      
   #RECPAY_TABLE RP,                      
   MULTIBANKID M                      
    WITH(NOLOCK)                      
  WHERE                      
   M.ACCNO <> RP.ACCOUNTNO                   
                      
  DROP TABLE #RECPAY_TABLE_TMP                     
  DROP TABLE #RECPAY_TABLE                      
  ROLLBACK TRAN                      
  DELETE FROM                      
   V2_UPLOADED_FILES                      
  WHERE                      
   U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
  RETURN                      
 END                      
*/    

/*--------------------------FINAL VALIDATION BASED ON BLOCKING ------------------------*/                            
SELECT                            
 @@ERROR_COUNT = COUNT(1)                            
FROM                            
 (                            
  SELECT DISTINCT                            
   BANK_CODE                            
  FROM                            
   #RECPAY_TABLE                            
  WHERE                            
   UPDFLAG = 'B'                            
 ) A                            
IF @@ERROR_COUNT > 0                            
 BEGIN                            
  SELECT                            
   'FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS ARE BLOCKED', 'NA','NA'                            
  UNION ALL                            
  SELECT DISTINCT                            
   BANK_CODE, 'NA','NA'                            
  FROM                            
   #RECPAY_TABLE                            
  WHERE                            
   UPDFLAG = 'B'                            
  DROP TABLE #RECPAY_TABLE_TMP                            
DROP TABLE #RECPAY_TABLE                            
  ROLLBACK TRAN                            
  DELETE FROM                            
   V2_UPLOADED_FILES                          WHERE                     
   U_FILENAME = @FNAME                            
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                            
  RETURN                            
 END                              
/*--------------------------FINAL VALIDATION BASED ON UPDFLAG ------------------------*/                      
SELECT                      
 @@ERROR_COUNT = COUNT(1)                      
FROM                      
 (                      
  SELECT DISTINCT                      
   CLIENT_CODE                      
  FROM                      
   #RECPAY_TABLE                      
  WHERE                      
   UPDFLAG = 'N'                      
 ) A                      
IF @@ERROR_COUNT > 0                      
 BEGIN                      
  SELECT                      
   'FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS DO NOT EXIST', 'NA','NA'                      
  UNION ALL                      
  SELECT DISTINCT                      
   CLIENT_CODE, 'NA','NA'                      
  FROM                      
   #RECPAY_TABLE                      
  WHERE                      
   UPDFLAG = 'N'                      
  DROP TABLE #RECPAY_TABLE_TMP                      
DROP TABLE #RECPAY_TABLE                      
  ROLLBACK TRAN                      
  DELETE FROM                      
   V2_UPLOADED_FILES                      
  WHERE               
   U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
  RETURN                      
 END                      
                 
 SET @@MyTempVno = CONVERT(VARCHAR,GETDATE(),12)+RIGHT(REPLACE(CONVERT(VARCHAR,GETDATE(),114),':',''),6)                     
                
                 
UPDATE                      
 R                
SET                 
TPFLAG = 0                
FROM                
 #RECPAY_TABLE R,                
 MULTIBANKID M                
WHERE                 
 R.CLIENT_CODE = M.CLTCODE                
 AND M.ACCNO = R.ACCOUNTNO                
                 
                
INSERT INTO AngelBSECM.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES                      
   (VOUCHERTYPE,                      
   BOOKTYPE,                      
   SNO,                      
   VDATE,                      
   EDATE,                      
   CLTCODE,                      
   CREDITAMT,                      
   DEBITAMT,                      
   NARRATION,                    
   OPPCODE,                    
   BANKNAME,                    
   DDNO,                    
   BRANCHCODE,                    
   BRANCHNAME,                    
   CHEQUEMODE,                    
   CHEQUEDATE,                    
   CHEQUENAME,                    
   CLEAR_MODE,                    
   EXCHANGE,                      
   SEGMENT,                      
   TPFLAG,                      
   ADDDT,                      
   ADDBY,                      
   STATUSID,                      
   STATUSNAME,                      
   ROWSTATE,                      
   APPROVALFLAG,                      
   APPROVALDATE,                      
   APPROVEDBY,                      
   VOUCHERNO,              
   UPLOADDT,                      
   CLIENTNAME,                
   TPACCOUNTNUMBER)                      
                     
 SELECT                       
  @@VTYP,'01',SERIAL_NO, VDT, EDT, CLIENT_CODE,                       
  CASE WHEN DRCR = 'C' THEN AMOUNT ELSE 0 END, CASE WHEN DRCR = 'D' THEN AMOUNT ELSE 0 END, NARRATION,                    
  BANK_CODE,BANK_NAME,REF_NO,BRANCHCODE,BRANCH_NAME,CHQ_MODE,DDDT,CHQ_NAME,CL_MODE,                         
  @EXCHANGE, @SEGMENT,TPFLAG,GETDATE(),@UNAME,@STATUSID,@STATUSNAME,0,0,                      
  GETDATE(),'',@@MyTempVno,GETDATE(),ACNAME,ACCOUNTNO                      
 FROM                       
  #RECPAY_TABLE                      
                    
COMMIT TRANSACTION                    
                      
SELECT 'CLTCODE, AMOUNT, REF_VNO' Union ALL                        
SELECT CLIENT_CODE + ',' + LTRIM(RTRIM(CONVERT(VARCHAR, AMOUNT))) + ',' + @@MyTempVno As RESULT FROM #RECPAY_TABLE                        
                    
DROP TABLE #RECPAY_TABLE_TMP                        
DROP TABLE #RECPAY_TABLE             
            
SET XACT_ABORT OFF

GO
