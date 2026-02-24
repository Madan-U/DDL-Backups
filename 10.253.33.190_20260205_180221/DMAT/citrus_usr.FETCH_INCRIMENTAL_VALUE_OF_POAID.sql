-- Object: FUNCTION citrus_usr.FETCH_INCRIMENTAL_VALUE_OF_POAID
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FETCH_INCRIMENTAL_VALUE_OF_POAID]  
()  
returns numeric  
begin  
declare @s numeric  
SELECT @s = BITRM_BIT_LOCATION  FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD = 'POAID_AUTO'  
return @s + 1  
end

GO
