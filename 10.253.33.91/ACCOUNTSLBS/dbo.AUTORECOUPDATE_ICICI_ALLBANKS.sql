-- Object: PROCEDURE dbo.AUTORECOUPDATE_ICICI_ALLBANKS
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROC [dbo].[AUTORECOUPDATE_ICICI_ALLBANKS]
 @FILENAME VARCHAR(100),                        
 @UNAME VARCHAR(100),                        
 @BANKCODE VARCHAR(10),                        
 @STATUSID VARCHAR(10),                        
 @STATUSNAME VARCHAR(100),                  
 @BANK_TYPE VARCHAR(10),                  
 @STAT_TYPE VARCHAR(10),                  
 @LOGIN VARCHAR(10),                  
 @PWD VARCHAR(15),                  
 @PROCESS_STATUS BIT = 0                    
                    
                        
AS                        
                        
/*                      
EXEC AUTORECOUPDATE_HDFC 'D:\BACKOFFICE\HDFCRECO\0308061.dat', 'TEST', 'HDFC001', 'BROKER','BROKER'                        
SELECT * FROM BANKRECO WHERE CLTCODE = 'HDFC001' AND BOOKDATE LIKE 'mAR 30 2006%'                        
EXEC AUTORECOUPDATE_HDFC 'D:\BackOffice\HDFCRECO\0308061.dat', 'jaydeep','hdfc001','broker','broker'                    
SELECT TOP 1 * FROM BANKRECO                    
*/                      
DECLARE                        
 @@SQL_QUERY AS VARCHAR(1000),                        
 @@CROSSREFERENCENO INT,                        
 @@TABLE_EXIST VARCHAR(20),                        
 @@RECORD_COUNT TINYINT,                        
 @@RECO_STATUS CHAR(1),                        
 @@FILE_EXIST INT,                        
 @@CLTCODE_EXIST INT,                        
 @@MICRNO VARCHAR(20)                        
                        
SET NOCOUNT ON                        
                        
SELECT @@CLTCODE_EXIST = COUNT(1) FROM ACMAST WHERE CLTCODE = @BANKCODE  AND ACCAT = 2                        
                        
IF @@CLTCODE_EXIST = 0                        
 BEGIN                        
  SELECT 'BANK CODE DOSE NOT EXIST.'                        
  RETURN                        
 END                        
                        
SELECT @@MICRNO = ISNULL(MICRNO, 0) FROM ACMAST WHERE CLTCODE = @BANKCODE  AND ACCAT = 2                        
                        
/*-------------------------VALIDATION FOR SINGLE VOUCHER TYPE BASED ON DRCR ------------------------*/                        
DECLARE                        
 @@ERROR_COUNT SMALLINT,                    
 @@EXIST_COUNT_BEFORE SMALLINT,                    
 @@EXIST_COUNT_AFTER SMALLINT                    
SELECT                        
 @@ERROR_COUNT = COUNT(1)                        
FROM                        
 (                        
  SELECT                        
   U_FILENAME                        
  FROM                        
   V2_UPLOADED_FILES                        
  WHERE                        
   U_FILENAME = @FILENAME                        
   AND U_MODULE = 'HDFC_RECO UPLOAD'                        
 ) A                        
/*IF @@ERROR_COUNT > 0                        
BEGIN                        
 SELECT                        
  'THE FILE YOU ARE UPLOADING IS ALREADY UPLOADED. PLEASE UPLOAD ANOTHER FILE.'                        
 RETURN                        
END       */                        
                        
SELECT @@CROSSREFERENCENO = ISNULL(MAX(CROSSREFERENCENO), 0) FROM BANKRECO                        
                  
CREATE TABLE #HDFCRECO                    
(                  
 BOOKDATE VARCHAR(11)                  
)                  
                  
CREATE TABLE #ICICIRECO                    
(                  
 SR_NO INT,                  
 TXN_ID VARCHAR(25),            
 VALUE_DATE VARCHAR(11),                  
 BOOKDATE VARCHAR(11)                  
)  

CREATE TABLE #BOIRECO      
(    
  TXN_ID VARCHAR(500)  
)    

                
                  
IF @BANK_TYPE = 'CITYRECO'                  
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD REFERENCE_NO VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(1),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " REFNO VARCHAR(100)"                  
END                  
ELSE IF (@BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'TAB') OR @BANK_TYPE = 'UTIRECO'                   
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD [DESCRIPTION] VARCHAR(100), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " LEDGER_BALANCE VARCHAR(20),"                    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " VALUEDATE VARCHAR(11),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"          
 SELECT @@SQL_QUERY = @@SQL_QUERY + " TRANSACTION_BRANCH VARCHAR(30)"                  
