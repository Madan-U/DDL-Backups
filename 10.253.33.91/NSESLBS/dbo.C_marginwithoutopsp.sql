-- Object: PROCEDURE dbo.C_marginwithoutopsp
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc C_marginwithoutopsp 
(@exchange Varchar(3), 
@segment Varchar(20), 
@party_code Varchar(10), 
@tdt As Varchar(20),
@accountdb Varchar(20),
@accountcode Varchar(20))
As
Declare @@dr Varchar(1)
Declare @@cr Varchar(1)

Set @@dr = 'd'
Set @@cr = 'c'
Set @accountcode = @accountcode + '%'
Set @tdt = @tdt + ' 23:59'

Exec ('select Camt = Isnull((case When Drcr = "'+@@cr+'"' + ' Then Sum(amount) Else 0 End),0),
Damt = Isnull((case When Drcr = "'+@@dr+'"' + ' Then Sum(amount) Else 0 End),0), Drcr
From ' + @accountdb + '.dbo.marginledger Where  Vdt <= "'+@tdt+'"' + 
' And Party_code = "'+@party_code+'"' + ' And Exchange = "'+@exchange+'"' +
' And Segment = "'+@segment+'"' + ' And Mcltcode Like "' +@accountcode+'"'  +
' Group By Drcr')

GO
