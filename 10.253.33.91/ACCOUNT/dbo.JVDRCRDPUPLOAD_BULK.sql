-- Object: PROCEDURE dbo.JVDRCRDPUPLOAD_BULK
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROC [dbo].[JVDRCRDPUPLOAD_BULK_YOGESH]  
 @FNAME VARCHAR(100),        
 @UNAME VARCHAR(25),        
 @VTYP SMALLINT,        
 @BOOKTYPE VARCHAR(2),        
 @FDESC VARCHAR(25),        
 @GLCODE VARCHAR(10) = ''        
AS    
/*        
 DELETE FROM V2_UPLOADED_FILES WHERE U_FILENAME = 'C:\BulkUploads\JvDrCrDpFiles\indorebse27062007.txt'        
 Exec JVDRCRDPUPLOAD_BULK 'D:\backoffice\JvDrCrDpFiles\tempbesjv023072010.txt', 'DEMO', 6, '01', 'DP FILE', '42000020'         
rollback    
*/        
 SET NOCOUNT ON        
        
 DECLARE        
  @@ERROR_COUNT AS INT,        
  @@SQL AS VARCHAR(2000)        
        
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
   SELECT RESULT = 'THE FILE SPECIFIED DOES NOT EXIST. PLEASE TYPE CORRECT FILENAME.'        
   DROP TABLE #FEXIST        
   RETURN        
  END        
         
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
        
 IF @FDESC = 'DP FILE'        
 BEGIN        
  DECLARE @@FILENAME AS VARCHAR(100)        
  SELECT @@FILENAME = 'C:\TESTIMPORT.TXT'        
        
  CREATE TABLE #TESTIMPORT                        
  (                        
   OneRow Varchar(2000),                      
   SNO INT IDENTITY(1,1)                      
  )         
        
  SELECT @@SQL = "INSERT INTO #TESTIMPORT EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FNAME + "' "                      
  EXEC(@@SQL)                        
          
  DELETE FROM #TESTIMPORT WHERE SNO = 1        
  DELETE FROM #TESTIMPORT WHERE ONEROW IS NULL           
          
  DECLARE         
  @@FILEDATA VARCHAR(500),          
  @@INDEX INT        
         
  SELECT TOP 1        
   @@FILEDATA = ONEROW         
  FROM         
   #TESTIMPORT        
          
  SELECT @@INDEX = CHARINDEX('~', @@FILEDATA)        
          
  IF @@INDEX = 0         
  BEGIN         
   SELECT 'THE FILE WHICH YOU ARE TRYING UPLOAD IS OF WRONG FORMAT'        
   DROP TABLE #TESTIMPORT        
   RETURN        
  END        
        
  SELECT * INTO TESTIMPORT FROM #TESTIMPORT        
  DROP TABLE #TESTIMPORT        
        
  SELECT @@SQL = "MASTER.DBO.XP_CMDSHELL 'bcp " + CHAR(34) + DB_NAME() + ".DBO.TESTIMPORT" + CHAR(34) + " out " + CHAR(34) + @@FILENAME + CHAR(34) + " -c -q -U " + CHAR(34) + "classapp" + CHAR(34) + " -P " + CHAR(34) + "class26app0701" + CHAR(34) + "', no
