-- Object: PROCEDURE dbo.VIRTUAL_MIS_LEDGER_CONVERTER_TODAY
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

      
/*        begin tran                           
EXEC VIRTUAL_MIS_LEDGER_CONVERTER 'D:\BACKOFFICE\19112015.19112015.3.40PM.csv', 'suresh'                                  
VIRTUAL_MIS_LEDGER_CONVERTER 'D:\BACKOFFICE\VIRTUAL_BANK_FORMAT.CSV','BHRT'                                   
SELECT * FROM VIRTUAL_MIS_LEDGER_REPORT    
  
rollback                                
*/       
  
                             
CREATE PROCEDURE [dbo].[VIRTUAL_MIS_LEDGER_CONVERTER]                                  
 @FILENAME VARCHAR(1000),                                  
 @UNAME VARCHAR(50)                                  
AS                                  
                                  
                                  
                                  
TRUNCATE TABLE VIRTUAL_MIS_LEDGER                                  
                                  
CREATE TABLE #VIRTUAL_MIS_LEDGER                                  
(                                  
 FILE_DATA VARCHAR(MAX),                                  
 SRNO INT IDENTITY(1, 1)                                  
)                                  
                                  
--INSERT INTO #VIRTUAL_MIS_LEDGER  EXEC MASTER.DBO.XP_CMDSHELL 'TYPE D:\BACKOFFICE\VIRTUAL_BANK_FORMAT.CSV'                                  
                                  
DECLARE                                  
 @@SQL VARCHAR(MAX)                                  
                                   
SET @@SQL = "INSERT INTO #VIRTUAL_MIS_LEDGER "                                  
SET @@SQL = @@SQL + " EXEC MASTER.DBO.XP_CMDSHELL 'TYPE " + @FILENAME + "'"                                  
                                  
--RETURN                              
--PRINT @@SQL                                  
                                  
EXEC(@@SQL)       
    
    
      
                                  
DELETE FROM #VIRTUAL_MIS_LEDGER WHERE SRNO <= 2                                  
DELETE FROM #VIRTUAL_MIS_LEDGER WHERE ISNULL(FILE_DATA, '') = ''                                  
                                
UPDATE #VIRTUAL_MIS_LEDGER SET FILE_DATA = LEFT(FILE_DATA, CHARINDEX('"',FILE_DATA)) + REPLACE(SUBSTRING(FILE_DATA, CHARINDEX('"',FILE_DATA), CHARINDEX('"',FILE_DATA, CHARINDEX('"',FILE_DATA) + 1) - CHARINDEX('"',FILE_DATA)), ',', '') + RIGHT(FILE_DATA, LEN(FILE_DATA) - CHARINDEX('"',FILE_DATA, CHARINDEX('"',FILE_DATA) + 1))                                    
                                    
UPDATE #VIRTUAL_MIS_LEDGER SET FILE_DATA = REPLACE(FILE_DATA, '"', '')      
    
       
    
      
      
                                
INSERT INTO VIRTUAL_MIS_LEDGER                                   
SELECT                                   
  CONVERT(DATETIME, .DBO.PIECE(FILE_DATA, ',', 1), 103),                                
 .DBO.PIECE(FILE_DATA, ',', 2),                                  
 .DBO.PIECE(FILE_DATA, ',', 3),                                  
 .DBO.PIECE(FILE_DATA, ',', 4),                                  
 .DBO.PIECE(FILE_DATA, ',', 5),                                  
 .DBO.PIECE(FILE_DATA, ',', 6),                                  
 .DBO.PIECE(FILE_DATA, ',', 7),                                  
 .DBO.PIECE(FILE_DATA, ',', 8),                                  
 .DBO.PIECE(FILE_DATA, ',', 9),                                  
 .DBO.PIECE(FILE_DATA, ',', 10),                                  
 .DBO.PIECE(FILE_DATA, ',', 11),                                   
 .DBO.PIECE(FILE_DATA, ',', 12),                                  
 .DBO.PIECE(FILE_DATA, ',', 13),                                  
 .DBO.PIECE(FILE_DATA, ',', 14),                                   
 .DBO.PIECE(FILE_DATA, ',', 15),                                  
 .DBO.PIECE(FILE_DATA, ',', 16),                                  
 .DBO.PIECE(FILE_DATA, ',', 17),                                  
 .DBO.PIECE(FILE_DATA, ',', 18),                                  
 .DBO.PIECE(FILE_DATA, ',', 19),                                  
 .DBO.PIECE(FILE_DATA, ',', 20),                                 
 .DBO.PIECE(FILE_DATA, ',', 21)                                  
FROM #VIRTUAL_MIS_LEDGER        
      
     
    
       
      
