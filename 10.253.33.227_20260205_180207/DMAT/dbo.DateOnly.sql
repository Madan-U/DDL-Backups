-- Object: FUNCTION dbo.DateOnly
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION [dbo].[DateOnly](@InDateTime varchar(10))
RETURNS varchar(10)
AS
BEGIN

    DECLARE @MYOUTPUT VARCHAR(10)
declare @pa_out varchar(10)
    EXEC dbo.DATEFORMATE @INDATETIME , @MYOUTPUT = @pa_out
	RETURN @MYOUTPUT

	--DECLARE @MyOutput varchar(10)
	--SET @MyOutput = CONVERT(varchar(10),@InDateTime,101)
	--RETURN @MyOutput
END

GO
