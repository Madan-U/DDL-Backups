-- Object: PROCEDURE dbo.V2_BULKCONTRAPOSTING
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROC [dbo].[V2_BULKCONTRAPOSTING]  
(  
 @FNAME VARCHAR(100),  
 @UNAME VARCHAR(25),  
 @FTYPE CHAR(1) = 3,  
 @USERCAT SMALLINT  
)  
  
AS  
  
 SET NOCOUNT ON  
  
 /*  
  DELETE FROM V2_UPLOADED_FILES WHERE U_FILENAME = 'D:\BACKOFFICE\CONTRAFILES\CONTRA_29112006_01.txt'  
  EXEC V2_BULKCONTRAPOSTING 'D:\BACKOFFICE\CONTRAFILES\CONTRA_29112006_01.txt', 'TEST', 120  
 */  
  
 DECLARE  
 @@ERROR_COUNT INT,  
 @@SQL VARCHAR(250)  
  
 CREATE TABLE #FEXIST  
 (  
  F1 INT,  
  F2 INT,  
  F3 INT  
 )  
  
 INSERT INTO   
  #FEXIST   
   EXEC MASTER.DBO.XP_FILEEXIST @FNAME  
  
 SELECT   
  @@ERROR_COUNT = F1   
 FROM   
  #FEXIST  
  
 IF @@ERROR_COUNT = 0  
 BEGIN  
  SELECT  
   'THE FILE YOU ARE UPLOADING DOES NOT EXIST. PLEASE VERIFY.', @FNAME, 'NA','NA'  
  DROP TABLE #FEXIST  
  RETURN  
 END  
   
 DROP TABLE #FEXIST  
  
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
   AND U_MODULE = 'CONTRA UPLOAD'  
 ) A  
  
 IF @@ERROR_COUNT > 0  
 BEGIN  
  SELECT  
   'THE FILE YOU ARE UPLOADING IS ALREADY UPLOADED. PLEASE UPLOAD ANOTHER FILE.', @FNAME, 'NA','NA'  
  RETURN  
 END  
   
 --BEGIN FILE FORMAT CHECKING--  
 CREATE TABLE  
  [#CONTRA_FILE_CHECK]  
  (  
   FILEDATA VARCHAR(500)  
  )  
  
 SELECT @@SQL = " "  
 SELECT @@SQL = @@SQL + "BULK INSERT "  
 SELECT @@SQL = @@SQL + " #CONTRA_FILE_CHECK "  
 SELECT @@SQL = @@SQL + "FROM "  
 SELECT @@SQL = @@SQL + " '" + @FNAME + "' "  
  SELECT @@SQL = @@SQL + "WITH (FIELDTERMINATOR = '~~', ROWTERMINATOR = '\n', FIRSTROW = 2, LASTROW = 2) "  
  
  EXEC(@@SQL)  
  
 DECLARE   
  @@FILEDATA VARCHAR(500),  
  @@FIELDDATA VARCHAR(50),  
  @INDEX INT  
   
 SELECT   
  @@FILEDATA = FILEDATA   
 FROM   
  #CONTRA_FILE_CHECK  
  
 SELECT TOP 1 @@FIELDDATA = ITEMS FROM SPLIT(@@FILEDATA, ',')  
  
 SELECT @INDEX = CHARINDEX('/', @@FIELDDATA)  
    
 IF @FTYPE = '1' AND @INDEX > 0   
 BEGIN   
  SELECT 'THE FILE WHICH YOU ARE TRYING UPLOAD IS OF WRONG FORMAT'  
  RETURN  
 END  
 ELSE IF @FTYPE = '2' AND @INDEX > 0   
 BEGIN   
  SELECT 'THE FILE WHICH YOU ARE TRYING UPLOAD IS OF WRONG FORMAT'  
  RETURN  
 END  
 ELSE IF @FTYPE = '3' AND @INDEX = 0   
 BEGIN   
  SELECT 'THE FILE WHICH YOU ARE TRYING UPLOAD IS OF WRONG FORMAT'  
  RETURN  
 END  
  
 --END FILE FORMAT CHECKING--  
   
 BEGIN TRAN  
  CREATE TABLE  
   [#CONTRA_TABLE_TMP]  
   (  
    EDATE VARCHAR(20),  
    VDATE VARCHAR(20),  
    CREDIT_BANKCODE VARCHAR(50),  
    DEBIT_BANKCODE VARCHAR(50),  
    AMOUNT MONEY,  
    NARRATION VARCHAR(234),  
    DDNO VARCHAR(15),  
    BANK_NAME VARCHAR (100),  
    BRANCH_NAME VARCHAR(50),  
    CHQ_MODE VARCHAR(1),  
    CHQ_DATE VARCHAR(20),  
    CL_MODE VARCHAR(1)  
   )  
  
  CREATE TABLE  
   [#CONTRA_TABLE]  
   (  
    EDATE VARCHAR(20),  
    VDATE VARCHAR(20),  
    CREDIT_BANKCODE VARCHAR(50),  
    DEBIT_BANKCODE VARCHAR(50),  
    AMOUNT MONEY,  
    CR VARCHAR(1),  
    DR VARCHAR(1),  
    NARRATION VARCHAR(234),  
    DDNO VARCHAR(15),  
    BANK_NAME VARCHAR (100),  
    BRANCH_NAME VARCHAR(50),  
    CHQ_MODE VARCHAR(1),  
    CHQ_DATE VARCHAR(20),      
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
    CREDIT_BANKNAME VARCHAR (100) NULL ,  
    DEBIT_BANKNAME VARCHAR (100) NULL ,  
    CREDIT_BRANCHCODE VARCHAR(20),  
    DEBIT_BRANCHCODE VARCHAR(20),  
    CREDIT_BANKCOST SMALLINT NULL,  
    DEBIT_BANKCOST SMALLINT NULL,      
    BOOKTYPE VARCHAR(2) NULL,  
   )  
  ON [PRIMARY]  
    
  IF @FTYPE = '1' OR @FTYPE = '2'   
  BEGIN  
   CREATE TABLE  
    [#CONTRA_TABLE_BANKTMP]  
    (  
     CREDIT_BANKCODE_ACC VARCHAR(16),  
     LOC VARCHAR(3),  
     AMOUNT MONEY,   
     FILE_DATE VARCHAR(8),  
     NARRATION VARCHAR(234),  
     TRAN_DATE VARCHAR(20),  
     TRAN_STATUS VARCHAR(8),  
     TRANFAIL_DETAIL VARCHAR(100),  
     DDNO VARCHAR(15)       
    )  
     
   SELECT @@SQL = " "  
   SELECT @@SQL = @@SQL + "BULK INSERT "  
   SELECT @@SQL = @@SQL + " #CONTRA_TABLE_BANKTMP "  
   SELECT @@SQL = @@SQL + "FROM "  
   SELECT @@SQL = @@SQL + " '" + @FNAME + "' "  
    SELECT @@SQL = @@SQL + "WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 1) "  
     
   EXEC(@@SQL)  
     
   DELETE FROM  
    #CONTRA_TABLE_BANKTMP  
   WHERE  
    TRAN_STATUS = 'REJECTED'  
  
   UPDATE   
    #CONTRA_TABLE_BANKTMP   
   SET CREDIT_BANKCODE_ACC = REPLACE(CREDIT_BANKCODE_ACC, '', '') --DO NOT ALTER THE ALIGNMENT OF THIS LINE  
   WHERE   
    CREDIT_BANKCODE_ACC LIKE '%' --DO NOT ALTER THE ALIGNMENT OF THIS LINE  
  END  
  
  IF @FTYPE = '1'   
  BEGIN     
   INSERT INTO   
    #CONTRA_TABLE_TMP  
    (      
    EDATE,  
    VDATE,  
    CREDIT_BANKCODE,  
    DEBIT_BANKCODE,  
    AMOUNT,  
    NARRATION,  
    DDNO,  
    BANK_NAME,  
    BRANCH_NAME,  
    CHQ_MODE,  
    CHQ_DATE,  
    CL_MODE  
    )  
   SELECT  
    EDATE = SUBSTRING(TRAN_DATE, 1, 2) + '/' + SUBSTRING(TRAN_DATE, 3, 2) + '/' + SUBSTRING(TRAN_DATE, 5, 8),  
    VDATE = SUBSTRING(TRAN_DATE, 1, 2) + '/' + SUBSTRING(TRAN_DATE, 3, 2) + '/' + SUBSTRING(TRAN_DATE, 5, 8),  
    CREDIT_BANKCODE = HOCLTCODE,  
    DEBIT_BANKCODE = BANKCODE,  
    AMOUNT,  
    NARRATION,  
    DDNO,  
    BANK_NAME = BANKNAME,  
    BRANCH_NAME = '',  
    CHQ_MODE = 'I',  
    CHQ_DATE = SUBSTRING(TRAN_DATE, 1, 2) + '/' + SUBSTRING(TRAN_DATE, 3, 2) + '/' + SUBSTRING(TRAN_DATE, 5, 8),  
    CL_MODE = 'O'  
   FROM  
    #CONTRA_TABLE_BANKTMP C,  
    DIVIDEND_AC M  
   WHERE  
    CREDIT_BANKCODE_ACC = BANKAC  
  END  
  
  ELSE IF @FTYPE = '2'   
  BEGIN  
   INSERT INTO   
    #CONTRA_TABLE_TMP  
    (      
    EDATE,  
    VDATE,  
    CREDIT_BANKCODE,  
    DEBIT_BANKCODE,  
    AMOUNT,  
    NARRATION,  
    DDNO,  
    BANK_NAME,  
    BRANCH_NAME,  
    CHQ_MODE,  
    CHQ_DATE,  
    CL_MODE  
    )  
   SELECT  
    EDATE = SUBSTRING(TRAN_DATE, 1, 2) + '/' + SUBSTRING(TRAN_DATE, 3, 2) + '/' + SUBSTRING(TRAN_DATE, 5, 8),  
    VDATE = SUBSTRING(TRAN_DATE, 1, 2) + '/' + SUBSTRING(TRAN_DATE, 3, 2) + '/' + SUBSTRING(TRAN_DATE, 5, 8),  
    CREDIT_BANKCODE = BANKCODE,  
    DEBIT_BANKCODE = HOCLTCODE,  
    AMOUNT,  
    NARRATION,  
    DDNO,  
    BANK_NAME = BANKNAME,  
    BRANCH_NAME = '',  
    CHQ_MODE = 'I',  
    CHQ_DATE = SUBSTRING(TRAN_DATE, 1, 2) + '/' + SUBSTRING(TRAN_DATE, 3, 2) + '/' + SUBSTRING(TRAN_DATE, 5, 8),  
    CL_MODE = 'O'  
   FROM  
    #CONTRA_TABLE_BANKTMP C,  
    DP_AC M  
   WHERE  
    CREDIT_BANKCODE_ACC = BANKAC  
  END  
  
  ELSE IF @FTYPE = '3'   
  BEGIN  
   SELECT @@SQL = " "  
   SELECT @@SQL = @@SQL + "BULK INSERT "  
   SELECT @@SQL = @@SQL + " #CONTRA_TABLE_TMP "  
   SELECT @@SQL = @@SQL + "FROM "  
   SELECT @@SQL = @@SQL + " '" + @FNAME + "' "  
    SELECT @@SQL = @@SQL + "WITH (ROWTERMINATOR = '\n', FIELDTERMINATOR = ',', FIRSTROW = 2) "  
     
   EXEC(@@SQL)  
  END  
  
  INSERT INTO  
   V2_UPLOADED_FILES  
  SELECT  
   @FNAME,  
   @FNAME,  
   COUNT(1),  
   'B',  
   GETDATE(),  
   @UNAME,  
   'CONTRA UPLOAD'  
  
  INSERT INTO  
   #CONTRA_TABLE  
   (  
   EDATE,  
   VDATE,  
   CREDIT_BANKCODE,  
   DEBIT_BANKCODE,  
   AMOUNT,  
   CR,  
   DR,  
   NARRATION,  
   DDNO,  
   BANK_NAME,  
   BRANCH_NAME,  
   CHQ_MODE,  
   CHQ_DATE,  
   CL_MODE,  
   VTYP,  
   BOOKTYPE  
   )  
  SELECT  
   EDATE,  
   VDATE,  
   UPPER(CREDIT_BANKCODE),  
   UPPER(DEBIT_BANKCODE),  
   AMOUNT,  
   'C',  
   'D',  
   NARRATION,  
   DDNO,  
   BANK_NAME,  
   BRANCH_NAME,  
   UPPER(CHQ_MODE),  
   CHQ_DATE,  
   CL_MODE,  
   5,  
   '01'  
  FROM  
   #CONTRA_TABLE_TMP  
  
  UPDATE   
   #CONTRA_TABLE  
  SET  
   CREDIT_BRANCHCODE = A.BRANCHCODE,  
   DEBIT_BRANCHCODE = B.BRANCHCODE       
  FROM  
   ACMAST A, ACMAST B  
  WHERE  
   A.CLTCODE = CREDIT_BANKCODE  
   AND B.CLTCODE = DEBIT_BANKCODE  
  
  UPDATE  
   #CONTRA_TABLE  
  SET  
   CREDIT_BRANCHCODE = A.BRANCHCODE,  
   DEBIT_BRANCHCODE = B.BRANCHCODE,  
   VDT = CONVERT(DATETIME, RIGHT(VDATE,4) + '-' + SUBSTRING(VDATE,4,2) + '-' + LEFT(VDATE,2)),  
   DDDT = CONVERT(DATETIME, RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),  
   EDT = CONVERT(DATETIME, RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),  
   FYSTART = P.SDTCUR,  
   FYEND = P.LDTCUR,  
   UPDFLAG = 'Y',  
    CREDIT_BANKCOST = C.COSTCODE,  
    DEBIT_BANKCOST= D.COSTCODE,  
    CREDIT_BANKNAME = A.LONGNAME,  
    DEBIT_BANKNAME = B.LONGNAME  
  FROM  
   ACMAST A, PARAMETER P, COSTMAST C, ACMAST B, COSTMAST D  
  WHERE  
   A.CLTCODE = CREDIT_BANKCODE  
   AND B.CLTCODE = DEBIT_BANKCODE  
   AND P.CURYEAR = 1  
   AND A.ACCAT = '2'  
   AND B.ACCAT = '2'  
   AND A.BRANCHCODE = C.COSTNAME  
   AND B.BRANCHCODE = D.COSTNAME    
  
  UPDATE  
   #CONTRA_TABLE  
  SET  
   CREDIT_BRANCHCODE = (CASE CREDIT_BRANCHCODE WHEN 'ALL' THEN 'HO' ELSE CREDIT_BRANCHCODE END),  
   DEBIT_BRANCHCODE = (CASE DEBIT_BRANCHCODE WHEN 'ALL' THEN 'HO' ELSE DEBIT_BRANCHCODE END),  
   VDT = CONVERT(DATETIME, RIGHT(VDATE,4) + '-' + SUBSTRING(VDATE,4,2) + '-' + LEFT(VDATE,2)),  
   DDDT = CONVERT(DATETIME, RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),  
   EDT = CONVERT(DATETIME, RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),  
   FYSTART = P.SDTCUR,  
   FYEND = P.LDTCUR,  
   UPDFLAG = 'Y',  
   CREDIT_BANKCOST = (CASE CREDIT_BRANCHCODE WHEN 'ALL' THEN (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO') ELSE (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = CREDIT_BRANCHCODE) END),  
    DEBIT_BANKCOST= (CASE DEBIT_BRANCHCODE WHEN 'ALL' THEN (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO') ELSE (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = DEBIT_BRANCHCODE) END),  
    CREDIT_BANKNAME = A.LONGNAME,  
   DEBIT_BANKNAME = B.LONGNAME  
  FROM  
   ACMAST A, PARAMETER P, ACMAST B  
  WHERE  
   A.CLTCODE = CREDIT_BANKCODE  
   AND B.CLTCODE = DEBIT_BANKCODE  
   AND P.CURYEAR = 1  
   AND A.ACCAT = '2'  
   AND B.ACCAT = '2'  
   AND (A.BRANCHCODE = 'ALL'  
   OR B.BRANCHCODE = 'ALL')  
  
    
  /*    --------------------------DECLARATION OF VARIABLES FOR VALIDATIONS ------------------------ */  
  DECLARE  
   @@STD_DATE VARCHAR(11),  
   @@LST_DATE VARCHAR(11),  
   @@VNOMETHOD INT,  
   @@ACNAME CHAR(100),  
   @@BOOKTYPE CHAR(2),  
   @@MICRNO VARCHAR(10),  
   @@DRCR VARCHAR(1),  
   @@VTYP SMALLINT,  
   @@BANK_CODE VARCHAR(100),  
   @@BACKDAYS INT,  
   @@BACKDATE VARCHAR(11),  
   @@BRNCOUNT TINYINT,  
   @@MONTHLYVDT VARCHAR(11),  
   @@SERIAL_NO INT,  
   @@COSTCODECOUNT TINYINT,  
   @@COSTCODEUPDATES CURSOR,
   @@VDT AS VARCHAR(11),
   @@STARTDATE AS DATETIME,
   @@ENDDATE AS DATETIME
  
  
  /* -------------- VALIDATION FOR MULTIPLE VOUCHER DATES-------------------------- */  
  /*SELECT  
   @@ERROR_COUNT = COUNT(DISTINCT VDT)  
  FROM  
   #CONTRA_TABLE  */

   SELECT TOP 1  
    @@VDT = CONVERT(VARCHAR(11), VDT, 109)  
   FROM  
    #CONTRA_TABLE

	SELECT @@STARTDATE = DATEADD(S,0,DATEADD(MM, DATEDIFF(M,0,@@VDT),0))
	SELECT @@ENDDATE = DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,@@VDT)+1,0))  
  
  
  /* -------------- VALIDATION FOR MULTIPLE VOUCHER DATES-------------------------- */  
  SELECT  
   @@ERROR_COUNT = COUNT(1)  
  FROM  
   #CONTRA_TABLE
  WHERE VDT < @@STARTDATE AND VDT > @@ENDDATE

  IF @@ERROR_COUNT > 1  
   BEGIN  
    SELECT  
     'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES', 'NA', 'NA','NA'  
    DROP TABLE #CONTRA_TABLE_TMP  
    DROP TABLE #CONTRA_TABLE  
    ROLLBACK TRAN  
    DELETE FROM  
     V2_UPLOADED_FILES  
    WHERE  
     U_FILENAME = @FNAME  
     AND U_MODULE = 'CONTRA UPLOAD'  
     RETURN  
   END     
  
  /* -------------- VALIDATION FOR BLANK NARRATION-------------------------- */  
  SELECT  
   @@ERROR_COUNT = COUNT(1)  
  FROM  
   #CONTRA_TABLE  
  WHERE  
   NARRATION IS NULL OR NARRATION = ''  
  IF @@ERROR_COUNT >= 1  
   BEGIN  
    SELECT  
     'SOME OF THE VOUCHERS ARE HAVING BLANK NARRATION', 'NA', 'NA','NA'  
    DROP TABLE #CONTRA_TABLE_TMP  
    DROP TABLE #CONTRA_TABLE  
    ROLLBACK TRAN  
    DELETE FROM  
     V2_UPLOADED_FILES  
    WHERE  
     U_FILENAME = @FNAME  
     AND U_MODULE = 'CONTRA UPLOAD'  
     RETURN  
   END  
  
  /*--------------------------VALIDATION FOR VOUCHER DATE GRATER THAN EFFECTIVE DATE ------------------------*/  
  SELECT   
   @@ERROR_COUNT = COUNT(1)  
  FROM   
   #CONTRA_TABLE  
  WHERE   
   VDT > EDT  
             IF @@ERROR_COUNT > 0  
              BEGIN  
               SELECT 'VOUHER DATE CAN NOT BE GRATER THAN EFFECTIVE DATE.', 'NA','NA','NA'  
      DROP TABLE #CONTRA_TABLE_TMP  
      DROP TABLE #CONTRA_TABLE  
      ROLLBACK TRAN  
      DELETE FROM  
       V2_UPLOADED_FILES  
      WHERE  
       U_FILENAME = @FNAME  
      AND U_MODULE = 'CONTRA UPLOAD'  
      RETURN  
              END  
  
  /*--------------------------VALIDATION FOR ZERO AMOUNT ------------------------*/  
  SELECT   
   @@ERROR_COUNT = COUNT(1)  
  FROM   
   #CONTRA_TABLE  
  WHERE   
   AMOUNT <= 0  
  IF @@ERROR_COUNT > 0  
   BEGIN  
              SELECT 'VOUHER AMOUNT SHOULD BE ALWAY GRATER THAN 0', 'NA','NA','NA'  
    DROP TABLE #CONTRA_TABLE_TMP  
    DROP TABLE #CONTRA_TABLE  
    ROLLBACK TRAN  
    DELETE FROM  
     V2_UPLOADED_FILES  
    WHERE  
     U_FILENAME = @FNAME  
    AND U_MODULE = 'CONTRA UPLOAD'  
    RETURN  
  END  
  
  /*   --------------------------VALIDATION FOR CHEQUE NUMBER ------------------------ */  
  SELECT  
   @@ERROR_COUNT = COUNT(1)  
  FROM  
   (  
    SELECT DISTINCT  
     DDNO  = RP.DDNO  
    FROM  
     #CONTRA_TABLE RP,  
     LEDGER1 L1 (NOLOCK)  
    WHERE  
     L1.DDNO = RP.DDNO  
     AND L1.DD = RP.CHQ_MODE  
     AND L1.VTYP = RP.VTYP  
     AND RP.DDNO <> '0'  
   ) A  
  IF @@ERROR_COUNT > 0  
   BEGIN  
    SELECT  
     'FILE CANNOT BE UPLOADED AS THE FOLLOWING CHEQUE NUMBER ALREADY EXISTS', 'NA','NA','NA'  
    UNION ALL  
    SELECT  
     'CHQ_NO', 'NA','NA','NA'  
    UNION ALL  
    SELECT DISTINCT  
     RP.DDNO, 'NA','NA','NA'  
    FROM  
     #CONTRA_TABLE RP,  
     LEDGER1 L1  
      WITH(NOLOCK)  
    WHERE  
     L1.DDNO = RP.DDNO  
     AND L1.DD = RP.CHQ_MODE  
     AND L1.VTYP = RP.VTYP  
     AND RP.CHQ_MODE <> 'N'  
    DROP TABLE #CONTRA_TABLE_TMP  
    DROP TABLE #CONTRA_TABLE  
    ROLLBACK TRAN  
    DELETE FROM  
     V2_UPLOADED_FILES  
    WHERE  
     U_FILENAME = @FNAME  
     AND U_MODULE = 'CONTRA UPLOAD'  
    RETURN  
   END  
  
  /*--------------------------FINAL VALIDATION BASED ON UPDFLAG ------------------------ */  
  SELECT  
   @@ERROR_COUNT = COUNT(1)  
  FROM  
   (  
    SELECT DISTINCT  
     UPDFLAG  
    FROM  
     #CONTRA_TABLE  
    WHERE  
     UPDFLAG = 'N'  
   ) A  
  IF @@ERROR_COUNT > 0  
   BEGIN  
    SELECT  
     'FILE CANNOT BE UPLOADED AS THE FOLLOWING BANKS DO NOT EXIST', 'NA','NA','NA'  
    UNION ALL  
    SELECT  
     'BANKCODE', 'NA','NA','NA'  
    UNION ALL  
    SELECT DISTINCT  
     CREDIT_BANKCODE, 'NA','NA','NA'  
    FROM  
     #CONTRA_TABLE  
    WHERE  
     CREDIT_BANKCODE NOT IN (SELECT CLTCODE FROM ACMAST WHERE ACCAT = 2)   
    UNION ALL  
    SELECT DISTINCT  
     DEBIT_BANKCODE, 'NA','NA','NA'  
    FROM  
     #CONTRA_TABLE  
    WHERE  
     DEBIT_BANKCODE NOT IN (SELECT CLTCODE FROM ACMAST WHERE ACCAT = 2)  
    DROP TABLE #CONTRA_TABLE_TMP  
    DROP TABLE #CONTRA_TABLE  
    ROLLBACK TRAN  
    DELETE FROM  
     V2_UPLOADED_FILES  
    WHERE  
     U_FILENAME = @FNAME  
     AND U_MODULE = 'CONTRA UPLOAD'  
    RETURN  
   END  
  
--------------------------VALIDATION WITH USERRIGHTS TABLE ------------------------                
    SELECT                      
     @@BACKDAYS = ISNULL(MAX(NODAYS), 0)                      
    FROM                      
     USERWRITESTABLE                      
    WHERE                      
     USERCATEGORY = @USERCAT                      
     AND VTYP = 5                      
     AND BOOKTYPE = '01'                      
    SELECT                      
     @@BACKDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), GETDATE(), 109)) - @@BACKDAYS                      
    SELECT                      
     @@ERROR_COUNT = ISNULL(COUNT(VDT), 0)                      
    FROM                      
     #CONTRA_TABLE                      
    WHERE                      
     VDT < @@BACKDATE                      
    IF @@ERROR_COUNT > 0                      
     BEGIN                      
      SELECT                      
       'SOME OF THE VOUCHERS ARE HAVING BACK DATED VOUCHER DATES FOR WHICH RIGHTS HAVE NOT BEEN SET', 'NA','NA'                      
  DROP TABLE #CONTRA_TABLE_TMP  
  DROP TABLE #CONTRA_TABLE  
  ROLLBACK TRAN  
  DELETE FROM  
   V2_UPLOADED_FILES  
  WHERE  
   U_FILENAME = @FNAME  
   AND U_MODULE = 'CONTRA UPLOAD'  
  RETURN        
     END    
  
   DECLARE  
    @@NEWVNO AS VARCHAR(12),  
    @@MAXCOUNT AS INT,  
    @@BANKBRANCH AS VARCHAR(10),  
    @@BANKCOST AS NUMERIC,  
    @@LNOCUR AS CURSOR,  
    @@VNOCUR AS CURSOR,  
    @@LNOVNO AS VARCHAR(12)  
  
   /*--------------------------AUTO GENERATION OF VNO ------------------------*/  
   CREATE TABLE  
    #BANK_VNO  
    (  
     SRNO INT,  
     NEWSRNO INT IDENTITY (1, 1)  
    )  
  
   INSERT INTO  
    #BANK_VNO  
   SELECT  
    SNO  
   FROM  
    #CONTRA_TABLE  
     
   SELECT TOP 1  
    @@VDT = VDT  
   FROM  
    #CONTRA_TABLE  
  
   SELECT  
    @@STD_DATE = LEFT(SDTCUR, 11),  
    @@LST_DATE = LEFT(LDTCUR, 11),  
    @@VNOMETHOD = VNOFLAG  
   FROM  
    PARAMETER  
   WHERE  
    @@VDT BETWEEN SDTCUR AND LDTCUR  
  
   SELECT  
    @@MAXCOUNT = COUNT(DISTINCT SNO)  
   FROM  
    #CONTRA_TABLE  
  
   CREATE TABLE #VNO  
   (  
    LASTVNO VARCHAR(12)  
   )  
  
   DECLARE @@MAXVNO AS INT  
  
   SELECT @@MAXVNO = MAX(NEWSRNO) FROM #BANK_VNO  
  
   INSERT INTO  
    #VNO  
   EXEC   
    ACC_GENVNO_NEW  
     @@VDT,  
     5,  
     '01',  
     @@STD_DATE,  
     @@LST_DATE,  
     @@MAXVNO  
  
   SELECT  
    @@NEWVNO = LASTVNO  
   FROM  
    #VNO  
        
   UPDATE  
    RP  
   SET   
    VNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC,@@NEWVNO) + (SNO - 1))  
   FROM  
    #CONTRA_TABLE RP,  
    #BANK_VNO BV  
   WHERE  
    RP.SNO = BV.SRNO  
  
   DROP TABLE #VNO  
   DROP TABLE #BANK_VNO     
  
   /* --------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------ */   
  
   /*==============================   
   LEDGER1 RECORDS   
   ==============================*/   
  
   INSERT INTO   
    LEDGER1   
   SELECT   
    BNKNAME = MAX(BANK_NAME),   
    BRNNAME = MAX(BRANCH_NAME),   
    DD = MAX(CHQ_MODE),   
    DDNO = MAX(DDNO),   
    DDDT = MAX(DDDT),   
    RELDT = '',   
    RELAMT = SUM(AMOUNT),   
    REFNO = 0,   
    RECEIPTNO = 0,   
    VTYP,   
    VNO,   
    LNO = 1,   
    DR,   
    BOOKTYPE = BOOKTYPE,   
    MICRNO = 0,   
    SLIPNO = 0,   
    SLIPDATE = '',   
    CHEQUEINNAME = '',   
    CHQPRINTED = 0,   
    CLEAR_MODE = MAX(CL_MODE)   
   FROM   
    #CONTRA_TABLE   
   GROUP BY   
    VTYP,   
    VNO,   
    DR,   
    BOOKTYPE   
  
   INSERT INTO   
    LEDGER1   
   SELECT   
    BNKNAME = MAX(BANK_NAME),   
    BRNNAME = MAX(BRANCH_NAME),   
    DD = MAX(CHQ_MODE),   
    DDNO = MAX(DDNO),   
    DDDT = MAX(DDDT),   
    RELDT = '',   
    RELAMT = SUM(AMOUNT),   
    REFNO = 0,   
    RECEIPTNO = 0,   
    VTYP,   
    VNO,   
    LNO = 2,   
    CR,   
    BOOKTYPE = BOOKTYPE,   
    MICRNO = 0,   
    SLIPNO = 0,   
    SLIPDATE = '',   
    CHEQUEINNAME = '',   
    CHQPRINTED = 0,   
    CLEAR_MODE = MAX(CL_MODE)   
   FROM   
    #CONTRA_TABLE   
   GROUP BY   
    VTYP,   
    VNO,   
    CR,   
    BOOKTYPE   
  
  
   /*==============================   
   LEDGER RECORDS   
   ==============================*/   
   INSERT INTO   
    LEDGER   
   SELECT   
    VTYP,   
    VNO,   
    EDT,   
    LNO = 1,   
    ACNAME = DEBIT_BANKNAME,   
    DR,   
    VAMT = AMOUNT,   
    VDT,   
    VNO1 = VNO,   
    REFNO = 0,   
    BALAMT = AMOUNT,   
    NODAYS = 0,   
    CDT = GETDATE(),   
    CLTCODE = DEBIT_BANKCODE,   
    BOOKTYPE = BOOKTYPE,   
    ENTEREDBY = @UNAME,   
    PDT = GETDATE(),   
    CHECKEDBY = @UNAME,   
    ACTNODAYS = 0,   
    NARRATION   
   FROM   
    #CONTRA_TABLE   
  
   INSERT INTO   
    LEDGER   
   SELECT   
    VTYP,   
    VNO,   
    EDT,   
    LNO = 2,   
    ACNAME = CREDIT_BANKNAME,   
    CR,   
    VAMT = AMOUNT,   
    VDT,   
    VNO1 = VNO,   
    REFNO = 0,   
    BALAMT = AMOUNT,   
    NODAYS = 0,   
    CDT = GETDATE(),   
    CLTCODE = CREDIT_BANKCODE,   
    BOOKTYPE = BOOKTYPE,   
    ENTEREDBY = @UNAME,   
    PDT = GETDATE(),   
    CHECKEDBY = @UNAME,   
    ACTNODAYS = 0,   
    NARRATION   
   FROM   
    #CONTRA_TABLE   
  
  
   /*==============================   
   LEDGER3 RECORDS   
   ==============================*/   
   INSERT INTO   
    LEDGER3   
   SELECT   
    NARATNO = 1,   
    NARRATION = MAX(NARRATION),   
    REFNO = 0,   
    VTYP,   
    VNO,   
    BOOKTYPE   
   FROM   
    #CONTRA_TABLE   
   GROUP BY   
    VTYP,   
    VNO,   
    BOOKTYPE   
  
   INSERT INTO   
    LEDGER3   
   SELECT   
    NARATNO = 2,   
    NARR = NARRATION,   
    REFNO = 0,   
    VTYP,   
    VNO,   
    BOOKTYPE   
   FROM   
    #CONTRA_TABLE   
  
  
   /*==============================   
   LEDGER2 RECORDS   
   ==============================*/   
  
   DECLARE   
    @@L2CUR AS CURSOR,   
    @@L2VNO AS VARCHAR(12)   
   SET @@L2CUR = CURSOR FOR   
    SELECT DISTINCT   
     VNO   
    FROM   
     #CONTRA_TABLE   
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
       
     INSERT INTO   
      TEMPLEDGER2   
     SELECT   
      'BRANCH',   
      C.COSTNAME,   
      AMOUNT,   
      VTYP,   
      VNO,   
      LNO = 1,   
      DR,   
      '0',   
      BOOKTYPE,   
      '9999999999',   
      DEBIT_BANKCODE,   
      'A',   
      '0'   
     FROM   
      #CONTRA_TABLE RP,   
      COSTMAST C   
     WHERE   
      RP.DEBIT_BANKCOST = C.COSTCODE   
      AND VNO = @@L2VNO  
  
     INSERT INTO   
      TEMPLEDGER2   
     SELECT   
      'BRANCH',   
      C.COSTNAME,   
      AMOUNT,   
      VTYP,   
      VNO,   
      LNO = 2,   
      CR,   
      '0',   
      BOOKTYPE,   
      '9999999999',   
      CREDIT_BANKCODE,   
      'A',   
      '0'   
     FROM   
      #CONTRA_TABLE RP,   
      COSTMAST C   
     WHERE   
      RP.CREDIT_BANKCOST = C.COSTCODE   
      AND VNO = @@L2VNO  
  
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
      
   CLOSE @@L2CUR    
   DEALLOCATE @@L2CUR  
  
  SELECT  
   'FILE UPLOADED SUCCESSFULLY',  
   'NA',  
   'NA',  
   'NA'  
    
  UNION ALL   
  
  SELECT   
   'CREDIT_BANKCODE',   
   'DEBIT_BANKCODE',   
   'AMOUNT',   
   'VNO'   
  
  UNION ALL   
  
  SELECT   
   CREDIT_BANKCODE,   
   DEBIT_BANKCODE,   
   CONVERT(VARCHAR, AMOUNT),   
   VNO   
  FROM   
   #CONTRA_TABLE  
   
  DROP TABLE #CONTRA_TABLE_TMP   
  DROP TABLE #CONTRA_TABLE   
  
 COMMIT TRAN

GO
