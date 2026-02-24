-- Object: PROCEDURE dbo.CASHUPLOAD_BULK
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE [dbo].[CASHUPLOAD_BULK]  
 @FNAME VARCHAR(100),            
 @UNAME VARCHAR(25),            
 @USERCAT INT    
AS  
--EXEC CASHUPLOAD_BULK 'E:\BACKOFFICE\CASHFILES\CASH_TEST.CSV', 'SYSTEM', 388  
  
  
SET NOCOUNT ON   
  
  
DECLARE    
 @@ERROR_COUNT INT,  
 @@SQL AS VARCHAR(2000)            
  
/*SELECT @@ERROR_COUNT = COUNT(1)  
FROM   (SELECT U_FILENAME  
        FROM   V2_UPLOADED_FILES  
        WHERE  U_FILENAME = @FNAME  
               AND U_MODULE = 'CASH UPLOAD') A  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'THE FILE YOU ARE UPLOADING IS ALREADY UPLOADED. PLEASE UPLOAD ANOTHER FILE.',  
           @FNAME,  
           'NA'  
      
    RETURN  
  END  
*/  
BEGIN TRAN  
  
CREATE TABLE #RECPAY_TABLE_TMP (  
  EDATE        VARCHAR(20),  
  VOUCHER_DATE VARCHAR(20),  
  CLIENT_CODE  VARCHAR(50),  
  CASHCODE VARCHAR(10),  
  AMOUNT       MONEY,  
  DRCR         VARCHAR(1),  
  NARRATION    VARCHAR(234),
  BRANCHCODE  VARCHAR(10),  
  SERIAL_NO    INT)  
  
CREATE TABLE [#RECPAY_TABLE] (  
  EDATE        VARCHAR(20),  
  VOUCHER_DATE VARCHAR(20),  
  CLIENT_CODE  VARCHAR(50),  
  CASHCODE VARCHAR(10),  
  AMOUNT       MONEY,  
  DRCR         VARCHAR(1),  
  NARRATION    VARCHAR(234),  
  SERIAL_NO    INT,  
  SNO          INT   IDENTITY ( 1,1 )   NOT NULL,  
  BRANCHCODE   VARCHAR(10)   NULL,  
  VDT          DATETIME   NULL,  
  FYSTART      DATETIME   NULL,  
  FYEND        DATETIME   NULL,  
  UPDFLAG      VARCHAR(1)   NOT NULL   DEFAULT ('N'),  
  EDT          DATETIME   NULL,  
  VNO          VARCHAR(12)   NULL,  
  VTYP         SMALLINT   NULL,  
  ACNAME       VARCHAR(100)   NULL,  
  COSTCODE     SMALLINT   NULL,  
  CASHBRANCH   VARCHAR(100)   NULL,  
  CASHCOST     SMALLINT   NULL,  
  LNO          SMALLINT   NOT NULL   DEFAULT (0),  
  CASHNAME VARCHAR(100),  
  BOOKTYPE VARCHAR(2))  
ON [PRIMARY]  
  
SELECT @@SQL = "BULK INSERT #RECPAY_TABLE_TMP FROM '"+ @FNAME + "' WITH (ROWTERMINATOR = '\n', FIELDTERMINATOR = ',', FIRSTROW = 2 )"  
EXEC(@@SQL)    
  
   
INSERT INTO V2_UPLOADED_FILES  
SELECT @FNAME,  
       @FNAME,  
       COUNT(1),  
       'B',  
       GETDATE(),  
       @UNAME,  
       'CASH UPLOAD'  
  
INSERT INTO #RECPAY_TABLE  
           (EDATE,  
            VOUCHER_DATE,  
            CLIENT_CODE,  
			CASHCODE,  
            AMOUNT,  
            DRCR,  
            NARRATION,  
            SERIAL_NO,  
   BRANCHCODE)  
SELECT EDATE,  
       VOUCHER_DATE,  
       UPPER(CLIENT_CODE),  
    UPPER(CASHCODE),  
       AMOUNT,  
       UPPER(DRCR),  
       NARRATION,  
       SERIAL_NO,  
       BRANCHCODE  
