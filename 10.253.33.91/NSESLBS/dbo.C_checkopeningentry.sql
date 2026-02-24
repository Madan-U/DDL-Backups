-- Object: PROCEDURE dbo.C_checkopeningentry
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc C_checkopeningentry (@sdt Varchar(11), @ldt Varchar(11), @accountdb Varchar(20))
As
Declare @@vtyp Varchar(2)
Set @@vtyp = '18'
Exec ('select Distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  From ' + @accountdb + '.dbo.marginledger
Where Vtyp = "'+@@vtyp+'"' + ' And  Vdt >= "'+@sdt+'"' + ' And Vdt <= "'+@ldt+  ' 23:59:59"')

GO
