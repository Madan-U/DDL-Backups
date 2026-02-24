-- Object: PROCEDURE dbo.CMSPAYMENT_BULK_APR092015
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[CMSPAYMENT_BULK_APR092015]          
    
 @FNAME VARCHAR(100),          
 @UNAME VARCHAR(25),          
 @BANK_CODE VARCHAR(10),          
 @USERCAT SMALLINT          
          
AS          
/*          
 CMSPAYMENT_BULK 'D:\BACKOFFICE\CMSPAYMENT\TEST_SAMPLE.CSV', 'SAMPLE', '03036', 1          
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
 @@COUNTER AS INT,          
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
          
/*--------------------------VALIDATION BASED ON VALID BANK CODE ------------------------*/          
SELECT          
 @@ERROR_COUNT = ISNULL(COUNT(1), 0)          
FROM          
 ACMAST          
WHERE          
 CLTCODE = @BANK_CODE          
 AND ACCAT = 2          
          
IF @@ERROR_COUNT = 0          
 BEGIN          
  SELECT          
   'FILE CANNOT BE UPLOADED AS SUPPLIED BANK CODE DOES NOT EXIST AS BANK', 'NA','NA'          
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
          
IF LEFT(@FNAME, 25) <> 'D:\BackOffice\CMSPayment\'          
 BEGIN          
  SELECT 'THE FILE YOU ARE UPLOADING MUST BE LOCATED IN D:\BackOffice\CMSPayment OF DATA SERVER', 'NA', 'NA'          
  RETURN          
 END          
          
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
          
BEGIN TRAN          
          
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
          
          
CREATE TABLE #CMSFILE          
(          
 PRODUCT_CO VARCHAR(20),          
 DDNO VARCHAR(15),          
 DDDT VARCHAR(10),          
 BENEF_DESCRIPTION VARCHAR(100),          
 AMOUNT MONEY,          
 LOC_DESCRIPTION VARCHAR(50),          
 STATUS VARCHAR(20),          
 CLTCODE VARCHAR(10),          
 NARRATION VARCHAR(234)          
)          
CREATE TABLE #RECPAY_TABLE_TMP          
(          
 SERIAL_NO INT IDENTITY(1,1),          
 EDATE VARCHAR(20),          
 VOUCHER_DATE VARCHAR(20),          
 CLIENT_CODE VARCHAR(50),          
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
          
SELECT @@SQL = "BULK INSERT #CMSFILE FROM '" + @FNAME + "' WITH (FIELDTERMINATOR = ',', FIRSTROW = 2, KEEPNULLS) "          
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
  EDATE,          
  VOUCHER_DATE,          
  CLIENT_CODE,          
  AMOUNT,          
  DRCR,          
  NARRATION,          
  BANK_CODE,          
  REF_NO,          
  CHQ_MODE,          
  CHQ_DATE,          
  CL_MODE          
 )          
SELECT          
 DDDT,          
 DDDT,          
 UPPER(LTRIM(RTRIM(CLTCODE))),          
 AMOUNT,          
 DRCR = 'D',          
 NARRATION,          
 BANK_CODE = @BANK_CODE,          
 REF_NO = DDNO,          
 CHQ_MODE = 'C',          
 CHQ_DATE = DDDT,          
 CL_MODE = 'O'          
FROM          
 #CMSFILE          
          
