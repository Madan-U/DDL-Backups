-- Object: FUNCTION citrus_usr.inside_trim
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--SELECT CITRUS_USR.inside_trim('TUSHAR PATEL','3')

CREATE function [citrus_usr].[inside_trim](@l_sting varchar(8000),@L_POSI VARCHAR(25))
returns varchar(8000)
as
begin
--
  DECLARE @L_FIRST VARCHAR(100)
   ,@L_SECOND VARCHAR(100)  
   ,@L_LAST VARCHAR(100)
   ,@L_INCR BIGINT
   ,@L_COUNTER BIGINT


  SET @L_INCR  = 1

  DECLARE @TEMP_DATA TABLE(ID BIGINT,L_STRING VARCHAR(100))
  

  SET @l_sting = replace(replace(replace(@l_sting,'    ',' '),'   ',' '),'  ',' ')
  SELECT @L_COUNTER = CITRUS_USR.UFN_COUNTSTRING(REPLACE(@l_sting,' ' ,'|'),'|')

  WHILE @L_COUNTER+2 > @L_INCR
  BEGIN
  --
    INSERT INTO @TEMP_DATA VALUES(@L_INCR,CITRUS_USR.FN_SPLITVAL_BY(REPLACE(@l_sting,' ' ,'|'),@L_INCR,'|')) 
    SET @L_INCR = @L_INCR + 1
  --
  END
  
SET @l_sting = ''

  IF  @L_POSI = 1
  SELECT @l_sting = L_STRING FROM @TEMP_DATA WHERE ID = 1
  IF  @L_POSI = 2
  BEGIN
    IF NOT EXISTS(SELECT L_STRING FROM @TEMP_DATA WHERE ID = 3)
    BEGIN 
     SELECT @l_sting = ''
    END
    ELSE 
    BEGIN
      SELECT @l_sting = L_STRING FROM @TEMP_DATA WHERE ID = 2
    END
  END
  IF  @L_POSI = 3
  BEGIN
   IF NOT EXISTS(SELECT L_STRING FROM @TEMP_DATA WHERE ID = 3)
   BEGIN 
    SELECT @l_sting = ISNULL(L_STRING,'') FROM @TEMP_DATA WHERE ID = 2
   END 
   ELSE 
   BEGIN
    SELECT @l_sting = @l_sting + ' ' +ISNULL(L_STRING,'') FROM @TEMP_DATA WHERE ID NOT IN (1,2)
   END

  END

  RETURN @l_sting
  
--
end

GO
