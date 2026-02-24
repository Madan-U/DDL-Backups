-- Object: FUNCTION citrus_usr.FN_SPLITVALWITHDELIMETER
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_SPLITVALWITHDELIMETER](@DELIMETER VARCHAR(10),@LINE VARCHAR(8000),@LEVEL INTEGER)   
RETURNS VARCHAR(8000)      
AS      
BEGIN      
--      
  DECLARE      
  --      
  @@FNLINE   VARCHAR(8000),      
  @@RETLINE  VARCHAR(8000),      
  @CTR       INTEGER      
  SET @@FNLINE =  @DELIMETER + @LINE + @DELIMETER    
  SET @CTR =0      
  --      
  WHILE @CTR < @LEVEL      
  BEGIN      
    --      
    SET @@FNLINE = SUBSTRING(@@FNLINE,CHARINDEX(@DELIMETER,@@FNLINE) +4,LEN(@@FNLINE))      
    --      
    IF CHARINDEX(@DELIMETER,@@FNLINE) <> 0      
    BEGIN      
      --      
      SET @@RETLINE = SUBSTRING(@@FNLINE,1,CHARINDEX(@DELIMETER,@@FNLINE)-1)      
      --      
    END      
    --      
    ELSE      
    BEGIN      
      --      
      SET @@RETLINE = ''      
      --      
    END      
    --      
    SET @CTR = @CTR+1      
    --      
  END      
  --      
RETURN @@RETLINE      
--      
END

GO
