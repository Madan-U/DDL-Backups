-- Object: PROCEDURE dbo.PROC_MRG_MCX_ANGEL
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

  
  
        
CREATE PROC [dbo].[PROC_MRG_MCX_ANGEL]         
(  @TDATE VARCHAR(10), @FILEFOR VARCHAR(100), @FILETYPE VARCHAR(100),         
 @PROGID VARCHAR(100), @UNAME VARCHAR(100),@FILENAME VARCHAR(100) = ''       
)        
        
AS       
  
  
DECLARE @RECCNT INT,@DELDATE DATETIME, @STRSQL VARCHAR(500),@FILEDATE VARCHAR(100)        
      
  
SELECT @FILEDATE = .DBO.PIECE(FILE_DATA,',',2) FROM MSAJAG.DBO.FILEDATA WHERE PROGID =  @PROGID AND .DBO.PIECE(FILE_DATA,',',1) = '10'  
    
      
SELECT @FILEDATE = LEFT(@FILEDATE,2) + '/' + RIGHT(LEFT(@FILEDATE,4),2) + '/' + RIGHT(@FILEDATE,4)    
  
SET @DELDATE =  CONVERT(DATETIME,@FILEDATE,103)  
  
  
DELETE FROM MCX_MRG_ANG  WHERE  [MDATE] = CONVERT(VARCHAR(11),@DELDATE,109)  
       
SELECT   
[Record Type],  
[TM ID],  
[Account Type],  
[Account ID],  
[Initial Margin/SPAN Margin],  
[Special Margin],  
[Additional Margin],  
[Tender Margin],  
[Delivery Margin],  
[Spread Margin Benefit],  
[Delivery Margin Exemption],  
[Early Pay-In Benefit],  
[Actual Margin Levied],  
[Reserved1],  
[Reserved2],  
[Net Buy Premium],  
[Extreme Loss Margin],  
[Concentration Margin],  
[Devolvement Margin]  INTO #MCX_MRG_ANG FROM MCX_MRG_ANG WHERE 1 <> 1    
    
INSERT INTO #MCX_MRG_ANG  
SELECT [Record Type] = .DBO.PIECE(FILE_DATA,',',1),  
[TM ID] = .DBO.PIECE(FILE_DATA,',',2),  
[Account Type] = .DBO.PIECE(FILE_DATA,',',3),  
[Account ID] = .DBO.PIECE(FILE_DATA,',',4),  
[Initial Margin/SPAN Margin] = CONVERT(NUMERIC(18,2),CASE WHEN .DBO.PIECE(FILE_DATA,',',5) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',5) END),  
[Special Margin] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',6) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',6) END),  
[Additional Margin] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',7) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',7) END),  
[Tender Margin] = CONVERT(NUMERIC(18,2),CASE WHEN .DBO.PIECE(FILE_DATA,',',8) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',8) END),  
[Delivery Margin] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',9) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',9) END),  
[Spread Margin Benefit] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',10) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',10) END),  
[Delivery Margin Exemption] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',11) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',11) END),   
[Early Pay-In Benefit] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',12) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',12) END),  
[Actual Margin Levied] = CONVERT(NUMERIC(18,2),CASE WHEN .DBO.PIECE(FILE_DATA,',',13) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',13) END),  
[Reserved1] = CONVERT(NUMERIC(18,2),CASE WHEN .DBO.PIECE(FILE_DATA,',',14) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',14) END),  
[Reserved2] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',15) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',15) END),  
[Net Buy Premium] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',16) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',16) END),  
[Extreme Loss Margin] = CONVERT(NUMERIC(18,2),CASE WHEN  .DBO.PIECE(FILE_DATA,',',17) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',17) END),  
[Concentration Margin] = CONVERT(NUMERIC(18,2),CASE WHEN .DBO.PIECE(FILE_DATA,',',18) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',18) END),  
[Devolvement Margin] = CONVERT(NUMERIC(18,2),CASE WHEN .DBO.PIECE(FILE_DATA,',',19) = '' THEN '0' ELSE .DBO.PIECE(FILE_DATA,',',19) END)  
FROM MSAJAG.DBO.FILEDATA   
WHERE PROGID =  @PROGID AND .DBO.PIECE(FILE_DATA,',',1) = '30'  
  
 INSERT INTO MCX_MRG_ANG SELECT CONVERT(VARCHAR(11),@DELDATE,109),  
[Record Type],  
[TM ID],  
[Account Type],  
[Account ID],  
[Initial Margin/SPAN Margin],  
[Special Margin],  
[Additional Margin],  
[Tender Margin],  
[Delivery Margin],  
[Spread Margin Benefit],  
[Delivery Margin Exemption],  
[Early Pay-In Benefit],  
[Actual Margin Levied],  
[Reserved1],  
[Reserved2],  
[Net Buy Premium],  
[Extreme Loss Margin],  
[Concentration Margin],  
[Devolvement Margin],  
ENTERED_BY = @UNAME ,   
UPLOADED_BY = GETDATE()  FROM  #MCX_MRG_ANG  
     
DROP TABLE #MCX_MRG_ANG  
  
   
DELETE FROM MSAJAG.DBO.FILEDATA  WHERE PROGID = @PROGID      

DELETE FROM MCX_MRG_ANG_FINAL  WHERE  [MDATE] = CONVERT(VARCHAR(11),@DELDATE,109)  

INSERT INTO MCX_MRG_ANG_FINAL
SELECT   FORMAT(MDATE,'dd-MMM-yyyy') AS MDATE,[TM ID] AS CMID,[ACCOUNT ID] AS PARTY_CODE,[Initial Margin/SPAN Margin]+[Extreme Loss Margin] AS IM, 
([Special Margin]+[Additional Margin]+[Tender Margin]+[Delivery Margin]-[Spread Margin Benefit]) AS OTHERM, 0 AS  MTMM, 
Reserved1,Reserved2, 0 AS MTMMC, 0 AS IMC, 0 AS OMC, 100 AS PMT,  
([Initial Margin/SPAN Margin]+[Extreme Loss Margin]+[Special Margin]+[Additional Margin]+[Tender Margin]+[Delivery Margin]-[Spread Margin Benefit]) AS PIM,
0 AS PMC, 0 AS PMS,'' AS ASINTRAALLOC1,'' AS ASINTRAALLOC2,'' AS ASINTRAALLOC3,'' AS ASINTRAALLOC4,'' AS ASINTRAALLOC5
FROM INHOUSE.DBO.MCX_MRG_ANG WHERE MDATE = CONVERT(VARCHAR(11),@DELDATE,109)    AND [ACCOUNT ID] <> '12685' ORDER BY PARTY_CODE
  

      
SELECT @RECCNT = ISNULL(COUNT(1),0) FROM MCX_MRG_ANG  WHERE  [MDATE] = CONVERT(VARCHAR(11),@DELDATE,109)  
      
IF @RECCNT > 0         
BEGIN        
 SELECT STRMSGCODE = 1, STRMSG = 'FILE UPLOADED SUCCESSFULLY WITH NO OF RECORD(S) ' + CONVERT(VARCHAR,@RECCNT)        
END        
ELSE        
BEGIN        
 SELECT STRMSGCODE = -1, STRMSG = 'PLEASE CHECK AND IMPORT CORRECT FILE'        
END

GO
