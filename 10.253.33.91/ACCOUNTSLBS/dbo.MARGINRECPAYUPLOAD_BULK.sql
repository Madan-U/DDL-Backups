-- Object: PROCEDURE dbo.MARGINRECPAYUPLOAD_BULK
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC [dbo].[MARGINRECPAYUPLOAD_BULK]    
 @FNAME VARCHAR(100),                      
 @UNAME VARCHAR(25),                      
 @USERCAT SMALLINT                      

AS                      
/*                      
begin tran                      
SP_HELPTRIGGER LEDGER                      
LEDGER_TRG_BILL                      
LEDGER_TRG                      
Exec MARGINRECPAYUPLOAD_BULK 'E:\BackOffice\RecPayFiles\MARGINRecpay_TEST1.csv', 'JAYDEEP', 388                      
ROLLBACK
SELECT TOP 1 * FROM LEDGER3                      
SELECT TOP 1 * FROM LEDGER_TRG                      
ROLLBACK                      
*/                      
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
 @@SQL AS VARCHAR(2000)                      
                      
/*SELECT                      
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
 END      */                
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
              
BEGIN TRAN                      
CREATE TABLE #RECPAY_TABLE_TMP                      
(                      
 SERIAL_NO INT,                      
 EDATE VARCHAR(20),                      
 VOUCHER_DATE VARCHAR(20),                      
 CLIENT_CODE VARCHAR(50),  
 MARGIN_CODE VARCHAR(50),          
 AMOUNT MONEY,                      
 DRCR VARCHAR(1),                      
 NARRATION VARCHAR(234),                      
 BANK_CODE VARCHAR(10),                      
 BANK_NAME VARCHAR(100),                      
 REF_NO VARCHAR(15),                      
 BRANCHCODE VARCHAR(20),                      
 BRANCH_NAME VARCHAR(50),                      
 CHQ_MODE VARCHAR(1),             
 CHQ_DATE VARCHAR(20),                      
 CHQ_NAME VARCHAR(100),                      
 CL_MODE VARCHAR(1)                      
)                      
CREATE TABLE [#RECPAY_TABLE]                      
 (                      
  SERIAL_NO INT,                      
  EDATE VARCHAR(20),                      
  VOUCHER_DATE VARCHAR(20),                      
  CLIENT_CODE VARCHAR(50),   
  MARGIN_CODE VARCHAR(50),   
  AMOUNT MONEY,                      
  DRCR VARCHAR(1),                      
  NARRATION VARCHAR(234),                      
  BANK_CODE VARCHAR(10),                      
  BANK_NAME VARCHAR(100),                      
  REF_NO VARCHAR(15),                      
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
 ) ON [PRIMARY]                      
                      
SELECT @@SQL = "BULK INSERT #RECPAY_TABLE_TMP FROM '" + @FNAME + "' WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n',FIRSTROW = 2, KEEPNULLS) "                      
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
  MARGIN_CODE,                     
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
  CL_MODE                      
 )                      
SELECT                      
 SERIAL_NO,                      
 EDATE,                      
 VOUCHER_DATE,                      
 UPPER(LTRIM(RTRIM(CLIENT_CODE))),                      
 UPPER(LTRIM(RTRIM(MARGIN_CODE))),  
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
 CL_MODE                      
FROM                      
 #RECPAY_TABLE_TMP                      
                      
UPDATE                      
 #RECPAY_TABLE                      
SET                
 VDT = CONVERT(DATETIME, RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),                      
 DDDT = CONVERT(DATETIME, RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),                      
 EDT = CONVERT(DATETIME, RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2))                      
                
                
SELECT TOP 1                      
 @@VDT = CONVERT(VARCHAR(11), VDT, 109)                      
FROM                      
 #RECPAY_TABLE                      
                
                
SELECT                      
 @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109),                      
 @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109),                      
 @@BRANCHFLAG = BRANCHFLAG,                      
 @@VNOFLAG = VNOFLAG                      
FROM                      
 PARAMETER                      
WHERE                      
 @@VDT BETWEEN SDTCUR AND LDTCUR                   
                      
