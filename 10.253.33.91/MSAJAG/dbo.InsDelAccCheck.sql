-- Object: PROCEDURE dbo.InsDelAccCheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Proc InsDelAccCheck as 
Truncate Table DelAccBalance
Insert Into DelAccBalance
Select A.CltCode,Amount=Sum(A.Credit)-Sum(A.Debit) From (
select CltCode,Debit=(Case When L.DrCr = 'D' Then Sum(Vamt) Else 0 end),
Credit=(Case When L.DrCr = 'C' Then Sum(Vamt) Else 0 end) from Account.Dbo.Ledger L, Account.dbo.Parameter P
Where EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'
And Edt >= SdtCur And CurYear = 1 
Group by CltCode,L.DrCr ) A 
Group by A.CltCode

Update DelAccBalance Set Amount = 0 Where CltCode in ( Select Party_Code From DelPartyFlag Where DebitFlag = 1 )

GO
