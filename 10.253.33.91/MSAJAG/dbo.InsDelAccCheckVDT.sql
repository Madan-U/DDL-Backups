-- Object: PROCEDURE dbo.InsDelAccCheckVDT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc InsDelAccCheckVDT (@FParty_Code Varchar(10), @TParty_Code Varchar(10)) as 
Truncate Table DelAccBalance
Insert Into DelAccBalance
Select A.CltCode,Amount=Sum(A.Credit)-Sum(A.Debit) From (
select CltCode,Debit=(Case When L.DrCr = 'D' Then Sum(Vamt) Else 0 end),
Credit=(Case When L.DrCr = 'C' Then Sum(Vamt) Else 0 end) from Account.Dbo.Ledger L, Account.dbo.Parameter P
Where VDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'
And Vdt >= SdtCur And CurYear = 1 
And CltCode >= @FParty_Code And CltCode <= @TParty_Code 
Group by CltCode,L.DrCr ) A 
Group by A.CltCode

GO
