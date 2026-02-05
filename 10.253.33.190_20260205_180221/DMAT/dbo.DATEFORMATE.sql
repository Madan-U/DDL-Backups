-- Object: PROCEDURE dbo.DATEFORMATE
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create PROCEDURE [dbo].[DATEFORMATE](@INDATETIME VARCHAR(10),@pa_out varchar(10) out)
AS
BEGIN
	DECLARE @MyOutput varchar(10)
	SET @MyOutput = CONVERT(varchar(10),@InDateTime,101)
	print @MyOutput    
END

GO
