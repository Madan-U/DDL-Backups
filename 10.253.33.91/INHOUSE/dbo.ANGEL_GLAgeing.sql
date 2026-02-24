-- Object: PROCEDURE dbo.ANGEL_GLAgeing
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure [dbo].[ANGEL_GLAgeing]        
(        
@GLcodefrom as varchar(10),@GLcodeto as varchar(10),        
@fromdate as varchar(11),@todate as varchar(11)        
)        
as        
        
set nocount on        
        
declare @fdate as datetime,@tdate as datetime        
set @fdate=convert(datetime,@fromdate+' 00:00')        
set @tdate=convert(datetime,@todate+' 23:59')        
        
        
select cltcode,value=sum(Case when drcr='D' then vamt else -vamt end),        
Bal0to30=convert(money,0),        
Bal31to60=convert(money,0),        
Bal61to90=convert(money,0),        
Bal90to180=convert(money,0),        
Bal181to360=convert(money,0),        
Bal361above=convert(money,0)        
into #ageing        
from Account.dbo.ledger where vdt >=@fdate and vdt <=@tdate        
and cltcode >=@GLcodefrom and cltcode <=@GLcodeto        
group by cltcode        
        
        
        
select cltcode,vdt=convert(datetime,convert(varchar(11),vdt)),        
value=sum(Case when drcr='D' then vamt else -vamt end)        
into #file1        
from Account.dbo.ledger (nolock)where vdt >=@fdate and vdt <=@tdate        
and cltcode >=@GLcodefrom and cltcode <=@GLcodeto        
group by cltcode,convert(datetime,convert(varchar(11),vdt))        
        
--print @tdate-30        
update #ageing set Bal0to30=b.bal30days from        
(select cltcode,Bal30days=sum(value) from #file1 where Vdt <= @tdate and vdt >=@tdate-30        
group by cltcode) b where #ageing.cltcode=b.cltcode        
        
        
update #ageing set Bal31to60=b.bal60days from        
(select cltcode,Bal60days=sum(value) from #file1 where Vdt <= @tdate-30 and vdt >=@tdate-60        
group by cltcode) b where #ageing.cltcode=b.cltcode        
        
        
update #ageing set Bal61to90=b.bal90days from        
(select cltcode,Bal90days=sum(value) from #file1 where Vdt <= @tdate-60 and vdt >=@tdate-90        
group by cltcode) b where #ageing.cltcode=b.cltcode        
        
        
update #ageing set Bal90to180=b.bal180days from        
(select cltcode,Bal180days=sum(value) from #file1 where Vdt <= @tdate-90 and vdt >=@tdate-180        
group by cltcode) b where #ageing.cltcode=b.cltcode        
        
        
update #ageing set Bal181to360=b.bal360days from        
(select cltcode,Bal360days=sum(value) from #file1 where Vdt <= @tdate-180 and vdt >=@tdate-360        
group by cltcode) b where #ageing.cltcode=b.cltcode        
        
        
update #ageing set Bal361above=b.bal361days from        
(select cltcode,Bal361days=sum(value) from #file1 where Vdt <= @tdate-360         
group by cltcode) b where #ageing.cltcode=b.cltcode        
        
      
update #ageing set bal0to30=0 where value < 0 and bal0to30 > 0      
update #ageing set bal31to60=0 where value < 0 and bal0to30 <=0 and bal31to60 > 0      
update #ageing set bal61to90=0 where value < 0 and (bal0to30+BAL31TO60) <=0 and bal61to90 > 0      
update #ageing set bal90to180=0 where value < 0 and (bal0to30+BAL31TO60+BAL61TO90) <=0 and bal90to180 > 0      
update #ageing set bal181to360=0 where value < 0 and (bal0to30+BAL31TO60+BAL61TO90+BAL90TO180) <=0 and bal181to360 > 0      
update #ageing set bal361above=0 where value < 0 and (bal0to30+BAL31TO60+BAL61TO90+BAL90TO180+bal181to360) <=0 and bal361above > 0      
      