IF @@VNOFLAG <> 0                 
BEGIN                     
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
END                  
                      
                      
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
   (SELECT * FROM ACMAST WHERE ACCAT = 14) A, PARAMETER P, COSTMAST C, (SELECT * FROM ACMAST WHERE ACCAT = 2) B, (SELECT * FROM ACMAST WHERE ACCAT = 4) A1
  WHERE                      
   A.CLTCODE = MARGIN_CODE                      
   AND B.CLTCODE = BANK_CODE                      
   AND A1.CLTCODE = CLIENT_CODE
   AND P.CURYEAR = 1                      
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
   (SELECT * FROM ACMAST WHERE ACCAT = 14) A, PARAMETER P, COSTMAST C, (SELECT * FROM ACMAST WHERE ACCAT = 2) B, (SELECT * FROM ACMAST WHERE ACCAT = 4) A1
  WHERE                      
   A.CLTCODE = MARGIN_CODE              
   AND B.CLTCODE = BANK_CODE                      
   AND P.CURYEAR = 1                      
   AND A1.CLTCODE = CLIENT_CODE
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
   (SELECT * FROM ACMAST WHERE ACCAT = 14) A, PARAMETER P, COSTMAST C, (SELECT * FROM ACMAST WHERE ACCAT = 2) B, (SELECT * FROM ACMAST WHERE ACCAT = 4) A1
  WHERE                      
   A.CLTCODE = MARGIN_CODE                      
   AND B.CLTCODE = BANK_CODE                      
   AND P.CURYEAR = 1                      
   AND A1.CLTCODE = CLIENT_CODE
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
   (SELECT * FROM ACMAST WHERE ACCAT = 14) A, (SELECT * FROM ACMAST WHERE ACCAT = 2) B, (SELECT * FROM ACMAST WHERE ACCAT = 4) A1
  WHERE                      
   A.CLTCODE = MARGIN_CODE                      
   AND B.CLTCODE = BANK_CODE
   AND A1.CLTCODE = CLIENT_CODE                      
 END                      
                
                     
/* -------------- VALIDATION FOR MULTIPLE VOUCHER DATES-------------------------- */                      
                      
SELECT                
 SERIAL_NO, VOUCHER_DATE                
INTO #DUP_VDTS                
FROM                
 #RECPAY_TABLE                
GROUP BY SERIAL_NO, VOUCHER_DATE                
                
SELECT @@ERROR_COUNT = COUNT(SERIAL_NO) FROM #DUP_VDTS                
GROUP BY SERIAL_NO                
HAVING COUNT(1) > 1                
                
 IF @@ERROR_COUNT > 1                      
  BEGIN                      
   SELECT                      
    'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES IN SAME SERIAL NO', 'NA', 'NA'                      
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
                
                
SELECT                 
 @@ERROR_COUNT = COUNT(SERIAL_NO)                 
FROM                 
 #RECPAY_TABLE                
WHERE VDT NOT BETWEEN FYSTART AND FYEND                
            
 IF @@ERROR_COUNT > 0                
  BEGIN                      
   SELECT               
    'SOME OF THE VOUCHERS ARE NOT BETWEEN THE CURRENT FINANCIAL YEAR DATE RANGE.', 'NA', 'NA'       
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
                
SET @@ERROR_COUNT = 0                
/*--------------------------VALIDATION FOR DIFFERENT VDTs IN SAME VOUCHER ------------------------*/                      
/*                      
SELECT @@ERROR_COUNT = COUNT(VDT) FROM  #RECPAY_TABLE WHERE SERIAL_NO IN (SELECT DISTINCT SERIAL_NO FROM #RECPAY_TABLE)                      
GROUP BY SERIAL_NO, VDT HAVING COUNT(VDT) > 1                      
 IF @@ERROR_COUNT > 0                      
  BEGIN                      
   SELECT 'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES ', 'NA', 'NA'                      
   DROP TABLE #RecPay_Table_Tmp                      
   DROP TABLE #RecPay_Table                      
   ROLLBACK TRAN                      
   DELETE FROM V2_Uploaded_Files                      
   WHERE U_FILENAME = ' & FName & ' AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
   RETURN                      
  END*/                      
                      
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
 SELECT                      
   DISTINCT DRCR = (CASE WHEN SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 'D' ELSE 'C' END)          
 FROM                      
  #RECPAY_TABLE      
 GROUP BY SERIAL_NO      
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
     THEN 20                      
     ELSE 19                     
    END                      
    )                      
  FROM                      
   #RECPAY_TABLE           
          
  UPDATE R           
  SET VTYP =           
 CASE WHEN AMOUNT1 > 0 THEN 20 ELSE 19 END          
 FROM (SELECT AMOUNT1 = SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END), SERIAL_NO FROM #RECPAY_TABLE GROUP BY SERIAL_NO) R1, #RECPAY_TABLE R          
 WHERE R.SERIAL_NO = R1.SERIAL_NO          
                  
  /*UPDATE                      
   #RECPAY_TABLE                      
  SET VTYP =       
   (                      
   CASE                      
     WHEN SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) > 0                    
     THEN 3                      
     ELSE 2                      
    END                      
   )       */               
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
               
