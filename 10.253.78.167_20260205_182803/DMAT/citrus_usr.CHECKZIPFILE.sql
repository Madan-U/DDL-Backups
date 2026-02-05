-- Object: FUNCTION citrus_usr.CHECKZIPFILE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create FUNCTION [citrus_usr].[CHECKZIPFILE]    
(    
 @FILENAME VARCHAR(200)    
) RETURNS INT    
AS    
BEGIN    
 DECLARE @STATUS INT    
 SET @STATUS = 0     
     
 SET @STATUS = (CASE WHEN @FILENAME LIKE '%.ZIP' THEN 1 ELSE 0 END)    
    
 IF @STATUS = 0    
 BEGIN    
  SET @STATUS = (CASE WHEN @FILENAME LIKE '%.GZ' THEN 1 ELSE 0 END)    
 END    
 RETURN @STATUS    
END

GO
