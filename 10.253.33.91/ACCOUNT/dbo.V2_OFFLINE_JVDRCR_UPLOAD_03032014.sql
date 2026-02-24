-- Object: PROCEDURE dbo.V2_OFFLINE_JVDRCR_UPLOAD_03032014
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[V2_OFFLINE_JVDRCR_UPLOAD_03032014]  
                    
                                   
 @FNAME VARCHAR(100),                                      
 @UNAME VARCHAR(25),                                      
 @VTYP SMALLINT,                                      
 @BOOKTYPE VARCHAR(2),                                      
 @EXCHANGE VARCHAR(3),                                      
    @SEGMENT  VARCHAR(10),                                      
 @STATUSID VARCHAR(15),                                      
 @STATUSNAME VARCHAR(15),                                      
 @USERCAT   INT                                      
                                       
                                      
AS                                      
/*                                      
 Exec V2_OFFLINE_JVDRCR_UPLOAD 'D:\BackOffice\DrCrNotes\TEST.Csv', 'BHRATA', 6, '01'                                       
 EXEC V2_OFFLINE_JVDRCR_UPLOAD 'D:\BACKOFFICE\DRCRNOTES\TEST.CSV', 'DEMO', 8, '01', 'NSE', 'CAPITAL','BROKER','BROKER'                                       
                                       
 SP CREATED BY  - BHARAT                                      
 SP CREATED ON  - JAN, 22 2009                                      
 ROLLBACK                                      
*/   
  
                                  
 SET NOCOUNT ON                                      
 SELECT @UNAME = 'B_' + LTRIM(RTRIM(@UNAME))                                      
 DECLARE                                      
  @@ERROR_COUNT AS INT,                                      
  @@SQL AS VARCHAR(2000),                                      
  @@STD_DATE VARCHAR(11),                                      
  @@LST_DATE VARCHAR(11),                                      
  @@VNOMETHOD INT,                                      
  @@ACNAME CHAR(100),                                      
  @@MICRNO VARCHAR(10),                                      
  @@DRCR VARCHAR(1),                                      
  @@NEWVNO AS VARCHAR(12),                                      
  @@VDT AS VARCHAR(11),                                      
  @@LNOCUR AS CURSOR,                                      
  @@LNOVNO AS INT,                                      
  @@NOREC AS INT,                                      
  @@MAXVNO AS VARCHAR(12),                                      
  @@VNO AS VARCHAR(12),                                      
  @@RCOUNT AS INT,                                      
  @@L2CUR AS CURSOR,                                      
  @@BRANCHFLAG AS SMALLINT,                                      
  @@L2VNO AS VARCHAR(12),                                      
  @@MyTempVno AS VARCHAR(12),                                      
  @@BACKDAYS        INT,                                        
  @@BACKDATE        VARCHAR(11),                                      
  @@ACTIVEDAYS AS INT    
  
set XACT_ABORT on   
                                   
                                      
  SELECT @@ACTIVEDAYS = ACTIVEDAYS FROM OWNER                                      
