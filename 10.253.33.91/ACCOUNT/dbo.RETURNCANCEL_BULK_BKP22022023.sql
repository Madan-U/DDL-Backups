-- Object: PROCEDURE dbo.RETURNCANCEL_BULK_BKP22022023
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------




---RETURNCANCEL_BULK_NEW
--RETURNCANCEL_BULK_BKP_20220907
CREATE PROC [dbo].[RETURNCANCEL_BULK_BKP22022023] 
(
  @VTYPE   SMALLINT, 
  @FNAME   VARCHAR(100), 
  @UNAME   VARCHAR(25), 
  @USERCAT SMALLINT 
)
AS 

--DECLARE 
--@VTYPE   SMALLINT, 
--@FNAME   VARCHAR(100), 
--@UNAME   VARCHAR(25), 
--@USERCAT SMALLINT 
--SELECT @VTYPE =2, @FNAME ='J:\BackOffice\RETURN_CANCEL\CHQ RETURN KOTAK 07.09.2022 NSE.csv', @UNAME='E73403', @USERCAT=25

    /*                                               
    BEGIN TRAN                                               
    SP_HELPTRIGGER LEDGER                                               
    LEDGER_TRG_BILL                                               
    LEDGER_TRG                                               
    EXEC RECPAYUPLOAD_BULK 'D:\BACKOFFICE\RECPAYFILES\SAMPLE1.CSV', 'JAYDEEP', 388                                               
    SELECT TOP 1 * FROM LEDGER3                                               
    SELECT TOP 1 * FROM LEDGER_TRG                                               
    ROLLBACK                                               
    */ 
    SET NOCOUNT ON 
 

    /*-------------------------VALIDATION FOR SINGLE VOUCHER TYPE B ASED ON DRCR ------------------------*/ 
    DECLARE @@STD_DATE        VARCHAR(11), 
            @@LST_DATE        VARCHAR(11), 
            @@BRANCHFLAG      AS TINYINT, 
            @@VNOFLAG         AS TINYINT, 
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
            @@MONTHLYVDT      VARCHAR(11), 
            @@SERIAL_NO       INT, 
            @@COSTCODECOUNT   TINYINT, 
            @@COSTCODEUPDATES CURSOR, 
            @@NEWVNO          AS VARCHAR(12), 
            @@MAXCOUNT        AS INT, 
            @@VDT             AS VARCHAR(11), 
            @@BANKBRANCH      AS VARCHAR(10), 
            @@BANKCOST        AS NUMERIC, 
            @@LNOCUR          AS CURSOR, 
            @@VNOCUR          AS CURSOR, 
            @@LNOVNO          AS VARCHAR(12), 
            @@MAXVNO          AS INT, 
            @@L2CUR           AS CURSOR, 
            @@L2VNO           AS VARCHAR(12), 
            @@ERROR_COUNT     AS INT, 
            @@FILEEXISTS      AS INT, 
            @@SQL             AS VARCHAR(2000) 

    CREATE TABLE #FEXIST 
      ( 
         F1 SMALLINT, 
         F2 SMALLINT, 
         F3 SMALLINT 
      ) 

    SELECT @@SQL = "INSERT INTO" 

    SELECT @@SQL = @@SQL + " #FEXIST " 

    SELECT @@SQL = @@SQL + " (F1, F2, F3) " 

    SELECT @@SQL = @@SQL + "EXEC MASTER.DBO.XP_FILEEXIST '" 
                   + @FNAME + "'" 

    EXEC(@@SQL) 

    SELECT @@FILEEXISTS = F1 
    FROM   #FEXIST 

    IF @@FILEEXISTS = 0 
      BEGIN 
       IF OBJECT_ID('tempdb..#FEXIST') IS NOT NULL
          DROP TABLE #FEXIST 

          SELECT 
'THE FILE YOU ARE UPLOADING DOES NOT EXIST. PLEASE VERIFY THE PATH AND FILENAME.' 

    RETURN 