_output "     
    
     
                     
    EXEC(@@SQL)                        
          
  DROP TABLE TESTIMPORT        
        
  CREATE TABLE #DP_TABLE_TMP        
  (        
   BATCHNO INT,        
   CLIENTTCODE VARCHAR(16),        
   DPID VARCHAR(10),           
   CLTCODE VARCHAR(10),           
   DRCR VARCHAR(1),        
   AMOUNT MONEY,        
   VVDT VARCHAR(10),        
   NARRATION VARCHAR(234),        
   SRNO INT IDENTITY (1, 1) NOT NULL        
  )        
        
  SELECT @@SQL = "BULK INSERT #DP_TABLE_TMP FROM '" + @@FILENAME + "' WITH (FIELDTERMINATOR = '~', ROWTERMINATOR = '\n', FIRSTROW = 1) "        
  EXEC(@@SQL)        
        
  INSERT INTO #RECPAY_TABLE        
   (SRNO,        
   VVDT,        
   EEDT,        
   CLTCODE,        
   DRCR,        
   AMOUNT,         NARRATION)        
  SELECT        
   SRNO,        
   VVDT,        
   VVDT,        
   UPPER(CLTCODE),        
   DRCR,        
   AMOUNT,        
   NARRATION        
  FROM #DP_TABLE_TMP        
        
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
   VVDT,        
   @GLCODE,        
   CASE DRCR WHEN 'D' THEN 'C' ELSE 'D' END,        
   AMOUNT,        
   NARRATION        
  FROM #DP_TABLE_TMP        
        
  UPDATE        
   #RECPAY_TABLE        
   SET        
    VDT = CONVERT(DATETIME, LEFT(VVDT,4) + '-' + SUBSTRING(VVDT,5,2) + '-' + RIGHT(VVDT,2)),        
    EDT = CONVERT(DATETIME, LEFT(EEDT,4) + '-' + SUBSTRING(EEDT,5,2) + '-' + RIGHT(EEDT,2)),        
    FYSTART = P.SDTCUR,        
    FYEND = P.LDTCUR,        
    UPDFLAG = 'Y',        
    ACNAME = LONGNAME,        
    COSTCODE = C.COSTCODE        
    FROM ACMAST A, PARAMETER P, COSTMAST C        
    WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE        
    AND P.CURYEAR = 1        
    AND A.ACCAT IN ('3','4','104')        
    AND A.BRANCHCODE = C.COSTNAME        
    AND A.BRANCHCODE <> 'ALL'        
          
    UPDATE        
   #RECPAY_TABLE        
   SET        
    VDT = CONVERT(DATETIME, LEFT(VVDT,4) + '-' + SUBSTRING(VVDT,5,2) + '-' + RIGHT(VVDT,2)),        
    EDT = CONVERT(DATETIME, LEFT(EEDT,4) + '-' + SUBSTRING(EEDT,5,2) + '-' + RIGHT(EEDT,2)),        
    FYSTART = P.SDTCUR,        
    FYEND = P.LDTCUR,        
    UPDFLAG = 'Y',        
    ACNAME = LONGNAME,        
    COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')        
    FROM ACMAST A, PARAMETER P        
    WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE        
    AND P.CURYEAR = 1        
    AND A.ACCAT IN ('3','4','104')        
    AND A.BRANCHCODE = 'ALL'        
 END        
        
 ELSE        
 BEGIN        
  CREATE TABLE #JVTESTIMPORT                        
  (        
   OneRow Varchar(2000),                      
   SNO INT IDENTITY(1,1)                      
  )        
        
  SELECT @@SQL = "INSERT INTO #JVTESTIMPORT EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FNAME + "' "                      
  EXEC(@@SQL)                        
          
  DELETE FROM #JVTESTIMPORT WHERE SNO = 1        
  DELETE FROM #JVTESTIMPORT WHERE ONEROW IS NULL           
          
  DECLARE         
  @@JVFILEDATA VARCHAR(500),          
  @@JVINDEX INT        
         
  SELECT TOP 1        
   @@JVFILEDATA = ONEROW         
  FROM         
   #JVTESTIMPORT        
          
  SELECT @@JVINDEX = CHARINDEX(',', @@JVFILEDATA)        
          
  IF @@JVINDEX = 0         
  BEGIN         
   SELECT 'THE FILE WHICH YOU ARE TRYING UPLOAD IS OF WRONG FORMAT'        
   DROP TABLE #JVTESTIMPORT        
   RETURN        
  END        
        
  DROP TABLE #JVTESTIMPORT        
        
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
        
  SELECT @@SQL = "BULK INSERT #RECPAY_TABLE_TMP FROM '"+ @FNAME + "' WITH (FIELDTERMINATOR = ',', FIRSTROW = 2) "        
  EXEC(@@SQL)        
        
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
   DRCR,        
   AMOUNT,        
   LEFT(NARRATION, 234)        
  FROM #RECPAY_TABLE_TMP        
        
  UPDATE        
   #RECPAY_TABLE        
   SET        
    VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),        
    EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),        
    FYSTART = P.SDTCUR,        
    FYEND = P.LDTCUR,        
    UPDFLAG = 'Y',        
    ACNAME = LONGNAME,        
    COSTCODE = C.COSTCODE        
    FROM ACMAST A, PARAMETER P, COSTMAST C        
    WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE        
    AND P.CURYEAR = 1        
    AND A.ACCAT IN ('3','4','104')        
    AND A.BRANCHCODE = C.COSTNAME        
    AND A.BRANCHCODE <> 'ALL'       
        
    UPDATE        
   #RECPAY_TABLE        
   SET        
    VDT = CONVERT(DATETIME, RIGHT(VVDT,4) + '-' + SUBSTRING(VVDT,4,2) + '-' + LEFT(VVDT,2)),        
    EDT = CONVERT(DATETIME, RIGHT(EEDT,4) + '-' + SUBSTRING(EEDT,4,2) + '-' + LEFT(EEDT,2)),        
    FYSTART = P.SDTCUR,        
    FYEND = P.LDTCUR,        
    UPDFLAG = 'Y',        
    ACNAME = LONGNAME,        
    COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')        
    FROM ACMAST A, PARAMETER P        
    WHERE A.CLTCODE = #RECPAY_TABLE.CLTCODE        
    AND P.CURYEAR = 1        
    AND A.ACCAT IN ('3','4','104')        
  AND A.BRANCHCODE = 'ALL'        
 END         
          
 BEGIN TRAN        
        
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
        
 IF @@ERROR_COUNT > 0        
  BEGIN        
   SELECT 'THE FILE YOU ARE UPLOADING IS ALREADY UPLOADED. PLEASE UPLOAD ANOTHER FILE.' + @FNAME        
   ROLLBACK TRAN        
   RETURN        
  END        
        
 INSERT INTO V2_UPLOADED_FILES        
 SELECT        
  @FNAME,        
  @FNAME,        
  COUNT(1),        
  'B',        
  GETDATE(),        
  @UNAME,        
  'DRCR NOTE UPLOAD'        
        