UPDATE #RECPAY_TABLE SET SERIAL_NO = SNO          
          
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
   CHQ_NAME = A.LONGNAME,          
   COSTCODE = C.COSTCODE,          
   BANK_NAME = B.LONGNAME,          
   BANKNAME = B.LONGNAME,          
   BOOKTYPE = B.BOOKTYPE,          
   MICRNO = ISNULL(B.MICRNO, 0),          
   VTYP = 3          
  FROM          
   ACMAST A, PARAMETER P, COSTMAST C, ACMAST B          
  WHERE          
   A.CLTCODE = CLIENT_CODE          
   AND B.CLTCODE = BANK_CODE          
   AND P.CURYEAR = 1          
   AND A.ACCAT IN ('4', '3')          
   AND B.ACCAT = '2'          
   AND A.BRANCHCODE = COSTNAME          
            
  UPDATE          
   #RECPAY_TABLE          
  SET          
   BRANCHCODE = 'HO',          
   FYSTART = P.SDTCUR,          
   FYEND = P.LDTCUR,          
   UPDFLAG = 'Y',          
   ACNAME = A.LONGNAME,          
   CHQ_NAME = A.LONGNAME,          
   COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO'),          
   BANK_NAME = B.LONGNAME,          
   BANKNAME = B.LONGNAME,          
   BOOKTYPE = B.BOOKTYPE,          
   MICRNO = ISNULL(B.MICRNO, 0),          
   VTYP = 3          
  FROM          
   ACMAST A, PARAMETER P, COSTMAST C, ACMAST B          
  WHERE          
   A.CLTCODE = CLIENT_CODE          
   AND B.CLTCODE = BANK_CODE          
   AND P.CURYEAR = 1          
   AND A.ACCAT IN ('4', '3')          
   AND B.ACCAT = '2'          
   AND A.BRANCHCODE = 'ALL'          
          
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
   CHQ_NAME = A.LONGNAME,          
   COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')  ,          
   BANKNAME = B.LONGNAME,          
   BANK_NAME = B.LONGNAME,          
   BOOKTYPE = B.BOOKTYPE,          
   MICRNO = ISNULL(B.MICRNO, 0),          
   VTYP = 3          
  FROM          
   ACMAST A, PARAMETER P, COSTMAST C, ACMAST B          
  WHERE          
   A.CLTCODE = CLIENT_CODE          
   AND B.CLTCODE = BANK_CODE          
   AND P.CURYEAR = 1          
   AND A.ACCAT IN ('4', '3')          
   AND B.ACCAT = '2'          
   AND #RECPAY_TABLE.UPDFLAG = 'N'          
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
   CHQ_NAME = A.LONGNAME,          
   BANKNAME = B.LONGNAME,          
   BANK_NAME = B.LONGNAME,          
   BOOKTYPE = B.BOOKTYPE,          
   MICRNO = ISNULL(B.MICRNO, 0),          
   VTYP = 3          
  FROM          
   ACMAST A, ACMAST B          
  WHERE          
   A.CLTCODE = CLIENT_CODE          
   AND B.CLTCODE = BANK_CODE          
   AND A.ACCAT IN ('4', '3')          
   AND B.ACCAT = '2'          
 END          
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
 SELECT @@ERROR_COUNT = 0          
          
/* -------------- VALIDATION FOR DEFAULT FINANCIAL YEAR-------------------------- */          
          
 SELECT          
  @@ERROR_COUNT = COUNT(1)          
 FROM          
  #RECPAY_TABLE R, PARAMETER P          
 WHERE R.VDT NOT BETWEEN SDTCUR AND LDTCUR AND CURYEAR = 1          
          
 IF @@ERROR_COUNT > 1          
  BEGIN          
   SELECT          
    'SOME OF THE VOUCHERS ARE NOT FALLING IN DEFAULT FINANCIAL YEAR.', 'NA', 'NA'          
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
 SELECT @@ERROR_COUNT = 0          
          
/*   --------------------------VALIDATION FOR CHEQUE NUMBER ------------------------ */          
SELECT          
 @@ERROR_COUNT = COUNT(1)          
