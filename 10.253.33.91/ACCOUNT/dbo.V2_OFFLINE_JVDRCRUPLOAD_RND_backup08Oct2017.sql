-- Object: PROCEDURE dbo.V2_OFFLINE_JVDRCRUPLOAD_RND_backup08Oct2017
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[V2_OFFLINE_JVDRCRUPLOAD_RND_backup08Oct2017](                    
                    
  @UNAME     VARCHAR(25),                    
  @USERCAT   INT,                    
  @EXCHANGE  VARCHAR(3),                    
  @SEGMENT   VARCHAR(10),                    
  @IP_VDATE  VARCHAR(11),                    
  @RECOFLAG  CHAR(1) = 'N',                    
  @VTYP   SMALLINT                    
)                    
AS                    
set XACT_ABORT          on              
  SET NOCOUNT ON                   
/*                
begin tran                
exec V2_OFFLINE_JVDRCRUPLOAD_RND 'OFFLINE',1,'NSE','CAPITAL','oct 20 2010','N',8                
rollback                
SELECT TOP 1* FROM LEDGER2            
*/                 
                    
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
     @@FLD_AUTO    AS INT,                    
           @@MAXVNO           AS INT,                    
           @@L2CUR            AS CURSOR,                    
           @@L2VNO            AS VARCHAR(12),                    
           @@ERROR_COUNT      AS BIGINT,                    
           @@FILEEXISTS       AS INT,                    
           @@SQL              AS VARCHAR(2000),                    
           @ERRORCODE         AS INT,                    
           @MESSAGE           AS VARCHAR(200),                     
     @@VOUCHERNO    AS VARCHAR(12),                    
     @@SQLPARA    AS VARCHAR(5000),                        
     @@RECPAYTBLCOUNT BIGINT,                    
     @@ACCOUNTDB VARCHAR(20),                    
     @@SHAREDB VARCHAR(20),                       
     @@ACCOUNTSVR VARCHAR(20)                    
                    
                    
                    
 SET @@VTYP = @VTYP                    
 SET @@BOOKTYPE = '01'                     
          
                    
 SELECT  @@ACCOUNTSVR = ACCOUNTSERVER                    
 FROM PRADNYA.DBO.MULTICOMPANY (NOLOCK) WHERE PRIMARYSERVER = 1 AND EXCHANGE = @EXCHANGE                     
 AND SEGMENT = @SEGMENT ORDER BY EXCHANGE                     
                    
  BEGIN TRAN                    
  CREATE TABLE [#RECPAY_TABLE] (                    
    SERIAL_NO    INT   IDENTITY ( 1,1 ),                    
    SNO INT,                  
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
 VOUCHERNO    VARCHAR(12)   NULL,            
 SRNO TINYINT )                  
  ON [PRIMARY]                    
                    
  /* POPULATE APPROVED RECORDS FROM OFFLINE ENTRIES TABLE TO TEMP TABLE FOR THE EXCHANGE-SEGMENT */                    
                    
                    
