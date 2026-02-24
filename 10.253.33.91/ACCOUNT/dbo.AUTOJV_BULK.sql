-- Object: PROCEDURE dbo.AUTOJV_BULK
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

-- select  convert(varchar,getdate(),103), convert(varchar,getdate(),12)+right(replace(convert(varchar,getdate(),114),':',''),6) From Owner    
CREATE PROC [dbo].[AUTOJV_BULK]      
(      
 @PROCESS_ID VARCHAR(25),      
 @UNAME VARCHAR(25),      
 @VTYP SMALLINT,      
 @BOOKTYPE VARCHAR(2),      
 @USERCAT INT      
)      
      
AS      
 /*      
 DELETE FROM V2_UPLOADED_FILES WHERE U_FILENAME = 'D:\BACKOFFICE\DRCRNOTES\CR TAMMANA2.CSV'      
 EXEC DRCRNOTEUPLOAD_BULK 'D:\BACKOFFICE\DRCRNOTES\CR TAMMANA2.CSV', 'TEST', 6, '01'      
 EXEC DRCRNOTEUPLOAD_BULK 'D:\BACKOFFICE\DRCRNOTES\CR TAMMANA2.CSV', 'TEST', 6, '01'      
 */      
 SET NOCOUNT ON      
      
 DECLARE      
  @@ERROR_COUNT AS INT,      
  @@SQL AS VARCHAR(2000),      
  @@BACKDAYS INT,      
  @@BACKDATE DATETIME      
        
 IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[TMP_RECPAY_TABLE_TMP]') AND TYPE IN (N'U'))      
  DROP TABLE [DBO].[TMP_RECPAY_TABLE_TMP]      
        
 IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[TMP_RECPAY_TABLE]') AND TYPE IN (N'U'))      
  DROP TABLE [DBO].[TMP_RECPAY_TABLE]      
        
 IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[TMP_RECPAY_TABLE_LNO]') AND TYPE IN (N'U'))      
  DROP TABLE [DBO].[TMP_RECPAY_TABLE_LNO]      
        
 IF  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[TMP_VNO]') AND TYPE IN (N'U'))      
  DROP TABLE [DBO].[TMP_VNO]      
        
 CREATE TABLE TMP_RECPAY_TABLE_TMP      
 (      
  SRNO INT,      
  VVDT VARCHAR(10),      
  EEDT VARCHAR(10),      
  CLTCODE VARCHAR(10),      
  GL_CODE VARCHAR(10),      
  DRCR VARCHAR(1),      
  AMOUNT MONEY,      
  NARRATION VARCHAR(500),      
  BRANCHCODE VARCHAR(10)      
 )      
      
 CREATE TABLE [TMP_RECPAY_TABLE]      
 (      
  SRNO INT,      
  VVDT VARCHAR(10),      
  EEDT VARCHAR(10),      
  CLTCODE VARCHAR(10),      
  DRCR VARCHAR(1),      
  AMOUNT MONEY,      
  NARRATION VARCHAR(500),      
  BRANCHCODE VARCHAR(10),      
  SNO INT IDENTITY (1, 1) NOT NULL ,      
  VDT DATETIME NULL ,      
  UPDFLAG VARCHAR (1)  NOT NULL DEFAULT('N'),      
  EDT DATETIME NULL ,      
  VNO VARCHAR (12)  NULL ,      
  ACNAME VARCHAR (100)  NULL ,      
  FYSTART DATETIME NULL,      
  FYEND DATETIME NULL,      
  COSTCODE SMALLINT NULL,      
  LNO SMALLINT NOT NULL DEFAULT(0)      
 ) ON [PRIMARY]      
      
 CREATE TABLE [TMP_RECPAY_TABLE_LNO]      
 (      
  SNO INT,      
  LNO INT IDENTITY (1, 1) NOT NULL      
 ) ON [PRIMARY]      
       
 INSERT INTO       
  TMP_RECPAY_TABLE_TMP      
 SELECT    
  FLDAUTO,       
  VVDT = CONVERT(VARCHAR(10), GETDATE(), 103),      
  EEDT = CONVERT(VARCHAR(10), GETDATE(), 103),      
  CLTCODE = PARTYCODE,      
  GL_CODE = CASE WHEN EXCHANGEFR = ACCOUNTDB THEN GLCODEFR ELSE GLCODETO END,      
  DRCR = CASE WHEN EXCHANGEFR = ACCOUNTDB THEN 'D' ELSE 'C' END ,      
  AMOUNT = JVAMT,      
  NARRATION /*= 'FUND TRNASFER'*/,      
  BRANCHCODE = 'ALL'      
 FROM       
  AngelBSECM.ACCOUNT_AB.DBO.OFFLINE_JV_ENTRIES J WITH (NOLOCK), OWNER O WITH (NOLOCK)      
 WHERE       
  (J.EXCHANGEFR = O.ACCOUNTDB OR EXCHANGETO = O.ACCOUNTDB) AND PROCESS_ID = @PROCESS_ID    
  AND (VCHNOFR IS NULL OR VCHNOTO IS NULL)    
  and JVAMT > 0
        
 INSERT INTO       
  TMP_RECPAY_TABLE      
 (      
  SRNO,      
  VVDT,      
  EEDT,      
  CLTCODE,      
  DRCR,      
  AMOUNT,      
  NARRATION,      
  BRANCHCODE,
  LNO      
 )      
 SELECT      
  SRNO,      
  VVDT,      
  EEDT,      
  UPPER(CLTCODE),      
  DRCR,      
  AMOUNT,      
  LEFT(NARRATION, 234),      
  BRANCHCODE,
  1      
 FROM       
  TMP_RECPAY_TABLE_TMP      
      
 INSERT INTO       
  TMP_RECPAY_TABLE      
 (      
  SRNO,      
  VVDT,      
  EEDT,      
  CLTCODE,      
  DRCR,      
  AMOUNT,      
  NARRATION,      
  BRANCHCODE,
  LNO      
 )      
 SELECT      
  SRNO,      
  VVDT,      
  EEDT,      
  GL_CODE,      
  DRCR = CASE WHEN DRCR = 'C' THEN 'D' ELSE 'C' END,      
  AMOUNT,      
  LEFT(NARRATION, 234),      
  BRANCHCODE,
  2      
 FROM       
  TMP_RECPAY_TABLE_TMP     
      
 UPDATE      
  TMP_RECPAY_TABLE      
 SET      
  VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),      
  EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),      
  FYSTART = P.SDTCUR,      
  FYEND = P.LDTCUR,      
  UPDFLAG = 'Y',      
  ACNAME = LONGNAME,      
  TMP_RECPAY_TABLE.COSTCODE = C.COSTCODE      
 FROM       
  ACMAST A,       
  PARAMETER P,       
  COSTMAST C      
 WHERE       
  A.CLTCODE = TMP_RECPAY_TABLE.CLTCODE      
  AND P.CURYEAR = 1      
  AND A.ACCAT IN ('3','4','104')      
  AND A.BRANCHCODE = C.COSTNAME      
  AND A.BRANCHCODE <> 'ALL'      
      
 UPDATE      
  TMP_RECPAY_TABLE      
 SET      
  VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),      
  EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),      
  FYSTART = P.SDTCUR,      
  FYEND = P.LDTCUR,      
  UPDFLAG = 'Y',      
  ACNAME = LONGNAME,      
  TMP_RECPAY_TABLE.COSTCODE = C.COSTCODE      
 FROM       
  ACMAST A,       
  PARAMETER P,       
  COSTMAST C      
 WHERE       
  A.CLTCODE = TMP_RECPAY_TABLE.CLTCODE      
  AND P.CURYEAR = 1      
  AND A.ACCAT IN ('3','4','104')      
  AND TMP_RECPAY_TABLE.BRANCHCODE = C.COSTNAME      
  AND A.BRANCHCODE = 'ALL'      
  AND TMP_RECPAY_TABLE.BRANCHCODE <> 'ALL'      
  AND TMP_RECPAY_TABLE.COSTCODE IS NULL      
      
 UPDATE      
  TMP_RECPAY_TABLE      
 SET      
  VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),      
  EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),      
  FYSTART = P.SDTCUR,      
  FYEND = P.LDTCUR,      
  UPDFLAG = 'Y',      
  ACNAME = LONGNAME,      
  TMP_RECPAY_TABLE.COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')      
 FROM       
  ACMAST A,       
  PARAMETER P      
 WHERE       
  A.CLTCODE = TMP_RECPAY_TABLE.CLTCODE      
  AND P.CURYEAR = 1      
  AND A.ACCAT IN ('3','4','104')      
  AND A.BRANCHCODE = 'ALL'      
  AND TMP_RECPAY_TABLE.BRANCHCODE = 'ALL'      
  AND TMP_RECPAY_TABLE.COSTCODE IS NULL      
      
 ---------------------------VALIDATION FOR INACTIVE CLIENTS FROM CLIENT5---------------------      
 UPDATE      
  TMP_RECPAY_TABLE      
 SET       
  UPDFLAG = 'N'      
 FROM      
 (      
 SELECT      
  PARTY_CODE,      
  INACTIVEFROM      
 FROM       
  MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK),      
  MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)      
 WHERE       
  C2.CL_CODE = C5.CL_CODE      
  AND C2.PARTY_CODE IN (SELECT CLTCODE FROM TMP_RECPAY_TABLE)      
  AND INACTIVEFROM <= GETDATE()      
 ) C      
 WHERE       
  CLTCODE = C.PARTY_CODE      
      
 /* '--------------------------DECLARATION OF VARIABLES FOR VALIDATIONS ------------------------*/      
      
 DECLARE      
  @@STD_DATE VARCHAR(11),      
  @@LST_DATE VARCHAR(11),      
  @@VNOMETHOD INT,      
  @@ACNAME CHAR(100),      
  @@MICRNO VARCHAR(10),      
  @@DRCR VARCHAR(1)      
      
 /* '--------------------------UPDATE OF COST CODE ------------------------*/      
      
 UPDATE       
  TMP_RECPAY_TABLE      
 SET       
  COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')      
 WHERE       
  COSTCODE IS NULL      
      
 DECLARE      
  @@NEWVNO AS VARCHAR(12),      
  @@VDT AS VARCHAR(11),      
  @@LNOCUR AS CURSOR,      
  @@LNOVNO AS INT,      
  @@NOREC AS INT      
      
 /* '--------------------------AUTO GENERATION OF VNO (FULL LOGIC)------------------------*/      
 DECLARE      
  @@MAXVNO AS VARCHAR(12),      
  @@VNO AS VARCHAR(12),      
  @@RCOUNT AS INT      
        
 SELECT TOP 1      
  @@VDT = CONVERT(VARCHAR(11), VDT, 109)      
 FROM      
  TMP_RECPAY_TABLE      
      
 SELECT TOP 1      
  @@VNOMETHOD = VNOFLAG,      
  @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109),      
  @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109)      
 FROM      
  PARAMETER      
 WHERE      
  @@VDT BETWEEN SDTCUR AND LDTCUR      
      
 SELECT      
  @@NOREC = COUNT(DISTINCT SRNO)      
 FROM      
  TMP_RECPAY_TABLE      
      
 CREATE TABLE TMP_VNO      
 (      
  LASTVNO VARCHAR(12)      
 )      
      
 INSERT INTO TMP_VNO      
 EXEC ACC_GENVNO_NEW @@VDT, @VTYP, @BOOKTYPE, @@STD_DATE, @@LST_DATE, @@NOREC      
      
 SELECT @@VNO = LASTVNO FROM TMP_VNO      
     
 CREATE TABLE #VNO_GEN    
 (    
 SNO INT IDENTITY(1, 1),    
 SRNO INT    
)    
    