/* '--------------------------DECLARATION OF VARIABLES FOR VALIDATIONS ------------------------*/        
        
 DECLARE        
  @@STD_DATE VARCHAR(11),        
  @@LST_DATE VARCHAR(11),        
  @@VNOMETHOD INT,        
  @@ACNAME CHAR(100),        
  @@MICRNO VARCHAR(10),        
  @@DRCR VARCHAR(1)        
        
        
/* '--------------------------VALIDATION FOR VOUCHER DATE NOT IN CURRENT FIN YEAR ------------------------*/        
        
 SELECT @@ERROR_COUNT = COUNT(1) FROM #RECPAY_TABLE WHERE VDT NOT BETWEEN FYSTART AND FYEND        
        
 IF @@ERROR_COUNT > 0        
  BEGIN        
   SELECT 'DATE MISMATCH'        
   IF @FDESC = 'DP FILE'        
    DROP TABLE #DP_TABLE_TMP        
   ELSE        
    DROP TABLE #RECPAY_TABLE_TMP        
   DROP TABLE #RECPAY_TABLE        
   ROLLBACK TRAN        
   DELETE FROM V2_UPLOADED_FILES        
    WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'        
   RETURN        
  END        
        
/* '--------------------------UPDATE OF COST CODE ------------------------*/        
        
 UPDATE #RECPAY_TABLE        
  SET COSTCODE = (SELECT TOP 1 COSTCODE FROM COSTMAST WHERE COSTNAME = 'HO')        
 WHERE COSTCODE IS NULL  
 
 
 /*---------------------------------------change by suresh to stop future dated upload --------  */       
      
      
 SELECT              
  @@ERROR_COUNT = COUNT(DISTINCT VDT)              
 FROM      
       
  #RECPAY_TABLE where vdt > getdate()+ 2   
