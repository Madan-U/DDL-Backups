-- Object: PROCEDURE dbo.REPROCESS_RECO
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/*-----------------------------
sp_helptext REPROCESS_RECO
-----------------------------*/
--Text
CREATE PROC [dbo].[REPROCESS_RECO](
           @BANKCODE        VARCHAR(10),
           @PROCESS_DATE    VARCHAR(10),
           @PROCESS_DATE_TO VARCHAR(10))
           
AS

  SET NOCOUNT ON 

  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED

--  IF @PROCESS_DATE_TO = '' SET @PROCESS_DATE_TO = @PROCESS_DATE 

  DECLARE  @@MICRNO        VARCHAR(20),
           @@PROC_DATE     VARCHAR(11),
           @@PROC_DATE_TO  VARCHAR(11)
                           
  CREATE TABLE #BANKRECOSAVE (
    CLTCODE          VARCHAR(10),
    BOOKDATE         DATETIME,
    [DESCRIPTION]    VARCHAR(200),
    AMOUNT           MONEY,
    DRCR             CHAR(1),
    VALUEDATE        DATETIME,
    REFERENCENO      VARCHAR(30),
    CROSSREFERENCENO BIGINT,
    STATUS           VARCHAR(15),
    BR_SNO           BIGINT,
    MICRNO           VARCHAR(10),
    AMOUNTLEDGR1     MONEY,
    L1_SNO           INT,
    VTYP             SMALLINT,
    BOOKTYPE         CHAR(2),
    VNO              VARCHAR(12),
    SLIPNO           INT)
  
  IF NOT EXISTS (SELECT 1
                 FROM   SYSOBJECTS
                 WHERE  TYPE = 'U' 
                        AND NAME = 'RECOPROCESS')
    CREATE TABLE RECOPROCESS (
             INPROCESS VARCHAR(1))
      
  IF (SELECT COUNT(1) 
      FROM   RECOPROCESS) = 0 
    INSERT INTO RECOPROCESS
               (INPROCESS)
    VALUES     ('N')
    
  IF (SELECT COUNT(1) 
      FROM   RECOPROCESS
      WHERE  INPROCESS = 'N') > 0 
    BEGIN
      BEGIN TRAN
      
      UPDATE RECOPROCESS
      SET    INPROCESS = 'Y'
    END
  ELSE
    BEGIN
      SELECT 'BANK RECO UPLOAD PROCESS IS ALREADY RUNNING FROM SOME OTHER TERMINAL. PLEASE TRY AGAIN LATER.'
      
      RETURN
    END
    
  TRUNCATE TABLE LEDGER_UPDATES 

  IF NOT EXISTS (SELECT 1
                 FROM   ACMAST
                 WHERE  CLTCODE = @BANKCODE
                        AND ACCAT = 2)
    BEGIN
      SELECT 'BANK CODE DOSE NOT EXIST.'
      
      ROLLBACK TRAN
      
      RETURN
    END
    
  SELECT @@MICRNO = MICRNO
  FROM   ACMAST
  WHERE  CLTCODE = @BANKCODE
         AND ACCAT = 2
                     
  SELECT @@PROC_DATE = CONVERT(VARCHAR(11),CONVERT(DATETIME,@PROCESS_DATE,103),
                               109)
  
  SELECT @@PROC_DATE_TO = CONVERT(VARCHAR(11),CONVERT(DATETIME,@PROCESS_DATE_TO,103),
                                  109)
                          
  IF NOT EXISTS (SELECT 1
                 FROM   BANKRECO
                 WHERE  CLTCODE = @BANKCODE
                        AND BOOKDATE BETWEEN @@PROC_DATE AND @@PROC_DATE_TO + ' 23:59') 
    BEGIN
      SELECT 'THE STATEMENT FOR SELECTED DATE RANGE FROM ' + @@PROC_DATE + ' TO ' + @@PROC_DATE_TO + ' FOR ' + @BANKCODE + ' IS NOT UPLOADED.'
      
      ROLLBACK TRAN
      
      RETURN
    END
    
  IF NOT EXISTS (SELECT 1 
                 FROM   BANKRECO 
                 WHERE  CLTCODE = @BANKCODE 
                        AND BOOKDATE BETWEEN @@PROC_DATE AND @@PROC_DATE_TO + ' 23:59' 
                        AND STATUS = 'UNMATCHED')
    BEGIN
      PRINT 'ALL THE RECORDS FOR SELECTED DATE RANGE FROM ' + @@PROC_DATE + ' TO ' + @@PROC_DATE_TO + ' FOR ' + @BANKCODE + ' IS ALREADY MATCHED.'
      
      ROLLBACK TRAN
      
      RETURN
    END
    
  INSERT INTO #BANKRECOSAVE
  SELECT CLTCODE,
         BOOKDATE,
         [DESCRIPTION],
         AMOUNT,
         UPPER(DRCR),
         VALUEDATE,
         LTRIM(RTRIM(REFERENCENO)),
         CROSSREFERENCENO,
         STATUS,
         BR_SNO,
         MICRNO,
         0,
         0,
         0,
         '',
         '',
         0
  FROM   BANKRECO
  WHERE  CLTCODE = @BANKCODE
         AND BOOKDATE BETWEEN @@PROC_DATE AND @@PROC_DATE_TO + ' 23:59'
         AND STATUS = 'UNMATCHED'

  SELECT   L2.CLTCODE, 
           RELAMT = SUM(L1.RELAMT), 
           DDNO = LTRIM(RTRIM(L1.DDNO)),  
  DRCR = UPPER(L1.DRCR), 
           VDT = LEFT(L2.VDT,11) 
  INTO     #CHECKSUM 
  FROM     LEDGER1 L1 WITH (NOLOCK),
           LEDGER L2 WITH (NOLOCK)
  WHERE    L2.VNO = L1.VNO
           AND L2.VTYP = L1.VTYP
           AND L2.BOOKTYPE = L1.BOOKTYPE
           AND RELDT = ''
           AND CLTCODE = @BANKCODE
  GROUP BY L2.CLTCODE,LTRIM(RTRIM(L1.DDNO)),UPPER(L1.DRCR),LEFT(L2.VDT,11)

  UPDATE #BANKRECOSAVE
  SET    STATUS = 'MATCHED',
         L1_SNO = LEDGER1.L1_SNO,
         VTYP = LEDGER1.VTYP,
         BOOKTYPE = LEDGER1.BOOKTYPE,
         VNO = LEDGER1.VNO
  FROM   (SELECT DDNO = LTRIM(RTRIM(DDNO)),
                 RELDT,
                 RELAMT,
                 VTYP,
                 VNO,
                 LNO,
                 DRCR = UPPER(DRCR),
                 BOOKTYPE,
                 MICRNO = ISNULL(MICRNO,0),
                 L1_SNO
          FROM   LEDGER1 L1 WITH (NOLOCK)
          WHERE  RELDT = ''
                 AND EXISTS (SELECT 1
                             FROM   LEDGER L
                             WHERE  L.VNO = L1.VNO
                                    AND L.VTYP = L1.VTYP
                                    AND L.BOOKTYPE = L1.BOOKTYPE
                                    AND L.CLTCODE = @BANKCODE)) LEDGER1 
  WHERE  (LEDGER1.VTYP = 2
           OR LEDGER1.VTYP = 3
           OR LEDGER1.VTYP = 5
           OR LEDGER1.VTYP = 17
           OR LEDGER1.VTYP = 19
           OR LEDGER1.VTYP = 20)
         AND #BANKRECOSAVE.DRCR = LEDGER1.DRCR
         AND #BANKRECOSAVE.REFERENCENO = LEDGER1.DDNO 
         AND #BANKRECOSAVE.MICRNO = @@MICRNO
         AND #BANKRECOSAVE.AMOUNT = LEDGER1.RELAMT
         AND #BANKRECOSAVE.MICRNO = LEDGER1.MICRNO 
         AND #BANKRECOSAVE.REFERENCENO <> '0'
         AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(C.RELAMT) 
                     FROM   #CHECKSUM C
                     WHERE  #BANKRECOSAVE.REFERENCENO = C.DDNO
                            AND #BANKRECOSAVE.DRCR = C.DRCR
                            AND #BANKRECOSAVE.VALUEDATE >= C.VDT) 
                            
  IF @@ERROR <> 0
    BEGIN
      SELECT 'THERE IS SOME PROBLEM IN BANKRECO UPDATES 1'
             
      ROLLBACK TRAN
      
      RETURN
    END
    
  UPDATE LEDGER1 WITH (ROWLOCK)
  SET    RELDT = VALUEDATE,
         REFNO = #BANKRECOSAVE.CROSSREFERENCENO
  FROM   #BANKRECOSAVE
  WHERE  #BANKRECOSAVE.L1_SNO <> 0
         AND LEDGER1.L1_SNO = #BANKRECOSAVE.L1_SNO
                              
  IF @@ERROR <> 0
    BEGIN
      SELECT 'THERE IS SOME PROBLEM IN LEDGER1 UPDATES 1'
             
      ROLLBACK TRAN
      
      RETURN
    END
    
  UPDATE #BANKRECOSAVE
  SET    AMOUNTLEDGR1 = BANKRECOCOMP.AMOUNT,
         STATUS = 'MATCHED',
         SLIPNO = BANKRECOCOMP.SLIPNO
  FROM   (SELECT   SUM(RELAMT)          AS AMOUNT,
                   LTRIM(RTRIM(SLIPNO)) AS SLIPNO,
                   UPPER(DRCR)          AS DRCR,
                   MICRNO
          FROM     LEDGER1 WITH (NOLOCK)
          WHERE    MICRNO = @@MICRNO
                   AND (VTYP = 2
                         OR VTYP = 19
                         OR VTYP = 5)
                   AND SLIPNO <> ''
                   AND RELDT = ''
          GROUP BY SLIPNO,DRCR,MICRNO) BANKRECOCOMP
  WHERE  #BANKRECOSAVE.DRCR = BANKRECOCOMP.DRCR
         AND BANKRECOCOMP.SLIPNO = REFERENCENO
         AND #BANKRECOSAVE.MICRNO = @@MICRNO
         AND #BANKRECOSAVE.AMOUNT = BANKRECOCOMP.AMOUNT
         AND #BANKRECOSAVE.MICRNO = BANKRECOCOMP.MICRNO
         AND REFERENCENO <> '0'
                            
  IF @@ERROR <> 0
    BEGIN
      SELECT 'THERE IS SOME PROBLEM IN BANKRECO UPDATES 2'
             
      ROLLBACK TRAN
      
      RETURN
    END
    
  SELECT L1.VTYP,
         L1.BOOKTYPE,
         L1.VNO,
         L1.L1_SNO,
         #BANKRECOSAVE.VALUEDATE,
         #BANKRECOSAVE.CROSSREFERENCENO
  INTO   #LEDGER_UPDATES_FOR_SLIPS
  FROM   #BANKRECOSAVE,
         LEDGER1 L1 WITH (NOLOCK)
  WHERE  L1.MICRNO = @@MICRNO
         AND L1.SLIPNO = #BANKRECOSAVE.SLIPNO
         AND #BANKRECOSAVE.SLIPNO <> 0
                                     
  UPDATE LEDGER1 WITH (ROWLOCK)
  SET    RELDT = VALUEDATE,
         REFNO = #LEDGER_UPDATES_FOR_SLIPS.CROSSREFERENCENO
  FROM   #LEDGER_UPDATES_FOR_SLIPS
  WHERE  #LEDGER_UPDATES_FOR_SLIPS.L1_SNO <> 0
         AND LEDGER1.L1_SNO = #LEDGER_UPDATES_FOR_SLIPS.L1_SNO
                              
  IF @@ERROR <> 0
    BEGIN
      SELECT 'THERE IS SOME PROBLEM IN LEDGER1 UPDATES 3'
             
      ROLLBACK TRAN
      
      RETURN
    END
    
  UPDATE L
  SET    EDT = VALUEDATE  
