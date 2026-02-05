-- Object: FUNCTION citrus_usr.ufn_CountString
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  function [citrus_usr].[ufn_CountString]  
( @pInput VARCHAR(max), @pSearchString VARCHAR(100) )  
RETURNS INT  
BEGIN  
  
    RETURN (LEN(@pInput) -   
            LEN(REPLACE(@pInput, @pSearchString, ''))) /  
            LEN(@pSearchString)  
  
END

GO
