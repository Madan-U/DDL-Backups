-- Object: PROCEDURE dbo.REPROCESS_RECO
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


create PROC REPROCESS_RECO        
 @BANKCODE VARCHAR(10),        
 @PROCESS_DATE VARCHAR(10)        
        
AS        
        
DECLARE         
 @@MICRNO VARCHAR(20),        
 @@TABLE_EXIST VARCHAR(20),              
 @@RECORD_COUNT SMALLINT,              
 @@RECO_STATUS CHAR(1),              
 @@CLTCODE_EXIST INT,        
 @@PROC_DATE VARCHAR(11)        
        
        
CREATE TABLE #BANKRECOSAVE        
(        
 Cltcode VARCHAR(10),        
 Bookdate DATETIME,        
 [Description] VARCHAR(200),        
 Amount MONEY,        
 Drcr CHAR(1),        
 Valuedate DATETIME,        
 Referenceno VARCHAR(30),        
 Crossreferenceno BIGINT,        
 STATUS VARCHAR(15),        
 BR_SNo BIGINT,        
 MICRNO VARCHAR(10),        
 AMOUNTLEDGR1 MONEY        
)        
        
SET @@TABLE_EXIST = ''              
SELECT @@TABLE_EXIST = NAME FROM SYSOBJECTS WHERE NAME = 'RECOPROCESS'              
              
IF @@TABLE_EXIST = ''              
BEGIN              
 CREATE TABLE RECOPROCESS (INPROCESS VARCHAR(1))              
 INSERT INTO RECOPROCESS (INPROCESS) VALUES ('N')              
END              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
SELECT @@RECORD_COUNT = COUNT(*) FROM RECOPROCESS              
              
IF @@RECORD_COUNT = 0              
BEGIN              
 INSERT INTO RECOPROCESS (INPROCESS) VALUES ('N')              
END              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
SELECT TOP 1 @@RECO_STATUS = INPROCESS FROM RECOPROCESS              
              
IF @@RECO_STATUS = 'N'              
BEGIN              
 BEGIN TRAN              
 UPDATE RECOPROCESS SET INPROCESS = 'Y'              
END              
ELSE              
BEGIN              
 SELECT 'BANK RECO UPLOAD PROCESS IS ALREADY RUNNING FROM SOME OTHER TERMINAL. PLEASE TRY AGAIN LATER.'              
 RETURN              
END              
              
SET @@TABLE_EXIST = ''              
SELECT @@TABLE_EXIST = NAME FROM SYSOBJECTS WHERE NAME = 'LEDGER_UPDATES'              
IF @@TABLE_EXIST <> ''              
BEGIN              
 DROP TABLE LEDGER_UPDATES              
END              
              
SET @@TABLE_EXIST = ''              
SELECT @@TABLE_EXIST = NAME FROM SYSOBJECTS WHERE NAME = 'BANKRECOCOMP'              
IF @@TABLE_EXIST <> ''              
BEGIN              
 DROP TABLE BANKRECOCOMP              
END              
              
CREATE TABLE LEDGER_UPDATES (VNO VARCHAR(12),VTYP VARCHAR(2),BOOKTYPE VARCHAR(2),VALUEDATE DATETIME)              
        
SELECT @@CLTCODE_EXIST = COUNT(1) FROM ACMAST WHERE CLTCODE = @BANKCODE  AND ACCAT = 2              
              
IF @@CLTCODE_EXIST = 0              
 BEGIN              
  SELECT 'BANK CODE DOSE NOT EXIST.'          
  ROLLBACK TRAN          
  RETURN              
 END              
        
SELECT @@MICRNO = MICRNO FROM ACMAST WHERE CLTCODE = @BANKCODE  AND ACCAT = 2              
        
        
SELECT @@PROC_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @PROCESS_DATE, 103), 109)        
      
      
SELECT       
 @@RECORD_COUNT = COUNT(1)       
FROM       
 BANKRECO       
WHERE        
 CLTCODE = @BANKCODE        
 AND BOOKDATE LIKE @@PROC_DATE + '%'      
      
IF @@RECORD_COUNT = 0      
BEGIN      
 SELECT 'THE STATEMENT FOR SELECTED DATE ' + @@PROC_DATE + ' FOR ' + @BANKCODE + ' IS NOT UPLOADED.'      
 ROLLBACK TRAN      
 RETURN      
END      
      
SELECT       
 @@RECORD_COUNT = COUNT(1)       
FROM       
 BANKRECO       
WHERE        
 CLTCODE = @BANKCODE        
 AND BOOKDATE LIKE @@PROC_DATE + '%'      
 AND STATUS = 'UNMATCHED'      
      
