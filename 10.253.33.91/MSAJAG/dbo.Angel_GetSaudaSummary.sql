-- Object: PROCEDURE dbo.Angel_GetSaudaSummary
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_GetSaudaSummary(@fromdate as varchar(11),@todate as varchar(11))      
as          
set nocount on        
/*  
declare @fromdate as varchar(11),@todate as varchar(11)        
set @fromdate = '08/01/2008'  
set @todate = '08/15/2008'  
*/  
  
        
declare @fromsett as varchar(10),@tosett as varchar(10)        
select @fromsett=min(sett_no) from sett_mst where start_date >=@fromdate and sett_type='N'        
select @tosett=max(sett_no) from sett_mst where start_date <=@todate and sett_type='N'        
print @fromsett  
print @tosett  
  
select cl_Code=party_Code into #pcode from Angel_NSECM_ECN_Client    
  
--select cl_code into #pcode from anand1.msajag.dbo.client_brok_details where exchange='NSE' and segment='CAPITAL' and print_options=2        
--delete from Angel_Sauda_summary where party_code in (select cl_code from #pcode)      
--and sauda_Date>=@fromdate and sauda_Date<=@todate       


--delete from Angel_Sauda_summary where sauda_DAte <= convert(datetime,@fromdate)-31  

/*      
set transaction isolation level read uncommitted            
insert into Angel_Sauda_summary      
select sett_No,SEtt_type,Party_code,Party_name,SAuda_Date,SCrip_cd,series,        
Bqty=sum(Pqtytrd+pqtydel),BAvgRt=(case when sum(Pqtytrd+pqtydel) > 0 then sum(pamttrd+pamtdel)/sum(Pqtytrd+pqtydel) else 0 end),BAmt=sum(pamttrd+pamtdel),        
Sqty=sum(Sqtytrd+Sqtydel),SAvgRt=(case when sum(Sqtytrd+Sqtydel) > 0 then sum(Samttrd+Samtdel)/sum(Sqtytrd+Sqtydel) else 0 end),SAmt=sum(Samttrd+Samtdel),        
Nqty=sum((Pqtytrd+pqtydel)-(Sqtytrd+Sqtydel)),      
NAvgRt=(case when sum((Pqtytrd+pqtydel)-(Sqtytrd+Sqtydel)) <> 0 then sum((Samttrd+Samtdel)-(Pamttrd+Pamtdel))/sum((Pqtytrd+pqtydel)-(Sqtytrd+Sqtydel)) else 0 end),NAmt=sum((Samttrd+Samtdel)-(Pamttrd+Pamtdel))          
--into Angel_sauda_summary      
from cmbillvalan (nolock) where sett_no >=@fromsett and sett_no <= @tosett         
and Tradetype not in( 'SBF','SCF','IBF','ICF','IR' )        
and party_code in (select cl_code from #pcode)        
and sett_Type in ('N','W')        
--and Pqtytrd+Sqtytrd > 0      
group by sett_No,SEtt_type,Party_code,Party_name,SAuda_Date,SCrip_cd,series        
*/      
      
select top 0 * into #file1 from Angel_Sauda_summary        
      
set transaction isolation level read uncommitted            
insert into #file1      
select sett_No,SEtt_type,Party_code,Party_name,SAuda_Date,SCrip_cd,series,        
Bqty=sum(Pqtytrd),BAvgRt=(case when sum(Pqtytrd) > 0 then sum(pamttrd)/sum(Pqtytrd) else 0 end),BAmt=sum(pamttrd),        
Sqty=sum(Sqtytrd),SAvgRt=(case when sum(Sqtytrd) > 0 then sum(Samttrd)/sum(Sqtytrd) else 0 end),SAmt=sum(Samttrd),        
Nqty=sum((Pqtytrd)-(Sqtytrd)),      
NAvgRt=(case when sum((Pqtytrd)-(Sqtytrd)) <> 0 then sum((Samttrd)-(Pamttrd))/sum((Pqtytrd)-(Sqtytrd)) else 0 end),NAmt=sum((Samttrd)-(Pamttrd)),'T',
Total_Levies=Sum(SerInEx+Service_Tax+ExService_Tax+Turn_Tax+Sebi_Tax+Ins_Chrg+Broker_Chrg+Other_Chrg)
          
--into Angel_sauda_summary      
from cmbillvalan (nolock) where sett_no >=@fromsett and sett_no <= @tosett         
and Tradetype not in( 'SBF','SCF','IBF','ICF','IR' )        
and party_code in (select cl_code from #pcode)        
and sett_Type in ('N','W')        
and Pqtytrd+Sqtytrd > 0      
group by sett_No,SEtt_type,Party_code,Party_name,SAuda_Date,SCrip_cd,series        
      
set transaction isolation level read uncommitted            
insert into #file1      
select sett_No,SEtt_type,Party_code,Party_name,SAuda_Date,SCrip_cd,series,        
Bqty=sum(Pqtydel),BAvgRt=(case when sum(Pqtydel) > 0 then sum(pamtdel)/sum(Pqtydel) else 0 end),BAmt=sum(pamtdel),        
Sqty=sum(Sqtydel),SAvgRt=(case when sum(Sqtydel) > 0 then sum(Samtdel)/sum(Sqtydel) else 0 end),SAmt=sum(Samtdel),        
Nqty=sum((Pqtydel)-(Sqtydel)),      
NAvgRt=(case when sum((Pqtydel)-(Sqtydel)) <> 0 then sum((Samtdel)-(Pamtdel))/sum((Pqtydel)-(Sqtydel)) else 0 end),NAmt=sum((Samtdel)-(Pamtdel)),'D',          
Total_Levies=Sum(SerInEx+Service_Tax+ExService_Tax+Turn_Tax+Sebi_Tax+Ins_Chrg+Broker_Chrg+Other_Chrg)

--into Angel_sauda_summary      
from cmbillvalan (nolock) where sett_no >=@fromsett and sett_no <= @tosett         
and Tradetype not in( 'SBF','SCF','IBF','ICF','IR' )        
and party_code in (select cl_code from #pcode)        
and sett_Type in ('N','W')        
and Pqtydel+Sqtydel > 0      
group by sett_No,SEtt_type,Party_code,Party_name,SAuda_Date,SCrip_cd,series        


update #file1  set Total_levies=0 from 
(select * from #file1 (nolock) where trdType='D') b
where #file1.party_code=b.party_code and #file1.scrip_Cd=b.scrip_Cd 
and #file1.sett_no=b.sett_no and #file1.sett_type=b.sett_Type
and #file1.trdType='T'

update #file1 set Total_levies=#file1.Total_levies+b.Total_levies from 
(select * from #file1 where bqty+sqty = 0 and total_levies > 0 and trdtype='D') b
where #file1.party_code=b.party_code 
and #file1.scrip_Cd=b.scrip_Cd 
and #file1.sett_no=b.sett_no 
and #file1.sett_type=b.sett_Type  
and #file1.bqty+#file1.sqty > 0  and #file1.trdtype='T'

update #file1 set total_levies=0 where bqty+sqty = 0 and total_levies > 0 and trdtype='D'
delete from #file1 where bqty+sqty = 0 and total_levies = 0 and trdtype='D'
delete from #file1 where bqty+sqty = 0 and total_levies = 0 and trdtype='T'

delete from Angel_Sauda_summary where sauda_date <= convert(datetime,@fromdate)-31    
delete from Angel_Sauda_summary where sauda_date >= @fromdate+' 00:00:00' and sauda_date <= @todate+' 23:59:59'
insert into Angel_Sauda_summary select * from #file1               
      
        
set nocount off

GO