END                  
ELSE IF @BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'CSV'                  
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD VALUEDATE VARCHAR(11), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(1),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " [DESCRIPTION] VARCHAR(100),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " TRANSACTION_BRANCH VARCHAR(30),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " RUNNING_BAL VARCHAR(20)"                  
END                  
ELSE IF @BANK_TYPE = 'BOIRECO'     
BEGIN    
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD [DESCRIPTION] VARCHAR(100), "    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(4),"    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " RUNNING_BAL VARCHAR(20)"    
    
END  
ELSE IF @BANK_TYPE = 'ICICIRECO'                   
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO ADD [DESCRIPTION] VARCHAR(100), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(2),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " RUNNING_BAL VARCHAR(20)"                  
                  
END                  
                  
EXEC (@@SQL_QUERY)                  
                  
IF @BANK_TYPE = 'ICICIRECO' OR @BANK_TYPE = 'BOIRECO' 
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #ICICIRECO ADD REFERENCE_NO VARCHAR(20), [DESCRIPTION] VARCHAR(100), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR CHAR(2),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " RUNNING_BAL VARCHAR(20)"                  
                  
 EXEC (@@SQL_QUERY)                  
END                  
                  
CREATE TABLE [#BANKRECOSAVE_TEMP]                        
 (                        
  CLTCODE VARCHAR(10),                        
  BOOKDATE DATETIME,                        
  [DESCRIPTION] VARCHAR(50),                        
  AMOUNT VARCHAR(20),                        
  DRCR VARCHAR(1),                        
  VALUEDATE DATETIME,                        
  REFERENCENO VARCHAR(30),                        
  STATUSID VARCHAR(15),                        
  STATUSNAME VARCHAR(25),                        
  LOGINNAME VARCHAR(25),                        
  STATUS VARCHAR(9),                        
  MICRNO INT,                        
  DUMMY1 VARCHAR(15) ,                        
  DUMMY2 VARCHAR(15),                        
  AMOUNTLEDGR1 VARCHAR(20),                        
  CROSSREFERENCENO [INT] IDENTITY (1, 1) NOT NULL                        
 )                        
ON [PRIMARY]                        
                        
CREATE TABLE [#BANKRECOSAVE]                        
 (                        
	CLTCODE VARCHAR(10),                        
	BOOKDATE DATETIME,                        
	[DESCRIPTION] VARCHAR(50),                        
	AMOUNT MONEY,                        
	DRCR VARCHAR(1),                        
	VALUEDATE DATETIME,                        
	REFERENCENO VARCHAR(30),                        
	STATUSID VARCHAR(15),                        
	STATUSNAME VARCHAR(25),                        
	LOGINNAME VARCHAR(25),                        
	CROSSREFERENCENO [INT],                        
	STATUS VARCHAR(9),                        
	MICRNO INT,                        
	DUMMY1 VARCHAR(15) ,                        
	DUMMY2 VARCHAR(15),                        
	AMOUNTLEDGR1 MONEY,
    L1_SNO INT,               
    VTYP SMALLINT,               
    BOOKTYPE CHAR(2),               
    VNO VARCHAR(12),               
    SLIPNO INT                        
 )                        
ON [PRIMARY]                       
                  
CREATE TABLE #TESTIMPORT                                  
(                          
 OneRow Varchar(2000),                                
 SNO INT IDENTITY(1,1)                                
)                     

IF @BANK_TYPE = 'BOIRECO'    
BEGIN    
 SELECT @@SQL_QUERY = "BULK INSERT #BOIRECO FROM '" + @FILENAME + "' WITH (FIRSTROW = 2, ROWTERMINATOR = '\n', KEEPNULLS)"    
END                 
ELSE IF @BANK_TYPE = 'ICICIRECO'                  
BEGIN                  
 SELECT @@SQL_QUERY = "EXEC BULKCOPYRECO_ALLBANK '" + @FILENAME + "',  '#ICICIRECO','" + @BANK_TYPE + "','" + @STAT_TYPE + "','" + @LOGIN + "','" + @PWD + "'"                  
          
                   
END                  
ELSE IF @BANK_TYPE <> 'CANARARECO'                  
BEGIN                  
 SELECT @@SQL_QUERY = "EXEC BULKCOPYRECO_ALLBANK '" + @FILENAME + "',  '#HDFCRECO','" + @BANK_TYPE + "','" + @STAT_TYPE + "','" + @LOGIN + "','" + @PWD + "'"                  
          
END                  
                  
--PRINT @@SQL_QUERY          
EXEC (@@SQL_QUERY)                   
                  
                  
                  
                  
IF @BANK_TYPE = 'CITYRECO'                  
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD [DESCRIPTION] VARCHAR(100), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " VALUEDATE VARCHAR(11), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20)"                  
END                  
ELSE IF (@BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'TAB') OR @BANK_TYPE = 'UTIRECO'                   
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD AMOUNT VARCHAR(20), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR VARCHAR(1) "                  
END                  
ELSE IF @BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'CSV'                  
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD CREDIT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20)"                  
END            
ELSE IF @BANK_TYPE = 'BOIRECO'    
BEGIN    
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD VALUEDATE VARCHAR(11), "    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"    
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20) "    
END         
ELSE IF @BANK_TYPE = 'ICICIRECO'                  
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD VALUEDATE VARCHAR(11), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20) "                  
END                  
ELSE                  
BEGIN                  
 SELECT @@SQL_QUERY = "ALTER TABLE #HDFCRECO "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " ADD [DESCRIPTION] VARCHAR(100), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " VALUEDATE VARCHAR(11), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " CREDIT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DEBIT VARCHAR(20),"                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " AMOUNT VARCHAR(20), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " DRCR VARCHAR(1), "                  
 SELECT @@SQL_QUERY = @@SQL_QUERY + " REFERENCE_NO VARCHAR(20) "                  