IF @@ERROR_COUNT >= 1              
  BEGIN              
   SELECT              
    'VOUCHER DATE SHOULD BE CURRENT DATE', 'NA', 'NA'              
   DROP TABLE #RECPAY_TABLE_TMP              
   DROP TABLE #RECPAY_TABLE              
   ROLLBACK TRAN              
   DELETE              
   FROM              
    V2_UPLOADED_FILES              
   WHERE              
    U_FILENAME = @FNAME              
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'              
   RETURN              
  END              
      
      
  SELECT              
  @@ERROR_COUNT = COUNT(DISTINCT EDT)              
 FROM      
       
  #RECPAY_TABLE where edt > getdate()+ 2   
IF @@ERROR_COUNT >= 1              
  BEGIN              
   SELECT              
    'FUTURE DATE ENTRY NOT ALLOWED', 'NA', 'NA'              
   DROP TABLE #RECPAY_TABLE_TMP              
   DROP TABLE #RECPAY_TABLE              
   ROLLBACK TRAN              
   DELETE              
   FROM              
    V2_UPLOADED_FILES              
   WHERE              
    U_FILENAME = @FNAME              
   AND U_MODULE = 'RECEIPT/PAYMENT UPLOAD'              
   RETURN              
  END             
      
            
             
   /* ---------------------------------------change by suresh to stop future dated upload -------- */             
        
/*--------------------------VALIDATION FOR DIFFERENT VDTS IN SAME VOUCHER ------------------------*/        
        
 SELECT @@ERROR_COUNT = COUNT(DISTINCT VDT) FROM  #RECPAY_TABLE WHERE SRNO IN (SELECT DISTINCT SRNO FROM #RECPAY_TABLE)        
 GROUP BY SRNO HAVING COUNT(DISTINCT VDT) > 1        
 IF @@ERROR_COUNT > 0        
  BEGIN        
   SELECT 'SOME OF THE VOUCHERS ARE HAVING DIFFERENT VOUCHER DATES'        
   IF @FDESC = 'DP FILE'        
    DROP TABLE #DP_TABLE_TMP        
   ELSE        
    DROP TABLE #RECPAY_TABLE_TMP        
   DROP TABLE #RECPAY_TABLE        
   ROLLBACK TRAN        
   DELETE FROM V2_UPLOADED_FILES        
   WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'        
   RETURN        
  END        
        
---------------------------VALIDATION FOR INACTIVE CLIENTS FROM CLIENT5---------------------        
 UPDATE         
  #RECPAY_TABLE         
  SET UPDFLAG = 'N'         
 FROM ( SELECT         
  PARTY_CODE,         
  INACTIVEFROM         
 FROM MSAJAG.DBO.CLIENT5 C5 WITH(NOLOCK),         
  MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)         
 WHERE C2.CL_CODE = C5.CL_CODE         
  AND C2.PARTY_CODE IN (SELECT CLTCODE FROM #RECPAY_TABLE)         
  AND INACTIVEFROM <= GETDATE()) C         
 WHERE CLTCODE = C.PARTY_CODE        
    
     
    
/*--------------------------VALIDATION FOR DRCR MISMATCH IN SAME VOUCHER ------------------------*/        
        
 SELECT @@ERROR_COUNT = COUNT(1) FROM        
  (SELECT AMOUNT = SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END)        
  FROM #RECPAY_TABLE        
  GROUP BY SRNO        
  HAVING SUM(CASE WHEN DRCR = 'D' THEN AMOUNT ELSE -AMOUNT END) <> 0) A        
 IF @@ERROR_COUNT > 0        