INSERT INTO #VNO_GEN    
SELECT DISTINCT SRNO  FROM TMP_RECPAY_TABLE ORDER BY SRNO    
    
    
 UPDATE      
  TMP_RECPAY_TABLE      
 SET       
  VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC,@@VNO) + V.SNO - 1)      
  FROM #VNO_GEN V    
  WHERE V.SRNO  = TMP_RECPAY_TABLE.SRNO    
      
 /* '--------------------------AUTO GENERATION OF LNO ------------------------*/      
      
 /*SET @@LNOCUR = CURSOR FOR      
  SELECT DISTINCT SRNO FROM TMP_RECPAY_TABLE      
  OPEN @@LNOCUR      
  FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO      
  WHILE @@FETCH_STATUS = 0      
  BEGIN      
   INSERT INTO TMP_RECPAY_TABLE_LNO      
   (SNO)      
   SELECT SNO FROM TMP_RECPAY_TABLE WHERE SRNO = @@LNOVNO      
   UPDATE RP      
   SET LNO = RL.LNO      
   FROM TMP_RECPAY_TABLE RP, TMP_RECPAY_TABLE_LNO RL      
   WHERE RP.SNO = RL.SNO      
   TRUNCATE TABLE TMP_RECPAY_TABLE_LNO      
   FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO      
  END      
 CLOSE @@LNOCUR      
 DEALLOCATE @@LNOCUR  */    
       
 DROP TABLE TMP_RECPAY_TABLE_LNO      
 --SELECT * FROM TMP_RECPAY_TABLE      
 --RETURN      
      
 /* '--------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------*/      
 /*==============================      
 LEDGER RECORD      
 ==============================*/  
 
 
 /*select * into #ledger from ledger where 1 = 2    
 
 INSERT INTO      
  #LEDGER      
 SELECT      
  VTYP = @VTYP,      
  VNO,      
  EDT,      
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
  CLTCODE,      
  BOOKTYPE = @BOOKTYPE,      
  ENTEREDBY = @UNAME,      
  PDT = GETDATE(),      
  CHECKEDBY = @UNAME,      
  ACTNODAYS = 0,      
  NARRATION      
 FROM      
  TMP_RECPAY_TABLE      
 GROUP BY      
  VNO,      
  EDT,      
  LNO,      
  ACNAME,      
  DRCR,      
  VDT,      
  CLTCODE,      
  NARRATION     */ 
      
 INSERT INTO      
  LEDGER      
 SELECT      
  VTYP = @VTYP,      
  VNO,      
  EDT,      
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
  CLTCODE,      
  BOOKTYPE = @BOOKTYPE,      
  ENTEREDBY = @UNAME,      
  PDT = GETDATE(),      
  CHECKEDBY = @UNAME,      
  ACTNODAYS = 0,      
  NARRATION      
 FROM      
  TMP_RECPAY_TABLE      
 GROUP BY      
  VNO,      
  EDT,      
  LNO,      
  ACNAME,      
  DRCR,      
  VDT,      
  CLTCODE,      
  NARRATION      
      
 /*==============================      
 LEDGER3 RECORD      
 ==============================*/      
 INSERT INTO      
  LEDGER3      
 SELECT      
  NARATNO = LNO,      
  NARRATION,      
  REFNO = 0,      
  VTYP = @VTYP,      
  VNO,      
  BOOKTYPE = @BOOKTYPE      
 FROM      
  TMP_RECPAY_TABLE      
      
 DELETE      
  TEMPLEDGER2      
 WHERE       
  SESSIONID = '9999999999'      
  
  /*SELECT * INTO #LEDGER2 FROM LEDGER2 WHERE 1 = 2                                  
                                  
 INSERT INTO #LEDGER2                                  
 SELECT VTYP, VNO, LNO, DRCR, VAMT, COSTCODE, L.BOOKTYPE, L.CLTCODE                                  
 FROM #LEDGER L, COSTMAST C, ACMAST A WHERE                                   
 L.CLTCODE = A.CLTCODE AND C.COSTNAME = L.BRANCHCODE --CASE WHEN UPPER(L.BRANCHCODE) = 'ALL' THEN 'HO' ELSE A.BRANCHCODE END                                  
          
          
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
 SELECT VTYPE,VNO,LNO,DRCR,CAMT,COSTCODE,BOOKTYPE,CLTCODE FROM #LEDGER2   */
      
 /*INSERT INTO       
  TEMPLEDGER2      
 SELECT      
  'BRANCH',      
  C.COSTNAME,      
  AMOUNT,      
  VTYP = @VTYP,      
  VNO,      
  LNO,      
  DRCR,      
  '0',      
  BOOKTYPE = @BOOKTYPE,      
  SESSIONID = '9999999999',      
  CLIENT_CODE = CLTCODE,      
  'A',      
  '0'      
 FROM      
  TMP_RECPAY_TABLE RP,      
  COSTMAST C      
 WHERE      
  RP.COSTCODE = C.COSTCODE      
      
 DECLARE @@L2CUR AS CURSOR,      
  @@L2VNO AS VARCHAR(12)      
  SET @@L2CUR = CURSOR FOR      
  SELECT DISTINCT VNO FROM TMP_RECPAY_TABLE ORDER BY VNO      
  OPEN @@L2CUR      
  FETCH NEXT FROM @@L2CUR INTO @@L2VNO      
  WHILE @@FETCH_STATUS = 0      
  BEGIN      
   EXEC INSERTTOLEDGER2 '9999999999', @@L2VNO, '1', '1', '1', 'BROKER', 'BROKER'      
   FETCH NEXT FROM @@L2CUR INTO @@L2VNO      
  END      
  DELETE FROM TEMPLEDGER2      
  WHERE SESSIONID = '9999999999'      
 CLOSE @@L2CUR      
 DEALLOCATE @@L2CUR      */
      
 SELECT       
  RESULT = 'DATA UPLOADED SUCCESSFULLY'      
 UNION ALL      
 SELECT       
  RESULT = CLTCODE + ', ' + CONVERT(VARCHAR, AMOUNT) + ', ' + VNO       
 FROM       
  TMP_RECPAY_TABLE      
      
 --UPDATE       
 -- J       
 --SET      
 -- VCHNOFR = CASE WHEN O.ACCOUNTDB = J.EXCHANGEFR THEN R.VNO ELSE VCHNOFR END,      
 -- VCHNOTO = CASE WHEN O.ACCOUNTDB = J.EXCHANGETO THEN R.VNO ELSE VCHNOTO END      
 --FROM       
 -- AngelBSECM.ACCOUNT_AB.DBO.OFFLINE_JV_ENTRIES J, OWNER O,      
 -- TMP_RECPAY_TABLE R      
 --WHERE       
 -- SRNO = FLDAUTO       
 -- AND (O.ACCOUNTDB = EXCHANGEFR OR O.ACCOUNTDB = EXCHANGETO)      
      
 DROP TABLE TMP_RECPAY_TABLE_TMP      
 DROP TABLE TMP_RECPAY_TABLE

GO
