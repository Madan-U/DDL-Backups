-- Object: PROCEDURE dbo.rpt_netBalancesTBDetailsAllS
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--*************************************************************  
create proc rpt_netBalancesTBDetailsAllS  
@fromdt varchar(11),      
@todt varchar(11),      
@Grpcode varchar(11),      
@statusid varchar(15),      
@statusname varchar(25)      
      
as  
  
Select cltcode, acname, sum(Amount) Amount, sum(DrAmount) DrAmount, sum(CrAmount) CrAmount  
from (     
Select l.cltcode, l.acname, Amount= isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),      
DrAmount= isnull(sum(case when drcr = 'd' then vamt else 0 end),0),      
CrAmount= isnull(sum(case when drcr = 'c' then vamt else 0 end),0)    
from ledger l, acmast a      
where l.cltcode = a.cltcode and substring(a.grpcode,1,len(rtrim(@grpcode))) = rtrim(@grpcode)       
and a.grpcode = substring(a.grpcode,1,len(rtrim(@grpcode)))+ right('0000000000',11-(len(rtrim(@grpcode))))    
and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'      
and a.accat<>'4'      
group by l.cltcode,l.acname      
having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0      
  
union  
  
Select l.cltcode, l.acname, Amount= isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),      
DrAmount= isnull(sum(case when drcr = 'd' then vamt else 0 end),0),      
CrAmount= isnull(sum(case when drcr = 'c' then vamt else 0 end),0)    
from accountbse.dbo.ledger l, accountbse.dbo.acmast a      
where l.cltcode = a.cltcode and substring(a.grpcode,1,len(rtrim(@grpcode))) = rtrim(@grpcode)       
and a.grpcode = substring(a.grpcode,1,len(rtrim(@grpcode)))+ right('0000000000',11-(len(rtrim(@grpcode))))    
and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'      
and a.accat<>'4'      
group by l.cltcode,l.acname      
having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0      
  
union  
  
Select l.cltcode, l.acname, Amount= isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),      
DrAmount= isnull(sum(case when drcr = 'd' then vamt else 0 end),0),      
CrAmount= isnull(sum(case when drcr = 'c' then vamt else 0 end),0)    
from accountfo.dbo.ledger l, accountfo.dbo.acmast a      
where l.cltcode = a.cltcode and substring(a.grpcode,1,len(rtrim(@grpcode))) = rtrim(@grpcode)       
and a.grpcode = substring(a.grpcode,1,len(rtrim(@grpcode)))+ right('0000000000',11-(len(rtrim(@grpcode))))    
and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'      
and a.accat<>'4'      
group by l.cltcode,l.acname      
having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0      
) z  
group by cltcode, acname  
order by cltcode, acname

GO