SELECT          
@@ERROR_COUNT = COUNT(1)          
FROM          
(          
 SELECT DISTINCT          
  DDNO  = RP.REF_NO          
 FROM          
  #RECPAY_TABLE RP,          
  LEDGER1 L1  WITH(NOLOCK)          
 WHERE          
  L1.DDNO = RP.REF_NO          
  AND L1.BNKNAME = RP.BANK_NAME          
  AND L1.DD = RP.CHQ_MODE          
  AND L1.DRCR = @@DRCR          
  AND L1.VTYP = @@VTYP          
  AND RP.REF_NO <> '0'          
  AND ISNUMERIC(RP.REF_NO) = 1          
) A          
             
                  
IF @@ERROR_COUNT > 0                      
 BEGIN                      
  SELECT                      
   'FILE CANNOT BE UPLOADED AS THE FOLLOWING CHEQUE NUMBER ALREADY EXISTS', 'NA','NA'                      
  UNION ALL                      
  SELECT DISTINCT                      
   RP.REF_NO, 'NA','NA'                      
  FROM                      
   #RECPAY_TABLE RP, LEDGER L,             
   LEDGER1 L1                      
    WITH(NOLOCK)                      
  WHERE                      
   L1.DDNO = RP.REF_NO                      
   AND L1.DD = RP.CHQ_MODE                      
   AND L1.DRCR = @@DRCR                      
   AND L1.VTYP = @@VTYP                      
   AND RP.CHQ_MODE <> 'N'             
   AND L.VTYP=@@VTYP            
   AND L.VNO=L1.VNO            
   AND L.BOOKTYPE=L1.BOOKTYPE            
   AND L.DRCR=@@DRCR             
   AND L.CLTCODE=RP.MARGIN_CODE            
                
                 
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
/*--------------------------FINAL VALIDATION BASED ON UPDFLAG ------------------------*/                      
SELECT                      
 @@ERROR_COUNT = COUNT(1)                      
FROM                      
 (                      
  SELECT DISTINCT                      
   CLIENT_CODE, MARGIN_CODE, BANK_CODE                      
  FROM                      
   #RECPAY_TABLE                      
  WHERE                      
   UPDFLAG = 'N'                      
 ) A                      
IF @@ERROR_COUNT > 0                      
 BEGIN                      
  SELECT                      
   'FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS/MARGIN/BANK DO NOT EXIST', 'NA','NA'                      
  UNION ALL                      
  SELECT DISTINCT                      
   CLIENT_CODE + '/' + MARGIN_CODE + '/' + BANK_CODE, 'NA', 'NA'                  
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
  /*    --------------------------AUTO GENERATION OF VNO ------------------------ */                      
  SET @@VNOCUR = CURSOR FOR                      
   SELECT DISTINCT                      
    BANK_CODE,                      
    BOOKTYPE                      
   FROM                      
    #RECPAY_TABLE WITH(NOLOCK)                      
  OPEN @@VNOCUR                      
  FETCH NEXT                      
   FROM                      
    @@VNOCUR                      
   INTO                      
    @@BANK_CODE,                      
    @@BOOKTYPE                      
  WHILE @@FETCH_STATUS = 0                      
   BEGIN                      
