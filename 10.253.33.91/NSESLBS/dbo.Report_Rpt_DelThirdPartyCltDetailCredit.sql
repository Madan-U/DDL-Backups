-- Object: PROCEDURE dbo.Report_Rpt_DelThirdPartyCltDetailCredit
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE proc Report_Rpt_DelThirdPartyCltDetailCredit (  
@StatusId Varchar(10),  
@Statusname Varchar(25),  
@PartyCode varchar(10),   
@settType varchar(2),  
@SettNo varchar(7)) As  
if @StatusId = 'broker'  
Begin   
select Party_code,Sett_no,sett_Type,Scrip_cd,Series,DpId,CltDpId,Qty=Sum(Qty),Cl_Rate,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid   
where reclearedpost > 0  
and  party_code = @PartyCode  
and sett_type = @settType and sett_no = @SettNo  
group by Party_code,Sett_no,sett_Type,Scrip_cd,Series,Cl_Rate,DpId,CltDpId    
end  
if @StatusId = 'branch'  
Begin   
select d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,DpId,CltDpId,Qty=Sum(Qty),Cl_Rate,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where reclearedpost > 0   
And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code   
And C1.Branch_Cd Like @StatusName  
And D.Party_code = @PartyCode  
and sett_type = @settType and sett_no = @SettNo  
group by d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,Cl_Rate,DpId,CltDpId    
end  
if @StatusId = 'subbroker'  
Begin   
select d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,DpId,CltDpId,Qty=Sum(Qty),Cl_Rate,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where reclearedpost > 0 And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code And C1.sub_broker Like @StatusName  
And D.Party_code = @PartyCode  
and sett_type = @settType and sett_no = @SettNo  
group by d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,Cl_Rate,DpId,CltDpId    
end  
if @StatusId = 'trader'  
Begin   
select d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,DpId,CltDpId,Qty=Sum(Qty),Cl_Rate,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where reclearedpost > 0 And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code And C1.Trader Like @StatusName  
And D.Party_code = @PartyCode  
and sett_type = @settType and sett_no = @SettNo  
group by d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,Cl_Rate,DpId,CltDpId    
end  
if @StatusId = 'client'  
Begin   
select Party_code,Sett_no,sett_Type,Scrip_cd,Series,DpId,CltDpId,Qty=Sum(Qty),Cl_Rate,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid   
where reclearedpost > 0  
and  party_code = @PartyCode  
and sett_type = @settType and sett_no = @SettNo  
group by Party_code,Sett_no,sett_Type,Scrip_cd,Series,Cl_Rate,DpId,CltDpId    
end  
if @StatusId = 'family'  
Begin   
select d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,DpId,CltDpId,Qty=Sum(Qty),Cl_Rate,Amount=Sum(Qty*Cl_Rate)   
from delthirdpartycltid D, Client1_Report C1, Client2_Report C2  
where reclearedpost > 0 And C1.Cl_Code = C2.Cl_Code   
And C2.Party_Code = D.Party_Code And C1.Family Like @StatusName  
And D.Party_code = @PartyCode  
and sett_type = @settType and sett_no = @SettNo  
group by d.Party_code,Sett_no,sett_Type,Scrip_cd,Series,Cl_Rate,DpId,CltDpId    
end

GO
