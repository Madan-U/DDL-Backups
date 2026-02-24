-- Object: PROCEDURE dbo.C_lastopeningentryms
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_lastopeningentryms (@sdt Varchar(11), @accountdb Varchar(20),@accountdbserver Varchar(15))
As
Declare @@vtyp Varchar(2)
Set @@vtyp = '18'
Exec ('select Distinct Isnull(left(convert(varchar,vdt,109),11),'''') Vdt  From ' + @accountdbserver + '.' + @accountdb + '.dbo.marginledger
Where Vtyp = "'+@@vtyp+'"' + ' And  Vdt < "'+@sdt+'"')

GO
