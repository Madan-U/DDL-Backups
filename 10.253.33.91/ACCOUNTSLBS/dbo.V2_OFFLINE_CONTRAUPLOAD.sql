-- Object: PROCEDURE dbo.V2_OFFLINE_CONTRAUPLOAD
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROC [dbo].[V2_OFFLINE_CONTRAUPLOAD](    
    
  @UNAME     VARCHAR(25),    
  @USERCAT   INT,    
  @EXCHANGE  VARCHAR(3),    
  @SEGMENT   VARCHAR(10),    
  @IP_VDATE varchar(11),    
  @RECOFLAG  CHAR(1) = 'N'    
)    
AS
/*    
V2_OFFLINE_CONTRAUPLOAD 'OFFLINE',1,'NSE','CAPITAL','DEC 29 2008','N'    
*/    
    
    
  SET NOCOUNT ON    
    
  /*---------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR --------*/    
  DECLARE  @@STD_DATE        VARCHAR(11),    
           @@LST_DATE        VARCHAR(11),    
           @@BRANCHFLAG       AS TINYINT,    
           @@VNOFLAG          AS TINYINT,    
           @@VNOMETHOD       INT,    
           @@ACNAME          CHAR(100),    
           @@BOOKTYPE        CHAR(2),    
           @@MICRNO          VARCHAR(10),    
           @@DRCR            VARCHAR(1),    
           @@VTYP            SMALLINT,    
           @@BANK_CODE       VARCHAR(100),    
           @@BACKDAYS        INT,    
           @@BACKDATE        VARCHAR(11),    
           @@BRNCOUNT        TINYINT,    
           @@MonthlyVdt      VARCHAR(11),    
           @@SERIAL_NO       INT,    
           @@COSTCODECOUNT   TINYINT,    
           @@COSTCODEUPDATES CURSOR,    
           @@NEWVNO           AS VARCHAR(12),    
           @@MAXCOUNT         AS INT,    
           @@VDT              AS VARCHAR(11),    
           @@BANKBRANCH       AS VARCHAR(10),    
           @@BANKCOST         AS NUMERIC,    
           @@LNOCUR           AS CURSOR,    
           @@VNOCUR           AS CURSOR,    
           @@LNOVNO           AS VARCHAR(12),    
           @@MAXVNO           AS INT,    
           @@L2CUR            AS CURSOR,    
           @@L2VNO            AS VARCHAR(12),    
           @@ERROR_COUNT      AS BIGINT,    
           @@FILEEXISTS       AS INT,    
           @@SQL              AS VARCHAR(2000),    
           @ERRORCODE         AS INT,    
           @MESSAGE           AS VARCHAR(200) ,  
     @@VOUCHERNO    AS VARCHAR(12),     
     @@RECPAYTBLCOUNT   BIGINT    
    
 SET @@VTYP = 5   
 SET @@BOOKTYPE = '01'   
    
 BEGIN TRAN    
    
  CREATE TABLE [#RECPAY_TABLE] (    
    SERIAL_NO    INT   IDENTITY ( 1,1 ),    
    EDATE        VARCHAR(20),    
    VOUCHER_DATE VARCHAR(20),    
    CLIENT_CODE  VARCHAR(50),    
    AMOUNT       MONEY,    
    DRCR         VARCHAR(1),    
    NARRATION    VARCHAR(234),    
    BANK_CODE    VARCHAR(10),    
    BANK_NAME    VARCHAR(100),    
    REF_NO       VARCHAR(15),    
    BRANCHCODE   VARCHAR(20),    
    BRANCH_NAME  VARCHAR(50),    
    CHQ_MODE     VARCHAR(1),    
    CHQ_DATE     VARCHAR(20),    
    CHQ_NAME     VARCHAR(100),    
    CL_MODE      VARCHAR(1),    
    FLD_AUTO     BIGINT,    
    ENTEREDBY    VARCHAR(25),    
    VDT          DATETIME   NULL,    
    FYSTART      DATETIME   NULL,    
    FYEND        DATETIME   NULL,    
    UPDFLAG      VARCHAR(1)   NOT NULL   DEFAULT ('N'),    
    EDT          DATETIME   NULL,    
    DDDT         DATETIME   NULL,    
    VNO          VARCHAR(12)   NULL,    
    VTYP         SMALLINT   NULL,    
    ACNAME       VARCHAR(100)   NULL,    
    COSTCODE     SMALLINT   NULL,    
    BANKCOST     SMALLINT   NULL,                  LNO          SMALLINT   NOT NULL   DEFAULT (0),    
    BANKNAME     VARCHAR(100)   NULL,    
    MICRNO       INT   NULL,    
    BOOKTYPE     VARCHAR(2)   NULL,    
    ACC_NO       VARCHAR(16),  
 VOUCHERNO  VARCHAR(12)   NULL)  
  ON [PRIMARY]    
    
  /* POPULATE APPROVED RECORDS FROM OFFLINE ENTRIES TABLE TO TEMP TABLE FOR THE EXCHANGE-SEGMENT */    
  INSERT INTO #RECPAY_TABLE    
             (EDATE,    
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
              FLD_AUTO,    
              ENTEREDBY,    
     VDT,    
              EDT,    
              DDDT,    
              ACC_NO,VTYP,VOUCHERNO)    
  SELECT /*CONVERT(VARCHAR,EDATE,103),*/ ---BY BHRT FOR ENTRY POST SHOULD BE GETDATE FOR FULLERTON CLIENT
		 CONVERT(VARCHAR,GETDATE(),103),      	
         CONVERT(VARCHAR,VDATE,103),    
         CLTCODE,    
         AMOUNT = CASE WHEN CREDITAMT = '' THEN DEBITAMT ELSE CREDITAMT END,  
         DECR = CASE WHEN CREDITAMT = '' THEN 'D' ELSE 'C' END,   
         NARRATION,    
         OPPCODE,    
         OPPCODENAME,    
         DDNO,    
         'ALL',    
         'ALL',    
         CHEQUEMODE,    
         CONVERT(VARCHAR,CHEQUEDATE,103),    
         CHEQUENAME,    
         CLEAR_MODE,    
         FLDAUTO,    
         ADDBY,    
         VDATE,    
         GETDATE(),    
         CHEQUEDATE,    
         TPAccountNumber='', VOUCHERTYPE,VOUCHERNO    
  FROM   ACCOUNT.DBO.V2_OFFLINE_LEDGER_ENTRIES WITH(NOLOCK)    
  WHERE  VOUCHERTYPE = @@VTYP     
         AND EXCHANGE = @EXCHANGE    
         AND SEGMENT = @SEGMENT    
         AND ISNULL(ROWSTATE,0) = 0    
   AND VDATE LIKE @IP_VDATE + '%'    
   AND APPROVALFLAG = 1    
  
    
 SELECT @@RECPAYTBLCOUNT = COUNT(1) FROM #RECPAY_TABLE    
    
 IF @@RECPAYTBLCOUNT = 0    
 BEGIN    
  COMMIT    
  RETURN    
 END    
    
    
  UPDATE ACCOUNT.DBO.V2_OFFLINE_LEDGER_ENTRIES WITH (ROWLOCK)    
  SET    ROWSTATE = 9    
  FROM   #RECPAY_TABLE    
  WHERE  FLDAUTO = #RECPAY_TABLE.FLD_AUTO    
    
  SELECT TOP 1 @@VDT = CONVERT(VARCHAR(11),VDT,109)    
  FROM   #RECPAY_TABLE    
    
  SELECT @@STD_DATE = CONVERT(VARCHAR(11),SDTCUR,109),    
         @@LST_DATE = CONVERT(VARCHAR(11),LDTCUR,109),    
         @@BRANCHFLAG = BRANCHFLAG,    
         @@VNOFLAG = VNOFLAG    
  FROM   PARAMETER WITH(NOLOCK)    
  WHERE  @@VDT BETWEEN SDTCUR AND LDTCUR    
    
  IF @@VNOFLAG <> 0    
    BEGIN    
      SELECT @@ERROR_COUNT = COUNT(DISTINCT VDT)    
      FROM   #RECPAY_TABLE    
    
      IF @@ERROR_COUNT > 1    
        BEGIN    
     DROP TABLE #RECPAY_TABLE    
     ROLLBACK TRANSACTION    
     SET @ERRORCODE = 1    
     SET @MESSAGE = 'FILE CANNOT BE UPLOADED WITH MULTIPLE VDTs.'    
     EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
     RETURN    
        END    
    END    
    
  IF @@BRANCHFLAG = 1    
    BEGIN    
      UPDATE #RECPAY_TABLE    
      SET    BRANCHCODE = A.BRANCHCODE,    
             FYSTART = P.SDTCUR,    
             FYEND = P.LDTCUR,    
             UPDFLAG = 'Y',    
             ACNAME = A.LONGNAME,    
             COSTCODE = C.COSTCODE,    
             BANKNAME = A.LONGNAME,    
             BOOKTYPE = A.BOOKTYPE,    
             MICRNO = ISNULL(A.MICRNO,0)    
      FROM   ACMAST A WITH(NOLOCK),    
             PARAMETER P WITH(NOLOCK),    
             COSTMAST C WITH(NOLOCK)    
      WHERE  A.CLTCODE = BANK_CODE    
             AND P.CURYEAR = 1    
             AND A.ACCAT = '2'    
             AND A.BRANCHCODE = COSTNAME    
    
      UPDATE #RECPAY_TABLE    
      SET    VDT = CONVERT(DATETIME,RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),    
             DDDT = CONVERT(DATETIME,RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),    
             EDT = CONVERT(DATETIME,RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),    
             FYSTART = P.SDTCUR,    
             FYEND = P.LDTCUR,    
             UPDFLAG = 'Y',    
             ACNAME = A.LONGNAME,    
             COSTCODE = (SELECT TOP 1 COSTCODE    
                         FROM   COSTMAST    
                         WHERE  COSTNAME = #RECPAY_TABLE.BRANCHCODE),    
             BANKNAME = A.LONGNAME,    
             BOOKTYPE = A.BOOKTYPE,    
             MICRNO = ISNULL(A.MICRNO,0)    
      FROM   ACMAST A WITH(NOLOCK),    
             PARAMETER P WITH(NOLOCK),    
             COSTMAST C WITH(NOLOCK)    
      WHERE  A.CLTCODE = BANK_CODE    
             AND P.CURYEAR = 1    
             AND A.ACCAT = '2'    
             AND A.BRANCHCODE = 'ALL'    
             AND #RECPAY_TABLE.BRANCHCODE <> 'ALL'    
    
      UPDATE #RECPAY_TABLE    
      SET    BRANCHCODE = 'HO',    
             VDT = CONVERT(DATETIME,RIGHT(VOUCHER_DATE,4) + '-' + SUBSTRING(VOUCHER_DATE,4,2) + '-' + LEFT(VOUCHER_DATE,2)),    
             DDDT = CONVERT(DATETIME,RIGHT(CHQ_DATE,4) + '-' + SUBSTRING(CHQ_DATE,4,2) + '-' + LEFT(CHQ_DATE,2)),    
             EDT = CONVERT(DATETIME,RIGHT(EDATE,4) + '-' + SUBSTRING(EDATE,4,2) + '-' + LEFT(EDATE,2)),    
             FYSTART = P.SDTCUR,    
             FYEND = P.LDTCUR,    
    UPDFLAG = 'Y',    
             ACNAME = A.LONGNAME,    
             COSTCODE = (SELECT TOP 1 COSTCODE    
                         FROM   COSTMAST    
             WHERE  COSTNAME = 'HO'),    
             BANKNAME = A.LONGNAME,    
             BOOKTYPE = A.BOOKTYPE,    
             MICRNO = ISNULL(A.MICRNO,0)    
      FROM   ACMAST A WITH(NOLOCK),    
             PARAMETER P WITH(NOLOCK),    
             COSTMAST C WITH(NOLOCK)    
     WHERE  A.CLTCODE = BANK_CODE    
             AND P.CURYEAR = 1    
             AND A.ACCAT = '2'    
             AND A.BRANCHCODE = 'ALL'    
             AND #RECPAY_TABLE.BRANCHCODE = 'ALL'    
    END    
 ELSE    
    BEGIN    
      UPDATE #RECPAY_TABLE    
      SET    FYSTART = @@STD_DATE,    
             FYEND = @@LST_DATE + ' 23:59:59',    
             UPDFLAG = 'Y',    
             ACNAME = A.LONGNAME,    
             BANKNAME = A.LONGNAME,    
             BOOKTYPE = A.BOOKTYPE,    
             MICRNO = ISNULL(A.MICRNO,0)    
      FROM   ACMAST A WITH(NOLOCK)    
      WHERE  A.CLTCODE = BANK_CODE  
             AND A.ACCAT = '2'    
    END    
    
  /* ------ VALIDATION FOR CURRENT FINANCIAL YEAR DATE RANGE---------- */    
  SELECT @@ERROR_COUNT = COUNT(SERIAL_NO)    
  FROM   #RECPAY_TABLE    
  WHERE  VDT NOT BETWEEN FYSTART AND FYEND    
    
  IF @@ERROR_COUNT > 0    
    BEGIN    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE = 'SOME OF THE VOUCHERS ARE NOT BETWEEN THE CURRENT FINANCIAL YEAR DATE RANGE.'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END    
    
  SET @@ERROR_COUNT = 0    
    
  /*----------VALIDATION FOR VOUCHER DATE GRATER THAN EFFECTIVE DATE --------*/    
  SELECT @@ERROR_COUNT = COUNT(1)    
  FROM   #RECPAY_TABLE    
  WHERE  VDT > EDT    
    
  IF @@ERROR_COUNT > 0    
    BEGIN    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE ='VOUHER DATE CAN NOT BE GRATER THAT EFFECTIVE DATE.'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END    
            /*----------VALIDATION FOR ZERO AMOUNT --------*/    
 /* SELECT @@ERROR_COUNT = COUNT(1)    
  FROM   #RECPAY_TABLE    
  WHERE  AMOUNT <= 0    
    
  IF @@ERROR_COUNT > 0    
    BEGIN    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE ='VOUHER AMOUNT SHOULD BE ALWAY GRATER THAN 0'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END  */  
  
 /*-----------VALIDATION FOR DRCR MISMATCH IN SAME VOUCHER ----*/   
   SELECT @@ERROR_COUNT = COUNT(1) FROM  
 (SELECT AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END)  
 FROM #RECPAY_TABLE  
 HAVING SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) <> 0) A  
  
 IF @@ERROR_COUNT > 0  
   BEGIN  
   DROP TABLE #RECPAY_TABLE  
   ROLLBACK TRAN  
   SET @ERRORCODE = 1  
   SET @MESSAGE ='DEBIT AND CREDIT TOTALS DO NOT MATCH IN SOME VOUCHERS.'  
      EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME  
      RETURN  
      END  
    
  /*   ----------VALIDATION FOR CHEQUE NUMBER -------- */    
  SELECT @@ERROR_COUNT = COUNT(1)    
  FROM   (SELECT DISTINCT DDNO = RP.REF_NO,    
                          CLTCODE = RP.CLIENT_CODE    
   FROM   #RECPAY_TABLE RP,    
                 LEDGER L WITH(NOLOCK),    
                 LEDGER1 L1 WITH(NOLOCK)    
          WHERE  L1.DDNO = RP.REF_NO    
                 AND L1.DD = RP.CHQ_MODE    
                 AND L1.DRCR = @@DRCR    
                 AND L1.VTYP = @@VTYP    
                 AND RP.REF_NO <> 0    
                 AND L.VTYP = @@VTYP    
                 AND L.VNO = L1.VNO    
                 AND L.BOOKTYPE = L1.BOOKTYPE    
                 AND L.DRCR = @@DRCR    
                 AND L.CLTCODE = RP.CLIENT_CODE) A    
    
  IF @@ERROR_COUNT > 0    
    BEGIN    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE ='DATA CANNOT BE UPLOADED AS THE SOME CHEQUE NUMBERS ALREADY EXISTS'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END    
    
  /*----------FINAL VALIDATION BASED ON UPDFLAG --------*/    
  SELECT @@ERROR_COUNT = COUNT(1)    
  FROM   (SELECT DISTINCT CLIENT_CODE    
          FROM   #RECPAY_TABLE    
          WHERE  UPDFLAG = 'N') A    
    
  IF @@ERROR_COUNT > 0    
    BEGIN    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE ='DATA CANNOT BE UPLOADED AS THE SOME CLIENTS DO NOT EXIST'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END    
    
  /*    ----------AUTO GENERATION OF VNO -------- */    
 CREATE TABLE    
    #BANK_VNO    
    (    
     VOUCHERNO VARCHAR(12),    
     NEWSRNO INT IDENTITY (1, 1)    
    )    
    
   INSERT INTO    
    #BANK_VNO    
   SELECT    
    DISTINCT VOUCHERNO    
   FROM    
    #RECPAY_TABLE    
       
   SELECT TOP 1    
    @@VDT = VDT    
   FROM    
    #RECPAY_TABLE    
    
   SELECT    
    @@STD_DATE = LEFT(SDTCUR, 11),    
    @@LST_DATE = LEFT(LDTCUR, 11),    
    @@VNOMETHOD = VNOFLAG    
   FROM    
    PARAMETER    
   WHERE    
    @@VDT BETWEEN SDTCUR AND LDTCUR    
    
   SELECT    
    @@MAXCOUNT = COUNT(DISTINCT VOUCHERNO)    
   FROM    
    #RECPAY_TABLE    
    
   SELECT    
    LASTVNO    
   INTO #VNO    
   FROM    
    V2_LASTVNO    
   WHERE    
    1 = 2    
    
   SELECT @@MAXVNO = MAX(NEWSRNO) FROM #BANK_VNO    
    
   INSERT INTO    
    #VNO    
   EXEC     
    ACC_GENVNO_NEW    
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
   SET     
    VNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC,@@NEWVNO) + (NEWSRNO - 1))    
   FROM    
    #RECPAY_TABLE RP,    
    #BANK_VNO BV    
   WHERE    
      RP.VOUCHERNO = BV.VOUCHERNO  
    
   DROP TABLE #VNO    
   DROP TABLE #BANK_VNO       
    
  /*   ----------AUTO GENERATION OF LNO -------- */    
  --bhrt  
  CREATE TABLE [#RECPAY_TABLE_LNO]  
 (  
  SNO VARCHAR(12) ,  
  LNO INT IDENTITY (1, 1) NOT NULL  
 ) ON [PRIMARY]  
  
 SET @@LNOCUR = CURSOR FOR  
  SELECT DISTINCT VOUCHERNO FROM #RECPAY_TABLE  
 OPEN @@LNOCUR  
  FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO  
 WHILE @@FETCH_STATUS = 0  
  BEGIN  
  
   INSERT INTO #RECPAY_TABLE_LNO  
    (SNO)  
   SELECT SERIAL_NO FROM #RECPAY_TABLE WHERE VOUCHERNO = @@LNOVNO  
   UPDATE RP  
    SET LNO = RL.LNO  
   FROM #RECPAY_TABLE RP, #RECPAY_TABLE_LNO RL  
   WHERE RP.SERIAL_NO = RL.SNO  
   TRUNCATE TABLE #RECPAY_TABLE_LNO  
   FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO  
  END  
 CLOSE @@LNOCUR  
 DEALLOCATE @@LNOCUR  
 DROP TABLE #RECPAY_TABLE_LNO  
    
  /* ----------BEGIN POSTING TO TRANSACTION TABLES -------- */    
  INSERT INTO LEDGER1    
             (BNKNAME,    
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
              CLEAR_MODE)    
  SELECT   BNKNAME = MAX(BANK_NAME),    
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
           LNO,    
           DRCR,    
           BOOKTYPE = BOOKTYPE,    
           MICRNO = MICRNO,    
           SLIPNO = 0,    
           SLIPDATE = '',    
           CHEQUEINNAME = MAX(ISNULL(CHQ_NAME,'')),    
           CHQPRINTED = 0,    
           CLEAR_MODE = MAX(CL_MODE)    
  FROM     #RECPAY_TABLE    
  GROUP BY VTYP,VNO,LNO,DRCR,BOOKTYPE,    
           MICRNO    
    
  IF @@ERROR <> 0    
    BEGIN    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE ='DUE TO ERROR IN LEDGER1 POSTING, THE FILE COULD NOT BE UPLOADED.'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END    
  
/*==CREATING LEDGER AND LEDGER3 STRUCTURE TO INSERT IN BULK=====*/    
  CREATE TABLE #LEDGER (    
    VTYP      SMALLINT,    
    VNO       VARCHAR(12),    
    EDT       DATETIME,    
    LNO       SMALLINT,    
    ACNAME    VARCHAR(100),    
    DRCR      VARCHAR(1),    
    VAMT      MONEY,    
    VDT       DATETIME,    
    VNO1      VARCHAR(12),    
    REFNO     CHAR(12),    
    BALAMT    MONEY,    
    NODAYS    INT,    
    CDT       DATETIME,    
    CLTCODE   VARCHAR(10),    
    BOOKTYPE  VARCHAR(2),    
    ENTEREDBY VARCHAR(25),    
    PDT       DATETIME,    
    CHECKEDBY VARCHAR(25),    
    ACTNODAYS INT,    
    NARRATION VARCHAR(234))    
    
  CREATE TABLE #LEDGER3 (    
    NARATNO  INT,    
    NARR     VARCHAR(234),    
    REFNO    CHAR(12),    
    VTYP     SMALLINT,    
    VNO      VARCHAR(12),    
    BOOKTYPE VARCHAR(2))    
    
