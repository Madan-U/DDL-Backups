-- Object: PROCEDURE dbo.C_CheckOpeningEntry
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Check For The Opening entry Between the Financila Year*/
CREATE  Proc C_CheckOpeningEntry (@Sdt Varchar(11), @Ldt Varchar(11), @AccountDb Varchar(20))
As
Declare @@Vtyp Varchar(2)
Set @@Vtyp = '18'
Exec ('select distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  from ' + @AccountDb + '.Dbo.MarginLedger
where vtyp = "'+@@Vtyp+'"' + ' and  vdt >= "'+@Sdt+'"' + ' and vdt <= "'+@Ldt+  ' 23:59:59"')

GO
