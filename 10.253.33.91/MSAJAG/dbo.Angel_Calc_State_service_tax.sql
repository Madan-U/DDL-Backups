-- Object: PROCEDURE dbo.Angel_Calc_State_service_tax
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure Angel_Calc_State_service_tax(@tdate as varchar(11))      
as      
set nocount on      
 set @tdate=convert(datetime,@tdate,103)     
declare @fdate as varchar(25),@xdate as varchar(25)      
set @fdate = @tdate+' 23:59:59'      
set @xdate = @tdate+' 00:00:00'      
      
select * into #tax from intranet.risk.dbo.tax_rate       
      
      
set transaction isolation level read uncommitted      
select party_Code,      
Brokerage_Realised=sum(PBrokTrd+SBrokTrd),      
Delivery_Brokerage=sum(PBrokDel+SBrokDel)      
,Grossservice_tax=sum(a.service_tax)       
,service_tax=sum(a.service_tax*convert(money,c.service_tax)/convert(money,c.gross_service_tax))      
,Cess_tax=sum((a.service_tax*convert(money,c.service_tax)/convert(money,c.gross_service_tax))*convert(money,c.cess_tax)/100)       
,Edu_tax=sum((a.service_tax*convert(money,c.service_tax)/convert(money,c.gross_service_tax))*convert(money,c.Education_cess_tax)/100)  ,
turn_tax=sum(turn_tax)      
into #file1      
from cmbillvalan a (nolock) left outer join  #tax c       
on a.sauda_date between Year_start_date and Year_end_date       
where sauda_date >= @xdate and sauda_date <= @fdate      
group by party_Code      
      
select l_state,      
Brokerage_Realised=sum(Brokerage_Realised),      
Delivery_Brokerage=sum(Delivery_Brokerage),      
Grossservice_tax=sum(Grossservice_tax),      
service_tax=sum(service_tax),      
Cess_tax=sum(Cess_tax),      
Edu_tax=sum(Edu_tax),
turn_tax=sum(turn_tax)       
--,tmonth= datepart(mm,@fdate),tyear= datepart(yy,@fdate)      
into #file2      
from #file1 a left outer join intranet.risk.dbo.client_details b on a.party_code=b.party_code       
group by l_state order by l_state      
      
delete from Angel_service_tax1  where sauda_date >= @xdate and sauda_date <= @fdate                     
      
      
insert into Angel_service_tax1        
(l_state,Brokerage_Realised,Delivery_Brokerage,Grossservice_tax,service_tax,Cess_tax,Edu_tax,segment,sauda_date,
turn_tax)      
select       
l_state,Brokerage_Realised,Delivery_Brokerage,Grossservice_tax,service_tax,Cess_tax,Edu_tax,segment='NSECM',sauda_date=@xdate,
turn_tax      
from #file2      
      
set nocount off

GO
