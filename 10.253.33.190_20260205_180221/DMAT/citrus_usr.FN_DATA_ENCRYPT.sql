-- Object: FUNCTION citrus_usr.FN_DATA_ENCRYPT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

    
create FUNCTION [citrus_usr].[FN_DATA_ENCRYPT]    
(    
 @KEY VARCHAR(100),    
 @DATA VARCHAR(MAX)    
) RETURNS VARBINARY(8000)    
AS    
BEGIN    
DECLARE @ENCRYPT_DATA VARBINARY(8000)    
    
SELECT @ENCRYPT_DATA = ENCRYPTBYKEY(KEY_GUID('Key4CertAutoProcess'),@DATA,1,HASHBYTES(@KEY,CONVERT( VARBINARY, @KEY)))    
    
RETURN @ENCRYPT_DATA    
END

GO
