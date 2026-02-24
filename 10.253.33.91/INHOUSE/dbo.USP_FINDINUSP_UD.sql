-- Object: PROCEDURE dbo.USP_FINDINUSP_UD
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


CREATE PROCEDURE USP_FINDINUSP_UD                                   
@DBNAME VARCHAR(500),                                  
@SRCSTR VARCHAR(500)                                    
AS                                    
                                    
 SET NOCOUNT ON              
 --                                
 SET @SRCSTR  = '%' + @SRCSTR + '%'                                    
                                  
 DECLARE @STR AS VARCHAR(1000)                                  
 SET @STR=''                                  
 IF @DBNAME <>''                                  
 BEGIN                                  
 SET @DBNAME=@DBNAME+'.DBO.'                                  
 END                                  
 ELSE                                  
 BEGIN                                  
 SET @DBNAME=DB_NAME()+'.DBO.'                                  
 END                                  
-- PRINT @DBNAME                                  
                               
 SET @STR=' INSERT INTO BO_OBJECT '                      
 SET @STR=@STR+' SELECT DISTINCT O.NAME,O.XTYPE,'''+@DBNAME+''',SUBSTRING('''+@SRCSTR+''',2,100) FROM '+@DBNAME+'SYSCOMMENTS  C '                                   
 SET @STR=@STR+' JOIN '+@DBNAME+'SYSOBJECTS O ON O.ID = C.ID '                                   
 SET @STR=@STR+' WHERE O.XTYPE  IN(''P'',''V'') AND (C.TEXT LIKE ''%insert%'' or C.TEXT LIKE ''%update%'' or  C.TEXT LIKE ''%delete%'') '                        
 SET @STR=@STR+' AND REPLACE(C.TEXT,'' '','''') LIKE '''+@SRCSTR+''''                                    
                      
--PRINT @STR                                  
EXEC(@STR)                                  
SELECT * FROM  BO_OBJECT       
                        
SET NOCOUNT OFF

GO