FROM   #RECPAY_TABLE_TMP  
  
UPDATE #RECPAY_TABLE  
SET    BRANCHCODE = A.BRANCHCODE,  
       VDT = CONVERT(DATETIME,RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),  
       EDT = CONVERT(DATETIME,RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),  
       FYSTART = P.SDTCUR,  
       FYEND = P.LDTCUR,  
       UPDFLAG = 'Y',  
       ACNAME = LONGNAME,  
       COSTCODE = C.COSTCODE  
FROM   ACMAST A,  
       PARAMETER P,  
       COSTMAST C  
WHERE  A.CLTCODE = CLIENT_CODE  
       AND P.CURYEAR = 1  
       AND ACCAT IN ('3','4')  
       AND A.BRANCHCODE = COSTNAME  
       AND A.BRANCHCODE <> 'ALL'  
  
UPDATE #RECPAY_TABLE  
SET    VDT = CONVERT(DATETIME,RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),  
       EDT = CONVERT(DATETIME,RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),  
       FYSTART = P.SDTCUR,  
       FYEND = P.LDTCUR,  
       UPDFLAG = 'Y',  
       ACNAME = LONGNAME,  
       COSTCODE = (SELECT TOP 1 COSTCODE  
                   FROM   COSTMAST  
                   WHERE  COSTNAME = #RECPAY_TABLE.BRANCHCODE)  
FROM   ACMAST A,  
       PARAMETER P  
WHERE  A.CLTCODE = CLIENT_CODE  
       AND P.CURYEAR = 1  
       AND ACCAT IN ('3','4')  
       AND A.BRANCHCODE = 'ALL'  
       AND #RECPAY_TABLE.BRANCHCODE <> 'ALL'  
  
UPDATE #RECPAY_TABLE  
SET    BRANCHCODE = 'HO',  
       VDT = CONVERT(DATETIME,RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),         EDT = CONVERT(DATETIME,RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),  
       FYSTART = P.SDTCUR,  
       FYEND = P.LDTCUR,  
       UPDFLAG = 'Y',  
       ACNAME = LONGNAME,  
       COSTCODE = (SELECT TOP 1 COSTCODE  
                   FROM   COSTMAST  
                   WHERE  COSTNAME = 'HO')  
FROM   ACMAST A,  
       PARAMETER P  
WHERE  A.CLTCODE = CLIENT_CODE  
       AND P.CURYEAR = 1  
       AND ACCAT IN ('3','4')  
       AND A.BRANCHCODE = 'ALL'  
       AND #RECPAY_TABLE.BRANCHCODE = 'ALL'   
  
/*--------------------------DECLARATION OF VARIABLES FOR VALIDATIONS ------------------------*/  
  
DECLARE  @@STD_DATE        VARCHAR(11),  
         @@LST_DATE        VARCHAR(11),  
         @@VNOMETHOD       INT,  
         @@ACNAME          CHAR(100),  
         @@BOOKTYPE        CHAR(2),  
         @@MICRNO          VARCHAR(10),  
         @@DRCR            VARCHAR(1),  
         @@CASHBRNCOUNT    TINYINT,  
         @@BACKDATE        DATETIME,  
         @@BACKDAYS        SMALLINT,  
         @@MonthlyVdt      VARCHAR(11),  
         @@VTYP            SMALLINT,  
         @@SERIAL_NO       INT,  
         @@COSTCODECOUNT   TINYINT,  
         @@COSTCODEUPDATES CURSOR,  
   @@VNOCUR AS CURSOR,  
   @@CASH_CODE VARCHAR(10)  
  
/*--------------------------VALIDATION FOR EXISTANCE AND TYPE OF CASH ACCOUNT ------------------------*/  
  
/*SELECT @@ERROR_COUNT = COUNT(1)  
FROM   ACMAST  
WHERE  CLTCODE = @CASHCODE  
       AND ACCAT = 1  
  
IF @@ERROR_COUNT = 0  
  BEGIN  
    SELECT 'INVALID CASH ACCOUNT SELECTED',  
           'NA',  
           ' NA'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END   
*/  
/*--------------------------GET BANK CODE DETAILS ------------------------*/  
  
UPDATE R SET CASHNAME = LONGNAME, R.BOOKTYPE = A.BOOKTYPE  
FROM   #RECPAY_TABLE R, ACMAST A  
WHERE  A.CLTCODE = R.CASHCODE  
       AND ACCAT = '1'   
  
/*------------------------- VALIDATION FOR CASH CODE MISSING ----------------------------------------*/  
SELECT @@ERROR_COUNT = COUNT(1)  
FROM   #RECPAY_TABLE WHERE CASHNAME IS NULL  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'INVALID CASH CODE IS SPECIFIED.',  
           'NA',  
     'NA',  
           ' NA'  
 UNION ALL  
 SELECT CASHCODE, 'NA', 'NA', 'NA'  
 FROM   #RECPAY_TABLE WHERE CASHNAME IS NULL  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END  
  
/*--------------------------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR ------------------------*/  
  
SELECT @@ERROR_COUNT = COUNT(1)  
FROM   (SELECT DISTINCT DRCR  
        FROM   #RECPAY_TABLE) A  
  
IF @@ERROR_COUNT > 1  
  BEGIN  
    SELECT 'PLEASE ENSURE THAT THERE IS EITHER RECIEPT OR PAYMENT ENTRY. BOTH TYPES OF ENTRY ARE NOT ALLOWED IN THE SAME FILE.',  
           'NA',  
     'NA',  
           ' NA'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END  
ELSE  
  BEGIN  
    SELECT TOP 1 @@DRCR = DRCR,  
                 @@VTYP = (CASE   
                             WHEN DRCR = 'D' THEN 4  
                             ELSE 1  
                           END)  
    FROM   #RECPAY_TABLE  
      
    UPDATE #RECPAY_TABLE  
    SET    VTYP = (CASE   
                     WHEN DRCR = 'D' THEN 4  
                     ELSE 1  
                   END)  
  END   
  
/* '--------------------------VALIDATION FOR VOUCHER DATE NOT IN CURRENT FIN YEAR ------------------------*/  
  
SELECT @@ERROR_COUNT = COUNT(1)  
FROM   #RECPAY_TABLE  
WHERE  (VDT NOT BETWEEN FYSTART AND FYEND  
   OR EDT NOT BETWEEN FYSTART AND FYEND)  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'Vouher Date Or Effective Date in some of the Vouchers is not falling in the default financial year.',  
           'NA',  
           'NA',  
           ' NA'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END   
  
/*--------------------------VALIDATION FOR VOUCHER DATE GRATER THAN EFFECTIVE DATE ------------------------*/  
  
SELECT @@ERROR_COUNT = COUNT(1)  
FROM   #RECPAY_TABLE  
WHERE  VDT > EDT  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'VOUHER DATE CAN NOT BE GRATER THAT EFFECTIVE DATE.',  
           'NA',  
           'NA',  
           ' NA'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END   
  
/*--------------------------VALIDATION FOR ZERO AMOUNT ------------------------*/  
  
SELECT @@ERROR_COUNT = COUNT(1)  
FROM   #RECPAY_TABLE  
WHERE  AMOUNT <= 0  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'VOUHER AMOUNT SHOULD BE ALWAY GRATER THAN 0',  
           'NA',  
           'NA',  
           ' NA'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END   
  
/* --------------- VALIDATION FOR MULTIPLE VOUCHER DATES IN CASE OF NON-YEARLY VNO METHOD-------------------------- */  
  
SELECT @@ERROR_COUNT = VNOFLAG  
FROM   PARAMETER  
WHERE  CURYEAR = 1  
  
  
  
IF @@ERROR_COUNT <> 0  
  BEGIN  
    SELECT @@ERROR_COUNT = COUNT(DISTINCT VDT)  
    FROM   #RECPAY_TABLE  
      
    IF @@ERROR_COUNT > 1  
      BEGIN  
        SELECT 'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES',  
               'NA',  
               'NA',  
               ' NA'  
          
        DROP TABLE #RECPAY_TABLE_TMP  
          
        DROP TABLE #RECPAY_TABLE  
          
        ROLLBACK TRAN  
          
        DELETE FROM V2_UPLOADED_FILES  
        WHERE       U_FILENAME = @FNAME  
                    AND U_MODULE = 'CASH UPLOAD'  
          
        RETURN  
      END  
  END   
  
/*--------------------------VALIDATION FOR DIFFERENT VDTs IN SAME VOUCHER ------------------------*/  
  
SET @@ERROR_COUNT = 0  
  
SELECT   @@ERROR_COUNT = COUNT(DISTINCT VDT)  
FROM     #RECPAY_TABLE  
WHERE    SERIAL_NO IN (SELECT DISTINCT SERIAL_NO  
                       FROM   #RECPAY_TABLE)  
GROUP BY SERIAL_NO  
HAVING   COUNT(DISTINCT VDT) > 1  
  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES',  
           'NA',  
           'NA',  
           ' NA'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END   
  
/*--------------------------FINAL VALIDATION BASED ON UPDFLAG ------------------------*/  
  
SELECT @@ERROR_COUNT = COUNT(1)  
FROM   (SELECT DISTINCT CLIENT_CODE  
        FROM   #RECPAY_TABLE  
        WHERE  UPDFLAG = 'N') A  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS DO NOT EXIST',  
           'NA',  
           'NA',  
           ' NA'  
    UNION ALL  
    SELECT DISTINCT CLIENT_CODE,  
                    'NA',  
           'NA',  
                    ' NA'  
    FROM   #RECPAY_TABLE  
    WHERE  UPDFLAG = 'N'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
     
    RETURN  
  END  
  
DECLARE  @@NEWVNO      AS VARCHAR(12),  
         @@MAXCOUNT    AS INT,  
         @@VDT         AS VARCHAR(11),  
         @@CASHBRANCH  AS VARCHAR(10),  
         @@CASHCOST    AS NUMERIC,  
         @@LNOCUR      AS CURSOR,  
         @@LNOVNO      AS VARCHAR(12)   
  
CREATE TABLE #CASHVNO  
(  
 SNO INT,  
 SRNO INT IDENTITY(1, 1)  
)  
  
  
/*    --------------------------AUTO GENERATION OF VNO ------------------------ */                    
  SET @@VNOCUR = CURSOR FOR                    
   SELECT DISTINCT                    
    CASHCODE,                    
    BOOKTYPE                    
   FROM                    
    #RECPAY_TABLE WITH(NOLOCK)                    
  OPEN @@VNOCUR                    
  FETCH NEXT                    
   FROM                    
    @@VNOCUR                    
   INTO                    
    @@CASH_CODE,                    
    @@BOOKTYPE                    
  WHILE @@FETCH_STATUS = 0                    
   BEGIN                    
  
/*--------------------------VALIDATION WITH USERRIGHTS TABLE ------------------------*/  
  
SELECT @@BACKDAYS = ISNULL(MAX(NODAYS),0)  
FROM   USERWRITESTABLE  
WHERE  USERCATEGORY = @USERCAT  
       AND VTYP = @@VTYP  
       AND BOOKTYPE = @@BOOKTYPE  
  
SELECT @@BACKDATE = CONVERT(DATETIME,CONVERT(VARCHAR(11),GETDATE(),109)) - @@BACKDAYS  
  
SELECT @@ERROR_COUNT = ISNULL(COUNT(VDT),0)  
FROM   #RECPAY_TABLE  
WHERE  VDT < @@BACKDATE  
  
IF @@ERROR_COUNT > 0  
  BEGIN  
    SELECT 'SOME OF THE VOUCHERS ARE HAVING BACK DATED VOUCHER DATES FOR WHICH RIGHTS HAVE NOT BEEN SET',  
           'NA',  
           'NA',  
           ' NA'  
      
    DROP TABLE #RECPAY_TABLE_TMP  
      
    DROP TABLE #RECPAY_TABLE  
      
    ROLLBACK TRAN  
      
    DELETE FROM V2_UPLOADED_FILES  
    WHERE       U_FILENAME = @FNAME  
                AND U_MODULE = 'CASH UPLOAD'  
      
    RETURN  
  END   
  
/*--------------------------UPDATE OF COST CODE ------------------------*/  
  
SELECT @@CASHBRANCH = BRANCHCODE,  
       @@CASHCOST = ISNULL(C.COSTCODE,-1)  
FROM   ACMAST A  
       LEFT OUTER JOIN COSTMAST C  
         ON (A.BRANCHCODE = C.COSTNAME)  
WHERE  A.CLTCODE = @@CASH_CODE  
  
IF @@CASHBRANCH <> 'ALL'  
  BEGIN  
    UPDATE RP  
    SET    CASHBRANCH = @@CASHBRANCH,  
           COSTCODE = @@CASHCOST  
    FROM   #RECPAY_TABLE RP,  
           ACMAST A  
    WHERE  A.CLTCODE = RP.CLIENT_CODE  
           AND A.BRANCHCODE = 'ALL'  
      
    UPDATE #RECPAY_TABLE  
    SET    CASHCOST = @@CASHCOST,  
           CASHBRANCH = @@CASHBRANCH  
  END  
ELSE  
  BEGIN  
    UPDATE #RECPAY_TABLE  
    SET    COSTCODE = (SELECT TOP 1 COSTCODE  
                       FROM   COSTMAST  
                       WHERE  COSTNAME = 'HO')  
    WHERE  COSTCODE = ''  
  END  
  
SET @@COSTCODEUPDATES = CURSOR FOR SELECT   SERIAL_NO,  
                                            COUNT(DISTINCT COSTCODE)  
                                   FROM     #RECPAY_TABLE WITH (NOLOCK)  
                                   GROUP BY SERIAL_NO  
                                   HAVING   COUNT(DISTINCT COSTCODE) > 1  
  
OPEN @@COSTCODEUPDATES  
  
FETCH NEXT FROM @@COSTCODEUPDATES  
INTO @@SERIAL_NO,  
     @@COSTCODECOUNT  
  
WHILE @@FETCH_STATUS = 0  
  BEGIN  
    UPDATE #RECPAY_TABLE  
    SET    CASHBRANCH = 'HO',  
           CASHCOST = (SELECT TOP 1 COSTCODE  
                       FROM   COSTMAST  
                       WHERE  COSTNAME = 'HO')  
    WHERE  SERIAL_NO = @@SERIAL_NO  
      
    FETCH NEXT FROM @@COSTCODEUPDATES  
    INTO @@SERIAL_NO,  
         @@COSTCODECOUNT  
  END  
  
UPDATE #RECPAY_TABLE  
SET    CASHBRANCH = BRANCHCODE,  
       CASHCOST = COSTCODE  
WHERE  (CASHCOST = ''  
         OR CASHCOST IS NULL)   
  
SELECT @@STD_DATE = LEFT(SDTCUR,11),  
       @@LST_DATE = LEFT(LDTCUR,11),  
       @@VNOMETHOD = VNOFLAG  
FROM   PARAMETER  
WHERE  CURYEAR = 1  
  
SELECT @@MAXCOUNT = COUNT(DISTINCT SNO)  
FROM   #RECPAY_TABLE  
WHERE BOOKTYPE = @@BOOKTYPE  
  
TRUNCATE TABLE #CASHVNO  
  
INSERT INTO #CASHVNO  
SELECT SERIAL_NO FROM #RECPAY_TABLE   
WHERE BOOKTYPE = @@BOOKTYPE  
  
SELECT TOP 1 @@VDT = VDT  
FROM   #RECPAY_TABLE  
  
CREATE TABLE #VNO  
(  
 LASTVNO VARCHAR(12)  
)  
  
INSERT INTO #VNO  
EXEC ACC_GENVNO_NEW  
  @@VDT ,  
  @@VTYP ,  
  @@BOOKTYPE ,  
  @@STD_DATE ,  
  @@LST_DATE,  
  @@MAXCOUNT  
  
SELECT @@NEWVNO = LASTVNO  
FROM   #VNO  
  
UPDATE R  
SET    VNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC,@@NEWVNO) + C.SRNO - 1)  
FROM #RECPAY_TABLE R, #CASHVNO C  
WHERE SERIAL_NO = C.SNO   
AND BOOKTYPE = @@BOOKTYPE  
  
SELECT @@NEWVNO = MAX(VNO)  
FROM   #RECPAY_TABLE   
  
  
  
DROP TABLE #VNO   
  
FETCH NEXT                    
   FROM @@VNOCUR                    
   INTO                    
    @@CASH_CODE,                    
    @@BOOKTYPE                    
 END     
  
  
  
/*--------------------------AUTO GENERATION OF LNO ------------------------*/  
  
UPDATE #RECPAY_TABLE  
SET    LNO = 2  
WHERE  VNO IN (SELECT   VNO  
               FROM     #RECPAY_TABLE WITH (NOLOCK)  
               GROUP BY VNO  
               HAVING   COUNT(*) = 1)  
  
SET @@LNOCUR = CURSOR FOR SELECT   VNO  
                          FROM     #RECPAY_TABLE WITH (NOLOCK)  
                          GROUP BY VNO  
                          HAVING   COUNT(*) > 1  
  
OPEN @@LNOCUR  
  
FETCH NEXT FROM @@LNOCUR  
INTO @@LNOVNO  
  
WHILE @@FETCH_STATUS = 0  
  BEGIN  
    CREATE TABLE [#LNOGEN] (  
      VNO VARCHAR(12),  
      SNO INT,  
      LNO INT   IDENTITY ( 1,1 ))  
      
    INSERT INTO #LNOGEN  
    SELECT   VNO,  
             SNO  
    FROM     #RECPAY_TABLE WITH (NoLock)  
    WHERE    VNO = @@LNOVNO  
    ORDER BY SNO  
      
    UPDATE #RECPAY_TABLE  
    SET    LNO = L.LNO + 1  
    FROM   #LNOGEN L  
    WHERE  #RECPAY_TABLE.VNO = L.VNO  
           AND #RECPAY_TABLE.SNO = L.SNO  
           AND #RECPAY_TABLE.LNO = 0  
      
    DROP TABLE #LNOGEN  
      
    FETCH NEXT FROM @@LNOCUR  
    INTO @@LNOVNO  
  END  
  
CLOSE @@LNOCUR  
  
DEALLOCATE @@LNOCUR   
  
/*--------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------*/ /*============================== CLIENT SIDE RECORD ==============================*/  
  
INSERT INTO LEDGER  
SELECT VTYP,  
       VNO,  
       EDT,  
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
       CLTCODE = CLIENT_CODE,  
       BOOKTYPE,  
       ENTEREDBY = @UNAME,  
       PDT = GETDATE(),  
       CHECKEDBY = @UNAME,  
       ACTNODAYS = 0,  
       NARRATION  
FROM   #RECPAY_TABLE   
  
/*============================== BANK SIDE RECORD ==============================*/  
  
INSERT INTO LEDGER  
SELECT   VTYP,  
         VNO,  
         EDT,  
         LNO = 1,  
         CASHNAME,  
         DRCR = (CASE   
                   WHEN DRCR = 'D' THEN 'C'  
                   ELSE 'D'  
                 END),  
         VAMT = SUM(AMOUNT),  
         VDT,  
         VNO1 = VNO,  
         REFNO = 0,  
         BALAMT = SUM(AMOUNT),  
         NODAYS = 0,  
         CDT = GETDATE(),  
         CLTCODE = CASHCODE,  
         BOOKTYPE,  
         ENTEREDBY = @UNAME,  
         PDT = GETDATE(),  
         CHECKEDBY = @UNAME,  
         ACTNODAYS = 0,  
         NARRATION = MAX(NARRATION)  
FROM     #RECPAY_TABLE  
GROUP BY VTYP,VNO,EDT,DRCR,CASHNAME, CASHCODE,  
         VDT, BOOKTYPE   
  
/*============================== CASH SIDE RECORD ==============================*/  
  
INSERT INTO LEDGER3  
SELECT   NARATNO = 1,  
         NARRATION = MAX(NARRATION),  
         REFNO = 0,  
         VTYP,  
         VNO,  
         BOOKTYPE  
FROM     #RECPAY_TABLE  
GROUP BY VTYP,VNO, BOOKTYPE   
/*============================== CLIENT SIDE RECORD ==============================*/  
  
INSERT INTO LEDGER3  
SELECT NARATNO = LNO,  
       NARR = NARRATION,  
       REFNO = 0,  
       VTYP,  
       VNO,  
       BOOKTYPE  
FROM   #RECPAY_TABLE  
  
DECLARE  @@L2CUR  AS CURSOR,  
         @@L2VNO  AS VARCHAR(12)  
  
SET @@L2CUR = CURSOR FOR SELECT   DISTINCT VNO  
                         FROM     #RECPAY_TABLE  
   ORDER BY VNO  
  
OPEN @@L2CUR  
  
FETCH NEXT FROM @@L2CUR  
INTO @@L2VNO  
  
WHILE @@FETCH_STATUS = 0  
  BEGIN  
    DELETE FROM TEMPLEDGER2  
    WHERE       SESSIONID = '9999999999'   
/*============================== CLIENT SIDE RECORD ==============================*/  
      
    INSERT INTO TEMPLEDGER2  
    SELECT 'BRANCH',  
           C.COSTNAME,  
           AMOUNT,  
           VTYP,  
           VNO,  
           LNO,  
           DRCR,  
           '0',  
           BOOKTYPE,  
           '9999999999',  
           CLIENT_CODE,  
           'A',  
           '0'  
    FROM   #RECPAY_TABLE RP,  
           COSTMAST C  
    WHERE  RP.COSTCODE = C.COSTCODE  
           AND VNO = @@L2VNO   
/*============================== BANK SIDE RECORD ==============================*/  
      
    INSERT INTO TEMPLEDGER2  
    SELECT   'BRANCH',  
             CASHBRANCH,  
             SUM(AMOUNT),  
             VTYP,  
             VNO,  
             LNO = 1,  
             DRCR = (CASE   
                       WHEN DRCR = 'D' THEN 'C'  
                       ELSE 'D'  
                     END),  
             '0',  
             BOOKTYPE,  
             '9999999999',  
             CASHCODE,  
             'A',  
             '0'  
    FROM     #RECPAY_TABLE  
    WHERE    VNO = @@L2VNO  
    GROUP BY CASHBRANCH,VTYP,VNO,CASHCODE,BOOKTYPE,(CASE   
                WHEN DRCR = 'D' THEN 'C'  
                ELSE 'D'  
              END)  
      
    EXEC INSERTTOLEDGER2  
      '9999999999' ,  
      @@L2VNO ,  
      '1' ,  
      '1' ,  
      '1' ,  
      'BROKER' ,  
      'BROKER'  
      
    FETCH NEXT FROM @@L2CUR  
    INTO @@L2VNO  
  END  
  
DELETE FROM TEMPLEDGER2  
WHERE       SESSIONID = '9999999999'  
  
COMMIT TRAN  
  
SELECT 'CLTCODE',  
    'CASHCODE',  
       'AMOUNT',  
       'VNO'  
UNION ALL  
SELECT CLIENT_CODE, CASHCODE,  
       CONVERT(VARCHAR,AMOUNT),  
       VNO                      AS RESULT  
FROM   #RECPAY_TABLE  
  
  
DROP TABLE #RECPAY_TABLE_TMP  
  
DROP TABLE #RECPAY_TABLE

GO
