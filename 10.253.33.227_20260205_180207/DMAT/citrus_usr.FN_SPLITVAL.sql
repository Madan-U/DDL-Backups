-- Object: FUNCTION citrus_usr.FN_SPLITVAL
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[FN_SPLITVAL](@LINE VARCHAR(8000),@LEVEL INTEGER) RETURNS VARCHAR(8000)
AS
BEGIN
--
  DECLARE
  --
  @@FNLINE   VARCHAR(8000),
  @@RETLINE  VARCHAR(8000),
  @CTR       INTEGER
  SET @@FNLINE =  '|*~|' + @LINE + '|*~|'
  SET @CTR =0
  --
  WHILE @CTR < @LEVEL
  BEGIN
    --
    SET @@FNLINE = SUBSTRING(@@FNLINE,CHARINDEX('|*~|',@@FNLINE) +4,LEN(@@FNLINE))
    --
    IF CHARINDEX('|*~|',@@FNLINE) <> 0
    BEGIN
      --
      SET @@RETLINE = SUBSTRING(@@FNLINE,1,CHARINDEX('|*~|',@@FNLINE)-1)
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