IF @@RECORD_COUNT = 0      
BEGIN      
 PRINT 'ALL THE RECORDS FOR SELECTED DATE ' + @@PROC_DATE + ' FOR ' + @BANKCODE + ' IS ALREADY MATCHED.'      
 ROLLBACK TRAN      
 RETURN      
END      
        
INSERT INTO #BANKRECOSAVE        
SELECT        
 Cltcode,        
 Bookdate,        
 [Description],        
 Amount,        
 Drcr,        
 Valuedate,        
 Referenceno,        
 Crossreferenceno,        
 STATUS,        
 BR_SNo,        
 MICRNO,        
 0        
FROM        
 BANKRECO        
WHERE        
 CLTCODE = @BANKCODE        
 AND BOOKDATE LIKE @@PROC_DATE + '%'        
 AND STATUS = 'UNMATCHED'        
        
        
UPDATE              
 #BANKRECOSAVE              
SET              
 STATUS ='MATCHED'              
FROM              
 LEDGER1              
WHERE              
 LEDGER1.VTYP IN ( '2', '3', '5', '19', '20', '17' )              
 AND UPPER(#BANKRECOSAVE.DRCR) = UPPER(LEDGER1.DRCR)              
 AND  RTRIM(DDNO)  =  RTRIM(REFERENCENO)              
 AND CLTCODE = @BANKCODE              
 AND #BANKRECOSAVE.MICRNO = @@MICRNO              
 AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(RELAMT) FROM LEDGER1 L1, LEDGER L2 WHERE L2.VNO=L1.VNO AND L2.VTYP=L1.VTYP AND L2.BOOKTYPE=L1.BOOKTYPE AND RELDT = '' AND CLTCODE= @BANKCODE AND #BANKRECOSAVE.REFERENCENO=DDNO AND #BANKRECOSAVE.DRCR = L1.DRCR AND CONVERT(VARCHAR(11), #BANKRECOSAVE.VALUEDATE, 101) >= CONVERT(VARCHAR(11), VDT, 101))          
 AND #BANKRECOSAVE.MICRNO =LEDGER1.MICRNO              
 AND   REFERENCENO  <> '0'              
              
IF @@ERROR <> 0              
BEGIN              
 SELECT 'THERE IS SOME PROBLEM IN BANKRECO UPDATES 1'              
 ROLLBACK TRAN              
 RETURN              
END              
              
              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
INSERT INTO              
 LEDGER_UPDATES              
SELECT             
 LEDGER1.VNO,LEDGER1.VTYP,LEDGER1.BOOKTYPE,#BANKRECOSAVE.VALUEDATE              
FROM              
 #BANKRECOSAVE, LEDGER1 (NOLOCK), LEDGER (NOLOCK)              
WHERE              
 (LEDGER1.VTYP ='2' OR LEDGER1.VTYP ='3' OR LEDGER1.VTYP = '19' OR LEDGER1.VTYP ='20' OR LEDGER1.VTYP = '5' or LEDGER1.VTYP = '17' )              
 AND #BANKRECOSAVE.CLTCODE = LEDGER.CLTCODE              
 AND LEDGER1.VNO = LEDGER.VNO              
 AND LEDGER1.VTYP = LEDGER.VTYP              
 AND LEDGER1.BOOKTYPE = LEDGER.BOOKTYPE              
 AND UPPER(#BANKRECOSAVE.DRCR) = UPPER(LEDGER1.DRCR)              
 AND DDNO =  REFERENCENO              
 AND RELDT = ''              
 AND #BANKRECOSAVE.CLTCODE = @BANKCODE              
 AND #BANKRECOSAVE.MICRNO = @@MICRNO              
 AND #BANKRECOSAVE.MICRNO =LEDGER1.MICRNO              
 AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(RELAMT) FROM LEDGER1 L1 (NOLOCK), LEDGER L2 (NOLOCK) WHERE L2.VNO=L1.VNO AND L2.VTYP=L1.VTYP AND L2.BOOKTYPE=L1.BOOKTYPE AND RELDT = '' AND CLTCODE= @BANKCODE AND #BANKRECOSAVE.REFERENCENO=DDNO AND #BANKRECOSAVE.DRCR = L1.DRCR AND CONVERT(VARCHAR(11), L2.VDT, 101) <= CONVERT(VARCHAR(11), #BANKRECOSAVE.VALUEDATE, 101))              
 AND CONVERT(VARCHAR(11), #BANKRECOSAVE.VALUEDATE, 101) >= CONVERT(VARCHAR(11), LEDGER.VDT, 101)      
 AND   REFERENCENO  <> '0'              
              
IF @@ERROR <> 0              
BEGIN              
 SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES 1'              
 ROLLBACK TRAN              
 RETURN              
END              
              
              
UPDATE              
 LEDGER1              
SET              
 RELDT = VALUEDATE , REFNO = #BANKRECOSAVE.CROSSREFERENCENO              
FROM              
 #BANKRECOSAVE, LEDGER (NOLOCK)              
WHERE              
 (LEDGER1.VTYP ='2' OR LEDGER1.VTYP ='3' OR LEDGER1.VTYP = '19' OR LEDGER1.VTYP ='20' OR LEDGER1.VTYP = '5' or LEDGER1.VTYP = '17')              
 AND UPPER(#BANKRECOSAVE.DRCR) = UPPER(LEDGER1.DRCR)              
 AND DDNO =  REFERENCENO              
 AND RELDT = ''              
 AND #BANKRECOSAVE.CLTCODE = @BANKCODE              
 AND #BANKRECOSAVE.MICRNO = @@MICRNO              
 AND #BANKRECOSAVE.MICRNO =LEDGER1.MICRNO              
 AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(RELAMT) FROM LEDGER1 L1, LEDGER L2 WHERE L2.VNO=L1.VNO AND L2.VTYP=L1.VTYP AND L2.BOOKTYPE=L1.BOOKTYPE AND RELDT = '' AND CLTCODE= @BANKCODE AND #BANKRECOSAVE.REFERENCENO=DDNO AND #BANKRECOSAVE.DRCR = L1.DRCR AND CONVERT(VARCHAR(11), L2.VDT, 101) <= CONVERT(VARCHAR(11), #BANKRECOSAVE.VALUEDATE, 101))        
 AND REFERENCENO  <> '0'              
 AND LEDGER.VNO = LEDGER1.VNO              
 AND LEDGER.VTYP = LEDGER1.VTYP              
 AND LEDGER.BOOKTYPE = LEDGER1.BOOKTYPE              
 AND LEDGER.CLTCODE = #BANKRECOSAVE.CLTCODE     
 AND CONVERT(VARCHAR(11), LEDGER.VDT, 101) <= CONVERT(VARCHAR(11), #BANKRECOSAVE.VALUEDATE, 101)               
              
IF @@ERROR <> 0              
BEGIN              
 SELECT 'THERE IS SOME PROBLEM IN LEDGER1 UPDATES 1'              
 ROLLBACK TRAN              
 RETURN              
END              
              
              
SELECT              
 SUM(RELAMT) AS AMOUNT,              
 SLIPNO AS SLIPNO,              
 UPPER(DRCR) AS DRCR,              
 MICRNO              
INTO              
 BANKRECOCOMP              
FROM              
 LEDGER1              
WHERE              
 MICRNO = @@MICRNO              
 AND (VTYP ='2' OR VTYP = '19' OR  VTYP = '5' )              
 AND SLIPNO <>''              
GROUP BY              
 SLIPNO,              
 DRCR,              
 MICRNO              
              
              
UPDATE              
 #BANKRECOSAVE              
SET              
 AMOUNTLEDGR1 =BANKRECOCOMP.AMOUNT, STATUS ='MATCHED'              
FROM              
 BANKRECOCOMP              
WHERE              
  UPPER(#BANKRECOSAVE.DRCR) = UPPER(BANKRECOCOMP.DRCR)              
  AND RTRIM(BANKRECOCOMP.SLIPNO)  =  RTRIM(REFERENCENO)              
  AND #BANKRECOSAVE.MICRNO = @@MICRNO              
  AND #BANKRECOSAVE.AMOUNT = BANKRECOCOMP.AMOUNT              
  AND #BANKRECOSAVE.MICRNO =BANKRECOCOMP.MICRNO              
  AND REFERENCENO  <> '0'              
              
IF @@ERROR <> 0              
BEGIN              
 SELECT 'THERE IS SOME PROBLEM IN BANKRECO UPDATES 2'              
 ROLLBACK TRAN              
 RETURN              
END              
              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED              
INSERT INTO LEDGER_UPDATES              
SELECT              
 LEDGER1.VNO,LEDGER1.VTYP,LEDGER1.BOOKTYPE,#BANKRECOSAVE.VALUEDATE              
FROM              
 #BANKRECOSAVE (NOLOCK), LEDGER1 (NOLOCK), LEDGER (NOLOCK)              
WHERE              
 (LEDGER1.VTYP ='2' OR LEDGER1.VTYP = '19' OR  LEDGER1.VTYP = '5' )              
 AND UPPER(#BANKRECOSAVE.DRCR) = UPPER(LEDGER1.DRCR)              
 AND RTRIM(LEDGER1.SLIPNO) = RTRIM(#BANKRECOSAVE.REFERENCENO)              
 AND RELDT = ''              
 AND #BANKRECOSAVE.CLTCODE = LEDGER.CLTCODE              
 AND LEDGER1.VNO = LEDGER.VNO              
 AND LEDGER1.VTYP = LEDGER.VTYP              
 AND LEDGER1.BOOKTYPE = LEDGER.BOOKTYPE              
 AND #BANKRECOSAVE.CLTCODE = @BANKCODE              
 AND #BANKRECOSAVE.MICRNO = @@MICRNO              
 AND #BANKRECOSAVE.MICRNO =LEDGER1.MICRNO              
 AND #BANKRECOSAVE.REFERENCENO  <> '0'              
 AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(LEDGER1.RELAMT) FROM LEDGER1 (NOLOCK) WHERE  REFERENCENO = CONVERT(VARCHAR,SLIPNO) AND UPPER(DRCR) = UPPER(#BANKRECOSAVE.DRCR) AND RELDT='' AND  MICRNO = @@MICRNO)              
              
IF @@ERROR <> 0              
BEGIN              
 SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES 2'              
 ROLLBACK TRAN              
 RETURN              
END              
              
              
UPDATE              
 LEDGER1              
SET              
 RELDT = VALUEDATE ,              
 REFNO = #BANKRECOSAVE.CROSSREFERENCENO              
FROM              
 #BANKRECOSAVE, LEDGER  (NOLOCK)              
WHERE              
 (LEDGER1.VTYP ='2' OR LEDGER1.VTYP = '19' OR  LEDGER1.VTYP = '5' )              
 AND UPPER(#BANKRECOSAVE.DRCR) = UPPER(LEDGER1.DRCR)              
 AND RTRIM(LEDGER1.SLIPNO) = RTRIM(#BANKRECOSAVE.REFERENCENO)              
 AND RELDT = ''              
 AND #BANKRECOSAVE.CLTCODE = @BANKCODE              
 AND #BANKRECOSAVE.MICRNO = @@MICRNO              
 AND #BANKRECOSAVE.MICRNO =LEDGER1.MICRNO              
 AND #BANKRECOSAVE.REFERENCENO  <> '0'              
 AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(LEDGER1.RELAMT) FROM LEDGER1 WHERE  REFERENCENO = CONVERT(VARCHAR,SLIPNO) AND UPPER(DRCR) = UPPER(#BANKRECOSAVE.DRCR) AND RELDT='' AND  MICRNO = @@MICRNO)              
 AND LEDGER.VNO = LEDGER1.VNO              
 AND LEDGER.VTYP = LEDGER1.VTYP              
 AND LEDGER.BOOKTYPE = LEDGER1.BOOKTYPE              
 AND LEDGER.CLTCODE = #BANKRECOSAVE.CLTCODE              
              
IF @@ERROR <> 0              
BEGIN              
 SELECT 'THERE IS SOME PROBLEM IN LEDGER1 UPDATES 2'              
 ROLLBACK TRAN              
 RETURN              
END              
              
UPDATE              
 L              
SET              
 EDT = VALUEDATE              
FROM              
 LEDGER L, LEDGER_UPDATES LU              
WHERE              
 LU.VNO=L.VNO              
 AND LU.VTYP=L.VTYP              
 AND LU.BOOKTYPE=L.BOOKTYPE              
 AND EDT LIKE 'DEC 31 2049%'              
              
IF @@ERROR <> 0              
BEGIN        
 SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES EDT'              
 ROLLBACK TRAN              
 RETURN              
END              
              
UPDATE              
 L              
SET              
 EDT = VDT              
FROM              
 LEDGER L, LEDGER_UPDATES LU              
WHERE              
 LU.VNO=L.VNO              
 AND LU.VTYP=L.VTYP              
 AND LU.BOOKTYPE=L.BOOKTYPE              
 AND CONVERT(DATETIME, (CONVERT(VARCHAR(11), EDT, 109))) < CONVERT(DATETIME, (CONVERT(VARCHAR(11), VDT, 109)))              
              
IF @@ERROR <> 0              
BEGIN              
 SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES EDT 2'              
 ROLLBACK TRAN              
 RETURN              
END              
              
DROP TABLE BANKRECOCOMP              
DROP TABLE LEDGER_UPDATES              
        
UPDATE BR         
SET STATUS = 'MATCHED'        
FROM BANKRECO BR, #BANKRECOSAVE BR1        
WHERE BR.BR_SNo = BR1.BR_SNo AND BR1.STATUS = 'MATCHED'        
        
          
UPDATE RECOPROCESS SET INPROCESS = 'N'              
              
COMMIT TRAN              
              
SELECT 'UPDATED SUCCESSFULLY.'

GO