--------------------------VALIDATION WITH USERRIGHTS TABLE ------------------------                
    SELECT                      
     @@BACKDAYS = ISNULL(MAX(NODAYS), 0)                      
    FROM                      
     USERWRITESTABLE                      
    WHERE                      
     USERCATEGORY = @USERCAT                      
     AND VTYP = @@VTYP                      
     AND BOOKTYPE = @@BOOKTYPE                      
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
      SELECT                      
       'SOME OF THE VOUCHERS ARE HAVING BACK DATED VOUCHER DATES FOR WHICH RIGHTS HAVE NOT BEEN SET', 'NA','NA'                      
      DROP TABLE #RECPAY_TABLE_TMP                      
      DROP TABLE #RECPAY_TABLE                      
      ROLLBACK TRAN                      
      DELETE FROM V2_UPLOADED_FILES                      
      WHERE                      
       U_FILENAME = @FNAME                      
       AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
      RETURN                      
     END     
                
    IF @@BRANCHFLAG = 1                      
     BEGIN                      
      SELECT                      
       @@BANKBRANCH = BRANCHCODE,                      
       @@BANKCOST = ISNULL(C.COSTCODE, -1)                      
      FROM                      
       ACMAST A                      
        LEFT OUTER JOIN                      
        COSTMAST C                      
        ON                      
         (                      
          A.BRANCHCODE = C.COSTNAME                      
         )                      
      WHERE                      
    A.CLTCODE = @@BANK_CODE                      
      IF @@BANKBRANCH <> 'ALL'                      
       BEGIN                    
        UPDATE                      
         RP                      
          SET COSTCODE = @@BANKCOST                      
        FROM                      
         #RECPAY_TABLE RP,                      
         ACMAST A                      
        WHERE                      
         A.CLTCODE = RP.CLIENT_CODE                      
         AND A.BRANCHCODE = 'ALL'                      
        UPDATE                      
         #RECPAY_TABLE                      
          SET BANKCOST = @@BANKCOST                      
        WHERE                      
         BANK_CODE = @@BANK_CODE                      
       END                      
      ELSE                      
       BEGIN                      
        UPDATE                      
         #RECPAY_TABLE                      
          SET COSTCODE =                      
           (                      
            SELECT TOP 1                      
             COSTCODE                      
            FROM                      
             COSTMAST                      
            WHERE                      
             COSTNAME = 'HO'                      
           )                      
        WHERE                      
         COSTCODE = ''                      
         AND BANK_CODE = @@BANK_CODE                      
                            SET @@COSTCODEUPDATES = CURSOR FOR                      
                                       SELECT                      
                                             SERIAL_NO, COUNT(DISTINCT COSTCODE)                      
                                       FROM                      
                                             #RECPAY_TABLE WITH(NOLOCK)                      
                                       WHERE                      
          BANK_CODE = @@BANK_CODE                      
  GROUP BY                      
                                             SERIAL_NO                      
                                       HAVING COUNT(DISTINCT COSTCODE)  > 1                      
                            OPEN @@COSTCODEUPDATES                      
                            FETCH NEXT                      
 FROM                      
                              @@COSTCODEUPDATES                      
                             INTO                      
              @@SERIAL_NO,                      
                              @@COSTCODECOUNT                      
   WHILE @@FETCH_STATUS = 0                      
                             BEGIN                      
          UPDATE                      
           #RECPAY_TABLE                      
            SET BANKCOST =                      
             (                      
              SELECT TOP 1                      
               COSTCODE                      
              FROM                      
               COSTMAST                      
              WHERE                      
               COSTNAME = 'HO'                      
             )                      
          WHERE                      
           (BANKCOST = ''   OR BANKCOST IS NULL)                      
           AND BANK_CODE = @@BANK_CODE                      
                                           AND SERIAL_NO = @@SERIAL_NO                      
                              FETCH NEXT                      
                               FROM                      
                     @@COSTCODEUPDATES                      
                               INTO                      
                                @@SERIAL_NO,                      
                                @@COSTCODECOUNT                      
                             END                      
                            CLOSE @@COSTCODEUPDATES                      
                            DEALLOCATE @@COSTCODEUPDATES                      
                  UPDATE                      
                   #RECPAY_TABLE                      
                    SET BANKCOST = COSTCODE                      
            WHERE                      
                   BANK_CODE = @@BANK_CODE                      
  AND (BANKCOST = ''   OR BANKCOST IS NULL)                      
       END                      
     END                      
    CREATE TABLE                      
     #BANK_VNO                      
     (                      
      SRNO INT,                      
      NEWSRNO INT IDENTITY (1, 1)                      
     )                      
    INSERT INTO                      
     #BANK_VNO                      
    SELECT                      
     DISTINCT SERIAL_NO                      
    FROM                      
     #RECPAY_TABLE                      
    WHERE                      
     BANK_CODE = @@BANK_CODE                      
     AND BOOKTYPE = @@BOOKTYPE                      
                      
   SELECT                      
     @@MAXCOUNT = COUNT(DISTINCT SNO)                      
    FROM                      
     #RECPAY_TABLE                      
                      
    SELECT TOP 1            
     @@VDT = VDT                      
    FROM                      
     #RECPAY_TABLE                      
    SELECT                      
     LASTVNO                      
    INTO #VNO                      
    FROM                      
     LASTVNO                      
    WHERE                      
     1 = 2                      
    SELECT @@MAXVNO = MAX(NEWSRNO) FROM #BANK_VNO                      
    INSERT                      
    INTO #VNO                      
     EXEC ACC_GENVNO_NEW                      
      @@VDT,                      
      @@VTYP,                      
      @@BOOKTYPE,                      
      @@STD_DATE,                      
      @@LST_DATE,                      
      @@MAXVNO                      
    SELECT                      
     @@NEWVNO = LASTVNO                      
    FROM                      
     #VNO                      
    UPDATE                      
     RP                      
      SET VNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC,@@NEWVNO) + (NEWSRNO - 1))                      
    FROM                      
     #RECPAY_TABLE RP,                      
     #BANK_VNO BV                      
    WHERE                      
     RP.SERIAL_NO = BV.SRNO                      
   DROP TABLE #VNO                      
   DROP TABLE #BANK_VNO                      
  FETCH NEXT                      
   FROM @@VNOCUR                      
   INTO                      
    @@BANK_CODE,                      
    @@BOOKTYPE                      
 END                      
