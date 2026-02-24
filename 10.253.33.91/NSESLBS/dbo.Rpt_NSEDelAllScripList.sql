-- Object: PROCEDURE dbo.Rpt_NSEDelAllScripList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NSEDelAllScripList (      
@StatusId Varchar(15),@StatusName Varchar(25),@Party_Code Varchar(10))      
as       
Set Transaction Isolation level read uncommitted      
   
select distinct d.scrip_cd,d.series,  
Qty=0  
from DeliveryClt D, Client2 C2, Client1 C1      
where D.Party_Code = @Party_Code      
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
Group by d.scrip_cd,d.series   
order by d.scrip_cd

GO