/* '--------------------------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR ------------------------*/                                      
 IF LTRIM(RTRIM(@FNAME)) = ''                                      
  BEGIN                                      
   SELECT RESULT = 'INVALID FILENAME SPECIFIED. PLEASE TRY AGAIN.'                                      
   RETURN                                      
  END                                      
                                      
 CREATE TABLE #FEXIST                                      
  (F1 INT, F2 INT, F3 INT)                                      
                                       
 SELECT @@SQL = "INSERT INTO #FEXIST EXEC MASTER.DBO.XP_FILEEXIST  '" + @FNAME + "' "                                      
 EXEC (@@SQL)                                      
                                      
 SELECT @@ERROR_COUNT = F1 FROM #FEXIST                                      
 IF @@ERROR_COUNT = 0                                      
  BEGIN                                      
   SELECT RESULT = 'THE SPECIFIED FILE DOES NOT EXIST. PLEASE TYPE CORRECT FILENAME.'                                      
   DROP TABLE #FEXIST                         
   RETURN                                      
  END                                      
                                      
 BEGIN TRAN                                 
 IF @VTYP = 8                                      
  BEGIN                                      
   SELECT                                       
    @@ERROR_COUNT = COUNT(1)                                       
   FROM                                      
    (SELECT                                       
     U_FILENAME                                   
    FROM                                       
     V2_UPLOADED_FILES                                      
    WHERE                                       
     U_FILENAME = @FNAME                                       
     AND U_MODULE = 'JV UPLOAD') A                                      
  END                                      
 ELSE                                      
  BEGIN                            
   SELECT                                       
    @@ERROR_COUNT = COUNT(1)                                       
   FROM                                      
    (SELECT                                       
     U_FILENAME                                      
    FROM                                       
     V2_UPLOADED_FILES                                      
    WHERE                                       
     U_FILENAME = @FNAME                                       
     AND U_MODULE = 'DRCR NOTE UPLOAD') A                                      
  END                                      
                                      
 IF @@ERROR_COUNT > 0                                      
  BEGIN                                      
   SELECT 'THE FILE YOU ARE UPLOADING IS ALREADY UPLOADED. PLEASE UPLOAD ANOTHER FILE.' + @FNAME                                      
   ROLLBACK TRAN                                      
   RETURN                                      
  END                                      
                                      
                                      
 CREATE TABLE #RECPAY_TABLE_TMP                                      
 (                                      
  SRNO INT,                                      
  VVDT VARCHAR(10),                                      
  EEDT VARCHAR(10),                                      
  CLTCODE VARCHAR(10),                                      
  DRCR VARCHAR(1),                                      
  AMOUNT MONEY,                                      
  NARRATION VARCHAR(500)                                  
                                      
 )                                      
                                      
 CREATE TABLE [#RECPAY_TABLE]                                      
 (                                      
  SRNO INT,                                      
  VVDT VARCHAR(10),                                      
  EEDT VARCHAR(10),                                      
  CLTCODE VARCHAR(10),                                      
  DRCR VARCHAR(1),                                      
  AMOUNT MONEY,                                      
  NARRATION VARCHAR(500),                                      
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
                                   
 CREATE TABLE [#RECPAY_TABLE_LNO]                                      
 (         
  SNO INT ,                                      
  LNO INT IDENTITY (1, 1) NOT NULL                                      
 ) ON [PRIMARY]                                      
                                      
 SELECT @@SQL = "BULK INSERT #RECPAY_TABLE_TMP FROM '"+ @FNAME + "' WITH (FIELDTERMINATOR = ',', FIRSTROW = 2) "                                      
 EXEC(@@SQL)                                   
                                  
                                  
                                      
 IF @@ERROR <> 0                                      
  BEGIN                                      
   ROLLBACK TRAN                                      
   SELECT 'DUE TO SOME ERROR IN BULK UPLOAD, FILE COULD NOT BE UPLOADED.'                                      
   RETURN                                      
  END                                      
                                      
 IF @VTYP = 8                                      
  BEGIN                                  
        INSERT INTO V2_UPLOADED_FILES                                      
        SELECT                                      
    @FNAME,                                      
    @FNAME,                                      
    COUNT(1),                                      
    'B',                                      
    GETDATE(),                      
    @UNAME,                                      
    'JV UPLOAD'                                      
  END                                      
 ELSE                                      
  BEGIN                                      
        INSERT INTO V2_UPLOADED_FILES                                      
        SELECT                                      
    @FNAME,                                      
    @FNAME,                                      
    COUNT(1),                                      
    'B',                                      
    GETDATE(),                                      
    @UNAME,                                      
    'DRCR NOTE UPLOAD'                                      
  END                                      
                                      
 INSERT INTO #RECPAY_TABLE                                      
  (SRNO,                   
  VVDT,                                      
  EEDT,                                      
  CLTCODE,                                      
  DRCR,                                      
  AMOUNT,                                      
  NARRATION)                                      
 SELECT                                      
  SRNO,                                      
  VVDT,                                      
  EEDT,                                      
  UPPER(CLTCODE),                                      
  DRCR,                        AMOUNT,                                      
  LEFT(NARRATION, 234)                                      
 FROM #RECPAY_TABLE_TMP                                      
                                    
 IF @@ERROR <> 0                                      
  BEGIN                                      
   ROLLBACK TRAN                                      
   SELECT 'DUE TO SYSTEM ERROR, FILE COULD NOT BE UPLOADED.'                                      
   RETURN                                      
  END                                      
                                      
 UPDATE                                      
  #RECPAY_TABLE                                      
 SET                                      
  VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),                                      
  EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2))                            
                                      
 SELECT TOP 1                                      
  @@VDT = CONVERT(VARCHAR(11), VDT, 109)                                      
 FROM                                      
  #RECPAY_TABLE                                      
                                      
 SELECT TOP 1                                      
  @@VNOMETHOD = VNOFLAG,                                  
  @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109),                                      
  @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109),                                      
  @@BRANCHFLAG = BRANCHFLAG                                      
 FROM                                      
  PARAMETER                                      
 WHERE                                      
  @@VDT BETWEEN SDTCUR AND LDTCUR                      
                        
                                      
 IF @@BRANCHFLAG = 1                                    
  BEGIN                                      
   UPDATE                                      
    #RECPAY_TABLE                                      
    SET                                      
     FYSTART = P.SDTCUR,                                      
     FYEND = P.LDTCUR,                                      
     UPDFLAG = 'Y',                                      
     ACNAME = LONGNAME,                                      
     COSTCODE = C.COSTCODE                                      
        FROM ACMAST A, PARAMETER P, COSTMAST C                                      
        WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE                                      
        AND @@VDT BETWEEN P.SDTCUR AND P.LDTCUR                                      
        AND A.ACCAT IN ('3','4','104','18')                                      
        AND A.BRANCHCODE = C.COSTNAME                                      
 AND A.BRANCHCODE <> 'ALL'                                      
