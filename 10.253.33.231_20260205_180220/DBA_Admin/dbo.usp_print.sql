-- Object: PROCEDURE dbo.usp_print
-- Server: 10.253.33.231 | DB: DBA_Admin
--------------------------------------------------


CREATE PROCEDURE [dbo].[usp_print]
(
	@string nvarchar(max),
	@verbose tinyint = 0 /* 1 => messages, 2 => messages + table results */
)
AS
BEGIN
/*	Purpose:		
	Modifications:	2025-Feb-27 - Initial Draft

	exec usp_print @string;
*/
	SET NOCOUNT ON

	DECLARE @CurrentEnd BIGINT; /* track the length of the next substring */
	DECLARE @offset tinyint; /*tracks the amount of offset needed */
	set @string = replace(  replace(@string, char(13) + char(10), char(10))   , char(13), char(10))

	WHILE LEN(@String) > 1
	BEGIN
		IF CHARINDEX(CHAR(10), @String) between 1 AND 4000
		BEGIN
			   SET @CurrentEnd =  CHARINDEX(char(10), @String) -1
			   set @offset = 2
		END
		ELSE
		BEGIN
			   SET @CurrentEnd = 4000
				set @offset = 1
		END   
		PRINT SUBSTRING(@String, 1, @CurrentEnd) 
		set @string = SUBSTRING(@String, @CurrentEnd+@offset, LEN(@String))   
	END /*End While loop*/
END

GO
