-- Object: PROCEDURE dbo.USP_H2H_File_MoveDateWise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


------// Created by Hrishi on 09-09-2022 //------
----Description:- To copy H2H .CSV file into current date folder.

Create proc USP_H2H_File_MoveDateWise
AS

DECLARE @command varchar(1000) = '';
SET @command = 'D:\H2HFileMoveCode\H2HFileMoveLive.bat'

EXEC master..xp_cmdshell @command, no_output;

SELECT 'FILES MOVED SUCCESSFULLY'

GO