CREATE TABLE #VIRTUAL_MIS                       
(                                  
 SRNO INT,                         
 EDATE VARCHAR(10),                                  
 VDATE VARCHAR(10),                         
 CLTCODE VARCHAR(10),                                  
 AMOUNT MONEY,                                  
 DRCR CHAR(1),                                  
 NARRATION VARCHAR(500),                            
 BANK_CODE VARCHAR(10),                                  
 BANK_NAME VARCHAR(100),                                  
 REF_NO VARCHAR(20),                 
 BRANCHCODE VARCHAR(10),                                  
 BRANCH_NAME VARCHAR(100),                                  
 CHQ_MODE VARCHAR(5),                                  
 CHQ_DATE VARCHAR(10),                                  
 CHQ_NAME VARCHAR(100),                                  
 CL_MODE CHAR(1),                                  
 ACCOUNTNO VARCHAR(50),                                  
 SEGMENT VARCHAR(10)                                  
)                           
                                
                                 
CREATE TABLE VIRTUAL_MIS_FILE                        
(                                  
 SRNO INT IDENTITY(1, 1),                         
 EDATE VARCHAR(10),                                  
 VDATE VARCHAR(10),                                  
 CLTCODE VARCHAR(10),                                  
 AMOUNT MONEY,                                  
 DRCR CHAR(1),                                  
 NARRATION VARCHAR(500),                    
 BANK_CODE VARCHAR(10),                                  
 BANK_NAME VARCHAR(100),                                  
 REF_NO VARCHAR(20),                                  
 BRANCHCODE VARCHAR(10),                                  
 BRANCH_NAME VARCHAR(100),                                  
 CHQ_MODE VARCHAR(5),                                  
 CHQ_DATE VARCHAR(10),                                  
 CHQ_NAME VARCHAR(100),                                  
 CL_MODE CHAR(1),                                  
 ACCOUNTNO VARCHAR(50),                                  
 SEGMENT VARCHAR(10)                                  
)                               
                        
CREATE TABLE VIRTUAL_MIS_FILE_GEN                        
(                                  
 SRNO VARCHAR(10),                         
 EDATE VARCHAR(10),                                  
 VDATE VARCHAR(10),                                  
 CLTCODE VARCHAR(10),                                  
 AMOUNT VARCHAR(15),                                  
 DRCR VARCHAR(10),                                  
 NARRATION VARCHAR(500),                                  
 BANK_CODE VARCHAR(10),                                  
 BANK_NAME VARCHAR(100),                                  
 REF_NO VARCHAR(20),                                  
 BRANCHCODE VARCHAR(10),                                  
 BRANCH_NAME VARCHAR(100),                                  
 CHQ_MODE VARCHAR(5),                                  
 CHQ_DATE VARCHAR(10),                                  
 CHQ_NAME VARCHAR(100),                                  
 CL_MODE VARCHAR(10),                                  
 ACCOUNTNO VARCHAR(50),                                  
 SEGMENT VARCHAR(10)                                  
)     
    
                  
   
    
                              
INSERT INTO #VIRTUAL_MIS                                  
SELECT                      
 1,                                   
 CONVERT(VARCHAR(10), BUSINESS_DATE, 103),                                   
 CONVERT(VARCHAR(10), BUSINESS_DATE, 103),                                   
 RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7),                                   
 TRANSACTION_AMOUNT,                                
 'C',                                   
 'VIRTUAL ' + TRANSACTION_DETAILS1,                                   
 '02093',                                   
 'SCB',                                   
 --.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1),                                   
 .DBO.UDF_GETNUMERIC(.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)),          
 'HO',                                   
 'ALL',                                   
 'C',                                   
 CONVERT(VARCHAR(10), BUSINESS_DATE, 103),                    
 '',                                   
 'L',     
   CASE WHEN PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) =0 THEN     
 REPLACE(TRANSACTION_DETAILS7,' ' ,'') ELSE     
 LEFT(REPLACE(TRANSACTION_DETAILS7,' ' ,''), PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) - 1)     
   END ,                                             
 --LEFT(REPLACE(TRANSACTION_DETAILS7,' ' ,''), PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) - 1),                                  
 SEGMENT                                  
FROM                                   
 VIRTUAL_MIS_LEDGER VL,                                  
 VIRTUAL_MIS_SEGMENT_MAPPING SM                                  
