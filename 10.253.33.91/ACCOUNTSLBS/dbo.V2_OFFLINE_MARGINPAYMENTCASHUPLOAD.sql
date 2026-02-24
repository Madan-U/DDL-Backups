-- Object: PROCEDURE dbo.V2_OFFLINE_MARGINPAYMENTCASHUPLOAD
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC [dbo].[V2_OFFLINE_MARGINPAYMENTCASHUPLOAD](

           @UNAME     VARCHAR(25),
           @USERCAT   INT,
           @EXCHANGE  VARCHAR(3),
           @SEGMENT   VARCHAR(10),
		   @IP_VDATE varchar(11),
           @RECOFLAG  CHAR(1) = 'N')

AS

--SET XACT_ABORT ON
/*
V2_OFFLINE_MARGINPAYMENTCASHUPLOAD 'OFFLINE', 1, 'NSE', 'CAPITAL', 'NOV 21 2008','N'
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
           @@RECPAYTBLCOUNT BIGINT


 SET @@VTYP = 23

       BEGIN TRAN

  CREATE TABLE [#RECPAY_TABLE] (
    SNO    INT   IDENTITY ( 1,1 ),
    EDATE        VARCHAR(20),
    VOUCHER_DATE VARCHAR(20),
    CLIENT_CODE  VARCHAR(50),
	MCLIENT_CODE  VARCHAR(50),
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
    BANKCOST     SMALLINT   NULL,
    LNO          SMALLINT   NOT NULL DEFAULT (0),
    BANKNAME     VARCHAR(100)   NULL,
    MICRNO       INT   NULL,
    BOOKTYPE     VARCHAR(2)   NULL,
    ACC_NO       VARCHAR(16),
	SETT_NO		 VARCHAR(7),
	SETT_TYPE	 VARCHAR(3))
  ON [PRIMARY]

  /* POPULATE APPROVED RECORDS FROM OFFLINE ENTRIES TABLE TO TEMP TABLE FOR THE EXCHANGE-SEGMENT */
  INSERT INTO #RECPAY_TABLE
             (EDATE,
              VOUCHER_DATE,
              CLIENT_CODE,
			  MCLIENT_CODE,
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
              ACC_NO,
			  VTYP,
			  SETT_NO,
			  SETT_TYPE)
  SELECT CONVERT(VARCHAR,EDATE,103),
         CONVERT(VARCHAR,VDATE,103),
         CLTCODE,
		 MARGINCODE,
         DEBITAMT,
         'D',
         NARRATION,
         OPPCODE,
         BANKNAME,
         DDNO,
         'ALL',
         BRANCHNAME,
         CHEQUEMODE,
         CONVERT(VARCHAR,CHEQUEDATE,103),
         CHEQUENAME,
         CLEAR_MODE,
         FLDAUTO,
         ADDBY,
		 VDATE,
         EDATE,
         CHEQUEDATE,
         TPAccountNumber,
		 VOUCHERTYPE,
		 SETT_NO,
		 SETT_TYPE
  FROM   ACCOUNT.DBO.V2_OFFLINE_LEDGER_ENTRIES WITH(NOLOCK)
  WHERE  VOUCHERTYPE = @@VTYP
         AND EXCHANGE = @EXCHANGE
         AND SEGMENT = @SEGMENT
         AND ISNULL(ROWSTATE,0) = 0
   AND ISNULL(APPROVALFLAG,0) = 1
   AND VDATE LIKE @IP_VDATE + '%'



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
     ROLLBACK TRANSACTION                                           SET @ERRORCODE = 1
     SET @MESSAGE = 'FILE CANNOT BE UPLOADED WITH MULTIPLE VDTs.'
     EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
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
             BANKNAME = B.LONGNAME,
             BOOKTYPE = B.BOOKTYPE,
             MICRNO = ISNULL(B.MICRNO,0)
      FROM   ACMAST A WITH(NOLOCK),
             PARAMETER P WITH(NOLOCK),
             COSTMAST C WITH(NOLOCK),
             ACMAST B WITH(NOLOCK)
      WHERE  A.CLTCODE = MCLIENT_CODE
             AND B.CLTCODE = BANK_CODE
             --AND P.CURYEAR = 1
			 AND #RECPAY_TABLE.VDT BETWEEN SDTCUR AND LDTCUR
             AND A.ACCAT IN ('3','4','18')
             AND B.ACCAT = '1'
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
             BANKNAME = B.LONGNAME,
             BOOKTYPE = B.BOOKTYPE,
             MICRNO = ISNULL(B.MICRNO,0)
      FROM   ACMAST A WITH(NOLOCK),
             PARAMETER P WITH(NOLOCK),
             COSTMAST C WITH(NOLOCK),
             ACMAST B WITH(NOLOCK)
      WHERE  A.CLTCODE = MCLIENT_CODE
             AND B.CLTCODE = BANK_CODE
             --AND P.CURYEAR = 1
			 AND #RECPAY_TABLE.VDT BETWEEN SDTCUR AND LDTCUR
             AND A.ACCAT IN ('3','4','18','14')
             AND B.ACCAT = '1'
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
             BANKNAME = B.LONGNAME,
             BOOKTYPE = B.BOOKTYPE,
             MICRNO = ISNULL(B.MICRNO,0)
      FROM   ACMAST A WITH(NOLOCK),
			 PARAMETER P WITH(NOLOCK),
             --COSTMAST C WITH(NOLOCK),
             ACMAST B WITH(NOLOCK)
      WHERE  A.CLTCODE = MCLIENT_CODE
             AND B.CLTCODE = BANK_CODE
             --AND P.CURYEAR = 1
			 AND #RECPAY_TABLE.VDT BETWEEN SDTCUR AND LDTCUR
             AND A.ACCAT IN ('3','4','18','14')
             AND B.ACCAT = '1'
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
             BANKNAME = B.LONGNAME,
             BOOKTYPE = B.BOOKTYPE,
             MICRNO = ISNULL(B.MICRNO,0)
      FROM   ACMAST A WITH(NOLOCK),
             ACMAST B WITH(NOLOCK)
      WHERE  A.CLTCODE = CLIENT_CODE
             AND B.CLTCODE = BANK_CODE
             AND A.ACCAT IN ('3','4','18','14')
             AND B.ACCAT = '1'
    END

  /* ------ VALIDATION FOR CURRENT FINANCIAL YEAR DATE RANGE---------- */
  SELECT @@ERROR_COUNT = COUNT(SNO)
  FROM   #RECPAY_TABLE
  WHERE  VDT NOT BETWEEN FYSTART AND FYEND

  IF @@ERROR_COUNT > 0
    BEGIN
    DROP TABLE #RECPAY_TABLE
    ROLLBACK TRAN
    SET @ERRORCODE = 1
    SET @MESSAGE = 'SOME OF THE VOUCHERS ARE NOT BETWEEN THE CURRENT FINANCIAL YEAR DATE RANGE.'
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
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
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
    RETURN
    END
            /*----------VALIDATION FOR ZERO AMOUNT --------*/
  SELECT @@ERROR_COUNT = COUNT(1)
  FROM   #RECPAY_TABLE
  WHERE  AMOUNT <= 0

  IF @@ERROR_COUNT > 0
    BEGIN
    DROP TABLE #RECPAY_TABLE
    ROLLBACK TRAN
    SET @ERRORCODE = 1
    SET @MESSAGE ='VOUHER AMOUNT SHOULD BE ALWAY GRATER THAN 0'
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
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
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
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
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
    RETURN
    END

  /*    ----------AUTO GENERATION OF VNO -------- */
  SET @@VNOCUR = CURSOR FOR SELECT DISTINCT BANK_CODE,
         BOOKTYPE
                            FROM   #RECPAY_TABLE WITH (NOLOCK)

  OPEN @@VNOCUR

  FETCH NEXT FROM @@VNOCUR
  INTO @@BANK_CODE,
       @@BOOKTYPE

  WHILE @@FETCH_STATUS = 0
    BEGIN
      IF @@BRANCHFLAG = 1
        BEGIN
          SELECT @@BANKBRANCH = BRANCHCODE,
                 @@BANKCOST = ISNULL(C.COSTCODE,-1)
          FROM   ACMAST A WITH(NOLOCK)
                 LEFT OUTER JOIN COSTMAST C WITH(NOLOCK)
                   ON (A.BRANCHCODE = C.COSTNAME)
          WHERE  A.CLTCODE = @@BANK_CODE

          IF @@BANKBRANCH <> 'ALL'
            BEGIN
              UPDATE RP
              SET    COSTCODE = @@BANKCOST
              FROM   #RECPAY_TABLE RP,
                     ACMAST A WITH(NOLOCK)
              WHERE  A.CLTCODE = RP.CLIENT_CODE
                     AND A.BRANCHCODE = 'ALL'

        UPDATE #RECPAY_TABLE
              SET    BANKCOST = @@BANKCOST
              WHERE  BANK_CODE = @@BANK_CODE
            END
          ELSE
            BEGIN
              UPDATE #RECPAY_TABLE
              SET    COSTCODE = (SELECT TOP 1 COSTCODE
                                 FROM   COSTMAST WITH(NOLOCK)
                                 WHERE  COSTNAME = 'HO')
              WHERE  COSTCODE = ''
                     AND BANK_CODE = @@BANK_CODE

              SET @@COSTCODEUPDATES = CURSOR FOR SELECT   SNO,
                                    COUNT(DISTINCT COSTCODE)
                                                 FROM     #RECPAY_TABLE
                                                 WHERE    BANK_CODE = @@BANK_CODE
                                                 GROUP BY SNO
                                                 HAVING   COUNT(DISTINCT COSTCODE) > 1

              OPEN @@COSTCODEUPDATES

              FETCH NEXT FROM @@COSTCODEUPDATES
              INTO @@SERIAL_NO,
                   @@COSTCODECOUNT

              WHILE @@FETCH_STATUS = 0
                BEGIN
                  UPDATE #RECPAY_TABLE
                  SET    BANKCOST = (SELECT TOP 1 COSTCODE
                                  FROM   COSTMAST WITH(NOLOCK)
                                     WHERE  COSTNAME = 'HO')
                  WHERE  (BANKCOST = ''
                     OR BANKCOST IS NULL)
                         AND BANK_CODE = @@BANK_CODE
                         AND SNO = @@SERIAL_NO

                  FETCH NEXT FROM @@COSTCODEUPDATES
                  INTO @@SERIAL_NO,
         @@COSTCODECOUNT
                END

              CLOSE @@COSTCODEUPDATES

              DEALLOCATE @@COSTCODEUPDATES

              UPDATE #RECPAY_TABLE
              SET    BANKCOST = COSTCODE
              WHERE  BANK_CODE = @@BANK_CODE
                     AND (BANKCOST = ''
                           OR BANKCOST IS NULL)