FROM          
 (          
  SELECT DISTINCT          
   DDNO  = RP.REF_NO          
  FROM          
   #RECPAY_TABLE RP,          
   LEDGER1 L1          
    WITH(NOLOCK)          
  WHERE          
   L1.DDNO = RP.REF_NO          
   AND L1.DD = RP.CHQ_MODE          
   AND L1.DRCR = @@DRCR          
   AND L1.VTYP = @@VTYP          
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
   LEDGER1 L1          
    WITH(NOLOCK)          
  WHERE          
   L1.DDNO = RP.REF_NO          
   AND L1.DD = RP.CHQ_MODE          
   AND L1.DRCR = @@DRCR          
   AND L1.VTYP = @@VTYP          
   AND RP.CHQ_MODE <> 'N'          
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
          
/*--------------------------VALIDATION BASED ON VDTs OUTSIDE FINANCIAL YEAR ------------------------*/          
SELECT          
 @@ERROR_COUNT = ISNULL(COUNT(1), 0)          
FROM          
 #RECPAY_TABLE          
WHERE          
 VDT NOT BETWEEN FYSTART AND FYEND          
          
IF @@ERROR_COUNT > 0          
 BEGIN          
  SELECT          
   'FILE CANNOT BE UPLOADED AS SOME OF THE DATES ARE NOT FALLING IN CURRENT FINANCIAL YEAR.', 'NA','NA'          
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
          
          
/*----------------VNO GENERATION--------------------------*/          
CREATE TABLE #VNO (VNO VARCHAR(12))          
SELECT @@BOOKTYPE = BOOKTYPE, @@VDT = CONVERT(VARCHAR(11), VDT, 109), @@COUNTER = COUNT(1) FROM #RECPAY_TABLE GROUP BY BOOKTYPE, CONVERT(VARCHAR(11), VDT, 109)          
INSERT INTO #VNO EXEC ACC_GENVNO_NEW @@VDT, 3, @@BOOKTYPE, @@STD_DATE, @@LST_DATE, @@COUNTER          
SELECT @@NEWVNO = VNO FROM #VNO          
UPDATE #RECPAY_TABLE SET VNO = CONVERT(VARCHAR(12), (CONVERT(NUMERIC, @@NEWVNO) + SERIAL_NO) - 1)          
DROP TABLE #VNO          
          
IF @@BRANCHFLAG = 1          
 BEGIN          
  UPDATE #RECPAY_TABLE          
  SET BANKCOST = C.COSTCODE          
  FROM ACMAST A, COSTMAST C          
  WHERE           
   #RECPAY_TABLE.BANK_CODE = A.CLTCODE          
   AND A.ACCAT = 2          
   AND A.BRANCHCODE = C.COSTNAME          
   AND A.BRANCHCODE <> 'ALL'          
          
  UPDATE #RECPAY_TABLE        
  SET BANKCOST = COSTCODE          
  FROM ACMAST A          
  WHERE           
   #RECPAY_TABLE.BANK_CODE = A.CLTCODE          
   AND A.ACCAT = 2          
   AND A.BRANCHCODE = 'ALL'          
 END          
          
          
          
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
 RELAMT = SUM(AMOUNT),          
 REFNO = 0,          
 RECEIPTNO = 0,          
 VTYP,          
 VNO,          
 LNO = 2,          
 DRCR,          
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
 DRCR,          
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
)          
CREATE TABLE #LEDGER3          
(          
 NARATNO INT,          
 NARR VARCHAR(234),          
 REFNO CHAR(12),          
 VTYP SMALLINT,          
 VNO VARCHAR(12),          
 BOOKTYPE VARCHAR(2)     
)              
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
 EDT,          
 LNO = 2,          
 ACNAME,          
 DRCR,          
 VAMT = AMOUNT,          
 VDT,          
 VNO1 = VNO,          
 REFNO = 0,          
 BALAMT = AMOUNT,          
 NODAYS = 0,          
 CDT = GETDATE(),          
 CLTCODE = CLIENT_CODE,          
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
SELECT          
 VTYP,          
 VNO,          
 EDT,          
 LNO = 1,          
 BANKNAME,          
 DRCR =          
  (          
   CASE          
    WHEN DRCR = 'D'          
    THEN 'C'          
    ELSE 'D'     
   END          
  ),          
 VAMT = SUM(AMOUNT),          
 VDT,          
 VNO1 = VNO,          
 REFNO = 0,          
 BALAMT = SUM(AMOUNT),          
 NODAYS = 0,          
 CDT = GETDATE(),          
 CLTCODE = BANK_CODE,          
 BOOKTYPE = BOOKTYPE,          
 ENTEREDBY = 'B_' + LEFT(@UNAME, 23),          
 PDT = GETDATE(),          
 CHECKEDBY = @UNAME,          
 ACTNODAYS = 0,          
 NARRATION = MAX(NARRATION)          
FROM          
 #RECPAY_TABLE          
GROUP BY          
 VTYP,          
 VNO,          
 EDT,          
 DRCR,          
 VDT,          
 BANK_CODE,          
 BOOKTYPE,          
 BANKNAME          
          
/*==============================          
INSERTING ALL LEDGER RECORDS AT ONE TIME          
==============================*/          
INSERT INTO LEDGER          
SELECT          
 *          
FROM          
 #LEDGER          
ORDER BY          
 BOOKTYPE,          
 VTYP,          
 VNO,          
 LNO          
          
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
 NARATNO = 2,          
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
  INSERT INTO LEDGER2          
   (VTYPE, VNO, LNO, DRCR, CAMT, COSTCODE, BOOKTYPE, CLTCODE)          
  SELECT          
   VTYPE = 3,          
   VNO,          
   LNO = 1,          
   DRCR = 'C',          
   CAMT = AMOUNT,          
   COSTCODE,          
   BOOKTYPE,          
   BANK_CODE          
  FROM          
   #RECPAY_TABLE          
  WHERE          
   COSTCODE = BANKCOST          
          
        
  INSERT INTO LEDGER2          
   (VTYPE, VNO, LNO, DRCR, CAMT, COSTCODE, BOOKTYPE, CLTCODE)          
  SELECT          
   VTYPE = 3,          
   VNO,          
   LNO = 2,          
   DRCR = 'D',          
   CAMT = AMOUNT,          
   COSTCODE,          
   BOOKTYPE,          
   CLIENT_CODE          
  FROM          
   #RECPAY_TABLE          
  WHERE          
   COSTCODE = BANKCOST          
          
          
          
  SET @@L2CUR = CURSOR FOR          
   SELECT DISTINCT VNO FROM #RECPAY_TABLE WHERE COSTCODE <> BANKCOST          
  OPEN @@L2CUR          
  FETCH NEXT FROM @@L2CUR INTO @@L2VNO          
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
     VTYP = 3,          
     VNO,          
     LNO = 2,          
     DRCR = 'D',          
     '0',          
     BOOKTYPE,          
     '9999999999',          
     CLIENT_CODE,          
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
     VTYP = 3,          
     VNO,          
     LNO = 1,          
     DRCR = 'C',          
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
     VNO,          
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
    FETCH NEXT FROM @@L2CUR INTO @@L2VNO          
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
