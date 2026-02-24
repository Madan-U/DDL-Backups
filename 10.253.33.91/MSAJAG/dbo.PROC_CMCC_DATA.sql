-- Object: PROCEDURE dbo.PROC_CMCC_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 

CREATE PROC [dbo].[PROC_CMCC_DATA] (@TDATE VARCHAR(10), @FILEFOR VARCHAR(20), @FILETYPE VARCHAR(50), @PROGID VARCHAR(50), @UNAME VARCHAR(50), @FILENAME VARCHAR(200)='')  
AS   
BEGIN
	DECLARE @RECCNT NUMERIC(18,0),        
	 @CNT NUMERIC(18,0),        
	 @FROMDATE DATETIME        
  
	SET @CNT = 1  
        
	SELECT @CNT=ISNULL(COUNT(1),1)    
	FROM FILEDATA        
	WHERE PROGID = @PROGID         
	AND .DBO.PIECE(FILE_DATA,',',1) <> @TDATE  
	AND LEN(FILE_DATA) > 0  
  
	IF @CNT > 0   
	BEGIN  
	 SELECT STRMSGCODE = -1, STRMSG = 'INVALID DATE PRESENT IN THE FILE OR IT IS NOT MATCHING WITH THE SELECTED DATE.'    
	 RETURN  
	END  
        
	 DELETE FROM TBL_CMCC_DATA   
	 WHERE TRANSDATE = CONVERT(DATETIME, @TDATE,103)  
  
	 INSERT INTO TBL_CMCC_DATA  
	 SELECT CONVERT(DATETIME, @TDATE,103),  
			LTRIM(RTRIM(.DBO.PIECE(FILE_DATA,',',2))),         
	  LTRIM(RTRIM(.DBO.PIECE(FILE_DATA,',',3))),  
	  LTRIM(RTRIM(.DBO.PIECE(FILE_DATA,',',4))),  
	  LTRIM(RTRIM(.DBO.PIECE(FILE_DATA,',',5))),  
	  LTRIM(RTRIM(.DBO.PIECE(FILE_DATA,',',6))),
	  LTRIM(RTRIM(.DBO.PIECE(FILE_DATA,',',7))),  
	  LTRIM(RTRIM(.DBO.PIECE(FILE_DATA,',',8))),  
	  ENTERED_BY=@UNAME,  
	  ENTERED_DATE=GETDATE()   
	 FROM FILEDATA        
	 WHERE PROGID = @PROGID         
	 AND .DBO.PIECE(FILE_DATA,',',1) = @TDATE  
          
	 SELECT @RECCNT = ISNULL(COUNT(1),0) FROM FILEDATA        
	 WHERE PROGID = @PROGID         
	 AND .DBO.PIECE(FILE_DATA,',',1) = @TDATE  
     
	 SELECT STRMSGCODE = 1, STRMSG = CONVERT(VARCHAR,@RECCNT) + ' RECORD(S) IMPORTED SUCCESSFULLY.' 
	 
	/*Added on Aug 07 2023 to check file upload status*/
	declare @Upload_on datetime,@Report_Date datetime,@filecount int
	set @Upload_on=(select MAX(ENTEREDON) from TBL_CMCC_DATA with (nolock))
	set @Report_Date=(select MAX(TRANSDATE) from TBL_CMCC_DATA with (nolock))
	
	set @filecount=(select count(1) from TBL_CMCC_DATA with (nolock) 
					where TRANSDATE=(select MAX(TRANSDATE) from TBL_CMCC_DATA with (nolock)))
	
	--truncate table Tbl_Pledge_CMCC_Filelog 
	insert into Tbl_Pledge_CMCC_Filelog
	select 'CMCC',@filecount,@Report_Date,@Upload_on
  
END

GO