END                  
                  
                  
EXEC (@@SQL_QUERY)                  
              
                  
IF @BANK_TYPE = 'ICICIRECO'                  
BEGIN                  
 INSERT INTO #HDFCRECO (BOOKDATE,[DESCRIPTION],REFERENCE_NO,DRCR,AMOUNT,RUNNING_BAL,VALUEDATE) SELECT BOOKDATE,[DESCRIPTION],REFERENCE_NO,DRCR,REPLACE(AMOUNT, ',', ''),RUNNING_BAL,VALUE_DATE FROM #ICICIRECO                  
          
END     

IF @BANK_TYPE = 'BOIRECO'    
BEGIN  
 INSERT INTO #HDFCRECO(BOOKDATE, [DESCRIPTION], REFERENCE_NO, DRCR, AMOUNT, RUNNING_BAL)   
 SELECT   
  SUBSTRING(TXN_ID, 1, 10),  
  SUBSTRING(TXN_ID, 11, 30),  
  LTRIM(RTRIM(SUBSTRING(TXN_ID, 42, 8))),  
  LEFT(LTRIM(SUBSTRING(TXN_ID, 50, 4)), 1),  
  REPLACE(SUBSTRING(TXN_ID, 55, 11), ',', ''),  
  SUBSTRING(TXN_ID, 67, 15)  
  FROM #BOIRECO  
END               
                  
SELECT * INTO HDFCRECO FROM #HDFCRECO                  
      
                  
IF @BANK_TYPE = 'CITYRECO'                  
BEGIN                  
 UPDATE HDFCRECO SET [DESCRIPTION] = 'CITY BANK RECONCILIATION FILE', VALUEDATE = BOOKDATE                  
END                  
ELSE IF (@BANK_TYPE = 'HDFCRECO' AND @STAT_TYPE = 'TAB') OR @BANK_TYPE = 'UTIRECO'                   
BEGIN                  
 UPDATE HDFCRECO SET AMOUNT = CASE WHEN (DEBIT IS NULL OR CONVERT(MONEY, DEBIT) = 0) THEN CREDIT ELSE DEBIT END, DRCR = CASE WHEN (DEBIT IS NULL OR CONVERT(MONEY, DEBIT) = 0) THEN 'C' ELSE 'D' END                  
          
END                  
ELSE IF @BANK_TYPE = 'ICICIRECO'                   
BEGIN                  
 UPDATE HDFCRECO SET VALUEDATE = BOOKDATE, DRCR = CASE WHEN DRCR = 'DR' THEN 'D' ELSE 'C' END                  
END                  
              
ELSE IF @BANK_TYPE = 'BOIRECO'     
BEGIN    
 UPDATE HDFCRECO SET VALUEDATE = BOOKDATE
END    
 
                  
IF @BANK_TYPE = 'ICICIRECO'                  
BEGIN                  
 INSERT INTO #BANKRECOSAVE_TEMP                        
 SELECT                        
  @BANKCODE,                        
  BOOKDATE = CONVERT(DATETIME,  (LEFT(BOOKDATE, 2) + '/' + SUBSTRING(BOOKDATE, 4, 2) + '/' + RIGHT(BOOKDATE,4)), 101),                        
          
  [DESCRIPTION],                        
  AMOUNT,                        
  DRCR,                        
  VALUEDATE = CONVERT(DATETIME, RIGHT(VALUEDATE,4) + '-' + LEFT(VALUEDATE, 2) + '-' + SUBSTRING(VALUEDATE, 4, 2)),                        
          
  REFERENCE_NO,                        
  @STATUSID,                  
  @STATUSNAME,                        
  @UNAME,                        
  'UNMATCHED',                        
  @@MICRNO,                        
  '',                        
  '',                        
  ''                        
 FROM                        
  HDFCRECO                    
                  
