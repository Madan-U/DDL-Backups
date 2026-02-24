-- Object: PROCEDURE dbo.InsDelAccCheck
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsDelAccCheck as   
Truncate Table DelAccBalance  
  
Set Transaction Isolation Level Read Uncommitted  
select * into #aniled from Account.Dbo.Ledger   
  
select * into #anipara from Account.Dbo.Parameter   
  
Insert Into DelAccBalance  
Select A.CltCode,Amount=Sum(A.Credit)-Sum(A.Debit), 0 From (  
select CltCode,Debit=(Case When L.DrCr = 'D' Then Sum(Vamt) Else 0 end),  
Credit=(Case When L.DrCr = 'C' Then Sum(Vamt) Else 0 end) from #aniled L, #anipara  
Where EDt <= Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'  
And Edt >= SdtCur And CurYear = 1   
Group by CltCode,L.DrCr ) A   
Group by A.CltCode  
  
Update DelAccBalance Set Amount = 0, PayFlag=1 Where CltCode in ( Select Party_Code From DelPartyFlag Where DebitFlag = 1 )  
Update DelAccBalance Set Amount = -1, PayFlag=2 Where CltCode in ( Select Party_Code From DelPartyFlag Where DebitFlag = 2 )

GO
