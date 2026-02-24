-- Object: PROCEDURE dbo.PROC_RMS_CAPITALREQUIREMENT_UPLOAD
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

    
      
CREATE PROC [dbo].[PROC_RMS_CAPITALREQUIREMENT_UPLOAD]       
(  @TDATE VARCHAR(10), @FILEFOR VARCHAR(100), @FILETYPE VARCHAR(100),       
 @PROGID VARCHAR(100), @UNAME VARCHAR(100),@FILENAME VARCHAR(100) = ''     
)      
      
AS     
    
DECLARE @RECCNT INT,@DELDATE DATETIME, @STRSQL VARCHAR(500)      
    
--Margindate,Intraday Pledge,Allocation in Other CC,Funds Pay in,Buffer for RRM,Exch Pay in,Creditors Payout,BG,CASH,Intraday,Margin for intraday to deposit with bank,Existing capital,Intradaylines available
--31/01/2024,111,115,433,1104,350,150,2150,100,1200,-600,2247,1500 


 SELECT CONVERT(DATETIME,.DBO.PIECE(FILE_DATA,',',1),105) AS [Margindate],    
.DBO.PIECE(FILE_DATA,',',2) AS [Intraday Pledge],    
.DBO.PIECE(FILE_DATA,',',3) AS [Allocation in Other CC],    
.DBO.PIECE(FILE_DATA,',',4) AS [Funds Pay in],    
.DBO.PIECE(FILE_DATA,',',5) AS [Buffer for RRM],    
.DBO.PIECE(FILE_DATA,',',6) AS [Exch Pay in],    
.DBO.PIECE(FILE_DATA,',',7) AS [Creditors Payout],    
.DBO.PIECE(FILE_DATA,',',8) AS [BG],    
.DBO.PIECE(FILE_DATA,',',9) AS [CASH],    
.DBO.PIECE(FILE_DATA,',',10) AS [Intraday],    
.DBO.PIECE(FILE_DATA,',',11) AS [Margin for intraday to deposit with bank],    
.DBO.PIECE(FILE_DATA,',',12) AS [Existing capital],    
.DBO.PIECE(FILE_DATA,',',13) AS [Intradaylines available]     INTO #FILDATA 
FROM MSAJAG.DBO.FILEDATA  WHERE PROGID = @PROGID    
AND .DBO.PIECE(FILE_DATA,',',1) <> 'Margindate'    
 

DELETE A FROM INHOUSE.DBO.CAPITALREQUIREMENT_SUMM A , #FILDATA B WHERE A.[Margindate] = B.[Margindate]

INSERT INTO INHOUSE.DBO.CAPITALREQUIREMENT_SUMM SELECT * FROM #FILDATA

DELETE FROM MSAJAG.DBO.FILEDATA  WHERE PROGID = @PROGID    

SELECT @RECCNT = ISNULL(COUNT(1),0) FROM #FILDATA

DROP TABLE #FILDATA
    
IF @RECCNT > 0       
BEGIN      
 SELECT STRMSGCODE = 1, STRMSG = 'FILE UPLOADED SUCCESSFULLY WITH NO OF RECORD(S) ' + CONVERT(VARCHAR,@RECCNT)      
END      
ELSE      
BEGIN      
 SELECT STRMSGCODE = -1, STRMSG = 'PLEASE CHECK AND IMPORT CORRECT FILE'      
END

GO