update #ageing set bal0to30=value,bal31to60=0,bal61to90=0,bal90to180=0,bal181to360=0,bal361above=0      
where value < 0 and bal0to30 < value      
      
update #ageing set bal31to60=(value-bal0to30),bal61to90=0,bal90to180=0,bal181to360=0,bal361above=0      
where value < 0 and (bal0to30+bal31to60) < value       
      
update #ageing set bal61to90=(value-bal0to30-bal31to60),bal90to180=0,bal181to360=0,bal361above=0      
where value < 0 and (bal0to30+bal31to60+bal61to90) < value       
      
update #ageing set bal90to180=(value-bal0to30-bal31to60-BAL61TO90),bal181to360=0,bal361above=0      
where value < 0 and (bal0to30+bal31to60+bal61to90+BAL90TO180) < value       
      
update #ageing set bal181to360=(value-bal0to30-bal31to60-BAL61TO90-BAL90TO180),bal361above=0      
where value < 0 and (bal0to30+bal31to60+bal61to90+BAL90TO180+BAL181TO360) < value       
      
update #ageing set bal361above=(value-bal0to30-bal31to60-BAL61TO90-BAL90TO180-bal181to360)      
where value < 0 and (bal0to30+bal31to60+bal61to90+BAL90TO180+BAL181TO360) < value       
      
------------------- Debit Balance      
      
update #ageing set bal0to30=0 where value > 0 and bal0to30 < 0      
update #ageing set bal31to60=0 where value > 0 and bal31to60 < 0      
update #ageing set bal61to90=0 where value > 0 and bal61to90 < 0      
update #ageing set bal90to180=0 where value > 0 and bal90to180 < 0      
update #ageing set bal181to360=0 where value > 0 and bal181to360 < 0      
update #ageing set bal361above=0 where value > 0 and bal361above < 0      
      
      
      
update #ageing set bal0to30=value,bal31to60=0,bal61to90=0,bal90to180=0,bal181to360=0,bal361above=0      
where value > 0 and bal0to30 >= value and bal0to30 > 0      
      
update #ageing set bal31to60=(value-bal0to30),bal61to90=0,bal90to180=0,bal181to360=0,bal361above=0      
where value > 0 and bal0to30+bal31to60 >= value and bal31to60 > 0      
      
update #ageing set bal61to90=(value-bal0to30-bal31to60),bal90to180=0,bal181to360=0,bal361above=0      
where value > 0 and (bal0to30+bal31to60+bal61to90) >= value and bal61to90 > 0      
      
update #ageing set bal90to180=(value-bal0to30-bal31to60-BAL61TO90),bal181to360=0,bal361above=0      
where value > 0 and (bal0to30+bal31to60+bal61to90+BAL90TO180) >= value and bal90to180 > 0      
      
      
update #ageing set bal181to360=(value-bal0to30-bal31to60-BAL61TO90-BAL90TO180),bal361above=0      
where value > 0 and (bal0to30+bal31to60+bal61to90+BAL90TO180+BAL181TO360) >= value       
and bal181to360 > 0      
      
update #ageing set bal361above=(value-bal0to30-bal31to60-BAL61TO90-BAL90TO180-bal181to360)      
where value > 0 and (bal0to30+bal31to60+bal61to90+BAL90TO180+BAL181TO360+bal361above) >= value       
and bal361above > 0      
      
      
      
select x.*,SBcode=isnull(y.sbcode,'') from        
(select a.*,acname,branchcode from #ageing a, acmast b (nolock) where a.cltcode=b.cltcode) x        
left outer join         
(select top 1 * from mis.remisior.dbo.remi_ledcode where coname='ACDLCM' ) y         
on x.cltcode=y.ledgercode        
          
        
      
        
set nocount off

GO