/*SET @@SQLPARA = " INSERT INTO #RECPAY_TABLE "                    
SET @@SQLPARA = @@SQLPARA + "              (SNO,EDATE, "                    
SET @@SQLPARA = @@SQLPARA + "              VOUCHER_DATE, "                    
SET @@SQLPARA = @@SQLPARA + "              CLIENT_CODE, "                    
SET @@SQLPARA = @@SQLPARA + "              AMOUNT, "                    
SET @@SQLPARA = @@SQLPARA + "          DRCR, "                    
SET @@SQLPARA = @@SQLPARA + "              NARRATION, "                    
SET @@SQLPARA = @@SQLPARA + "              BANK_CODE, "                    
SET @@SQLPARA = @@SQLPARA + "              BANK_NAME, "                    
SET @@SQLPARA = @@SQLPARA + "              REF_NO, "                    
SET @@SQLPARA = @@SQLPARA + "              BRANCHCODE, "                    
SET @@SQLPARA = @@SQLPARA + "              BRANCH_NAME, "                    
SET @@SQLPARA = @@SQLPARA + "              CHQ_MODE, "                    
SET @@SQLPARA = @@SQLPARA + "              CHQ_DATE, "                    
SET @@SQLPARA = @@SQLPARA + "              CHQ_NAME, "                    
SET @@SQLPARA = @@SQLPARA + "              CL_MODE, "                    
SET @@SQLPARA = @@SQLPARA + "              FLD_AUTO, "                    
SET @@SQLPARA = @@SQLPARA + "              ENTEREDBY, "                    
SET @@SQLPARA = @@SQLPARA + "              VDT, "                    
SET @@SQLPARA = @@SQLPARA + "              EDT, "                    
SET @@SQLPARA = @@SQLPARA + "              DDDT, "                    
SET @@SQLPARA = @@SQLPARA + "              ACC_NO,VTYP,VOUCHERNO) "                    
SET @@SQLPARA = @@SQLPARA + "  SELECT o.SNO,CONVERT(VARCHAR,EDATE,103), "                    
SET @@SQLPARA = @@SQLPARA + "         CONVERT(VARCHAR,VDATE,103), "                    
SET @@SQLPARA = @@SQLPARA + "         O.CLTCODE, "                    
SET @@SQLPARA = @@SQLPARA + "         AMOUNT = CONVERT(VARCHAR,CASE WHEN CC.CREDITAMT IS NULL THEN CASE WHEN O.CREDITAMT = '' THEN O.DEBITAMT ELSE O.CREDITAMT END ELSE CASE WHEN CC.CREDITAMT = '' THEN CC.DEBITAMT ELSE CC.CREDITAMT END END) , "            
  
   
      
         
SET @@SQLPARA = @@SQLPARA + "         DRCR = CONVERT(VARCHAR,CASE WHEN CC.CREDITAMT IS NULL THEN CASE WHEN O.CREDITAMT = '' THEN 'D' ELSE 'C' END ELSE CASE WHEN CC.CREDITAMT = '' THEN 'D' ELSE 'C' END END), "                    
SET @@SQLPARA = @@SQLPARA + "         NARRATION, "                    
SET @@SQLPARA = @@SQLPARA + "         OPPCODE, "                    
SET @@SQLPARA = @@SQLPARA + "         OPPCODENAME, "                    
SET @@SQLPARA = @@SQLPARA + "         DDNO, "                    
SET @@SQLPARA = @@SQLPARA + "         CONVERT(VARCHAR,CASE WHEN CC.COSTCODE IS NOT NULL THEN CC.COSTCODE ELSE 'ALL' END), "                    
SET @@SQLPARA = @@SQLPARA + "         'ALL', "                    
SET @@SQLPARA = @@SQLPARA + "        CHEQUEMODE, "                    
SET @@SQLPARA = @@SQLPARA + "         CONVERT(VARCHAR,CHEQUEDATE,103), "                    
SET @@SQLPARA = @@SQLPARA + "         CHEQUENAME, "              SET @@SQLPARA = @@SQLPARA + "         CLEAR_MODE, "                    
SET @@SQLPARA = @@SQLPARA + "         CONVERT(VARCHAR,O.FLDAUTO), "                     
SET @@SQLPARA = @@SQLPARA + "         O.ADDBY, "                    
SET @@SQLPARA = @@SQLPARA + "         CONVERT(VARCHAR,VDATE), "                    
SET @@SQLPARA = @@SQLPARA + "         CONVERT(VARCHAR,EDATE), "                    
SET @@SQLPARA = @@SQLPARA + "         CHEQUEDATE, "                    
SET @@SQLPARA = @@SQLPARA + "        TPACCOUNTNUMBER, CONVERT(VARCHAR,VOUCHERTYPE),VOUCHERNO "                    
IF @@ACCOUNTSVR <> @@SERVERNAME                    
 BEGIN                     
SET @@SQLPARA = @@SQLPARA + "  FROM   " + @@ACCOUNTSVR + ".ACCOUNT.DBO.V2_OFFLINE_LEDGER_ENTRIES O WITH(NOLOCK) "                    
SET @@SQLPARA = @@SQLPARA + "   LEFT OUTER JOIN "+ @@ACCOUNTSVR +".ACCOUNT.DBO.V2_OFFLINE_CC_ENTRIES CC "                    
SET @@SQLPARA = @@SQLPARA + "   ON "                    
SET @@SQLPARA = @@SQLPARA + "    O.FLDAUTO = CC.VOLE_REFNO "                    
END                    
ELSE                    
 BEGIN                    
SET @@SQLPARA = @@SQLPARA + " FROM   ACCOUNT.DBO.V2_OFFLINE_LEDGER_ENTRIES O WITH(NOLOCK) "                    
SET @@SQLPARA = @@SQLPARA + "   LEFT OUTER JOIN ACCOUNT.DBO.V2_OFFLINE_CC_ENTRIES CC "                    
SET @@SQLPARA = @@SQLPARA + "   ON "                    
SET @@SQLPARA = @@SQLPARA + "     O.FLDAUTO = CC.VOLE_REFNO "                    
END                    
SET @@SQLPARA = @@SQLPARA + "  WHERE  CONVERT(VARCHAR,VOUCHERTYPE) = '"+CONVERT(VARCHAR,@@VTYP)+"' "                     
SET @@SQLPARA = @@SQLPARA + "         AND EXCHANGE = '"+@EXCHANGE+"' "                    
SET @@SQLPARA = @@SQLPARA + "         AND SEGMENT = '"+@SEGMENT+"' "                    
SET @@SQLPARA = @@SQLPARA + "         AND CONVERT(VARCHAR,ISNULL(ROWSTATE,0)) = '0' "                    
SET @@SQLPARA = @@SQLPARA + "   AND CONVERT(VARCHAR,VDATE) LIKE '"+@IP_VDATE+"' + '%' "                    
SET @@SQLPARA = @@SQLPARA + "   AND CONVERT(VARCHAR,APPROVALFLAG) = '1' "                    
                    
EXEC(@@SQLPARA)   */            
            
 SET @@SQLPARA = " INSERT INTO #RECPAY_TABLE "                    
 SET @@SQLPARA = @@SQLPARA + "              (SNO,EDATE, "                    
 SET @@SQLPARA = @@SQLPARA + "              VOUCHER_DATE, "                    
 SET @@SQLPARA = @@SQLPARA + "              CLIENT_CODE, "                    
 SET @@SQLPARA = @@SQLPARA + "              AMOUNT, "                    
 SET @@SQLPARA = @@SQLPARA + "      DRCR, "                    
 SET @@SQLPARA = @@SQLPARA + "              NARRATION, "                    
 SET @@SQLPARA = @@SQLPARA + "              BANK_CODE, "                    
 SET @@SQLPARA = @@SQLPARA + "              BANK_NAME, "                    
 SET @@SQLPARA = @@SQLPARA + "              REF_NO, "                    
 SET @@SQLPARA = @@SQLPARA + "              BRANCHCODE, "                    
 SET @@SQLPARA = @@SQLPARA + "              BRANCH_NAME, "                    
 SET @@SQLPARA = @@SQLPARA + "              CHQ_MODE, "                    
 SET @@SQLPARA = @@SQLPARA + "              CHQ_DATE, "                    
 SET @@SQLPARA = @@SQLPARA + "              CHQ_NAME, "                    
 SET @@SQLPARA = @@SQLPARA + "              CL_MODE, "                    
 SET @@SQLPARA = @@SQLPARA + "              FLD_AUTO, "                    
 SET @@SQLPARA = @@SQLPARA + "              ENTEREDBY, "                    
 SET @@SQLPARA = @@SQLPARA + "              VDT, "                    
 SET @@SQLPARA = @@SQLPARA + "              EDT, "                    
 SET @@SQLPARA = @@SQLPARA + "              DDDT, "                    
 SET @@SQLPARA = @@SQLPARA + "              ACC_NO,VTYP,VOUCHERNO,SRNO) "             
 IF @@ACCOUNTSVR <> 'ANAND'                    
  BEGIN                     
  SET @@SQLPARA = @@SQLPARA + "  EXEC ANAND.ACCOUNT_AB.DBO.V2_OFFLINE_FILL_REC "+CONVERT(VARCHAR,@@VTYP)+",'"+@EXCHANGE+"', '"+@SEGMENT+"', '"+@IP_VDATE+"' "                
  END                    
 ELSE                    
  BEGIN                    
  SET @@SQLPARA = @@SQLPARA + " EXEC V2_OFFLINE_FILL_REC "+CONVERT(VARCHAR,@@VTYP)+",'"+@EXCHANGE+"', '"+@SEGMENT+"', '"+@IP_VDATE+"' "            
  END            
 PRINT @@SQLPARA            
 EXEC(@@SQLPARA)             
           
 SELECT @@RECPAYTBLCOUNT = COUNT(1) FROM #RECPAY_TABLE                    
                    
 IF @@RECPAYTBLCOUNT = 0                    
 BEGIN                    
  COMMIT                    
  RETURN                    
 END                    
              
                    
                    
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
             BANKNAME = '',                    
             BOOKTYPE = '01',                    
             MICRNO = '0'                    
      FROM   ACMAST A WITH(NOLOCK),                    
             PARAMETER P WITH(NOLOCK),                    
             COSTMAST C WITH(NOLOCK)                    
      WHERE  A.CLTCODE = CLIENT_CODE                    
             AND P.CURYEAR = 1                    
             AND A.ACCAT IN ('3','4','18')                    
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
       BANKNAME = '',                    
             BOOKTYPE = '01',                    
             MICRNO = '0'                    
      FROM   ACMAST A WITH(NOLOCK),                    
             PARAMETER P WITH(NOLOCK)                    
      WHERE  A.CLTCODE = CLIENT_CODE                    
             AND P.CURYEAR = 1                    
             AND A.ACCAT IN ('3','4','18')                    
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
             BANKNAME = '',                    
             BOOKTYPE = '01',                    
             MICRNO = ''                    
      FROM   ACMAST A WITH(NOLOCK),                    
             PARAMETER P WITH(NOLOCK)                    
      WHERE  A.CLTCODE = CLIENT_CODE                    
             AND P.CURYEAR = 1                    
             AND A.ACCAT IN ('3','4','18')                    
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
             BANKNAME = '',                    
             BOOKTYPE = '01',                    
             MICRNO = ''                    
      FROM   ACMAST A WITH(NOLOCK)                    
      WHERE  A.CLTCODE = CLIENT_CODE                 
             AND A.ACCAT IN ('3','4','18')                    
                    
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
                    
  /*----------AUTO GENERATION OF VNO -------- */                    
 CREATE TABLE                      
    #BANK_VNO                      
    (                      
     VOUCHERNO VARCHAR(12),                  
  SNO INT,                      
     NEWSRNO INT IDENTITY (1, 1)                      
    )                      
                      
   INSERT INTO                      
    #BANK_VNO                      
   SELECT                      
    DISTINCT VOUCHERNO,SNO                      
   FROM                      
    #RECPAY_TABLE         
     ORDER BY          
   VOUCHERNO, SNO                       
                         
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
    LASTVNO                      
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
   AND RP.SNO = BV.SNO             
          
          
            
                 
   DROP TABLE #VNO                      
   DROP TABLE #BANK_VNO                         
                     