END 
IF OBJECT_ID('tempdb..#FEXIST') IS NOT NULL
    DROP TABLE #FEXIST 

    BEGIN TRAN 

    CREATE TABLE #RECPAY_TABLE_TMP 
      ( 
         PRODUCT_CO        VARCHAR(10), 
         INST_NMBR         VARCHAR(15), 
         INST_DATE         VARCHAR(10), 
         BENEF_DESCRIPTION VARCHAR(200), 
         INSTRUMENT_AMNT   VARCHAR(50), 
         LOC_DESCRIPTION   VARCHAR(100), 
         I_STAT            VARCHAR(10), 
         ENRICH_VALUE      VARCHAR(10), 
         NARRATION         VARCHAR(250),
	 DEPOSIT_FLG CHAR(1)
      ) 

    CREATE TABLE [#RECPAY_TABLE] 
      ( 
         SRNO              INT IDENTITY(1, 1), 
         PRODUCT_CO        VARCHAR(10), 
         INST_NMBR         VARCHAR(15), 
         INST_DATE         DATETIME, 
         BENEF_DESCRIPTION VARCHAR(200), 
         INSTRUMENT_AMNT   MONEY, 
         LOC_DESCRIPTION   VARCHAR(100), 
         I_STAT            VARCHAR(10), 
         ENRICH_VALUE      VARCHAR(10), 
         NARRATION         VARCHAR(250), 
	 DEPOSIT_FLG CHAR(1),
         VNO               VARCHAR(12), 
         VTYP              INT, 
         BOOKTYPE          VARCHAR(2), 
         VNO_REV           VARCHAR(12), 
         VTYP_REV          VARCHAR(12) 
      ) 
    ON [PRIMARY] 

    SELECT @@SQL = "BULK INSERT #RECPAY_TABLE_TMP FROM '" 
                   + @FNAME 
                   + "' WITH (FIELDTERMINATOR = ',', FIRSTROW = 2, KEEPNULLS)" 

    EXEC (@@SQL) 
	print (@@SQL) 

    IF @@ERROR <> 0 
      BEGIN 
      IF OBJECT_ID('tempdb..#RECPAY_TABLE_TMP') IS NOT NULL
          DROP TABLE #RECPAY_TABLE_TMP 
           IF OBJECT_ID('tempdb..#RECPAY_TABLE') IS NOT NULL
          DROP TABLE #RECPAY_TABLE 

          ROLLBACK TRANSACTION 

          SELECT 
      'DUE TO SOME ERROR IN BULK INSERT, THE FILE COULD NOT BE UPLOADED...' 

          RETURN 
      END 

       
 IF OBJECT_ID('tempdb..#BANK') IS NOT NULL
          DROP TABLE #BANK 
    CREATE TABLE #BANK 
      ( 
         CLTCODE VARCHAR(10) 
      )   
    INSERT INTO #BANK 
    SELECT LOC_DESCRIPTION 
    FROM   #RECPAY_TABLE_TMP 
    GROUP BY LOC_DESCRIPTION

    IF OBJECT_ID('tempdb..#tmpL11') IS NOT NULL
          DROP TABLE #tmpL11 
    SELECT VNO, 
            VTYP, 
            BOOKTYPE, 
            CLTCODE  INTO #tmpL11
        FROM   LEDGER L12 WITH(NOLOCK)
        WHERE  VTYP = 2 
        AND LNO = 1 
        AND EXISTS(SELECT CLTCODE 
        FROM   #BANK B 
        WHERE  L12.CLTCODE =  B.CLTCODE)
        AND  L12.VDT > DATEADD(DD,-6 ,GETDATE())

 CREATE INDEX IX_#tmpL11 On #tmpL11 (VNO) INCLUDE (VTYP,BOOKTYPE)

        IF OBJECT_ID('tempdb..#tmpInternalLdger') IS NOT NULL
          DROP TABLE #tmpInternalLdger 

    SELECT CLTCODE = L.CLTCODE, 
            BANK_CODE = L11.CLTCODE, 
            DDNO, 
            RELAMT, 
            VNO = MAX(L.VNO), 
            VTYP = MAX(L.VTYP), 
            BOOKTYPE = MAX(L.BOOKTYPE)  INTO #tmpInternalLdger
    FROM   LEDGER L  WITH(NOLOCK)
    INNER JOIN  LEDGER1 L1  WITH(NOLOCK) ON L.VNO = L1.VNO AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.LNO = L1.LNO 
    INNER JOIN  #tmpL11 L11  WITH(NOLOCK) ON L.VNO = L11.VNO AND L.VTYP = L11.VTYP AND L.BOOKTYPE = L11.BOOKTYPE 
          WHERE   L.VDT >DATEADD(DD,-5 ,GETDATE())
                                         --AND dddt >DATEADD(DD,-10 ,GETDATE())
                                         AND L1.CLEAR_MODE <> 'R' 
                                         AND L.VTYP = 2 
                                  GROUP  BY L.CLTCODE, 
                                            L11.CLTCODE, 
                                            DDNO, 
                                            RELAMT 
                                  HAVING COUNT(1) = 1
  
    Create Index IX_#tmpInternalLdger On #tmpInternalLdger (CLTCODE,DDNO) INCLUDE(RELAMT)             

    IF @VTYPE = 2 
      BEGIN 
          INSERT INTO #RECPAY_TABLE 
                      (PRODUCT_CO, 
                       INST_NMBR, 
                       INST_DATE, 
                       BENEF_DESCRIPTION, 
                       INSTRUMENT_AMNT, 
                       LOC_DESCRIPTION, 
                       I_STAT, 
                       ENRICH_VALUE, 
                       NARRATION,
		                   DEPOSIT_FLG, 
                       VNO, 
                       VTYP, 
                       BOOKTYPE) 

          SELECT          PRODUCT_CO, 
                          INST_NMBR, 
                          CONVERT(DATETIME, INST_DATE, 103), 
                          BENEF_DESCRIPTION, 
                          CONVERT(MONEY, INSTRUMENT_AMNT), 
                          LOC_DESCRIPTION, 
                          I_STAT, 
                          ENRICH_VALUE, 
                          NARRATION, 
						              DEPOSIT_FLG,
                          VNO, 
                          VTYP, 
                          BOOKTYPE 
          FROM   #RECPAY_TABLE_TMP R 
                 LEFT OUTER JOIN #tmpInternalLdger R1 
                              ON       CLTCODE = ENRICH_VALUE 
                                 AND INST_NMBR = DDNO 
                                 AND CONVERT(MONEY, INSTRUMENT_AMNT) = RELAMT 
                                 AND BANK_CODE = LOC_DESCRIPTION 
         GROUP BY         PRODUCT_CO, 
                          INST_NMBR, 
                          CONVERT(DATETIME, INST_DATE, 103), 
                          BENEF_DESCRIPTION, 
                          CONVERT(MONEY, INSTRUMENT_AMNT), 
                          LOC_DESCRIPTION, 
                          I_STAT, 
                          ENRICH_VALUE, 
                          NARRATION, 
						              DEPOSIT_FLG,
                          VNO, 
                          VTYP, 
                          BOOKTYPE 

          UPDATE #RECPAY_TABLE 
          SET    VTYP_REV = 17 , NARRATION=CASE WHEN DEPOSIT_FLG = 'N' THEN '' + NARRATION ELSE NARRATION END
      END 
    ELSE 
      BEGIN 
 IF OBJECT_ID('tempdb..#tmpInternalLdger_1') IS NOT NULL
          DROP TABLE #tmpInternalLdger_1 
          SELECT CLTCODE, 
                 DDNO, 
                 RELAMT, 
                 VNO = MAX(L.VNO), 
                 VTYP = MAX(L.VTYP), 
                 BOOKTYPE = MAX(L.BOOKTYPE) 
                 INTO #tmpInternalLdger_1
                                  FROM   LEDGER L WITH (NOLOCK)
                                         INNER JOIN  LEDGER1 L1  WITH(NOLOCK) ON L.VNO = L1.VNO AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.LNO = L1.LNO  
                                  WHERE   L.VDT >DATEADD(DD,-6 ,GETDATE())
                                       --   AND dddt >DATEADD(DD,-10 ,GETDATE())
                                         AND L1.CLEAR_MODE <> 'C' 
                                         AND L.VTYP = 3 
                                         AND L1.RELDT = '' 
                                  GROUP  BY CLTCODE, 
                                            DDNO, 
                                            RELAMT 
                                  HAVING COUNT(1) = 1

								  select * from #tmpInternalLdger_1
Create Index IX_#tmpInternalLdger_1 On #tmpInternalLdger_1 (CLTCODE,DDNO) INCLUDE(RELAMT)
              
          INSERT INTO #RECPAY_TABLE 
                      (PRODUCT_CO, 
                       INST_NMBR, 
                       INST_DATE, 
                       BENEF_DESCRIPTION, 
                       INSTRUMENT_AMNT, 
                       LOC_DESCRIPTION, 
                       I_STAT, 
                       ENRICH_VALUE, 
                       NARRATION, 
		       DEPOSIT_FLG,
                       VNO, 
                       VTYP, 
                       BOOKTYPE) 
          SELECT DISTINCT PRODUCT_CO, 
                          INST_NMBR, 
                          CONVERT(DATETIME, INST_DATE, 103), 
                          BENEF_DESCRIPTION, 
                          CONVERT(MONEY, INSTRUMENT_AMNT), 
                          LOC_DESCRIPTION, 
                          I_STAT, 
                          ENRICH_VALUE, 
                          NARRATION, 
			  DEPOSIT_FLG,
                          VNO, 
                          VTYP, 
                          BOOKTYPE 
          FROM   #RECPAY_TABLE_TMP R 
                 LEFT OUTER JOIN  #tmpInternalLdger_1 R1 
                                ON CLTCODE = ENRICH_VALUE 
                                 AND INST_NMBR = DDNO 
                                 AND CONVERT(MONEY, INSTRUMENT_AMNT) = RELAMT 


          UPDATE #RECPAY_TABLE 
          SET    VTYP_REV = 16 , NARRATION=CASE WHEN DEPOSIT_FLG = 'N' THEN 'Fund Payout Rejected ' + NARRATION ELSE NARRATION END
      END 

	  select * from #RECPAY_TABLE
--select * from #RECPAY_TABLE
---return
    /* SELECT                                               
      @@ERROR_COUNT = COUNT(1)                                               
     FROM                                               
      #RECPAY_TABLE           
     WHERE INST_DATE < CONVERT(VARCHAR(11), GETDATE()- 2, 109)         
                                                    
     IF @@ERROR_COUNT > 1                                               
      BEGIN                                               
       DROP TABLE #RECPAY_TABLE_TMP                                               
       DROP TABLE #RECPAY_TABLE                                               
       ROLLBACK TRANSACTION                                               
       SELECT 'FILE CANNOT BE UPLOADED WITH BACKDATED VDTS.'                            
       RETURN                                               
      END  */ 
    SELECT TOP 1 @@VDT = CONVERT(VARCHAR(11), INST_DATE, 109), 
                 @@VTYP = VTYP_REV, 
                 @@BOOKTYPE = BOOKTYPE 
    FROM   #RECPAY_TABLE 

    /*--------------------------VALIDATION WITH USERRIGHTS TABLE ------------------------*/ 
    SELECT @@BACKDAYS = MAX(NODAYS) 
    FROM   USERWRITESTABLE 
    WHERE  USERCATEGORY = @USERCAT 
           AND VTYP = @@VTYP 
           AND BOOKTYPE = @@BOOKTYPE 

    SELECT @@BACKDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), GETDATE(), 109)) 
                               - @@BACKDAYS 

    SELECT @@ERROR_COUNT = ISNULL(COUNT(INST_DATE), 0) 
    FROM   #RECPAY_TABLE 
    WHERE  INST_DATE < @@BACKDATE 

    IF @@ERROR_COUNT > 0 
      BEGIN 
          SELECT 