/*======CLIENT SIDE RECORD======*/    
  INSERT INTO #LEDGER    
             (VTYP,    
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
              NARRATION)    
  SELECT VTYP,    
         VNO,    
         EDT = (CASE    
                  WHEN VTYP = 5    
                       AND @RECOFLAG = 'Y' THEN EDT /*'DEC 31 2049'*/    
                  ELSE EDT    
                END),    
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
         CLTCODE = BANK_CODE,    
         BOOKTYPE = BOOKTYPE,    
         ENTEREDBY = ENTEREDBY,    
         PDT = GETDATE(),    
         CHECKEDBY = @UNAME,    
         ACTNODAYS = 0,    
         NARRATION    
  FROM   #RECPAY_TABLE    
    
/*======INSERTING ALL LEDGER RECORDS AT ONE TIME======*/    
  INSERT INTO LEDGER    
             (VTYP,    
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
              NARRATION)    
  SELECT   VTYP,    
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
  FROM     #LEDGER    
  ORDER BY BOOKTYPE,    
           VTYP,    
           VNO,    
           LNO    
    
  IF @@ERROR <> 0    
    BEGIN    
    DROP TABLE #LEDGER    
    DROP TABLE #LEDGER3    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE ='DUE TO ERROR IN LEDGER POSTING, THE FILE COULD NOT BE UPLOADED.'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END    
    
  DROP TABLE #LEDGER    
    
