-- Object: PROCEDURE dbo.VIRTUAL_MIS_FILEGEN
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE VIRTUAL_MIS_FILEGEN
(
	@SQLQRY varchar(1000),
	@DATASERVER varchar(50)	,
	@FNAME VARCHAR(500)
)
AS

DECLARE
	@@SQL VARCHAR(1000)

	SELECT @@SQL = "DECLARE @@ERR AS INT EXEC @@ERR = MASTER.DBO.XP_CMDSHELL 'BCP " + CHAR(34) + @SQLQRY + " " + CHAR(34) + " queryout " + CHAR(34) + @FNAME + CHAR(34) + " -c -q -t " + CHAR(34) + "," + CHAR(34) + " -T -S "+ CHAR(34) + CHAR(34) + @DATASERVER + CHAR(34) + "', no_output"
	PRINT @@SQL
	EXEC (@@SQL)

GO
