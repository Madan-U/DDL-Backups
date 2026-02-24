-- Object: PROCEDURE dbo.usp_writeSysObjectReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC usp_writeSysObjectReport(@outfile VARCHAR(255))
AS
BEGIN
   DECLARE @strCommand VARCHAR(255)
   DECLARE @lret       INT

   SET @strCommand = 'bcp "EXECUTE msajag..usp_CreateSysObjectsReport"'
       + ' QUERYOUT "' + @outfile + '" -T -S' + LOWER(@@SERVERNAME) + ' -c'

   --BCP the HTML file
   PRINT 'EXEC master..xp_cmdshell ''' + @strCommand + ''''
   EXEC @lRet = master..xp_cmdshell @strCommand, NO_OUTPUT

   IF @lret = 0
      PRINT 'File Created'
   ELSE
      PRINT 'Error: ' + str(@lret)
END

GO
