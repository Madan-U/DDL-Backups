-- Object: PROCEDURE dbo.Report_Rpt_NseDebitStockRpt
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







CREATE Proc Report_Rpt_NseDebitStockRpt 
(@Branch_Cd Varchar(10),
 @Sub_broker Varchar(10),
 @Trader Varchar(20), 
 @Family Varchar(10),
 @Client Varchar(10),
 @From Varchar(10),
 @To Varchar(10),
 @RptWise int
) As
If @RptWise = 0
Begin
Select Branch_Cd,Party_Code=Family,Long_Name=FamilyName,LedBal=Sum(LedBal),EffBal=Sum(EffBal),Cash=Sum(Cash),NonCash=Sum(NonCash), 
DebitQty=Sum(DebitQty*Cl_Rate),PayQty=Sum(PayQty*Cl_Rate),FutQty=Sum(FutQty*Cl_Rate),ShrtQty=Sum(ShrtQty*Cl_Rate),PParty=Party_Code 
From DelDebitSummary Where Family >= @From And Family <= @To And Branch_Cd Like @Branch_Cd And Sub_Broker Like @Sub_Broker
And Trader Like @Trader And Family Like @Family And Party_Code Like @Client
Group By Branch_Cd,Family,FamilyName,Party_Code 
Order By Family,Party_Code 
end
Else
Begin
Select Branch_Cd,Party_Code,Long_Name,LedBal=Sum(LedBal),EffBal=Sum(EffBal),Cash=Sum(Cash),NonCash=Sum(NonCash), 
DebitQty=Sum(DebitQty*Cl_Rate),PayQty=Sum(PayQty*Cl_Rate),FutQty=Sum(FutQty*Cl_Rate),ShrtQty=Sum(ShrtQty*Cl_Rate),
PParty=Party_Code From DelDebitSummary Where Party_Code >= @From And Party_Code <= @To And Branch_Cd Like @Branch_Cd 
And Sub_Broker Like @Sub_Broker And Trader Like @Trader And Family Like @Family And Party_Code Like @Client
Group By Branch_Cd,Party_Code,Long_Name 
Order By Party_Code 
End

GO