-- Changes done by Samit on Mar 31 2012 for skipping In-active client code - request by Rahul Shah on Phone  
--AND NOT EXISTS (SELECT PARTY_CODE, INACTIVEFROM FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK), MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)                        
--WHERE LTRIM(RTRIM(C2.CL_CODE)) = C5.CL_CODE AND DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) <= GETDATE() AND A.CLTCODE = PARTY_CODE)                                      
                        
  -- AND NOT EXISTS (SELECT DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) , PARTY_CODE, INACTIVEFROM FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK), MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)                         
--WHERE LTRIM(RTRIM(C2.CL_CODE)) = C5.CL_CODE AND CASE WHEN INACTIVEFROM LIKE 'DEC 31 2049%' THEN INACTIVEFROM ELSE DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) END <= GETDATE())                        
                                
   UPDATE                                      
    #RECPAY_TABLE                                      
    SET                                      
     FYSTART = P.SDTCUR,                                      
     FYEND = P.LDTCUR,                                      
  UPDFLAG = 'Y',                                      
     ACNAME = LONGNAME,                                      
     COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')                                      
        FROM ACMAST A, PARAMETER P                                      
        WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE                                      
        AND @@VDT BETWEEN P.SDTCUR AND P.LDTCUR                                      
        AND A.ACCAT IN ('3','4','104','18')                                      
        AND A.BRANCHCODE = 'ALL'                               
-- Changes done by Samit on Mar 31 2012 for skipping In-active client code - request by Rahul Shah on Phone  
-- AND NOT EXISTS (SELECT PARTY_CODE, INACTIVEFROM FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK), MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK) WHERE LTRIM(RTRIM(C2.CL_CODE)) = C5.CL_CODE AND DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) <= GETDATE() AND A.CLTCODE = PARTY_CODE)
                                      
   
   
 -- AND NOT EXISTS (SELECT DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) , PARTY_CODE, INACTIVEFROM FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK), MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)                         
--WHERE LTRIM(RTRIM(C2.CL_CODE)) = C5.CL_CODE AND CASE WHEN INACTIVEFROM LIKE 'DEC 31 2049%' THEN INACTIVEFROM ELSE DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) END <= GETDATE())                        
                               
END                         
                        
                                       
 ELSE                                      
  BEGIN                                      
   UPDATE                                      
    #RECPAY_TABLE                                      
    SET                                      
     FYSTART = P.SDTCUR,                                      
     FYEND = P.LDTCUR,                                      
     UPDFLAG = 'Y',                                      
     ACNAME = LONGNAME                                      
        FROM ACMAST A, PARAMETER P                                      
    WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE                                      
        AND @@VDT BETWEEN P.SDTCUR AND P.LDTCUR                                      
        AND A.ACCAT IN ('3','4','104','18')                                      
   
 -- Changes done by Samit on Mar 31 2012 for skipping In-active client code - request by Rahul Shah on Phone  
 --AND NOT EXISTS (SELECT PARTY_CODE, INACTIVEFROM FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK), MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK) WHERE LTRIM(RTRIM(C2.CL_CODE)) = C5.CL_CODE AND DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) <= GETDATE() AND A.CLTCODE = PARTY_CODE) 
                                     
                        
--  AND NOT EXISTS (SELECT DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) , PARTY_CODE, INACTIVEFROM FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK), MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)                         
--WHERE LTRIM(RTRIM(C2.CL_CODE)) = C5.CL_CODE AND CASE WHEN INACTIVEFROM LIKE 'DEC 31 2049%' THEN INACTIVEFROM ELSE DATEADD(DAY,@@ACTIVEDAYS,INACTIVEFROM) END <= GETDATE())                        
                             
  END                                      
                                      
