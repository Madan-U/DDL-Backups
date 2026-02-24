-- Object: PROCEDURE dbo.Report_Rpt_NseDelSettPosParty
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE Proc Report_Rpt_NseDelSettPosParty 
(@StatusId Varchar(15),@StatusName Varchar(25),@SettNo Varchar(7),@Sett_Type Varchar(2))
As
if @statusid = 'broker'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2 Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End
if @statusid = 'branch'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2,branches br  
Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
and br.short_name = c1.trader and br.branch_cd = @statusname
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End
if @statusid = 'subbroker'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2, subbrokers sb  
Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End
if @statusid = 'trader'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2 Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
and c1.trader = @statusname
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End
if @statusid = 'client'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2 Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
and c2.party_code = @statusname
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End
if @statusid = 'family'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2 Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
and c1.family = @statusname
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End
if @statusid = 'region'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2 Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
and c1.region = @statusname
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End
if @statusid = 'area'
begin
select D.Party_Code,C1.Long_Name,ScripName=S1.Short_Name,D.Scrip_Cd,D.Series,ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end ) 
from DeliveryClt_Report D, Client2_Report C2, Client1_Report C1, Scrip1 S1, Scrip2 S2 Where sett_no = @SettNo and sett_type = @Sett_Type 
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code And Qty > 0 
And S1.Co_Code = S2.Co_Code and S2.Scrip_Cd = D.Scrip_cd and S1.series = s2.series and D.series = s2.series
and c1.area = @statusname
Order By D.Party_Code,C1.Long_Name,S1.Short_Name
End

GO