'SOME OF THE VOUCHERS ARE HAVING BACK DATED VOUCHER DATES FOR WHICH RIGHTS HAVE NOT BEEN SET' 
, 
'NA', 
'NA' 

 IF OBJECT_ID('tempdb..#RECPAY_TABLE_TMP') IS NOT NULL
    DROP TABLE #RECPAY_TABLE_TMP 
     IF OBJECT_ID('tempdb..#RECPAY_TABLE') IS NOT NULL
    DROP TABLE #RECPAY_TABLE 

    ROLLBACK TRAN 

    DELETE FROM V2_UPLOADED_FILES 
    WHERE  U_FILENAME = @FNAME 
           AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD' 

    RETURN 
END 

    SELECT @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109), 
           @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109), 
           @@BRANCHFLAG = BRANCHFLAG, 
           @@VNOFLAG = VNOFLAG 
    FROM   PARAMETER 
    WHERE  @@VDT BETWEEN SDTCUR AND LDTCUR 

    IF @@VNOFLAG <> 0 
      BEGIN 
          SELECT @@ERROR_COUNT = COUNT(DISTINCT INST_DATE) 
          FROM   #RECPAY_TABLE 

          IF @@ERROR_COUNT > 1 
            BEGIN 
            IF OBJECT_ID('tempdb..#RECPAY_TABLE_TMP') IS NOT NULL
                DROP TABLE #RECPAY_TABLE_TMP 

                IF OBJECT_ID('tempdb..#RECPAY_TABLE') IS NOT NULL
                DROP TABLE #RECPAY_TABLE 

                ROLLBACK TRANSACTION 

                SELECT 'FILE CANNOT BE UPLOADED WITH MULTIPLE VDTS.' 

                RETURN 
            END 
      END 

    SELECT @@ERROR_COUNT = COUNT(1) 
    FROM   #RECPAY_TABLE 
    WHERE  VNO IS NULL 

    IF @@ERROR_COUNT > 0 
      BEGIN 
          SELECT 
      'FILE CANNOT BE UPLOADED AS FOLLOWING ENTRIES ARE NOT FOUND IN LEDGER.' 
          UNION ALL 
          SELECT 'CLTCODE , DDNO , AMOUNT, BANK_CODE ' 
          UNION ALL 
          SELECT ENRICH_VALUE + ' , ' + INST_NMBR + ' , ' 
                 + CONVERT(VARCHAR, INSTRUMENT_AMNT) + ' , ' 
                 + LOC_DESCRIPTION AS RESULT 
          FROM   #RECPAY_TABLE 
          WHERE  VNO IS NULL 
           IF OBJECT_ID('tempdb..#RECPAY_TABLE_TMP') IS NOT NULL
          DROP TABLE #RECPAY_TABLE_TMP 
           IF OBJECT_ID('tempdb..#RECPAY_TABLE') IS NOT NULL
          DROP TABLE #RECPAY_TABLE 

          ROLLBACK TRANSACTION 

          RETURN 
      END 

    CREATE TABLE #VNO 
      ( 
         LASTVNO VARCHAR(12), 
      ) 

    SELECT @@MAXVNO = MAX(SRNO) 
    FROM   #RECPAY_TABLE 

    INSERT INTO #VNO 
    EXEC ACC_GENVNO_NEW 
      @@VDT, 
      @@VTYP, 
      @@BOOKTYPE, 
      @@STD_DATE, 
      @@LST_DATE, 
      @@MAXVNO 

    SELECT @@NEWVNO = LASTVNO 
    FROM   #VNO 

    UPDATE #RECPAY_TABLE 
    SET    VNO_REV = CONVERT(NUMERIC(12), @@NEWVNO) + SRNO - 1 

	--SELECT * INTO INDRAJIT FROM #RECPAY_TABLE
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
    SELECT VTYP_REV, 
           VNO_REV, 
           INST_DATE, 
           LNO, 
           ACNAME, 
           CASE 
             WHEN DRCR = 'D' THEN 'C' 
             ELSE 'D' 
           END, 
           VAMT, 
           INST_DATE, 
           VNO1, 
           REFNO, 
           BALAMT, 
           NODAYS, 
           GETDATE(), 
           CLTCODE, 
           L.BOOKTYPE, 
           @UNAME, 
           GETDATE(), 
           @UNAME, 
           ACTNODAYS, 
           --CASE WHEN DEPOSIT_FLG = 'N' THEN 'CHEQUE REVERSE ' END + R.NARRATION 
		   --CASE WHEN DEPOSIT_FLG = 'N' THEN 'CHEQUE REVERSE ' + R.NARRATION ELSE R.NARRATION END
		   --CASE WHEN DEPOSIT_FLG = 'N' THEN 'Fund Payout Rejected ' + R.NARRATION ELSE R.NARRATION END
		   --CASE WHEN DEPOSIT_FLG = 'N' THEN '' + R.NARRATION ELSE R.NARRATION END
		   R.NARRATION
    FROM   LEDGER L, 
           #RECPAY_TABLE R 
    WHERE  L.VNO = R.VNO 
           AND L.VTYP = R.VTYP 
           AND L.BOOKTYPE = R.BOOKTYPE 
           AND VDT > DATEADD(DD, -10 ,GETDATE())

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
    SELECT BNKNAME, 
           BRNNAME, 
           DD, 
           DDNO, 
           DDDT, 
           RELDT = CASE WHEN (DEPOSIT_FLG = 'N' AND @VTYPE = 2) or @VTYPE = 3 THEN INST_DATE ELSE '' END,
           RELAMT, 
           '',
           RECEIPTNO, 
           VTYP_REV, 
           VNO_REV, 
           LNO, 
           CASE 
             WHEN DRCR = 'D' THEN 'C' 
             ELSE 'D' 
           END, 
           L.BOOKTYPE, 
           MICRNO, 
           SLIPNO, 
           SLIPDATE, 
           CHEQUEINNAME, 
           CHQPRINTED, 
           CLEAR_MODE 
    FROM   LEDGER1 L, 
           #RECPAY_TABLE R 
    WHERE  L.VNO = R.VNO 
           AND L.VTYP = R.VTYP 
           AND L.BOOKTYPE = R.BOOKTYPE 

    INSERT INTO LEDGER2 
                (VTYPE, 
                 VNO, 
                 LNO, 
                 DRCR, 
                 CAMT, 
                 COSTCODE, 
                 BOOKTYPE, 
                 CLTCODE) 
    SELECT VTYP_REV, 
           VNO_REV, 
           LNO, 
           CASE 
             WHEN DRCR = 'D' THEN 'C' 
             ELSE 'D' 
           END, 
           CAMT, 
           COSTCODE, 
           L.BOOKTYPE, 
           CLTCODE 
    FROM   LEDGER2 L, 
           #RECPAY_TABLE R 
    WHERE  L.VNO = R.VNO 
           AND L.VTYPE = R.VTYP 
           AND L.BOOKTYPE = R.BOOKTYPE 

    INSERT INTO LEDGER3 
                (NARATNO, 
                 NARR, 
                 REFNO, 
                 VTYP, 
                 VNO, 
                 BOOKTYPE) 
    SELECT NARATNO, 
           R.NARRATION, 
           REFNO, 
           VTYP_REV, 
           VNO_REV, 
           L.BOOKTYPE 
    FROM   LEDGER3 L, 
           #RECPAY_TABLE R 
    WHERE  L.VNO = R.VNO 
           AND L.VTYP = R.VTYP 
           AND L.BOOKTYPE = R.BOOKTYPE 