WHERE                                
--NOT EXISTS(SELECT PARTY_CODE FROM VIRTUAL_MIS_LEDGER_REPORT VT WHERE BUSINESS_DATE = TXN_DATE AND RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7) = PARTY_CODE AND .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1) = BANK_REF_NO)                                  
 --AND EXISTS(SELECT PARTY_CODE FROM MSAJAG.DBO.CLIENT_DETAILS D WHERE D.PARTY_CODE = RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7))                                  
  -- NOT EXISTS(SELECT TXN_REF_NO FROM VIRTUAL_MIS_LEDGER_REPORT WHERE .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)=TXN_REF_NO )            
      NOT EXISTS(SELECT TXN_REF_NO FROM VIRTUAL_MIS_LEDGER_REPORT WHERE .DBO.UDF_GETNUMERIC(.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)) = TXN_REF_NO )            
                              
    AND LEFT(VL.VA_NUMBER, 7) = SEGCODE    
    
  
      
              
                             
              
UPDATE #VIRTUAL_MIS SET ACCOUNTNO=RTRIM(LTRIM(REPLACE(ACCOUNTNO,'|','') ))              
                              
UPDATE #VIRTUAL_MIS SET ACCOUNTNO=RTRIM(LTRIM(REPLACE(ACCOUNTNO,'/','') ))               
              
--UPDATE #VIRTUAL_MIS SET REF_NO=SUBSTRING(REF_NO,3,18)               
          
                             
UPDATE   #VIRTUAL_MIS SET BANK_NAME= (CASE WHEN B.ACCNO= '' THEN 'SCB'ELSE B.BANK_NAME END)                          
 --CHQ_NAME = (CASE WHEN B.ACCNO= '' THEN 'SCB' ELSE B.BANK_NAME END)                          
FROM BANKALLSEGMENT B                          
WHERE B.CLTCODE =#VIRTUAL_MIS.CLTCODE                          
AND B.ACCNO=#VIRTUAL_MIS.ACCOUNTNO                          
AND B.SEGMENT=#VIRTUAL_MIS.SEGMENT                          
                          
UPDATE #VIRTUAL_MIS SET CHQ_NAME=BANK_NAME        
      
--SELECT EDATE,VDATE,CLTCODE,AMOUNT,DRCR,NARRATION,BANK_CODE,BANK_NAME,REF_NO,BRANCHCODE,BRANCH_NAME,CHQ_MODE,CHQ_DATE,CHQ_NAME,CL_MODE,ACCOUNTNO,SEGMENT FROM #VIRTUAL_MIS                        
                                
/*SELECT  SRNO,EDATE,VDATE,CLTCODE,AMOUNT,DRCR,NARRATION,BANK_CODE,BANK_NAME,                           
.DBO.REPLACECHAR(REF_NO)AS REF_NO,BRANCHCODE,BRANCH_NAME,CHQ_MODE,CHQ_DATE,CHQ_NAME,CL_MODE,ACCOUNTNO,SEGMENT                                
FROM #VIRTUAL_MIS                                 
ORDER BY SEGMENT  */    
  
  
      
 --SELECT CONVERT(VARCHAR, SRNO) ,EDATE,VDATE,CLTCODE,CONVERT(VARCHAR, AMOUNT),DRCR,NARRATION,BANK_CODE,BANK_NAME,REF_NO,BRANCHCODE,  
 --BRANCH_NAME,CHQ_MODE,CHQ_DATE,CHQ_NAME,CL_MODE,ACCOUNTNO,SEGMENT FROM #VIRTUAL_MIS  
 --return 
 
  
                      
---------------------TO SAVE THE FILE DIRECTLY TO THE RESPECTIVE DATABASE SERVERS-----------                        
        
                  
                        
DECLARE @@MAINREC AS CURSOR                        
DECLARE                        
 @@SEGMENT VARCHAR(20),                        
 @@DATASERVER VARCHAR(50),                        
 @@ACCOUNTDB VARCHAR(50),                        
 @@SQLQRY VARCHAR(8000),                        
 @@FNAME VARCHAR(500),                        
 @@REC_COUNT INT,                        
 @@FILE_SEGMENT VARCHAR(500)                      
                         
 SET @@FILE_SEGMENT = ''                        
                        
SET @@MAINREC = CURSOR FOR                                
     SELECT SEGMENT, ACCOUNTDB, DATASERVER FROM VIRTUAL_MIS_SEGMENT_MAPPING                        
                             
