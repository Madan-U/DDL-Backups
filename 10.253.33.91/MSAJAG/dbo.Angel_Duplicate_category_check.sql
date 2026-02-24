-- Object: PROCEDURE dbo.Angel_Duplicate_category_check
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_Duplicate_category_check  
as                    
SET NOCOUNT ON                    
                    
DECLARE                     
@catcode varchar(10),                    
@catname varchar(1000),  
@tcatcode varchar(10),   
@menucode varchar(10)   
              
truncate table angelcatmap   
  
DECLARE error_cursor CURSOR FOR                     
--select fldcategorycode,fldcategoryname,tcode='%,'+convert(varchar(10),fldcategorycode)+',%' from tblcategory  
select fldcategorycode,menucode from angelcatmenu order by fldcategorycode,menucode          
  
OPEN error_cursor                    
                    
FETCH NEXT FROM error_cursor                     
INTO @catcode,@menucode  
  
set @tcatcode=''  
                    
  
WHILE @@FETCH_STATUS = 0                    
BEGIN      
                
 if @tcatcode <> @catcode   
 begin  
  insert into angelcatmap select @tcatcode,@catname  
   set @catname=@menucode+','  
   set @tcatcode=@catcode  
 end  
 else  
 begin  
   set @catname=@catname+@menucode+','  
 end  
                  
  FETCH NEXT FROM error_cursor                     
INTO @catcode,@menucode  
                    
END                    
                    
CLOSE error_cursor                    
DEALLOCATE error_cursor

GO