END 
ELSE IF @BANK_TYPE = 'BOIRECO'    
BEGIN    
 INSERT INTO #BANKRECOSAVE_TEMP          
 SELECT          
  @BANKCODE,          
  BOOKDATE = CONVERT(DATETIME,  (SUBSTRING(BOOKDATE, 4, 2) + '/' + LEFT(BOOKDATE, 2) + '/' + RIGHT(BOOKDATE,4)), 101),          
  [DESCRIPTION],          
  AMOUNT,          
  DRCR,          
  VALUEDATE = CONVERT(DATETIME, RIGHT(VALUEDATE,4) + '-' + SUBSTRING(VALUEDATE, 4, 2) + '-' + LEFT(VALUEDATE, 2)) ,          
  REFERENCE_NO,          
  @STATUSID,          
  @STATUSNAME,          
  @UNAME,          
  'UNMATCHED',          
  @@MICRNO,          
  '',          
  '',          
  ''          
 FROM          
  HDFCRECO      
    
END                     
ELSE                  
BEGIN                  
 INSERT INTO #BANKRECOSAVE_TEMP                        
 SELECT                        
  @BANKCODE,                        
  BOOKDATE = CONVERT(DATETIME, (LEFT(BOOKDATE, 2) + '/' + SUBSTRING(BOOKDATE, 4, 2) + '/' + RIGHT(BOOKDATE,4)), 103),                        
          
  [DESCRIPTION],                        
  AMOUNT,                        
  DRCR,                        
  VALUEDATE = CONVERT(DATETIME, RIGHT(VALUEDATE,4) + '-' + SUBSTRING(VALUEDATE, 4, 2) + '-' + LEFT(VALUEDATE, 2)),                        
          
  REFERENCE_NO,                        
  @STATUSID,                 
  @STATUSNAME,                        
  @UNAME,                        
  'UNMATCHED',                        
  @@MICRNO,                        
  '',                        
  '',                        
  ''                        
 FROM                        
  HDFCRECO                    
END                  
                  
              
DROP TABLE HDFCRECO      

INSERT INTO #BANKRECOSAVE                        
SELECT                        
 @BANKCODE,                        
 BOOKDATE,                      
 [DESCRIPTION],                        
 AMOUNT = CASE WHEN DRCR = 'D' THEN ABS(CONVERT(MONEY,AMOUNT)) ELSE CONVERT(MONEY,AMOUNT) END ,                        
 DRCR,                        
 VALUEDATE,                        
 REFERENCENO = CONVERT(VARCHAR, CONVERT(BIGINT, REFERENCENO)),                           
 @STATUSID,                        
 @STATUSNAME,                        
 @UNAME,                        
 CROSSREFERENCNEO = CONVERT(INT, @@CROSSREFERENCENO + CROSSREFERENCENO),                        
 'UNMATCHED',                        
 @@MICRNO,                        
 '',                        
 '',                        
 0, 0, 0, '', '', 0                        
FROM                        
 #BANKRECOSAVE_TEMP                        
WHERE                   
 REFERENCENO NOT LIKE '%[A-Z]%'                  
                  
INSERT INTO #BANKRECOSAVE                        
SELECT              
 @BANKCODE,                        
 BOOKDATE,                      
 [DESCRIPTION],                        
 AMOUNT = CASE WHEN DRCR = 'D' THEN ABS(CONVERT(MONEY,AMOUNT)) ELSE CONVERT(MONEY,AMOUNT) END ,                        
 DRCR,                        
 VALUEDATE,                        
 ISNULL(REFERENCENO, 0),                        
 @STATUSID,                        
 @STATUSNAME,                        
 @UNAME,                        
 CROSSREFERENCNEO = CONVERT(INT, @@CROSSREFERENCENO + CROSSREFERENCENO),                        
 'UNMATCHED',                        
 @@MICRNO,                        
 '',                        
 '',                        
 0, 0, 0, '', '', 0                        
FROM                        
 #BANKRECOSAVE_TEMP                        
WHERE                   
 REFERENCENO LIKE '%[A-Z]%'                  
           
INSERT INTO #BANKRECOSAVE                        
SELECT                        
 @BANKCODE,                        
 BOOKDATE,                      
 [DESCRIPTION],                        
 AMOUNT = CASE WHEN DRCR = 'D' THEN ABS(CONVERT(MONEY,AMOUNT)) ELSE CONVERT(MONEY,AMOUNT) END ,                        
 DRCR,                        
 VALUEDATE,                        
 REFERENCENO = ISNULL(CONVERT(VARCHAR, CONVERT(BIGINT, REFERENCENO)), 0),                        
 @STATUSID,                        
 @STATUSNAME,                        
 @UNAME,                        
 CROSSREFERENCNEO = CONVERT(INT, @@CROSSREFERENCENO + CROSSREFERENCENO),                        
 'UNMATCHED',                        
 @@MICRNO,                        
 '',                        
 '',                        
 0, 0, 0, '', '', 0                        