/* '-----------AUTO GENERATION OF LNO --------------*/                    
--bhrt               
            
UPDATE #RECPAY_TABLE SET LNO = LNO + (SELECT SUM(SRNO) FROM #RECPAY_TABLE L1           
WHERE #RECPAY_TABLE.VNO = L1.VNO AND #RECPAY_TABLE.SERIAL_NO <= L1.SERIAL_NO)           
          
             
                
  /*CREATE TABLE [#RECPAY_TABLE_LNO]                    
 (                    
  SNO VARCHAR(12) ,                    
  FLD_AUTO INT,                    
  LNO INT IDENTITY (1, 1) NOT NULL                    
 ) ON [PRIMARY]                    
           
 SET @@LNOCUR = CURSOR FOR                    
  SELECT DISTINCT VOUCHERNO, FLD_AUTO FROM #RECPAY_TABLE                    
 OPEN @@LNOCUR                    
  FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO, @@FLD_AUTO                    
 WHILE @@FETCH_STATUS = 0                    
  BEGIN                    
                    
   INSERT INTO #RECPAY_TABLE_LNO                    
    (SNO, FLD_AUTO)                    
   SELECT DISTINCT VOUCHERNO, FLD_AUTO FROM #RECPAY_TABLE WHERE VOUCHERNO = @@LNOVNO                    
   UPDATE RP                    
    SET LNO = RL.LNO                    
   FROM #RECPAY_TABLE RP, #RECPAY_TABLE_LNO RL                    
   WHERE RP.VOUCHERNO = RL.SNO AND RP.FLD_AUTO = RL.FLD_AUTO                    
   TRUNCATE TABLE #RECPAY_TABLE_LNO                    
   FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO, @@FLD_AUTO                    
  END                    
 CLOSE @@LNOCUR                    
 DEALLOCATE @@LNOCUR                    
 DROP TABLE #RECPAY_TABLE_LNO     */               
                    
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
    NARRATION VARCHAR(234),                 
      BRANCHCODE VARCHAR(10))          
                  
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
              NARRATION,                   
 BRANCHCODE)        
  SELECT VTYP,                    
         VNO,                    
         EDT = (CASE                    
                  WHEN VTYP = @@VTYP       
                       AND @RECOFLAG = 'Y' THEN EDT /*'DEC 31 2049'*/                    
                 ELSE EDT                    
                END),                    
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
         CLTCODE = CLIENT_CODE,                    
      BOOKTYPE = BOOKTYPE,                    
         ENTEREDBY = ENTEREDBY,                    
         PDT = GETDATE(),                    
         CHECKEDBY = @UNAME,                    
         ACTNODAYS = 0,                    
         NARRATION ,                   
