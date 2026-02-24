-- Object: PROCEDURE dbo.CMValanDiff
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CMValanDiff    Script Date: 09/11/2002 2:47:27 PM ******/
Create Proc CMValanDiff (@FromSett_No Varchar(7),@ToSett_No Varchar(7),@Sett_Type Varchar(2)) As 
Select Sett_No=IsNull(C.Sett_No,A.Sett_No),Sett_Type=IsNull(C.Sett_Type,A.Sett_Type),Party_Code=IsNull(C.Party_Code,A.Party_Code),
Party_Name,Branch_Cd,SubBroker,Family,Trader,NewAmt=Abs(IsNull(Sum(PAmt),0)-IsNull(Sum(SAmt),0)),OldAmt=IsNull(Amount,0),
Diff=Abs(IsNull(Sum(PAmt),0)-IsNull(Sum(SAmt),0))-IsNull(Amount,0) From CMBillValan C Full Outer Join AccBill A
On (A.Sett_No = C.Sett_No And A.Sett_Type = C.Sett_Type And A.Party_Code = C.Party_Code)
Where TradeType = 'S' And IsNull(C.Sett_No,A.Sett_No) >= @FromSett_No 
And IsNull(C.Sett_No,A.Sett_No) <= @ToSett_No And IsNull(C.Sett_Type,A.Sett_Type) = @Sett_Type 
Group By IsNull(C.Sett_No,A.Sett_No),IsNull(C.Sett_Type,A.Sett_Type),IsNull(C.Party_Code,A.Party_Code),Party_Name,Amount,Branch_Cd,SubBroker,Family,Trader
Having Abs(IsNull(Sum(PAmt),0)-IsNull(Sum(SAmt),0))-IsNull(Amount,0) > 1
Union All
Select Sett_No=IsNull(C.Sett_No,A.Sett_No),Sett_Type=IsNull(C.Sett_Type,A.Sett_Type),Party_Code=IsNull(C.Party_Code,A.Party_Code),
Party_Name,Branch_Cd,SubBroker,Family,Trader,NewAmt=Abs(IsNull(Sum(PAmt),0)-IsNull(Sum(SAmt),0)),OldAmt=IsNull(Amount,0),
Diff=Abs(IsNull(Sum(PAmt),0)-IsNull(Sum(SAmt),0))-IsNull(Amount,0) From CMBillValan C Full Outer Join IAccBill A
On (A.Sett_No = C.Sett_No And A.Sett_Type = C.Sett_Type And A.Party_Code = C.Party_Code)
Where TradeType = 'I' And IsNull(C.Sett_No,A.Sett_No) >= @FromSett_No 
And IsNull(C.Sett_No,A.Sett_No) <= @ToSett_No And IsNull(C.Sett_Type,A.Sett_Type) = @Sett_Type 
Group By IsNull(C.Sett_No,A.Sett_No),IsNull(C.Sett_Type,A.Sett_Type),IsNull(C.Party_Code,A.Party_Code),Party_Name,Amount,Branch_Cd,SubBroker,Family,Trader
Having Abs(IsNull(Sum(PAmt),0)-IsNull(Sum(SAmt),0))-IsNull(Amount,0) > 1
Order By IsNull(C.Sett_No,A.Sett_No),IsNull(C.Sett_Type,A.Sett_Type),IsNull(C.Party_Code,A.Party_Code)

GO