/*   --------------------------AUTO GENERATION OF LNO ------------------------ */                      
UPDATE                      
 #RECPAY_TABLE                      
  SET LNO = 2                      
WHERE                      
 VNO IN                      
  (                      
   SELECT                      
    VNO                      
   FROM                      
 #RECPAY_TABLE                      
     WITH(NOLOCK)                      
   GROUP BY                      
    VNO                      
   HAVING                      
    COUNT(*) = 1                      
  )                      
SET @@LNOCUR = CURSOR FOR                      
 SELECT                      
  VNO                      
 FROM                      
  #RECPAY_TABLE                      
   WITH(NOLOCK)                      
 GROUP BY                      
  VNO                      
 HAVING                      
  COUNT(*) > 1                      
OPEN @@LNOCUR                      
FETCH NEXT                      
 FROM                      
  @@LNOCUR                      
 INTO                      
  @@LNOVNO                      
WHILE @@FETCH_STATUS = 0                      
 BEGIN                      
  CREATE TABLE                      
   [#LNOGEN]                      
    (                      
     VNO VARCHAR(12),                      
     SNO INT,                      
     LNO INT IDENTITY(1,1)                      
    )                      
  INSERT INTO                      
   #LNOGEN                      
    SELECT                      
     VNO,                      
     SNO                      
    FROM                      
     #RECPAY_TABLE                      
      WITH(NOLOCK)                      
    WHERE                      
     VNO = @@LNOVNO                      
    ORDER BY                      
     SNO                      
  UPDATE                      
   #RECPAY_TABLE                      
    SET LNO = L.LNO + 1                      
  FROM                      
   #LNOGEN L                      
  WHERE                      
   #RECPAY_TABLE.VNO = L.VNO                      
   AND #RECPAY_TABLE.SNO = L.SNO                      
   AND #RECPAY_TABLE.LNO = 0                      
  DROP TABLE #LNOGEN                      
  FETCH NEXT                      
   FROM                      
    @@LNOCUR                      
   INTO                      
    @@LNOVNO                      
 END                      
CLOSE @@LNOCUR                      
DEALLOCATE @@LNOCUR                      
/* --------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------ */                      
INSERT INTO                      
 LEDGER1                      
  (                      
   BNKNAME,                      
   BRNNAME,                      
   DD,                      
   DDNO,                      
   DDDT,                      
   RELDT,                      
   RELAMT,                      
   REFNO,                      
   RECEIPTNO,                      
   VTYP,                      
   VNO,                      
   LNO,                      
   DRCR,                      
   BOOKTYPE,                      
   MICRNO,                      
   SLIPNO,                      
   SLIPDATE,                      
   CHEQUEINNAME,                      
   CHQPRINTED,                      
   CLEAR_MODE                      
  )                      
SELECT                      
 BNKNAME = MAX(BANK_NAME),                      
 BRNNAME = MAX(BRANCH_NAME),                      
 DD = MAX(CHQ_MODE),                      
 DDNO = MAX(REF_NO),                      
 DDDT = MAX(DDDT),                      
 RELDT = '',                      
 RELAMT = ABS(SUM(CASE DRCR WHEN 'C' THEN AMOUNT ELSE -AMOUNT END)),                      
 REFNO = 0,                      
 RECEIPTNO = 0,                      
 VTYP,                      
 VNO,                      
 LNO = 2,                      
 @@DRCR,                    
 BOOKTYPE = BOOKTYPE,                      
 MICRNO = MICRNO,                      
 SLIPNO = 0,                      
 SLIPDATE = '',                      
 CHEQUEINNAME = MAX(ISNULL(CHQ_NAME,'')),                      
 CHQPRINTED = 0,                      
 CLEAR_MODE = MAX(CL_MODE)                      
FROM                      
 #RECPAY_TABLE                      
GROUP BY                      
 VTYP,                      
 VNO,                      
 BOOKTYPE,                    
 MICRNO                    
                      
IF @@ERROR <> 0                      
 BEGIN                      
  SELECT                      
   'DUE TO ERROR IN LEDGER1 POSTING, THE FILE COULD NOT BE UPLOADED.'                      
  DROP TABLE #RECPAY_TABLE_TMP                      
  DROP TABLE #RECPAY_TABLE                      
  ROLLBACK TRAN                      
  DELETE FROM V2_UPLOADED_FILES                      
  WHERE                      
   U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
  RETURN                      
 END                      
                      
/*================================                      
CREATING LEDGER AND LEDGER3 STRUCTURE TO INSERT IN BULK                      
=================================*/                      
CREATE TABLE #LEDGER                      
(                      
 VTYP SMALLINT,                      
 VNO VARCHAR(12),                      
 EDT DATETIME,                      
 LNO SMALLINT,                      
 ACNAME VARCHAR(100),                      
 DRCR VARCHAR(1),                      
 VAMT MONEY,                      
 VDT DATETIME,                      
 VNO1 VARCHAR(12),                      
 REFNO CHAR(12),                      
 BALAMT MONEY,                      
 NODAYS INT,                      
 CDT DATETIME,                      
 CLTCODE VARCHAR(10),                      
 BOOKTYPE VARCHAR(2),                      
 ENTEREDBY VARCHAR(25),                      
 PDT DATETIME,                      
 CHECKEDBY VARCHAR(25),                      
 ACTNODAYS INT,                      
 NARRATION VARCHAR(234)                      
)    --SELECT VTYP, VNO,  EDT, LNO, ACNAME, DRCR, VAMT, VDT, VNO1, REFNO, BALAMT, NODAYS, CDT, CLTCODE, BOOKTYPE, ENTEREDBY, PDT, CHECKEDBY, ACTNODAYS, NARRATION INTO #LEDGER FROM LEDGER WHERE 1 = 0                      
CREATE TABLE #LEDGER3                      
(                      
 NARATNO INT,                      
 NARR VARCHAR(234),                      
 REFNO CHAR(12),                      
 VTYP SMALLINT,                      
 VNO VARCHAR(12),                      
 BOOKTYPE VARCHAR(2)                      
)                      
--SELECT * INTO #LEDGER3 FROM LEDGER3 WHERE 1 = 0                      
/*==============================                      
CLIENT SIDE RECORD                      
==============================*/                      
INSERT INTO                      
 #LEDGER                      
 (                      
  VTYP,                      
  VNO,                    
  EDT,                      
  LNO,                      
  ACNAME,                      
  DRCR,                      
  VAMT,                      
  VDT,                      
  VNO1,                      
  REFNO,                      
  BALAMT,                      
  NODAYS,                      
  CDT,                      
  CLTCODE,                      
  BOOKTYPE,                      
  ENTEREDBY,                      
  PDT,                 
  CHECKEDBY,                      
  ACTNODAYS,                      
  NARRATION                      
 )                      
SELECT                      
 VTYP,                      
 VNO,                      
 EDT = EDT,  
 LNO,                      
 ACNAME,                      
 DRCR,                      
 VAMT = AMOUNT,                      
 VDT,                      
 VNO1 = VNO,                      
 REFNO = 0,                      
 BALAMT = AMOUNT,                      
 NODAYS = 0,                      
 CDT = GETDATE(),                      
 CLTCODE = MARGIN_CODE,                      
 BOOKTYPE = BOOKTYPE,                      
 ENTEREDBY = 'B_' + LEFT(@UNAME, 23),                      
 PDT = GETDATE(),                      
 CHECKEDBY = @UNAME,                      
 ACTNODAYS = 0,                      
 NARRATION                    
FROM                      
 #RECPAY_TABLE                      
/*==============================                      
BANK SIDE RECORD                      
==============================*/                      
INSERT INTO                      
 #LEDGER                      
SELECT  DISTINCT                    
 VTYP,                      
 VNO,                      
 EDT = edt, --(CASE WHEN VTYP = 2 THEN 'DEC 31 2049' ELSE EDT END),                      
 LNO = 1,                      
 BANKNAME,                      
 MAX(DRCR1),                      
 VAMT = ABS(MAX(AMOUNT1)),                      
 VDT,                      
 VNO1 = VNO,                      
 REFNO = 0,                      
 BALAMT = ABS(MAX(AMOUNT1)),                      
 NODAYS = 0,                      
 CDT = GETDATE(),                      
 CLTCODE = BANK_CODE,                      
 BOOKTYPE = BOOKTYPE,                      
 ENTEREDBY = 'B_' + LEFT(@UNAME, 23),                      
 PDT = GETDATE(),                      
 CHECKEDBY = @UNAME,                      
 ACTNODAYS = 0,                      
 NARRATION = NARRATION_FIN    
FROM      
 #RECPAY_TABLE R, (SELECT SERIAL_NO, AMOUNT1 = SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END), DRCR1 = CASE WHEN SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 'C' ELSE 'D' END, NARRATION_FIN = MAX(NARRATION) FROM #RECPAY_TABLE GROUP
  
 BY SERIAL_NO) R1          