/* '--------------------------VALIDATION FOR VOUCHER DATE NOT IN CURRENT FIN YEAR ------------------------*/                                      
                                      
 SELECT @@ERROR_COUNT = COUNT(1) FROM #RECPAY_TABLE WHERE VDT NOT BETWEEN FYSTART AND FYEND                                      
                                      
 IF @@ERROR_COUNT > 0                                      
  BEGIN                                      
   SELECT 'SOME OF THE VOUCHERS ARE NOT FALLING IN THE RESPECTIVE FINANCIAL YEAR.'                                      
   DROP TABLE #RECPAY_TABLE_TMP                                      
   DROP TABLE #RECPAY_TABLE                                      
   ROLLBACK TRAN                                      
   IF @VTYP = 8                                      
    BEGIN                                      
     DELETE FROM V2_UPLOADED_FILES                           
      WHERE U_FILENAME = @FNAME AND U_MODULE = 'JV UPLOAD'                                      
    END                                      
   ELSE                                      
    BEGIN                                      
     DELETE FROM V2_UPLOADED_FILES                                      
      WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                                      
    END                                      
   RETURN                                      
  END                                      
                                      
--------------------------VALIDATION WITH USERRIGHTS TABLE ------------------------                                                      
   SELECT                                                            
     @@BACKDAYS = ISNULL(MIN(NODAYS), 0)                                                            
    FROM                                                            
     USERWRITESTABLE                                      
    WHERE                                                            
     USERCATEGORY = @USERCAT                                                            
     AND VTYP = @VTYP                                                            
     AND BOOKTYPE = @BOOKTYPE                                      
                                                         
    SELECT                                                            
     @@BACKDATE = CONVERT(DATETIME, CONVERT(VARCHAR(11), GETDATE(), 109)) - @@BACKDAYS                                                            
    SELECT                                                      
     @@ERROR_COUNT = ISNULL(COUNT(VDT), 0)                                                            
    FROM                                                            
     #RECPAY_TABLE                                           
    WHERE                                                            
     VDT < @@BACKDATE                                         
                                                           
    IF @@ERROR_COUNT > 0                                                            
     BEGIN                                                            
  SELECT 'FEW OF THE VOUCHRS ARE BACKDATED WHICH IS NOT ALLOWED.'                                            
  DROP TABLE #RECPAY_TABLE_TMP                                      
  DROP TABLE #RECPAY_TABLE                                      
  ROLLBACK TRAN                                      
  IF @VTYP = 8                                      
   BEGIN                                      
    DELETE FROM V2_UPLOADED_FILES                                      
     WHERE U_FILENAME = @FNAME AND U_MODULE = 'JV UPLOAD'                                      
   END                                      
  ELSE                                      
   BEGIN                                 
    DELETE FROM V2_UPLOADED_FILES                                      
     WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                                      
   END                                      
  RETURN                                                    
     END                
                       
/* '--------------------------UPDATE OF COST CODE ------------------------*/                                      
 IF @@BRANCHFLAG = 1                                      
  BEGIN                                      
   UPDATE #RECPAY_TABLE                                      
    SET COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')                                      
   WHERE COSTCODE IS NULL                                      
  END                                      
                                      
/*--------------------------VALIDATION FOR DIFFERENT VDTS IN SAME VOUCHER ------------------------*/                                      
                                      
 SELECT @@ERROR_COUNT = COUNT(DISTINCT VDT) FROM  #RECPAY_TABLE WHERE SRNO IN (SELECT DISTINCT SRNO FROM #RECPAY_TABLE)                                      
 GROUP BY SRNO HAVING COUNT(DISTINCT VDT) > 1                                  
 IF @@ERROR_COUNT > 0                                      
  BEGIN                                      
   SELECT 'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES'                                      
   DROP TABLE #RECPAY_TABLE_TMP                                      
   DROP TABLE #RECPAY_TABLE                                      
   ROLLBACK TRAN                                      
   IF @VTYP = 8                                      
    BEGIN                                      
     DELETE FROM V2_UPLOADED_FILES                                 
      WHERE U_FILENAME = @FNAME AND U_MODULE = 'JV UPLOAD'                                      
    END                                      
   ELSE                                      
    BEGIN                                      
     DELETE FROM V2_UPLOADED_FILES                                      
      WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                                   
    END                                      
   RETURN                                      
  END                                      
                                      
