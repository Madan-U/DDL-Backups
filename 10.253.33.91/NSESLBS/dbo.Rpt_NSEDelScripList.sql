-- Object: PROCEDURE dbo.Rpt_NSEDelScripList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NSEDelScripList (  
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Scrip_Cd Varchar(12),@Series Varchar(3))  
as   
select distinct d.scrip_cd,d.series,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End) 
from DeliveryClt D, Client2 C2, Client1 C1  
where d.sett_no like @settno and d.sett_type like @Sett_Type 
and d.scrip_cd like @Scrip_Cd and d.series like @Series  
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code
And @StatusName = 
	  (case 
	        when @StatusId = 'BRANCH' then c1.branch_cd
	        when @StatusId = 'SUBBROKER' then c1.sub_broker
	        when @StatusId = 'Trader' then c1.Trader
	        when @StatusId = 'Family' then c1.Family
	        when @StatusId = 'Area' then c1.Area
	        when @StatusId = 'Region' then c1.Region
	        when @StatusId = 'Client' then c2.party_code
	  else 
	        'BROKER'
	  End)     
Group by d.scrip_cd,d.series order by d.scrip_cd

GO
