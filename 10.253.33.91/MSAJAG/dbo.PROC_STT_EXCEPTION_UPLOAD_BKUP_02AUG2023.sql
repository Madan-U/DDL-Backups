-- Object: PROCEDURE dbo.PROC_STT_EXCEPTION_UPLOAD_BKUP_02AUG2023
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[PROC_STT_EXCEPTION_UPLOAD_BKUP_02AUG2023]  
(  
 @FILEPATH VARCHAR(150),   
 @FILEDATE VARCHAR(11),  
 @FILETYPE VARCHAR(3)  
) AS      
  
Declare @strSql varchar(400)    
      
TRUNCATE TABLE Tbl_Stt_Scrip_Tmp  
truncate table STT_Tmp
    
set @strSql = 'Bulk insert STT_Tmp from ''' + @FilePath  + ''' with ( ROWTERMINATOR = ''' + char(10) + ''' )'          
Exec(@strSql)        
    
      
INSERT INTO Tbl_Stt_Scrip_Tmp    
SELECT PRADNYA.DBO.PIECE(FILETEXT,',',1),    
LEFT(GETDATE(),11), 'DEC 31 2049 23:59',  
'AUTO',GETDATE(),'AUTO',GETDATE(),  
PRADNYA.DBO.PIECE(FILETEXT,',',2), (CASE WHEN @FILETYPE = 'IND' THEN 1 ELSE 0 END)  
FROM MSAJAG.DBO.STT_TMP WHERE LEN(PRADNYA.DBO.PIECE(FILETEXT,',',2)) = 2  

Exec Proc_Stt_Rec_Update

GO