/*--------------------------VALIDATION FOR DRCR MISMATCH IN SAME VOUCHER ------------------------*/                                      
 SELECT @@ERROR_COUNT = 0               
 SELECT @@ERROR_COUNT = COUNT(1) FROM                                      
  (SELECT AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END)                                      
  FROM #RECPAY_TABLE                                    
  GROUP BY SRNO                                      
  HAVING SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) <> 0) A                                      
 IF @@ERROR_COUNT > 0                                      
  BEGIN                                      
   SELECT 'DEBIT AND CREDIT TOTALS DO NOT MATCH IN SOME VOUCHERS.'                                      
   ROLLBACK TRAN                                      
   IF @VTYP = 8                                      
    BEGIN                                      
     DELETE FROM V2_UPLOADED_FILES                                      
      WHERE U_FILENAME = @FNAME AND U_MODULE = 'JV UPLOAD'                        
    END                                      
   ELSE                                      
    BEGIN                                  
     DELETE FROM V2_UPLOADED_FILES                                      
      WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                                      
    END                                      
   RETURN                                      
  END                                      
                                      
/* '--------------------------FINAL VALIDATION BASED ON UPDFLAG ------------------------*/                                      
                                      
 SELECT @@ERROR_COUNT = COUNT(1) FROM                                      
 (                                      
  SELECT DISTINCT                                      
   CLTCODE                                      
  FROM #RECPAY_TABLE                                      
  WHERE UPDFLAG = 'N'                                      
 ) A                 
                                      
 IF @@ERROR_COUNT > 0                               
  BEGIN                                      
   SELECT 'FILE CANNOT BE UPLOADED AS THE FOLLOWING CLIENTS DO NOT EXIST' UNION ALL                                      
   SELECT DISTINCT                                      
    CLTCODE                                      
   FROM #RECPAY_TABLE                                      
   WHERE UPDFLAG = 'N'                                      
   DROP TABLE #RECPAY_TABLE_TMP                                      
   DROP TABLE #RECPAY_TABLE                                      
   ROLLBACK TRAN                                      
   IF @VTYP = 8                                      
    BEGIN                                      
     DELETE FROM V2_UPLOADED_FILES                                      
   WHERE U_FILENAME = @FNAME AND U_MODULE = 'JV UPLOAD'                                      
    END                                    
   ELSE                                      
    BEGIN                                      
     DELETE FROM V2_UPLOADED_FILES                                      
      WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'                        
    END                                      
   RETURN                                
  END                                      
                                      
 UPDATE #RECPAY_TABLE                                       
 SET ACNAME = A.LONGNAME                                       
 FROM ACMAST A (NOLOCK)                                       
 WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE                                       
                                      
 SET @@MyTempVno = CONVERT(VARCHAR,GETDATE(),12)+RIGHT(REPLACE(CONVERT(VARCHAR,GETDATE(),114),':',''),6)                                       
                                      
 INSERT INTO ANAND.ACCOUNT_AB.DBO.V2_OFFLINE_LEDGER_ENTRIES                    
   (VOUCHERTYPE,                                      
   BOOKTYPE,                                      
   SNO,                                      
   VDATE,                                      
   EDATE,                                      
   CLTCODE,                                      
   CREDITAMT,                                      
   DEBITAMT,                                      
   NARRATION,                                      
   EXCHANGE,                                   
   SEGMENT,                                      
   TPFLAG,                                      
   ADDDT,                          
   ADDBY,                                      
   STATUSID,                                      
   STATUSNAME,                                      
   ROWSTATE,                                      
   APPROVALFLAG,                                      
   APPROVALDATE,                                      
   APPROVEDBY,                                      
   VOUCHERNO,                                      
   UPLOADDT,                                      
   CLIENTNAME)                                 
                                      
 SELECT                                       
  @VTYP,'01',SRNO, VDT, EDT, CLTCODE,                                       
  CASE WHEN DRCR = 'C' THEN AMOUNT ELSE 0 END, CASE WHEN DRCR = 'D' THEN AMOUNT ELSE 0 END, NARRATION,                                       
  @EXCHANGE, @SEGMENT,0,GETDATE(),@UNAME,@STATUSID,@STATUSNAME,0,1,                                      
  GETDATE(),'SYSTEM',@@MyTempVno,GETDATE(),ACNAME                                      
 FROM                                       
  #RECPAY_TABLE                                      
                                      
 COMMIT TRAN                                
 SELECT RESULT = 'Data Uploaded Successfully'   
  
set XACT_ABORT off

GO