FROM                        
 #BANKRECOSAVE_TEMP                        
WHERE                   
 REFERENCENO IS NULL                  
          
                  
IF @BANK_TYPE = 'CANARARECO'                  
BEGIN                  
 UPDATE #BANKRECOSAVE SET AMOUNT = CONVERT(MONEY, AMOUNT / 100)                   
END                  
              
/*********************** New code added to check the referenceno from description column *****************/              
              
SELECT VTYPE              
INTO   #VMAST              
FROM   VMAST WITH(NOLOCK)               
WHERE  VTYPE IN ('2','3','5','19',              
                 '20','17')   

SELECT 
	DDNO = PRADNYA.DBO.REMOVE_ZERO(DDNO,'0'),
	RELDT,
	RELAMT,
	REFNO,
	VTYP,
	VNO,
	LNO,
	DRCR,
	BOOKTYPE,
	MICRNO,
	SLIPNO,
	CLEAR_MODE,
	L1_SNO
INTO #LEDGER1_UP
FROM LEDGER1 L1
WHERE EXISTS (SELECT VTYPE              
               FROM   #VMAST              
               WHERE  L1.VTYP = VTYPE)  
	AND RELDT = ''
	AND LEN(DDNO) > 4 

           
                              
UPDATE #BANKRECOSAVE              
SET    STATUS = 'MATCHED',               
         L1_SNO = L11.L1_SNO,               
         VTYP = L11.VTYP,               
         BOOKTYPE = L11.BOOKTYPE,               
         VNO = L11.VNO                            
