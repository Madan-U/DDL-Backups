-- Object: PROCEDURE dbo.C_LastOpeningEntry
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Take The latest Opening Entry*/
CREATE Proc C_LastOpeningEntry (@Sdt Varchar(11), @AccountDb Varchar(20))
As
Declare @@Vtyp Varchar(2)
Set @@Vtyp = '18'
Exec ('select distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  from ' + @AccountDb + '.Dbo.MarginLedger
where vtyp = "'+@@Vtyp+'"' + ' and  vdt < "'+@Sdt+'"')

GO