WHERE R.SERIAL_NO = R1.SERIAL_NO                  
GROUP BY                      
 VTYP,                      
 VNO,                      
 EDT,                      
 VDT,                      
 BANK_CODE,                      
 BOOKTYPE,                      
 BANKNAME,           
 LNO,    
 NARRATION_FIN                      
/*==============================                      
INSERTING ALL LEDGER RECORDS AT ONE TIME                      
==============================*/                      
                
INSERT INTO LEDGER  SELECT                      
 Vtyp,Vno,Edt,Lno,Acname,Drcr,Vamt,Vdt,Vno1,Refno,Balamt,Nodays,Cdt,Cltcode,Booktype,Enteredby,Pdt,Checkedby,Actnodays,Narration                      
FROM                      
 #LEDGER                      
ORDER BY                      
 BOOKTYPE,                      
 VTYP,                      
 VNO,                      
 LNO     
  
INSERT INTO MARGINLEDGER    
 SELECT                        
  VTYP,                        
  VNO,                        
  LNO,                        
  DRCR,          
  VDT,       
  AMOUNT,                        
  CLIENT_CODE,                        
  'NSE',    
  'CAPITAL',    
  0,    
  '',               
  BOOKTYPE = BOOKTYPE,                        
  MCLTCODE = MARGIN_CODE    
 FROM                        
  #RECPAY_TABLE                     
                      