/*======CLIENT SIDE RECORD======*/    
  INSERT INTO #LEDGER3    
  SELECT NARATNO = LNO,    
         NARR = NARRATION,    
         REFNO = 0,    
         VTYP,    
         VNO,    
         BOOKTYPE    
  FROM   #RECPAY_TABLE    
    
/*======INSERTING ALL LEDGER3 RECORDS AT ONE TIME======*/    
  INSERT INTO LEDGER3    
  SELECT   *    
  FROM     #LEDGER3    
  ORDER BY BOOKTYPE,    
           VTYP,    
           VNO,    
           NARATNO    
    
  IF @@ERROR <> 0    
    BEGIN    
    DROP TABLE #LEDGER3    
    DROP TABLE #RECPAY_TABLE    
    ROLLBACK TRAN    
    SET @ERRORCODE = 1    
    SET @MESSAGE = 'DUE TO ERROR IN LEDGER3 POSTING, THE FILE COULD NOT BE UPLOADED.'    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME    
    RETURN    
    END    
  DROP TABLE #LEDGER3    
  
  IF @@BRANCHFLAG = 1    
    BEGIN    
  
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
  
  /*======CLIENT SIDE RECORD======*/    
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
                 BANK_CODE,    
                 'A',    
                 '0'    
    FROM   #RECPAY_TABLE RP,    
                 COSTMAST C WITH(NOLOCK)    
          WHERE  RP.COSTCODE = C.COSTCODE    
                 AND VNO = @@L2VNO    
    
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
  
      DELETE FROM TEMPLEDGER2 WITH(ROWLOCK)    
      WHERE       SESSIONID = '9999999999'    
 END    
  
UPDATE ACCOUNT.DBO.V2_OFFLINE_LEDGER_ENTRIES WITH(ROWLOCK)    
SET    
 ROWSTATE = 1,    
 APPROVALFLAG = 1,    
 APPROVALDATE = GETDATE(),  
 UPLOADDT = GETDATE(),   
 --APPROVEDBY = 'SYSTEM',    
 LEDGERVNO = VNO    
FROM   #RECPAY_TABLE    
WHERE  FLDAUTO = #RECPAY_TABLE.FLD_AUTO    

COMMIT TRAN    
    
DROP TABLE #RECPAY_TABLE    
SET @ERRORCODE = 0    
SET @MESSAGE = 'POSTED SUCCESSFULLY'    
EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, 2, @ERRORCODE, @MESSAGE, @UNAME

GO
