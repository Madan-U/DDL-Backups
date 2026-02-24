-- Object: PROCEDURE dbo.C_MarginWithOutOpSp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*Calculate the Ledger Balance From The Beginning to the Collateral Calculation Date*/
CREATE Proc C_MarginWithOutOpSp 
(@Exchange Varchar(3), 
@Segment Varchar(20), 
@Party_code Varchar(10), 
@Tdt as varchar(20),
@AccountDb Varchar(20),
@AccountCode Varchar(20))
As
Declare @@Dr Varchar(1)
Declare @@Cr Varchar(1)

Set @@Dr = 'D'
Set @@Cr = 'C'
Set @AccountCode = @AccountCode + '%'
Set @Tdt = @Tdt + ' 23:59'

exec ('select Camt = isnull((case when drcr = "'+@@Cr+'"' + ' then sum(Amount) else 0 end),0),
Damt = isnull((Case when drcr = "'+@@Dr+'"' + ' then sum(Amount) else 0 end),0), drcr
from ' + @AccountDb + '.dbo.MarginLedger where  vdt <= "'+@Tdt+'"' + 
' and party_code = "'+@Party_code+'"' + ' and exchange = "'+@Exchange+'"' +
' and segment = "'+@Segment+'"' + ' and MCltcode like "' +@AccountCode+'"'  +
' group by drcr')

GO