BRANCHCODE         
  FROM   #RECPAY_TABLE                    
  GROUP BY                    
   VTYP,                    
      VNO,                    
         (CASE                    
                  WHEN VTYP = @@VTYP                    
                       AND @RECOFLAG = 'Y' THEN EDT /*'DEC 31 2049'*/                    
                  ELSE EDT                    
                END),                    
         LNO,                    
         ACNAME,                    
         DRCR,                    
         VDT,                    
         CLIENT_CODE,                    
         BOOKTYPE,                    
         ENTEREDBY,                    
         NARRATION ,                   
               BRANCHCODE        
                    
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
    DROP TABLE #RECPAY_TABLE                    
    ROLLBACK TRAN                    
    SET @ERRORCODE = 1                    
    SET @MESSAGE ='DUE TO ERROR IN LEDGER POSTING, THE FILE COULD NOT BE UPLOADED.'                    
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME                    
    RETURN                    
    END                    
                    
                    
IF @@BRANCHFLAG = 1                      
    BEGIN               
              
 SELECT * INTO #LEDGER2 FROM LEDGER2 WHERE 1 = 2              
              
 INSERT INTO #LEDGER2              
 SELECT VTYP, VNO, LNO, DRCR, VAMT, COSTCODE, L.BOOKTYPE, L.CLTCODE              
 FROM #LEDGER L, COSTMAST C, ACMAST A WHERE               
 L.CLTCODE = A.CLTCODE AND C.COSTNAME = L.BRANCHCODE --CASE WHEN UPPER(A.BRANCHCODE) = 'ALL' THEN 'HO' ELSE A.BRANCHCODE END              
              
 INSERT INTO #LEDGER2              
 SELECT VTYPE, VNO, LNO, CASE WHEN DRCR = 'C' THEN 'D' ELSE 'C' END, CAMT, COSTCODE, BOOKTYPE, 'HOCTRL'              
 FROM #LEDGER2 WHERE COSTCODE IN(SELECT COSTCODE FROM COSTMAST WHERE COSTNAME <> 'HO')              
    AND vno not in (SELECT VNO FROM #LEDGER2 GROUP BY VNO, COSTCODE HAVING COUNT(1) > 1)                     
 DECLARE @@COSTCODE INT              
              
 SELECT @@COSTCODE = COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO'              
              
 INSERT INTO #LEDGER2              
 SELECT VTYPE, VNO, LNO, DRCR, CAMT, @@COSTCODE, BOOKTYPE, BRCONTROLAC              
 FROM #LEDGER2 L2, BRANCHACCOUNTS B, COSTMAST C              
 WHERE L2.COSTCODE = C.COSTCODE AND COSTNAME <> 'HO' AND CLTCODE <> 'HOCTRL'              
 AND COSTNAME = BRANCHNAME               
 AND vno not in (SELECT VNO FROM #LEDGER2 GROUP BY VNO, COSTCODE HAVING COUNT(1) > 1)                
              
 INSERT INTO LEDGER2 (VTYPE,VNO,LNO,DRCR,CAMT,COSTCODE,BOOKTYPE,CLTCODE )                   
 SELECT VTYPE,VNO,LNO,DRCR,CAMT,COSTCODE,BOOKTYPE,CLTCODE FROM #LEDGER2              
                    
      /*SET @@L2CUR = CURSOR FOR SELECT   DISTINCT VNO                      
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
                 CLIENT_CODE,                      
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
      WHERE       SESSIONID = '9999999999'    */                  
 END                      
              
            
DROP TABLE #LEDGER              
                    
            
IF @@ACCOUNTSVR <> 'ANAND'          
 BEGIN                     
 SET @@SQLPARA = " EXEC ANAND.ACCOUNT_AB.DBO.V2_OFFLINE_REV_UPDATE '" + @@NEWVNO + "','" + @EXCHANGE + "','" + @SEGMENT + "' "            
 END                    
ELSE                    
 BEGIN                    
 SET @@SQLPARA = " EXEC V2_OFFLINE_REV_UPDATE '" + @@NEWVNO + "','" + @EXCHANGE + "','" + @SEGMENT + "' "            
END               
print @@SQLPARA                 
EXEC(@@SQLPARA)               
               
COMMIT TRAN                         
                        
DROP TABLE #RECPAY_TABLE                        
SET @ERRORCODE = 0                        
SET @MESSAGE = 'POSTED SUCCESSFULLY'                        
EXEC ANAND.ACCOUNT_AB.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME                        
                        
SET XACT_ABORT OFF

GO