END
        END

      CREATE TABLE #BANK_VNO (
        SRNO    INT,
        NEWSRNO INT   IDENTITY ( 1,1 ))

      INSERT INTO #BANK_VNO
      SELECT DISTINCT SNO
      FROM   #RECPAY_TABLE
      WHERE  BANK_CODE = @@BANK_CODE
          AND BOOKTYPE = @@BOOKTYPE

      SELECT @@MAXCOUNT = COUNT(DISTINCT SNO)
      FROM   #RECPAY_TABLE

      SELECT TOP 1 @@VDT = VDT
      FROM   #RECPAY_TABLE

      SELECT LASTVNO
      INTO   #VNO
      FROM  V2_LASTVNO WITH(NOLOCK)
      WHERE  1 = 2

      SELECT @@MAXVNO = MAX(NEWSRNO)
      FROM   #BANK_VNO




     IF @EXCHANGE = 'BSE' AND @SEGMENT = 'FUTURES'
     BEGIN
      INSERT INTO #VNO
      EXEC ACC_GENVNO_NEW_OFFLINE
        @@VDT ,
        @@VTYP ,
        @@BOOKTYPE ,
        @@STD_DATE ,
        @@LST_DATE ,
        @@MAXVNO
     END
     ELSE
     BEGIN
      INSERT INTO #VNO
      EXEC ACC_GENVNO_NEW
        @@VDT ,
        @@VTYP ,
        @@BOOKTYPE ,
        @@STD_DATE ,
        @@LST_DATE ,
        @@MAXVNO
     END

      SELECT @@NEWVNO = LASTVNO
      FROM   #VNO

      UPDATE RP
      SET    VNO = CONVERT(VARCHAR(12),CONVERT(NUMERIC,@@NEWVNO) + (NEWSRNO - 1))
      FROM   #RECPAY_TABLE RP,
             #BANK_VNO BV
      WHERE  RP.SNO = BV.SRNO



      DROP TABLE #VNO

      DROP TABLE #BANK_VNO

      FETCH NEXT FROM @@VNOCUR
      INTO @@BANK_CODE,
          @@BOOKTYPE
    END

  /*   ----------AUTO GENERATION OF LNO -------- */
  UPDATE #RECPAY_TABLE
 SET    LNO = 2
  WHERE  VNO IN (SELECT   VNO
                 FROM     #RECPAY_TABLE
                 GROUP BY VNO
                 HAVING   COUNT(*) = 1)




  SET @@LNOCUR = CURSOR FOR SELECT  VNO
                            FROM     #RECPAY_TABLE
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
      SELECT   VNO, SNO
      FROM     #RECPAY_TABLE WITH (NOLOCK)
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
                  WHEN VTYP = @@VTYP
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
         CLTCODE = MCLIENT_CODE,
         BOOKTYPE = BOOKTYPE,
         ENTEREDBY = ENTEREDBY,
         PDT = GETDATE(),
         CHECKEDBY = @UNAME,
         ACTNODAYS = 0,
         NARRATION
  FROM   #RECPAY_TABLE