FROM   #LEDGER1_UP L11    
WHERE  UPPER(#BANKRECOSAVE.DRCR) = UPPER(L11.DRCR)              
       AND CHARINDEX(L11.DDNO,[DESCRIPTION]) > 0              
       AND CLTCODE = @BANKCODE              
       AND #BANKRECOSAVE.MICRNO = @@MICRNO              
       AND #BANKRECOSAVE.AMOUNT = (SELECT SUM(RELAMT)              
                                   FROM   #LEDGER1_UP L1 WITH (NOLOCK),              
                                          LEDGER L2 WITH (NOLOCK)              
                                   WHERE  L2.VNO = L1.VNO              
                                          AND L2.VTYP = L1.VTYP              
                                          AND L2.BOOKTYPE = L1.BOOKTYPE              
										  AND RELDT = ''              
                                          AND CLTCODE = @BANKCODE              
                                          AND CHARINDEX(L1.DDNO,#BANKRECOSAVE.[DESCRIPTION]) > 0              
                                          AND #BANKRECOSAVE.DRCR = L1.DRCR)              
       AND #BANKRECOSAVE.MICRNO = ISNULL(L11.MICRNO,0)              
       AND REFERENCENO = '0'      
       
        
              
/*********************** New code added to check the referenceno from description column *****************/              
                  
                  
/*CREATE TABLE #BANKRECOSAVE_DELETE                        
(                        
 [DESCRIPTION] VARCHAR(250),                        
 AMOUNT MONEY,                        
 DRCR CHAR(1),                        
 REFERENCENO VARCHAR(25),                        
CROSSREFERENCENO INT                     
) */                       
                    
DECLARE                     
@@AMOUNTDIFF MONEY,                    
@@STAMOUNTDIFF MONEY,                    
@@BOOKDATE_MIN DATETIME,                    
@@BOOKDATE_MAX DATETIME                    
                    
SELECT @@BOOKDATE_MIN = MIN(BOOKDATE) FROM #BANKRECOSAVE                     
SELECT @@BOOKDATE_MAX = MAX(BOOKDATE) FROM #BANKRECOSAVE                     
                    
                    
CREATE TABLE #RECODUPS                     
(                    
 BOOKDATE VARCHAR(11),                     
 REFERENCENO VARCHAR(25),                     
 AMOUNT MONEY,                     
 DESCRIPTION VARCHAR(200),                     
 STATUS VARCHAR(10),                     
 CROSSREFERENCENO INT                    
)                    
                    
SET @@EXIST_COUNT_BEFORE = 0                    
SET @@EXIST_COUNT_AFTER = 0                    
                    
DECLARE                     
@CLTCODE VARCHAR(10),                     
@BOOKDATE DATETIME,                     
@AMOUNT MONEY,           @DRCR CHAR(1),                     
@VALUEDATE DATETIME,                     
@REFERENCENO VARCHAR(20),                    
@DESCRIPTION VARCHAR(200)                    
                    
DECLARE CUR_CHECCK CURSOR FOR                    
 SELECT CLTCODE, BOOKDATE, AMOUNT, DRCR, VALUEDATE, REFERENCENO, [DESCRIPTION] FROM #BANKRECOSAVE WHERE AMOUNT < 0                    
          
                    
OPEN CUR_CHECCK                    
                    
FETCH NEXT FROM CUR_CHECCK                    
INTO @CLTCODE, @BOOKDATE, @AMOUNT, @DRCR, @VALUEDATE, @REFERENCENO, @DESCRIPTION                    
                    
WHILE @@FETCH_STATUS = 0                    
BEGIN                    
/* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */                    
 IF @PROCESS_STATUS = 0                     
 BEGIN                    
  SELECT @@ERROR_COUNT = 0                    
                      
  SELECT                      
   @@EXIST_COUNT_BEFORE = COUNT(1)                    
  FROM                     
   BANKRECO                    
  WHERE    
   CLTCODE = @CLTCODE AND BOOKDATE = @BOOKDATE AND AMOUNT = ABS(@AMOUNT)                    
   AND DRCR = @DRCR AND VALUEDATE = @VALUEDATE AND ISNULL(REFERENCENO, '0') = ISNULL(@REFERENCENO, '0')                    
                    
                    
                      
 /* IF @@ERROR_COUNT > 0                    
   BEGIN                    
    SELECT                      
     BOOKDATE = CONVERT(VARCHAR(11), BR.BOOKDATE, 103), BR.REFERENCENO, BR.AMOUNT, BR.[DESCRIPTION], BR.STATUS                    
          
    FROM                     
     (SELECT * FROM BANKRECO WHERE BOOKDATE BETWEEN @@BOOKDATE_MIN AND @@BOOKDATE_MAX + ' 23:59' AND CLTCODE = @BANKCODE) BR,                     
          
     (SELECT CLTCODE, BOOKDATE, AMOUNT, DRCR, VALUEDATE, REFERENCENO FROM #BANKRECOSAVE WHERE AMOUNT < 0) B                    
    WHERE                    
     BR.CLTCODE = B.CLTCODE AND BR.BOOKDATE = B.BOOKDATE AND BR.AMOUNT = ABS(B.AMOUNT)                    
     AND BR.DRCR = B.DRCR AND BR.VALUEDATE = B.VALUEDATE AND BR.REFERENCENO = B.REFERENCENO                    
                      
    RETURN                    
   END */                    
 END                    
 /* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */                    
                    
                     
                         
 SELECT @@CROSSREFERENCENO = MIN(CROSSREFERENCENO)                    
 FROM #BANKRECOSAVE                    
 WHERE [DESCRIPTION] = @DESCRIPTION AND AMOUNT =  ABS(@AMOUNT) AND DRCR = @DRCR AND ISNULL(REFERENCENO, '0') = ISNULL(@REFERENCENO, '0') AND AMOUNT > 0                        
          
                     
 DELETE BR FROM #BANKRECOSAVE BR                    
 WHERE BR.CROSSREFERENCENO = @@CROSSREFERENCENO                    
                     
                     
 IF @PROCESS_STATUS = 0                     
 BEGIN                    
  SELECT                     
   @@EXIST_COUNT_AFTER = COUNT(1)                    
  FROM                     
   #BANKRECOSAVE                    
  WHERE                     
   [DESCRIPTION] = @DESCRIPTION AND AMOUNT =  ABS(@AMOUNT) AND DRCR = @DRCR                     
   AND ISNULL(REFERENCENO, '0') = ISNULL(@REFERENCENO, '0') AND AMOUNT > 0                        
                      
                      
  IF @@EXIST_COUNT_BEFORE <> @@EXIST_COUNT_AFTER                    
   BEGIN                    
    INSERT INTO #RECODUPS                    
    SELECT                      
     BOOKDATE = CONVERT(VARCHAR(11), BR.BOOKDATE, 103), BR.REFERENCENO, BR.AMOUNT, BR.[DESCRIPTION], BR.STATUS, BR.CROSSREFERENCENO                    
          
    FROM                     
     (SELECT * FROM BANKRECO WHERE BOOKDATE BETWEEN @@BOOKDATE_MIN AND @@BOOKDATE_MAX + ' 23:59' AND CLTCODE = @BANKCODE) BR                    
          
    WHERE                    
     CLTCODE = @CLTCODE AND BOOKDATE = @BOOKDATE AND AMOUNT = ABS(@AMOUNT)                    
     AND DRCR = @DRCR AND VALUEDATE = @VALUEDATE AND ISNULL(REFERENCENO, '0') = ISNULL(@REFERENCENO, '0')                    
                      
   END                     
  SET @@EXIST_COUNT_BEFORE = 0                    
  SET @@EXIST_COUNT_AFTER = 0                    
 END                     
 FETCH NEXT FROM CUR_CHECCK                    
 INTO @CLTCODE, @BOOKDATE, @AMOUNT, @DRCR, @VALUEDATE, @REFERENCENO, @DESCRIPTION                    
END                    
                    
DELETE FROM #BANKRECOSAVE WHERE AMOUNT < 0                        
                    
SELECT @@ERROR_COUNT = COUNT(1) FROM #RECODUPS                    
                    
IF @@ERROR_COUNT > 0                    
BEGIN                    
 SELECT * FROM #RECODUPS                    
 RETURN                    
END                    
                    
                    
/* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */                    
DELETE BR FROM                      
 BANKRECO B, #BANKRECOSAVE BR                      
WHERE               
 LTRIM(RTRIM(B.CLTCODE)) = LTRIM(RTRIM(BR.CLTCODE)) AND CONVERT(VARCHAR(11), B.BOOKDATE, 109) = CONVERT(VARCHAR(11), BR.BOOKDATE, 109) AND LTRIM(RTRIM(B.[DESCRIPTION])) = LTRIM(RTRIM(BR.[DESCRIPTION]))                      
          
 AND B.AMOUNT = BR.AMOUNT AND LTRIM(RTRIM(B.DRCR)) = LTRIM(RTRIM(BR.DRCR)) AND CONVERT(VARCHAR(11), B.VALUEDATE, 109) = CONVERT(VARCHAR(11), BR.VALUEDATE, 109) AND ISNULL(LTRIM(RTRIM(B.REFERENCENO)), '') = ISNULL(LTRIM(RTRIM(BR.REFERENCENO)), '')        
           
                    
SELECT @@ERROR_COUNT = COUNT(1) FROM #BANKRECOSAVE WHERE VALUEDATE IS NOT NULL                    
                  
                    
IF @@ERROR_COUNT = 0                    
BEGIN                     
 SELECT 'THE FILE YOU ARE TRYING TO UPLOAD IS ALREADY UPLOADED. PLEASE CHECK THE BANK RECONCILATION REPORT.'                     
 RETURN                    
END                    
                      
SELECT                     
 @@AMOUNTDIFF = ABS(BR.AMOUNT - BR1.AMOUNT)                     
FROM                    
 (SELECT AMOUNT FROM #BANKRECOSAVE WHERE [DESCRIPTION] = 'OPENING BALANCE') BR,                    
 (SELECT AMOUNT FROM #BANKRECOSAVE WHERE [DESCRIPTION] = 'CLOSING BALANCE') BR1                    
                    
                    
IF @PROCESS_STATUS = 1                    
BEGIN                    
 SELECT @@STAMOUNTDIFF = ABS(SUM(AMOUNT))                    
 FROM                     
 (                    
  SELECT                     
   AMOUNT = SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END)                    
  FROM                     
   BANKRECO                    
  WHERE                     
   BOOKDATE BETWEEN @@BOOKDATE_MIN AND @@BOOKDATE_MAX AND CLTCODE = @BANKCODE                    
   AND CROSSREFERENCENO NOT IN(SELECT CROSSNO FROM RECODUPS1)                    
  UNION ALL                    
  SELECT                     
   AMOUNT = SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END)                    
  FROM                     
   #BANKRECOSAVE                    
  WHERE                     
   VALUEDATE IS NOT NULL                    
                      
                      
 )B                    
END                     
ELSE                    
BEGIN                     
 SELECT @@STAMOUNTDIFF = ABS(SUM(AMOUNT))                    
 FROM                     
 (                    
  SELECT                     
   AMOUNT = SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END)                    
  FROM                     
   BANKRECO                    
  WHERE                
  BOOKDATE BETWEEN @@BOOKDATE_MIN AND @@BOOKDATE_MAX AND CLTCODE = @BANKCODE                    
  UNION ALL                    
  SELECT                     
   AMOUNT = SUM(CASE DRCR WHEN 'D' THEN AMOUNT ELSE -AMOUNT END)                    
  FROM                     
   #BANKRECOSAVE                    
  WHERE                     
   VALUEDATE IS NOT NULL                    
                      
                      
 )B                    
END                    
                    
                    
IF @@AMOUNTDIFF <> @@STAMOUNTDIFF                    
BEGIN                    
 SELECT 'THERE IS SOME AMOUNT DIFFERENCE IN THE STATEMENT WHICH YOU ARE TRYING TO UOLOAD. PLEASE CHECK.'                    
 RETURN                    
END                    
                    
 DELETE FROM                     
  #BANKRECOSAVE                    
 WHERE                     
  VALUEDATE IS NULL                    
                    
                    
                    
/* NEW LOGIC TO UPLOAD THE SAME BOOKDATED BANK STATEMENT MULTIPLE TIMES */                    
                        
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
                        
INSERT                        
INTO                        
 V2_UPLOADED_FILES                        
SELECT                        
 @FILENAME,                        
 @FILENAME,                        
 COUNT(1),                        
 'B',                        
 GETDATE(),                        
 @UNAME,                        
 'HDFC_RECO UPLOAD'                 
              
                     
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
 #BANKRECOSAVE (NOLOCK), LEDGER1 (NOLOCK), LEDGER (NOLOCK)    WHERE                        
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
 AND #BANKRECOSAVE.MICRNO = ISNULL(LEDGER1.MICRNO, 0)                  
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
 REFNO = #BANKRECOSAVE.CROSSREFERENCENO            FROM                        
 #BANKRECOSAVE, LEDGER  (NOLOCK)                        
WHERE                        
 (LEDGER1.VTYP ='2' OR LEDGER1.VTYP = '19' OR  LEDGER1.VTYP = '5' )                        
 AND UPPER(#BANKRECOSAVE.DRCR) = UPPER(LEDGER1.DRCR)                        
 AND RTRIM(LEDGER1.SLIPNO) = RTRIM(#BANKRECOSAVE.REFERENCENO)                        
 AND RELDT = ''                        
 AND #BANKRECOSAVE.CLTCODE = @BANKCODE                        
 AND #BANKRECOSAVE.MICRNO = @@MICRNO                        
 AND #BANKRECOSAVE.MICRNO = ISNULL(LEDGER1.MICRNO, 0)                  
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
                        
UPDATE L              
  SET    EDT = (CASE               
                  WHEN CONVERT(DATETIME,(CONVERT(VARCHAR(11),VALUEDATE,109))) < CONVERT(DATETIME,(CONVERT(VARCHAR(11),VDT,109))) THEN VDT              
                  ELSE VALUEDATE              
                END)              
  FROM   LEDGER L WITH (ROWLOCK),              
         (SELECT VTYP,              
                 BOOKTYPE,              
                 VNO,              
                 VALUEDATE              
          FROM   #BANKRECOSAVE              
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
                        
                        
IF @@ERROR <> 0                        
BEGIN                        
 SELECT 'THERE IS SOME PROBLEM IN LEDGER UPDATES EDT 2'                        
 ROLLBACK TRAN                        
 RETURN               
END                        
                        
IF @PROCESS_STATUS = 1                    
BEGIN                    
 DELETE FROM BANKRECO WHERE CLTCODE = @BANKCODE AND CROSSREFERENCENO IN(SELECT CROSSNO FROM RECODUPS1)                    
END                                          
INSERT INTO                        
 BANKRECO (Cltcode,Bookdate,Description,Amount,Drcr,Valuedate,Referenceno,Statusid,Statusname,Loginname,Crossreferenceno,Status,Micrno,Dummy1,Dummy2)                       
SELECT                        
 B.CLTCODE,B.BOOKDATE, B.DESCRIPTION, B.AMOUNT, B.DRCR, B.VALUEDATE, B.REFERENCENO, B.STATUSID,                        
 B.STATUSNAME, B.LOGINNAME, B.CROSSREFERENCENO,B.STATUS,@@MICRNO,'0','0'                        
FROM                        
 #BANKRECOSAVE B                      
                  
INSERT INTO                        
 BANKRECO_LOG (Cltcode,Bookdate,Description,Amount,Drcr,Valuedate,Referenceno,Statusid,Statusname,Loginname,Crossreferenceno,Status,Micrno,Dummy1,Dummy2,BR_SNo,Updated_by,Update_Dt,Reco_Status)                       
SELECT                        
 B.CLTCODE,B.BOOKDATE, B.DESCRIPTION, B.AMOUNT, B.DRCR, B.VALUEDATE, B.REFERENCENO, B.STATUSID,                        
 B.STATUSNAME, B.LOGINNAME, B.CROSSREFERENCENO,B.STATUS,@@MICRNO,'0','0',0,'AUTO', GETDATE(), 'MATCHED'                   
FROM                        
 #BANKRECOSAVE B                      
WHERE                  
 B.STATUS = 'MATCHED'                  
                  
INSERT INTO LEDGER1_BANKRECO_LOG                  
SELECT L1.*, 'AUTO', GETDATE(), 'MATCHED'                   
FROM LEDGER1 L1, LEDGER_UPDATES LU                  
WHERE L1.VNO = LU.VNO AND L1.VTYP = LU.VTYP AND L1.BOOKTYPE = LU.BOOKTYPE                  
                  
DROP TABLE BANKRECOCOMP                        
DROP TABLE LEDGER_UPDATES                      
                  
UPDATE RECOPROCESS SET INPROCESS = 'N'                        
                        
COMMIT TRAN                        
                        
SELECT 'UPDATED SUCCESSFULLY.'

GO