BEGIN        
   SELECT 'DEBIT AND CREDIT TOTALS DO NOT MATCH IN SOME VOUCHERS.'        
   IF @FDESC = 'DP FILE'        
    DROP TABLE #DP_TABLE_TMP        
   ELSE        
    DROP TABLE #RECPAY_TABLE_TMP        
   DROP TABLE #RECPAY_TABLE        
   ROLLBACK TRAN        
   DELETE FROM V2_UPLOADED_FILES        
   WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'        
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
   IF @FDESC = 'DP FILE'        
    DROP TABLE #DP_TABLE_TMP        
   ELSE        
    DROP TABLE #RECPAY_TABLE_TMP        
   DROP TABLE #RECPAY_TABLE        
   ROLLBACK TRAN        
   DELETE FROM V2_UPLOADED_FILES        
    WHERE U_FILENAME = @FNAME AND U_MODULE = 'DRCR NOTE UPLOAD'        
   RETURN        
  END        
        
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
  #RECPAY_TABLE        
        
 SELECT TOP 1        
  @@VNOMETHOD = VNOFLAG,        
  @@STD_DATE = CONVERT(VARCHAR(11), SDTCUR, 109),        
  @@LST_DATE = CONVERT(VARCHAR(11), LDTCUR, 109)        
 FROM        
  PARAMETER        
 WHERE        
  @@VDT BETWEEN SDTCUR AND LDTCUR        
        
 /*DP FILE SINGLE VNO GENERATION LOGIC*/        
 IF @FDESC = 'DP FILE'        
 BEGIN        
  SELECT         
   VVDT,        
   EEDT,        
   CLTCODE,        
   DRCR,        
   AMOUNT = SUM(AMOUNT),        
   NARRATION = MAX(NARRATION),        
   VDT,        
   UPDFLAG,        
   EDT,        
   ACNAME,        
   FYSTART,        
   FYEND,        
   COSTCODE,        
   LNO         
  INTO         
   #GLDETAIL        
  FROM         
   #RECPAY_TABLE        
  WHERE         
   DRCR = 'C'        
  GROUP BY         
   VVDT,        
   EEDT,        
   CLTCODE,        
   DRCR,        
   VDT,        
   UPDFLAG,        
   EDT,        
   ACNAME,        
   FYSTART,        
   FYEND,        
   COSTCODE,        
   LNO        
         
  DELETE FROM         
   #RECPAY_TABLE        
  WHERE         
   DRCR = 'C'        
         
  INSERT INTO #RECPAY_TABLE        
  (        
   SRNO,        
   VVDT,        
   EEDT,        
   CLTCODE,        
   DRCR,        
   AMOUNT,        
   NARRATION,        
   VDT,        
   UPDFLAG,        
   EDT,        
   ACNAME,        
   FYSTART,        
   FYEND,        
   COSTCODE,        
   LNO        
  )        
  SELECT        
   1,        
   VVDT,        
   EEDT,        
   CLTCODE,        
   DRCR,        
   AMOUNT,        
   NARRATION,        
   VDT,        
   UPDFLAG,        
   EDT,        
   ACNAME,        
   FYSTART,        
   FYEND,        
   COSTCODE,        
   LNO        
  FROM         
  #GLDETAIL        
         
  UPDATE        
   #RECPAY_TABLE        
  SET        
   SRNO = 1        
 END        
 /*DP FILE SINGLE VNO GENERATION LOGIC*/        
        
 SELECT        
  @@NOREC = COUNT(DISTINCT SRNO)        
 FROM        
  #RECPAY_TABLE        
        
 IF @@VNOMETHOD = 0        
  BEGIN        
   SELECT        
    @@MAXVNO = CONVERT(VARCHAR(12), ISNULL(MAX(CONVERT(NUMERIC,LASTVNO)),0))        
   FROM        
    LASTVNO WITH (TABLOCKX,HOLDLOCK)        
   WHERE        
    VTYP = @VTYP        
    AND BOOKTYPE = @BOOKTYPE        
    AND VDT BETWEEN @@STD_DATE AND @@LST_DATE + ' 23:59'        
   IF @@MAXVNO = '0'        
    BEGIN        
     SELECT @@MAXVNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, RIGHT(@@STD_DATE, 4) + '00000000') + @@NOREC)        
     SELECT @@VNO = RIGHT(@@STD_DATE, 4) + '00000001', @@RCOUNT = 0        
    END        
   ELSE        
    BEGIN        
     SELECT @@VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO)+1), @@RCOUNT = 1        
     SELECT @@MAXVNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO)+@@NOREC)        
    END        
   IF @@RCOUNT = 1        
    BEGIN        
     UPDATE        
      LASTVNO        
     SET        
      LASTVNO = @@MAXVNO        
     WHERE        
      VTYP = @VTYP        
      AND BOOKTYPE = @BOOKTYPE        
      AND VDT BETWEEN @@STD_DATE AND @@LST_DATE + ' 23:59'        
    END        
   ELSE        
    BEGIN        
     INSERT INTO        
      LASTVNO        
      (VTYP, BOOKTYPE, VDT, LASTVNO)        
     VALUES        
      (@VTYP, @BOOKTYPE, @@STD_DATE, @@MAXVNO)        
    END        
  END        
 ELSE IF @@VNOMETHOD = 1        
  BEGIN        
   SELECT        
    @@MAXVNO = CONVERT(VARCHAR(12), ISNULL(MAX(CONVERT(NUMERIC,LASTVNO)),0))        
   FROM        
    LASTVNO WITH (TABLOCKX,HOLDLOCK)        
   WHERE        
    VTYP = @VTYP        
    AND BOOKTYPE = @BOOKTYPE        
    AND VDT BETWEEN @@VDT AND @@VDT + ' 23:59'        
   IF @@MAXVNO = '0'        
    BEGIN        
     SELECT @@MAXVNO = RIGHT(@@VDT, 4) + RIGHT('0' + RTRIM(LTRIM(CONVERT(VARCHAR(2), MONTH(@@VDT)))), 2) + RIGHT('0' + LTRIM(RTRIM(CONVERT(VARCHAR(2), DAY(@@VDT)))), 2) + '0000'        
     SELECT @@MAXVNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO) + @@NOREC)        
     SELECT @@VNO = RIGHT(@@VDT, 4) + RIGHT('0' + RTRIM(LTRIM(CONVERT(VARCHAR(2), MONTH(@@VDT)))), 2) + RIGHT('0' + LTRIM(RTRIM(CONVERT(VARCHAR(2), DAY(@@VDT)))), 2) + '0001', @@RCOUNT = 0        
    END        
   ELSE        
    BEGIN        
     SELECT @@VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO)+1), @@RCOUNT = 1        
     SELECT @@MAXVNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO)+@@NOREC)        
    END        
   IF @@RCOUNT = 1        
    BEGIN        
     UPDATE        
      LASTVNO        
     SET        
      LASTVNO = @@MAXVNO        
     WHERE        
      VTYP = @VTYP        
      AND BOOKTYPE = @BOOKTYPE        
      AND VDT BETWEEN @@VDT AND @@VDT + ' 23:59'        
    END        
   ELSE        
    BEGIN        
     INSERT INTO        
      LASTVNO        
      (VTYP, BOOKTYPE, VDT, LASTVNO)        
     VALUES        
      (@VTYP, @BOOKTYPE, @@VDT, @@MAXVNO)        
    END        
  END        
 ELSE IF @@VNOMETHOD = 2        
  BEGIN        
   SELECT        
    @@MAXVNO = CONVERT(VARCHAR(12), ISNULL(MAX(CONVERT(NUMERIC,LASTVNO)),0))        
   FROM        
    LASTVNO WITH (TABLOCKX,HOLDLOCK)        
   WHERE        
    VTYP = @VTYP        
    AND BOOKTYPE = @BOOKTYPE        
    AND MONTH(VDT) = MONTH(@@VDT)        
    AND YEAR(VDT) = YEAR(@@VDT)        
   IF @@MAXVNO = '0'        
    BEGIN        
     SELECT @@MAXVNO = RIGHT(@@VDT, 4) + RIGHT('0' + RTRIM(LTRIM(CONVERT(VARCHAR(2), MONTH(@@VDT)))), 2) + '000000'        
     SELECT @@MAXVNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO) + @@NOREC)        
     SELECT @@VNO = RIGHT(@@VDT, 4) + RIGHT('0' + RTRIM(LTRIM(CONVERT(VARCHAR(2), MONTH(@@VDT)))), 2) + '000001', @@RCOUNT = 0        
    END        
   ELSE        
    BEGIN        
     SELECT @@VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO)+1), @@RCOUNT = 1        
     SELECT @@MAXVNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC, @@MAXVNO)+@@NOREC)        
    END        
   IF @@RCOUNT = 1        
    BEGIN        
     UPDATE        
      LASTVNO        
     SET        
      LASTVNO = @@MAXVNO        
     WHERE        
      VTYP = @VTYP        
      AND BOOKTYPE = @BOOKTYPE        
      AND MONTH(VDT) = MONTH(@@VDT)        
      AND YEAR(VDT) = YEAR(@@VDT)        
    END        
   ELSE        
    BEGIN        
     INSERT INTO        
      LASTVNO        
      (VTYP, BOOKTYPE, VDT, LASTVNO)        
     VALUES        
      (@VTYP, @BOOKTYPE, @@VDT, @@MAXVNO)        
    END        
  END        
        
 UPDATE        
  #RECPAY_TABLE        
 SET VNO = CONVERT(VARCHAR(12), CONVERT(NUMERIC,@@VNO) + SRNO - 1)        
        
        
