-- Object: PROCEDURE dbo.Sebiinspection_SCFM_Consolidation
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Proc [dbo].[Sebiinspection_SCFM_Consolidation]              
as              
SEt Nocount on              
set transaction isolation level read uncommitted
              
declare @tdate as varchar(11)              

select @tdate =convert(varchar(11),max(processdate))  from Sebiinspection_SCFM_ClientData with (nolock)               
            
select @tdate as ProcessDate,               
party_code,sum(Balance) as Balance,      
sum(UnrecoAmt) as UnrecoAmt,      
sum(MArginAmt) as MArginAmt,      
sum(NETAMT) as NETAMT,  
SUM(Case when NETAMT < 0 then NETAMT else 0 end) as DebitorsBal,         
sum(CreditorsBal) as CreditorsBal,              
sum(Case when abs(MArginAmt) > CreditorsBal then CreditorsBal else abs(MArginAmt) end) as MC              
into #file1              
from              
(              
select @tdate as ProcessDate,party_code,sum(Balance) as Balance,  
sum(UnrecoBal) as UnrecoAmt,sum(MArginAmt) as MArginAmt,              
sum(Balance+UnrecoBal) as NETAMT,              
(Case when sum(Balance+UnrecoBal) > 0 then sum(Balance+UnrecoBal) else 0 end) as CreditorsBal              
from Sebiinspection_SCFM_ClientData with (nolock) where ProcessDate >=@tdate  and ProcessDate <=@tdate +' 23:59:59'              
group by party_code      
) x               
group by party_code      
  
delete from Sebiinspection_SCFM_ClientGroup where  ProcessDate=@tdate 
  
insert into Sebiinspection_SCFM_ClientGroup( ProcessDate,party_code,Balance,UnrecoAmt,MArginAmt,NETAMT,CreditorsBal,MC,DebitorsBal,Entity)  
select  ProcessDate,party_code,Balance,UnrecoAmt,MArginAmt,NETAMT,CreditorsBal,MC,DebitorsBal,Entity='Equity'  from #file1  
  
              
select               
processDate,              
convert(money,SUM(NETAMT)/10000000.00) as NETAMT,              
convert(money,SUM(Case when NETAMT < 0 then NETAMT else 0 end)/10000000.00) as DrBal,              
convert(money,SUM(MarginAmt)/10000000.00) as MarginAmt,              
convert(money,sum(CreditorsBal)/10000000.00) as CreditorsBal,              
convert(money,SUM(MC)/10000000.00) as MC              
into #file2              
from #file1              
group by  processDate              

delete from Sebiinspection_SCFM_Consolidated where  ProcessDate=@tdate 
              
insert into Sebiinspection_SCFM_Consolidated 
select * from #file2  
    

SEt Nocount off

GO
