-- Object: PROCEDURE dbo.FileListProc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  Proc FileListProc (@FilePath Varchar(100) )        
As         
      
Declare @NewFilePath Varchar(100)      
      
Set @NewFilePath = Replace(@FilePath, '*.txt', '*.*')      
Create Table #FileList         
( FileNameList Varchar(100))        
Insert into #FileList         
Exec master.dbo.xp_cmdshell @NewFilePath        
  
Select * from #FileList

GO
