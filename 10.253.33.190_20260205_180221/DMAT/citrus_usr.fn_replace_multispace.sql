-- Object: FUNCTION citrus_usr.fn_replace_multispace
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_replace_multispace](@pa_string varchar(8000))
RETURNS VARCHAR(8000)       
AS      
--      
BEGIN      
--  
declare @l_string varchar(8000)
SELECT @l_string  = REPLACE(
            REPLACE(
                REPLACE(
                    LTRIM(RTRIM(@pa_string))
                ,'  ',' '+CHAR(7))  --Changes 2 spaces to the OX model
            ,CHAR(7)+' ','')        --Changes the XO model to nothing
        ,CHAR(7),'')  --Changes the remaining X's to nothing
  WHERE CHARINDEX('  ',@pa_string) > 0
return @l_string 
--        
END

GO
