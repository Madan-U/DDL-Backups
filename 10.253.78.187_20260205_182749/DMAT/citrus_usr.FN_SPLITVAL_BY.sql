-- Object: FUNCTION citrus_usr.FN_SPLITVAL_BY
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_SPLITVAL_BY](@LINE VARCHAR(8000),@LEVEL INTEGER,@by varchar(10)) RETURNS VARCHAR(8000)    
AS    
BEGIN    
--    
  DECLARE    
  --    
  @@FNLINE   VARCHAR(8000),    
  @@RETLINE  VARCHAR(8000),    
  @CTR       INTEGER    
  SET @@FNLINE =  @by + @LINE + @by    
  SET @CTR =0    
  --    
  WHILE @CTR < @LEVEL    
  BEGIN    
    --    
    SET @@FNLINE = SUBSTRING(@@FNLINE,CHARINDEX(@by,@@FNLINE) +len(@by),LEN(@@FNLINE))    
    --    
    IF CHARINDEX(@by,@@FNLINE) <> 0    
    BEGIN    
      --    
      SET @@RETLINE = SUBSTRING(@@FNLINE,1,CHARINDEX(@by,@@FNLINE)-1)    
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
