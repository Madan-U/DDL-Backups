-- Object: PROCEDURE dbo.Report_Rpt_DelDirectPayin
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE proc Report_Rpt_DelDirectPayin
(@StatusId Varchar(15), @Statusname varchar(25), @Sett_No Varchar(7), @Sett_Type varchar(2))
As
select D.Party_code,PartyName=Long_Name,D.scrip_cd,Scripname=S2.Scrip_Cd,D.Isin,Qty=SellQty,dpid,Cltdpid,TransNo 
from DelBseDirectPI D, 
Client2_Report C2 , Client1_Report c1, Scrip2 S2 
where sett_no like @Sett_No and sett_type like @Sett_Type
And C2.Cl_Code = C1.Cl_Code And C2.Party_code = D.Party_Code And S2.Scrip_Cd = D.Scrip_Cd And S2.Series = D.Series 
And C1.Branch_Cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)
And C2.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)
Order By Long_Name,S2.Scrip_Cd

GO
