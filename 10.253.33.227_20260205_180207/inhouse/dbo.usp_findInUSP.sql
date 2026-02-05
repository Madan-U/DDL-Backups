-- Object: PROCEDURE dbo.usp_findInUSP
-- Server: 10.253.33.227 | DB: inhouse
--------------------------------------------------

CREATE PROCEDURE usp_findInUSP                
@dbname varchar(500),              
@srcstr varchar(500)                
AS                
                
 set nocount on              
 set @srcstr  = '%' + @srcstr + '%'                
              
 declare @str as varchar(1000)              
 set @str=''              
 if @dbname <>''              
 Begin              
 set @dbname=@dbname+'.dbo.'              
 End              
 else              
 begin              
 set @dbname=db_name()+'.dbo.'              
 End              
 print @dbname              
              
 set @str='select distinct O.name,O.xtype from '+@dbname+'sysComments  C '               
 set @str=@str+' join '+@dbname+'sysObjects O on O.id = C.id '               
 set @str=@str+' where O.xtype in (''P'',''V'') and C.text like '''+@srcstr+''''                
 print @str              
  exec(@str)              
set nocount off

GO
