-- Object: FUNCTION citrus_usr.FN_DATA_DECRYPT
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create FUNCTION [citrus_usr].[FN_DATA_DECRYPT]    
(    
 @KEY VARCHAR(100),    
 @DATA VARBINARY(8000)    
) RETURNS VARCHAR(MAX)    
AS    
BEGIN    
DECLARE @DECRYPT_DATA VARCHAR(MAX)    
    
SELECT @DECRYPT_DATA =  DECRYPTBYKEY(@DATA,1,HASHBYTES(@KEY,CONVERT( VARBINARY, @KEY)))    
    
RETURN @DECRYPT_DATA    
END

GO
