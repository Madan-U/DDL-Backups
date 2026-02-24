-- Object: PROCEDURE dbo.VIRTUAL_MIS_LEDGER_CONVERTER_jan272014
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/*                                    
EXEC VIRTUAL_MIS_LEDGER_CONVERTER 'D:\BACKOFFICE\VIRTUAL_BANK_FORMAT.CSV', 'TEST'                                    
VIRTUAL_MIS_LEDGER_CONVERTER 'D:\BACKOFFICE\VIRTUAL_BANK_FORMAT.CSV','BHRT'                                     
SELECT * FROM VIRTUAL_MIS_LEDGER_REPORT                                    
*/                                    
CREATE PROCEDURE [dbo].[VIRTUAL_MIS_LEDGER_CONVERTER_jan272014]                                    
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
 ACCOUNTNO VARCHAR(20),                                    
 SEGMENT VARCHAR(10)                                    
)                             
                                  
/*IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VIRTUAL_MIS_FILE]') AND type in (N'U'))
DROP TABLE [dbo].[VIRTUAL_MIS_FILE]*/

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
	.DBO.PIECE(TRANSACTION_DETAILS1, '|', 1), 
	'HO', 
	'ALL', 
	'C', 
	CONVERT(VARCHAR(10), BUSINESS_DATE, 103), 
	'', 
	'L', 
	LEFT(TRANSACTION_DETAILS7, PATINDEX('%[A-Z]%',TRANSACTION_DETAILS7) - 1),
	SEGMENT
FROM 
	VIRTUAL_MIS_LEDGER VL,
	VIRTUAL_MIS_SEGMENT_MAPPING SM
WHERE 
	NOT EXISTS(SELECT PARTY_CODE FROM VIRTUAL_MIS_LEDGER_REPORT VT WHERE BUSINESS_DATE = TXN_DATE AND RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7) = PARTY_CODE AND .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1) = BANK_REF_NO)
	--AND EXISTS(SELECT PARTY_CODE FROM MSAJAG.DBO.CLIENT_DETAILS D WHERE D.PARTY_CODE = RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7))
	AND LEFT(VL.VA_NUMBER, 7) = SEGCODE
	
INSERT INTO VIRTUAL_MIS_LEDGER_REPORT
SELECT 
	BRANCH_CD, SUB_BROKER, PARTY_CODE, LONG_NAME, SEGMENT, TRANSACTION_AMOUNT, BUSINESS_DATE, '',
	LEFT(TRANSACTION_DETAILS7, PATINDEX('%[A-Z]%',TRANSACTION_DETAILS7) - 1), .DBO.PIECE(TRANSACTION_DETAILS1, '|', 1),
	'SCB -Virtual', TRANSACTION_DETAILS7, @UNAME, GETDATE()
FROM 
	VIRTUAL_MIS_LEDGER VL, VIRTUAL_MIS_SEGMENT_MAPPING SM, MSAJAG.DBO.CLIENT_DETAILS
WHERE 
	LEFT(VL.VA_NUMBER, 7) = SEGCODE
	AND RIGHT(VA_NUMBER, LEN(VA_NUMBER) - 7) = PARTY_CODE


SELECT * FROM #VIRTUAL_MIS ORDER BY SEGMENT

GO
