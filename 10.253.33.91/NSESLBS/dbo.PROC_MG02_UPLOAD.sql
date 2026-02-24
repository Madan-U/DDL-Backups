-- Object: PROCEDURE dbo.PROC_MG02_UPLOAD
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


  
CREATE  PROC [dbo].[PROC_MG02_UPLOAD](@FILEDATE VARCHAR(11), @FILEPATH VARCHAR(150)) AS            
Declare @strSql varchar(400)               
            
delete from tbl_MG02 where margin_date like @filedate + '%'

TRUNCATE TABLE MG02_TMP1            
set @strSql = 'Bulk insert MG02_TMP1 from ''' + @FilePath  + ''' with ( ROWTERMINATOR = ''\n'' )'                
Exec(@strSql)      

insert into tbl_MG02        
select @FILEDATE,         
    ISNULL(.DBO.PIECE(FILETEXT,',',1),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',2),''),        
    ISNULL(.DBO.PIECE(FILETEXT,',',3),''),        
    ISNULL(.DBO.PIECE(FILETEXT,',',4),''),        
    ISNULL(.DBO.PIECE(FILETEXT,',',6),''),        
    ISNULL(.DBO.PIECE(FILETEXT,',',7),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',8),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',9),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',10),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',11),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',12),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',13),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',14),0),        
    ISNULL(.DBO.PIECE(FILETEXT,',',15),0),         
    ISNULL(.DBO.PIECE(FILETEXT,',',16),0),       
    ISNULL(.DBO.PIECE(FILETEXT,',',5),'')        
from MG02_TMP1        
where LEFT(FILETEXT,2) = 10         

if (select ISNULL(count(1),0) from MG02_TMP1) > 0 
Begin
	EXEC PROC_MARGIN_IMPORT_MAPPING @FILEDATE
end

GO
