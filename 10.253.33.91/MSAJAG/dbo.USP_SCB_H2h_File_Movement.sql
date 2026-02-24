-- Object: PROCEDURE dbo.USP_SCB_H2h_File_Movement
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE DBO.USP_SCB_H2h_File_Movement
AS
BEGIN

DECLARE @SourcePath VARCHAR(100)
DECLARE @DestPath VARCHAR(100)
SET @DestPath ='J:\Backoffice\H2H_Files\'
SET @SourcePath='D:\Temp\'
DECLARE @SFileName VARCHAR(100)
DECLARE @DFileName VARCHAR(100)
SELECT @SFileName =CONVERT(VARCHAR(12),GETDATE(),112) +'_'+'DONE\'
SET @DFileName =CONVERT(VARCHAR(12),GETDATE(),112) +'_'+'DONE'
SELECT @SourcePath=@SourcePath +@SFileName --+'\*'
SELECT @DestPath =@DestPath +@DFileName
SELECT @SourcePath ,@DestPath

DECLARE @cmd nvarchar(500) ,@move varchar(100) 
--GO
--CREATE TABLE tbl_H2h_Files_MovementLogs
--(
--Id INT IDENTITY(1,1), 
--SFile  VARCHAR (100),
--DPATH  VARCHAR (100),
--OnDate VARCHAR (12),
--Flag   VARCHAR(10)
--)
 
	IF NOT EXISTS (SELECT TOP 1 * FROM tbl_H2h_Files_MovementLogs WHERE OnDate =CONVERT(VARCHAR(12),GETDATE(),112))
	BEGIN
		INSERT INTO tbl_H2h_Files_MovementLogs
		(
		SFile
		,DPATH
		,OnDate
		,Flag
		)
		SELECT @SourcePath,@DestPath , CONVERT(VARCHAR(12),GETDATE(),112) , 'DONE'
	END

	SET @cmd = 'mkdir ' + @DestPath
	EXEC MASTER..xp_cmdshell @cmd   --- this will create folder(newfolder_mmddyyy)
	SET @move ='move ' + @SourcePath + '*.* '+ @DestPath
	EXEC MASTER.dbo.xp_cmdshell @move  ---this will move files to newly created folder

END

GO
