-- Object: PROCEDURE citrus_usr.PR_LOGNA_ACCESS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_LOGNA_ACCESS 'pass',''        
CREATE PROCEDURE PR_LOGNA_ACCESS        
(        
@LNAME VARCHAR(20)        
,@FINYEAR VARCHAR(20)        
)        
AS        
BEGIN         
      
if exists (      
SELECT  isnull(LOGNA_NO_OF_DAYS,'') LOGNA_NO_OF_DAYS  FROM LOGIN_NAMES_ACCESS WHERE LOGNA_DELETED_IND=1 AND LOGNA_NAME=@LNAME        
)    
begin    
SELECT  isnull(LOGNA_NO_OF_DAYS,'') LOGNA_NO_OF_DAYS  FROM LOGIN_NAMES_ACCESS WHERE LOGNA_DELETED_IND=1 AND LOGNA_NAME=@LNAME        
end     
else    
begin    
select '0'    
end    
      
        
END

GO