IF @@ERROR <> 0                      
 BEGIN                      
  SELECT                      
   'DUE TO ERROR IN LEDGER POSTING, THE FILE COULD NOT BE UPLOADED.'                      
  DROP TABLE #RECPAY_TABLE_TMP          
  DROP TABLE #RECPAY_TABLE                      
  DROP TABLE #LEDGER                      
  DROP TABLE #LEDGER3                      
  ROLLBACK TRAN                      
  DELETE FROM V2_UPLOADED_FILES                      
  WHERE                      
   U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
  RETURN                      
 END                      
DROP TABLE #LEDGER                      
/*==============================                      
BANK SIDE RECORD                      
==============================*/                      
INSERT INTO                      
 #LEDGER3                      
SELECT                      
 NARATNO = 1,                      
 NARRATION = MAX(NARRATION),                      
 REFNO = 0,                 
 VTYP,                      
 VNO,                      
 BOOKTYPE                      
FROM                      
 #RECPAY_TABLE                      
GROUP BY                      
 VTYP,                      
 VNO,                      
 BOOKTYPE                      
/*==============================                      
CLIENT SIDE RECORD                      
==============================*/                      
INSERT INTO                      
 #LEDGER3                      
SELECT                      
 NARATNO = LNO,                      
 NARR = NARRATION,                      
 REFNO = 0,                      
 VTYP,                      
 VNO,                      
 BOOKTYPE                      
FROM                      
 #RECPAY_TABLE                      
                      
                      
