-- Object: PROCEDURE dbo.Angel_Duplicate_category
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_Duplicate_category  
as                    
SET NOCOUNT ON                    
                    
DECLARE                     
@catcode varchar(10),                    
@catname varchar(100),  
@tcatcode varchar(10)   
              
truncate table angelcatmenu   
  
DECLARE error_cursor CURSOR FOR                     
select fldcategorycode,fldcategoryname,tcode='%,'+convert(varchar(10),fldcategorycode)+',%' from tblcategory  
          
OPEN error_cursor                    
                    
FETCH NEXT FROM error_cursor                     
INTO @catcode,@catname,@tcatcode  
                    
WHILE @@FETCH_STATUS = 0                    
BEGIN                    
    
insert into angelcatmenu   
select @catcode,@catname,fldreportcode from tblcatmenu where fldcategorycode like @tcatcode  
                  
  FETCH NEXT FROM error_cursor                     
  INTO @catcode,@catname,@tcatcode  
                    
END                    
                    
CLOSE error_cursor                    
DEALLOCATE error_cursor

GO
