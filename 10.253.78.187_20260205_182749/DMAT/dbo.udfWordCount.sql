-- Object: FUNCTION dbo.udfWordCount
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[udfWordCount](
@OriginalText VARCHAR(8000)
)
RETURNS int
as
/*
SELECT dbo.udfWordCount ('hello   world')
*/
BEGIN
     
    DECLARE @i int ,@j INT, @Words int
    SELECT     @i = 1, @Words = 0 

    WHILE @i <= DATALENGTH(@OriginalText)
    BEGIN
        
        SELECT    @j = CHARINDEX(' ', @OriginalText, @i)
        if @j = 0
        BEGIN
            SELECT    @j = DATALENGTH(@OriginalText) + 1
        END
        IF SUBSTRING(@OriginalText, @i, @j - @i) <>' '
              SELECT @Words = @Words +1 
        SELECT    @i = @j +1
    END
    RETURN(@Words)
END

GO