/* '--------------------------AUTO GENERATION OF LNO ------------------------*/        
        
 SET @@LNOCUR = CURSOR FOR        
  SELECT DISTINCT SRNO FROM #RECPAY_TABLE        
 OPEN @@LNOCUR        
  FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO        
 WHILE @@FETCH_STATUS = 0        
  BEGIN        
  INSERT INTO #RECPAY_TABLE_LNO        
    (SNO)        
   SELECT SNO FROM #RECPAY_TABLE WHERE SRNO = @@LNOVNO        
   UPDATE RP        
    SET LNO = RL.LNO        
   FROM #RECPAY_TABLE RP, #RECPAY_TABLE_LNO RL        
   WHERE RP.SNO = RL.SNO        
   TRUNCATE TABLE #RECPAY_TABLE_LNO        
   FETCH NEXT FROM @@LNOCUR INTO @@LNOVNO        
  END        
 CLOSE @@LNOCUR        
 DEALLOCATE @@LNOCUR        
 DROP TABLE #RECPAY_TABLE_LNO        
        
/* '--------------------------BEGIN POSTING TO TRANSACTION TABLES ------------------------*/        
/*==============================        
      LEDGER RECORD        
==============================*/        
 INSERT        
 INTO LEDGER        
 SELECT        
  VTYP = @VTYP,        
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
  CLTCODE,        
  BOOKTYPE = @BOOKTYPE,        
  ENTEREDBY = @UNAME,        
  PDT = GETDATE(),        
  CHECKEDBY = @UNAME,        
  ACTNODAYS = 0,        
  NARRATION        
 FROM        
  #RECPAY_TABLE        
        
