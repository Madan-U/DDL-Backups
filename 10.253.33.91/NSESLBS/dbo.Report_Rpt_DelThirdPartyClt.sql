-- Object: PROCEDURE dbo.Report_Rpt_DelThirdPartyClt
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE proc Report_Rpt_DelThirdPartyClt (  
@StatusId Varchar(10),  
@Statusname Varchar(25),  
@fromParty varchar(10),   
@toParty varchar(10) ) As  
if @StatusId = 'broker'  
Begin   
select Party_code,Sett_no,sett_Type,Amount=Sum(Qty*Cl_Rate) from delthirdpartycltid   
where unclearedpost > 0  
and  party_code between @fromParty and @toParty  
group by Party_code,Sett_no,sett_Type   
end  
if @StatusId = 'branch'  
Begin   
select D.Party_code,Sett_no,sett_Type,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where unclearedpost > 0 And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code And C1.Branch_Cd Like @StatusName  
And D.Party_code between @fromParty and @toParty  
group by D.Party_code,Sett_no,sett_Type   
end  
if @StatusId = 'subbroker'  
Begin   
select D.Party_code,Sett_no,sett_Type,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where unclearedpost > 0 And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code And C1.sub_broker Like @StatusName  
And D.Party_code between @fromParty and @toParty  
group by D.Party_code,Sett_no,sett_Type   
end  
if @StatusId = 'trader'  
Begin   
select D.Party_code,Sett_no,sett_Type,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where unclearedpost > 0 And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code And C1.Trader Like @StatusName  
And D.Party_code between @fromParty and @toParty  
group by D.Party_code,Sett_no,sett_Type   
end  
if @StatusId = 'client'  
Begin   
select Party_code,Sett_no,sett_Type,Amount=Sum(Qty*Cl_Rate) from delthirdpartycltid   
where unclearedpost > 0  
and party_code between @fromParty and @toParty  
group by Party_code,Sett_no,sett_Type   
end  
if @StatusId = 'family'  
Begin   
select D.Party_code,Sett_no,sett_Type,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where unclearedpost > 0 And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code And C1.Family Like @StatusName  
And D.Party_code between @fromParty and @toParty  
group by D.Party_code,Sett_no,sett_Type   
end

GO