/*=====================================================================================================
REMOVED THE CASE CONDITION AS THE DATE CONDITION IS ALREADY MENTIONED IN ABOVE QUERY
=====================================================================================================*/
/*  SET    EDT = (CASE 
                  WHEN CONVERT(DATETIME,(CONVERT(VARCHAR(11),VALUEDATE,109))) < CONVERT(DATETIME,(CONVERT(VARCHAR(11),VDT,109))) THEN VDT
                  ELSE (CASE 
                          WHEN CONVERT(DATETIME,(CONVERT(VARCHAR(11),VALUEDATE,109))) < CONVERT(DATETIME,(CONVERT(VARCHAR(11),GETDATE(),109))) THEN CONVERT(VARCHAR(11),GETDATE(),109)
                          ELSE VALUEDATE
                        END)
                END)*/ 
  FROM   LEDGER L WITH (ROWLOCK), 
         (SELECT VTYP, 
                 BOOKTYPE, 
                 VNO, 
                 VALUEDATE 
          FROM   #BANKRECOSAVE 
          WHERE  VNO <> '' 
          UNION  
          SELECT VTYP, 
                 BOOKTYPE, 
                 VNO, 
                 VALUEDATE 
          FROM   #LEDGER_UPDATES_FOR_SLIPS 
          WHERE  VNO <> '') LU 
  WHERE  LU.VNO = L.VNO 
         AND LU.VTYP = L.VTYP 
         AND LU.BOOKTYPE = L.BOOKTYPE 
         AND EDT LIKE 'DEC 31 2049%' 
                      
  IF @@ERROR <> 0
    BEGIN
      SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES EDT'
             
      ROLLBACK TRAN
      
      RETURN
    END
    
  UPDATE BR
  SET    STATUS = 'MATCHED'
  FROM   BANKRECO BR,
         #BANKRECOSAVE BR1
  WHERE  BR.BR_SNO = BR1.BR_SNO
         AND BR1.STATUS = 'MATCHED'
                          
  INSERT INTO BANKRECO_LOG
  SELECT B.CLTCODE,
         B.BOOKDATE,
         B.DESCRIPTION,
         B.AMOUNT,
         B.DRCR,
         B.VALUEDATE,
         B.REFERENCENO,
         '',
         '',
         '',
         B.CROSSREFERENCENO,
         B.STATUS,
         @@MICRNO,
         '0',
         '0',
         0,
         'AUTO',
         GETDATE(),
         'MATCHED'
  FROM   #BANKRECOSAVE B
  WHERE  B.STATUS = 'MATCHED'
                    
  INSERT INTO LEDGER1_BANKRECO_LOG
  SELECT L1.*,
         'AUTO',
         GETDATE(),
         'MATCHED'
  FROM   LEDGER1 L1 WITH (NOLOCK),
         (SELECT VTYP,
                 BOOKTYPE,
                 VNO
          FROM   #BANKRECOSAVE
          WHERE  VNO <> ''
          UNION 
          SELECT VTYP,
                 BOOKTYPE,
                 VNO
          FROM   #LEDGER_UPDATES_FOR_SLIPS
          WHERE  VNO <> '') LU
  WHERE  L1.VNO = LU.VNO
         AND L1.VTYP = LU.VTYP
         AND L1.BOOKTYPE = LU.BOOKTYPE
                           
  UPDATE RECOPROCESS
  SET    INPROCESS = 'N'
                     
  COMMIT TRAN
  
  SELECT 'UPDATED SUCCESSFULLY.'

GO