/*==============================        
 LEDGER3 RECORD        
==============================*/        
 INSERT        
 INTO LEDGER3        
 SELECT        
  NARATNO = LNO,        
  NARRATION,        
  REFNO = 0,        
  VTYP = @VTYP,        
  VNO,        
  BOOKTYPE = @BOOKTYPE        
      FROM        
  #RECPAY_TABLE        
        
        
        
        
 DELETE FROM TEMPLEDGER2        
  WHERE SESSIONID = '9999999999'        
 INSERT INTO TEMPLEDGER2        
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
  #RECPAY_TABLE RP,        
  COSTMAST C        
 WHERE        
  RP.COSTCODE = C.COSTCODE        
        
 DECLARE @@L2CUR AS CURSOR,        
  @@L2VNO AS VARCHAR(12)        
 SET @@L2CUR = CURSOR FOR        
  SELECT DISTINCT VNO FROM #RECPAY_TABLE ORDER BY VNO        
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
  DEALLOCATE @@L2CUR        
 COMMIT TRAN     
        
 SELECT RESULT = '0~Data Uploaded Successfully'        
 UNION ALL        
 SELECT RESULT = VNO + ', ' + DRCR + ', ' + CLTCODE + ', ' + CONVERT(VARCHAR, AMOUNT) FROM #RECPAY_TABLE ORDER BY 1         
 IF @FDESC = 'DP FILE'        
  DROP TABLE #DP_TABLE_TMP        
 ELSE        
 DROP TABLE #RECPAY_TABLE_TMP        
 DROP TABLE #RECPAY_TABLE

GO