/*======BANK SIDE RECORD======*/
  INSERT INTO #LEDGER
  SELECT   VTYP,
           VNO,
           EDT = (CASE
                    WHEN VTYP = @@VTYP
                         AND @RECOFLAG = 'Y' THEN EDT /*'DEC 31 2049'*/
         ELSE EDT
                  END),
           LNO = 1,
           BANKNAME,
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
           CLTCODE = BANK_CODE,
           BOOKTYPE = BOOKTYPE,
           ENTEREDBY = ENTEREDBY,
           PDT = GETDATE(),
           CHECKEDBY = @UNAME,
           ACTNODAYS = 0,
           NARRATION = MAX(NARRATION)
  FROM     #RECPAY_TABLE
  GROUP BY VTYP,VNO,EDT,DRCR,
           VDT,BANK_CODE,BOOKTYPE,BANKNAME,
           ENTEREDBY

/*======INSERTING ALL LEDGER RECORDS AT ONE TIME======*/
  INSERT INTO LEDGER
 (			  VTYP,
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
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
    RETURN
    END

  DROP TABLE #LEDGER
/*======INSERTING MARGINLEDGER RECORDS ======*/
  INSERT INTO MARGINLEDGER(
			  VTYP,
			  VNO,
			  LNO,
			  DRCR,
			  VDT,
			  AMOUNT,
			  PARTY_CODE,
			  EXCHANGE,
			  SEGMENT,
			  SETT_NO,
			  SETT_TYPE,
			  BOOKTYPE,
			  MCLTCODE)
  SELECT VTYP,
		 VNO,
		 LNO = 2,
		 DRCR ='D',
		 VDT,
         AMOUNT,
		 CLIENT_CODE,
		 EXCHANGE = @EXCHANGE,
		 SEGMENT = @SEGMENT,
		 SETT_NO = ISNULL(SETT_NO,''),
		 SETT_TYPE = ISNULL(SETT_TYPE,''),
		 BOOKTYPE,
		 MCLIENT_CODE
  FROM #RECPAY_TABLE

/*======BANK SIDE RECORD======*/
  INSERT INTO #LEDGER3
  SELECT   NARATNO = 1,
           NARRATION = MAX(NARRATION),
           REFNO = 0,
           VTYP,
           VNO,
           BOOKTYPE
  FROM     #RECPAY_TABLE
  GROUP BY VTYP,VNO,BOOKTYPE

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
    EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME
    RETURN
    END
ELSE
 BEGIN
      COMMIT TRAN
 END

  DROP TABLE #LEDGER3

  

UPDATE ACCOUNT.DBO.V2_OFFLINE_LEDGER_ENTRIES WITH(ROWLOCK)
SET
 ROWSTATE = 1,
 APPROVALFLAG = 1,
 UPLOADDT = GETDATE(),
 APPROVEDBY = 'SYSTEM',
 LEDGERVNO = VNO
FROM   #RECPAY_TABLE
WHERE  FLDAUTO = #RECPAY_TABLE.FLD_AUTO


DROP TABLE #RECPAY_TABLE
SET @ERRORCODE = 0
SET @MESSAGE = 'POSTED SUCCESSFULLY'
EXEC ACCOUNT.DBO.V2_OFFLINE_UPLOAD_PUTLOG  @EXCHANGE, @SEGMENT, @@VTYP, @ERRORCODE, @MESSAGE, @UNAME

--SET XACT_ABORT OFF

GO
