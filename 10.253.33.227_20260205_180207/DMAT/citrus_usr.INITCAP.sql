-- Object: FUNCTION citrus_usr.INITCAP
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[INITCAP] (@s varchar(255) ) 
--Returns a string with the first letter of each word in uppercase, all other letters in lowercase (capitalize first character).  
returns varchar(255)
as
BEGIN
DECLARE @i int, @c char(1),@result varchar(255)
SET @result=LOWER(@s)
SET @i=2
SET @result=STUFF(@result,1,1,UPPER(SUBSTRING(@s,1,1)))
WHILE @i<=LEN(@s)
 BEGIN
 SET @c=SUBSTRING(@s,@i,1)
 IF (@c=' ') OR (@c=';') OR (@c=':') OR (@c='!') OR (@c='?') OR (@c=',')OR (@c='.')OR (@c='_')
  IF @i<LEN(@s)
   BEGIN
   SET @i=@i+1
   SET @result=STUFF(@result,@i,1,UPPER(SUBSTRING(@s,@i,1)))
   END
 SET @i=@i+1
 END
RETURN  @result
END

GO