/*==============================                      
INSERTING ALL LEDGER3 RECORDS AT ONE TIME                      
==============================*/                      
INSERT INTO LEDGER3                      
SELECT                      
 *                      
FROM                      
 #LEDGER3                      
ORDER BY                      
 BOOKTYPE,                      
 VTYP,                      
 VNO,                      
 NARATNO                      
                      
IF @@ERROR <> 0                      
 BEGIN                      
  SELECT                      
   'DUE TO ERROR IN LEDGER3 POSTING, THE FILE COULD NOT BE UPLOADED.'                      
  DROP TABLE #RECPAY_TABLE_TMP                      
  DROP TABLE #RECPAY_TABLE                      
  DROP TABLE #LEDGER3                      
  ROLLBACK TRAN                      
  DELETE FROM V2_UPLOADED_FILES                      
  WHERE                      
   U_FILENAME = @FNAME                      
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'                      
  RETURN                      
 END                      
DROP TABLE #LEDGER3                      
              
                      
IF @@BRANCHFLAG = 1                      
 BEGIN                      
  SET @@L2CUR = CURSOR FOR                      
   SELECT DISTINCT                      
    VNO                      
   FROM                      
    #RECPAY_TABLE                      
   ORDER BY                      
    VNO                      
  OPEN @@L2CUR                      
   FETCH NEXT                      
   FROM                      
    @@L2CUR                      
   INTO                      
    @@L2VNO                      
  WHILE @@FETCH_STATUS = 0                      
   BEGIN                      
    DELETE FROM                      
     TEMPLEDGER2                      
    WHERE                      
     SESSIONID = '9999999999'                      
/*==============================                      
CLIENT SIDE RECORD                      
==============================*/                      
    INSERT INTO                      
     TEMPLEDGER2                      
    SELECT                      
     'BRANCH',                      
     C.COSTNAME,                      
    AMOUNT,                      
     VTYP,                      
     VNO,                      
     LNO,    
     DRCR,                      
     '0',                      
     BOOKTYPE,                      
     '9999999999',                      
     MARGIN_CODE,                      
     'A',                      
     '0'                      
    FROM                      
     #RECPAY_TABLE RP,                      
     COSTMAST C                      
    WHERE                      
     RP.COSTCODE = C.COSTCODE                      
     AND VNO = @@L2VNO                      
/*==============================                      
BANK SIDE RECORD                      
==============================*/                      
    INSERT INTO                      
     TEMPLEDGER2                      
    SELECT                      
     'BRANCH',                      
     C.COSTNAME,                      
     SUM(AMOUNT),                      
     VTYP,                      
     VNO,                      
     LNO = 1,                      
     DRCR =                      
      (                      
       CASE                      
       WHEN DRCR = 'D'                      
    THEN 'C'                      
       ELSE 'D'                      
       END                      
      ),                      
     '0',                      
     BOOKTYPE,                      
     '9999999999',                      
     BANK_CODE,                      
     'A',                      
     '0'                      
    FROM                      
     #RECPAY_TABLE RP,                      
     COSTMAST C                      
    WHERE                      
     RP.BANKCOST = C.COSTCODE                      
     AND VNO = @@L2VNO                      
    GROUP BY                      
     C.COSTNAME,                      
     VTYP,                  
     VNO,                      
      (                      
       CASE                      
       WHEN DRCR = 'D'                      
       THEN 'C'                      
       ELSE 'D'                      
       END                      
      ),                      
     BANK_CODE,                      
     BOOKTYPE                      
    EXEC INSERTTOLEDGER2                      
     '9999999999',                      
     @@L2VNO,                      
     '1',                      
     '1',                      
     '1',                      
     'BROKER',                      
     'BROKER'                      
    FETCH NEXT                      
     FROM                      
      @@L2CUR                      
     INTO                      
      @@L2VNO                      
   END                      
  DELETE FROM                      
   TEMPLEDGER2                      
  WHERE                      
   SESSIONID = '9999999999'                      
                        
 END             
COMMIT TRAN                   
SELECT 'CLTCODE, AMOUNT, VNO' Union ALL                      
SELECT CLIENT_CODE + ',' + LTRIM(RTRIM(CONVERT(VARCHAR, AMOUNT))) + ',' + VNO As RESULT FROM #RECPAY_TABLE                      
DROP TABLE #RECPAY_TABLE_TMP                      
DROP TABLE #RECPAY_TABLE

GO
