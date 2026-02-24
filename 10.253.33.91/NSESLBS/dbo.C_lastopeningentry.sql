-- Object: PROCEDURE dbo.C_lastopeningentry
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_lastopeningentry (@sdt Varchar(11), @accountdb Varchar(20))
As
Declare @@vtyp Varchar(2)
Set @@vtyp = '18'
Exec ('select Distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  From ' + @accountdb + '.dbo.marginledger
Where Vtyp = "'+@@vtyp+'"' + ' And  Vdt < "'+@sdt+'"')

GO
