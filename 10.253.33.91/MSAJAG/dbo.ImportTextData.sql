-- Object: PROCEDURE dbo.ImportTextData
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[ImportTextData]    

as    

--    

/*Created By :-jay Khare    

    

*/    

--    

Truncate table ImportCDR    

declare @cmd varchar(1000)                        

declare @ssispath varchar(1000)                        

set @ssispath = 'd:\BackOffice\VT05082013_3.csv'                     

select @cmd = 'dtexec /F "' + @ssispath + '"'                        

select @cmd = @cmd                

exec master..xp_cmdshell @cmd      

  

  

Truncate table ImportDID    

declare @cmd2 varchar(1000)     

declare @ssispath2 varchar(1000)                        

set @ssispath2 = 'd:\BackOffice\VT05082013_3.csv'                       

select @cmd2 = 'dtexec /F "' + @ssispath2 + '"'                        

select @cmd2 = @cmd2                

exec master..xp_cmdshell @cmd2

GO