OPEN @@MAINREC                                
 FETCH NEXT FROM @@MAINREC INTO @@SEGMENT, @@ACCOUNTDB, @@DATASERVER                        
  WHILE @@FETCH_STATUS = 0                                
  BEGIN                               
  TRUNCATE TABLE VIRTUAL_MIS_FILE                  
  TRUNCATE TABLE VIRTUAL_MIS_FILE_GEN                   
                      
    INSERT INTO VIRTUAL_MIS_FILE                         
 SELECT EDATE,VDATE,CLTCODE,AMOUNT,DRCR,NARRATION,BANK_CODE,BANK_NAME,REF_NO,BRANCHCODE,  
 BRANCH_NAME,CHQ_MODE,CHQ_DATE,CHQ_NAME,CL_MODE,ACCOUNTNO,SEGMENT FROM #VIRTUAL_MIS WHERE SEGMENT = @@SEGMENT 
 
            
       
                        
    SET  @@SQLQRY = " INSERT INTO VIRTUAL_MIS_FILE_GEN SELECT * FROM VIRTUAL_MIS_FILE "                  
                            
    EXEC(@@SQLQRY) 
  --  print    @@SQLQRY   
          
    SELECT @@REC_COUNT = COUNT(1) FROM VIRTUAL_MIS_FILE_GEN                        
                     
   SET  @@SQLQRY = " SELECT CONVERT(VARCHAR, SRNO), EDATE, VDATE, CLTCODE, CONVERT(VARCHAR, AMOUNT), DRCR, NARRATION, BANK_CODE, BANK_NAME,REF_NO, BRANCHCODE, BRANCH_NAME, CHQ_MODE, CHQ_DATE, CHQ_NAME, CL_MODE, ACCOUNTNO FROM ANAND1.ACCOUNT.DBO.VIRTUAL_MIS_FILE_GEN "                        
                          
  --  EXEC(@@SQLQRY)                        
                            
    SET @@FNAME = "D:\BACKOFFICE\RECPAYFILES\" + 'VIRTUAL_' + @@SEGMENT + '_' + CONVERT(VARCHAR(20),GETDATE(), 112) + REPLACE(CONVERT(VARCHAR(20),GETDATE(), 108), ':', '') +  ".CSV"                        
                            
    IF @@REC_COUNT > 0                        
    BEGIN                        
  SELECT @@FILE_SEGMENT = @@FILE_SEGMENT + @@SEGMENT + ","          
      print @@FILE_SEGMENT                               
               
  SELECT @@SQL = "EXEC " + @@DATASERVER + "." + @@ACCOUNTDB + ".DBO.VIRTUAL_MIS_FILEGEN '" + @@SQLQRY + "','" + @@DATASERVER + "','" + @@FNAME + "'"                        
    --SELECT @@SQL = "DECLARE @@ERR AS INT EXEC @@ERR = MASTER.DBO.XP_CMDSHELL 'BCP " + CHAR(34) + @@SQLQRY + " " + CHAR(34) + " QUERYOUT " + CHAR(34) + @@FNAME + CHAR(34) + " -C -Q -T " + CHAR(34) + "," + CHAR(34) + " -T -S "+ CHAR(34) + CHAR(34) + @@DATASERVER + CHAR(34) + "'"                        
                 
  EXEC (@@SQL)    
  print @@SQL                        
 END                        
                        
 FETCH NEXT FROM @@MAINREC INTO @@SEGMENT, @@ACCOUNTDB, @@DATASERVER                        
  END                        
                        
                           
SELECT 'FILES GENERATED FOR ' + @@FILE_SEGMENT + 'SEGMENTS.'         
                       
                       
DROP TABLE VIRTUAL_MIS_FILE_GEN                        
DROP TABLE VIRTUAL_MIS_FILE                 
                  
                        
--------------------------------------------------------------------------------------                                  
                          
                                
                                   
INSERT INTO VIRTUAL_MIS_LEDGER_REPORT                                  
SELECT                                   
 BRANCH_CD, SUB_BROKER, PARTY_CODE, LONG_NAME, SEGMENT, TRANSACTION_AMOUNT, BUSINESS_DATE, '',                                  
-- LEFT(TRANSACTION_DETAILS7, PATINDEX('%[A-Z]%',TRANSACTION_DETAILS7) - 1),     
 CASE WHEN PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) =0 THEN     
 REPLACE(TRANSACTION_DETAILS7,' ' ,'') ELSE     
 LEFT(REPLACE(TRANSACTION_DETAILS7,' ' ,''), PATINDEX('%[A-Z]%',REPLACE(TRANSACTION_DETAILS7,' ' ,'')) - 1)     
   END ,    
     
    .DBO.UDF_GETNUMERIC(.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)),                                  
 'SCB -VIRTUAL', TRANSACTION_DETAILS7, @UNAME, GETDATE()
                              
FROM                                
 VIRTUAL_MIS_LEDGER VL, VIRTUAL_MIS_SEGMENT_MAPPING SM, MSAJAG.DBO.CLIENT_DETAILS                                  
WHERE                                  
    --.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1) NOT IN (SELECT TXN_REF_NO FROM VIRTUAL_MIS_LEDGER_REPORT)          
    .DBO.UDF_GETNUMERIC(.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1)) NOT IN (SELECT TXN_REF_NO FROM VIRTUAL_MIS_LEDGER_REPORT)                                
    AND LEFT(VL.VA_NUMBER, 7) = SEGCODE                                  
 AND RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7) = PARTY_CODE

GO
