-- Object: PROCEDURE dbo.USP_H2H_FIle_MOVE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--- Created By HRISHI on 07-09-2022 
--- Description:- To move H2H files 


Create Proc USP_H2H_FIle_MOVE
AS

DECLARE @command varchar(1000) = '';
 --DECLARE @sourcePathA varchar(128) = 'D:\Test\H2H\';
 --DECLARE @destinationPathB varchar(128) = 'D:\Test\Dest\';
 DECLARE @sourcePathA varchar(128) = 'D:\H2H_DATA\host2host\documents\reportscust\in\txn\';
 DECLARE @destinationPathB varchar(128) = 'D:\Archive\FileCopy\';
 DECLARE @fileName varchar(128) = '*.csv';
   
 --SET @command = 'move "' + @sourcePathA + @fileName + '" "' + @destinationPathB + @newFileName + '"';
 SET @command = 'Move "' + @sourcePathA + @fileName + '" "' + @destinationPathB + '"';
 print @command

 EXEC master..xp_cmdshell @command, no_output;

 SELECT 'FILES MOVED SUCCESSFULLY'

GO
