-- Object: PROCEDURE dbo.proc_genscript
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


---EXEC PROC_GENSCRIPT @SERVERNAME = 'ANGELBOUAT',@DBNAME = 'MSAJAG', @ObjectName = '', @ObjectType = 'Table', @TableName = 'dbo',@ScriptFile = 'D:\pubs.sql'

CREATE PROCEDURE proc_genscript 
	@ServerName varchar(30), 
	@DBName varchar(30), 
	@ObjectName varchar(50), 
	@ObjectType varchar(10), 
	@TableName varchar(50),
	@ScriptFile varchar(255)
AS

DECLARE @CmdStr varchar(255)
DECLARE @object int
DECLARE @hr int

SET NOCOUNT ON
SET @CmdStr = 'Connect('+@ServerName+')'
EXEC @hr = sp_OACreate 'SQLDMO.SQLServer', @object OUT

--Comment out for standard login
EXEC @hr = sp_OASetProperty @object, 'LoginSecure', TRUE

/* Uncomment for Standard Login
EXEC @hr = sp_OASetProperty @object, 'Login', 'sa'
EXEC @hr = sp_OASetProperty @object, 'password', 'sapassword'
*/

EXEC @hr = sp_OAMethod @object,@CmdStr
SET @CmdStr = 
  CASE @ObjectType
    WHEN 'Database' 	THEN 'Databases("' 
    WHEN 'Procedure'	THEN 'Databases("' + @DBName + '").StoredProcedures("'
    WHEN 'View' 	THEN 'Databases("' + @DBName + '").Views("'
    WHEN 'Table'	THEN 'Databases("' + @DBName + '").Tables("'
    WHEN 'Index'	THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Indexes("'
    WHEN 'Trigger'	THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Triggers("'
    WHEN 'Key'	THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Keys("'
    WHEN 'Check'	THEN 'Databases("' + @DBName + '").Tables("' + @TableName + '").Checks("'
    WHEN 'Job'	THEN 'Jobserver.Jobs("'
  END

SET @CmdStr = @CmdStr + @ObjectName + '").Script(5,"' + @ScriptFile + '")'
EXEC @hr = sp_OAMethod @object, @CmdStr
EXEC @hr = sp_OADestroy @object

GO