--UPDATE L SET EDT = CASE WHEN (DEPOSIT_FLG = 'N' AND @VTYPE = 2) OR @VTYPE = 3 THEN INST_DATE ELSE '2049-12-31' END 
--FROM LEDGER L, #RECPAY_TABLE R 
--    WHERE  L.VNO = R.VNO 
--           AND L.VTYP = R.VTYP 
--           AND L.BOOKTYPE = R.BOOKTYPE
		   --AND L.VTYP='2'


		   
UPDATE L SET EDT = CASE WHEN( DEPOSIT_FLG = 'N' AND @VTYPE = 2) OR @VTYPE = 3 THEN INST_DATE ELSE '2049-12-31' END 
FROM LEDGER L, #RECPAY_TABLE R 
    WHERE  L.VNO = R.VNO
           AND L.VTYP = R.VTYP
           AND L.BOOKTYPE = R.BOOKTYPE
		   --AND L.VTYP='17'




    UPDATE L 
    SET    CLEAR_MODE = CASE 
                          WHEN @VTYPE = 2 THEN 'R' 
                          ELSE 'C' 
                        END, 
RELDT = CASE WHEN (DEPOSIT_FLG = 'N' AND @VTYPE = 2) OR @VTYPE = 3 THEN INST_DATE ELSE '' END 
 
    FROM   LEDGER1 L, 
           #RECPAY_TABLE R 
    WHERE  L.VNO = R.VNO 
           AND L.VTYP = R.VTYP 
           AND L.BOOKTYPE = R.BOOKTYPE 

    SELECT 'FILE UPLOADED SUCCESSFULLY' 
    UNION ALL 
    SELECT 'VNO, VTYP, RECEIPT_VNO' 
    UNION ALL 
    SELECT VNO_REV + ' , ' + VTYP_REV + ' , ' + VNO AS RESULT 
    FROM   #RECPAY_TABLE 

    COMMIT 
--ROLLBACK TRAN

GO
