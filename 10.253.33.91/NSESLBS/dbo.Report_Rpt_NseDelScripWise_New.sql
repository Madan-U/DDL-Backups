-- Object: PROCEDURE dbo.Report_Rpt_NseDelScripWise_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/*
exec Report_Rpt_NseDelScripWise_New 'broker','broker','2005085','n','%','HDFCBANK','EQ' 
*/
CREATE Proc Report_Rpt_NseDelScripWise_New (@StatusId Varchar(15), @StatusName Varchar(25),@Sett_no Varchar(7), @sett_Type Varchar(2),@Party_Code Varchar(10),  
@Scrip_Cd Varchar(12), @Series Varchar(3)) As   
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = BuyQty, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) ,  
SellTradeQty = SellQty , SellRecQty=Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End) ,  
BuyShortage = (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) > 0   
          Then BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End)  
          Else 0 End )   
 + (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) < 0 Then   
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End),  
SellShortage = (Case When (SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) > 0 Then   
  Abs(SellQty - Sum(Case When DrCr = 'C' Then isnull(De.qty,0) Else 0 End)) Else 0 End) +  
  (Case When BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End) < 0   
           Then Abs(BuyQty - Sum(Case When DrCr = 'D' Then isnull(De.qty,0) Else 0 End))  
          Else 0 End )  
from Client2_Report C2,Client1_Report C1, 
(
	Select Sett_no,Sett_Type,scrip_cd,series,Party_code,  
	BuyQty=Sum(Case When Inout = 'O' Then Qty Else 0 End),  
	SellQty=Sum(Case When Inout = 'I' Then Qty Else 0 End)  
	from DeliveryClt_Report 
	where sett_no = @sett_no
	and sett_type = @sett_type  
	Group BY Sett_no,Sett_Type,scrip_cd,series,Party_code  
)
 d Left Outer Join Deltrans_Report de   
On ( de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd  
and de.series = d.series and de.party_code = d.party_code and filler2 = 1 )  
Where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And D.Sett_no = @Sett_No And D.Sett_type = @Sett_Type  
And Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)  
And Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)  
And Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)  
And Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)  
And D.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)  
And D.Party_Code Like @Party_Code   
And D.Scrip_Cd Like @Scrip_Cd   
And D.Series Like @Series  
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series,d.BuyQty,SellQty  
  
Union All  
  
select d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.Scrip_cd,d.Series,  
BuyTradeQty = 0, BuyRecQty=Sum(Case When DrCr = 'D' Then isnull(d.qty,0) Else 0 End) ,  
SellTradeQty = 0, SellRecQty=Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) ,  
BuyShortage = (Case When Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) > 0 Then  
  Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) Else 0 End),  
SellShortage = (Case When Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) > 0 Then  
  Sum(Case When DrCr = 'D' Then isnull(D.qty,0) Else 0 End) - Sum(Case When DrCr = 'C' Then isnull(D.qty,0) Else 0 End) Else 0 End)  
from Client2_Report C2,Client1_Report C1, Deltrans_Report d   
Where D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And D.Sett_no = @Sett_No And D.Sett_type = @Sett_Type  
And Filler2 = 1 And TrType <> 906 And D.Party_Code Not in ( Select Party_Code From DeliveryClt_Report DE   
Where de.sett_no = d.sett_no and de.sett_type = d.sett_type and de.scrip_cd = d.scrip_cd  
and de.series = d.series and de.party_code = d.party_code )  
And Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)  
And Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)  
And Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)  
And Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)  
And D.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)  
And D.Party_Code Like @Party_Code   
And D.Scrip_Cd Like @Scrip_Cd   
And D.Series Like @Series  
group by d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,d.scrip_cd,d.series  
Order BY d.sett_no,d.sett_type,d.Party_Code,c1.Short_Name,D.scrip_cd,d.series

GO
