-- Object: PROCEDURE dbo.PROC_MG02_UPLOAD_BKUP_01SEP20
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[PROC_MG02_UPLOAD](@FILEDATE VARCHAR(11), @FILEPATH VARCHAR(150)) AS    
Declare @strSql varchar(400)       
    
TRUNCATE TABLE MG02_TMP1    
set @strSql = 'Bulk insert MG02_TMP1 from ''' + @FilePath  + ''' with ( ROWTERMINATOR = ''\n'' )'        
Exec(@strSql)      
    
delete from tbl_MG02 where margin_date like @filedate + '%'    

insert into tbl_MG02
select @FILEDATE, 
	   ISNULL(.DBO.PIECE(FILEDATA,',',1),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',2),''),
	   ISNULL(.DBO.PIECE(FILEDATA,',',3),''),
	   ISNULL(.DBO.PIECE(FILEDATA,',',4),''),
	   ISNULL(.DBO.PIECE(FILEDATA,',',5),''),
	   ISNULL(.DBO.PIECE(FILEDATA,',',6),''),
	   ISNULL(.DBO.PIECE(FILEDATA,',',7),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',8),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',9),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',10),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',11),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',12),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',13),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',14),0),
	   ISNULL(.DBO.PIECE(FILEDATA,',',15),0)
from MG02_TMP1
where LEFT(FILEDATA,2) = 10

GO
