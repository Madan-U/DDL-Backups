-- Object: PROCEDURE dbo.angel_getledger_cost4
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





CREATE procedure [dbo].[angel_getledger_cost4](@cltcode as varchar(25),@fdate as varchar(11),@tdate as varchar(11), @segment as varchar(10))      
as  

set transaction isolation level read uncommitted      
set nocount on      

 /*  
drop table #abl_cost_a  
drop table #file1
drop table #abl_cost
drop table #temp1
drop table #tempa
declare @cltcode as varchar(11),@fdate as varchar(11),@tdate as varchar(11),@segment as varchar(10)      
set @cltcode='26100010'      
set @fdate='Aug 01 2007'      
set @tdate='Aug 30 2007'      
set @segment='NSECM'
*/

set transaction isolation level read uncommitted      

select a.*,camt=isnull(b.camt,0),costname=isnull(b.costname,' - ')      
into #abl_cost_a      
from       
(select * from ledger where cltcode=@cltcode and vdt>=@fdate+' 00:00:00' and vdt <=@tdate+' 23:59:59'      
) a left outer join      
(select camt=(case when drcr='D' then l2.camt else -l2.camt end),l2.cltcode,l2.vno,l2.vtype,l2.lno,costname=isnull(costname,'')       
from ledger2 l2 (nolock)      
left outer join costmast cm (nolock)      
on l2.costcode=cm.costcode) b       
on a.vno=b.vno and a.lno=b.lno and a.vtyp=b.vtype and a.cltcode=b.cltcode      


--select * from #abl_cost_a    


set transaction isolation level read uncommitted    
select cltcode,vno,vtyp,vamt=(case when drcr='D' then vamt else -vamt end),acname    
into #file1    
from ledger (nolock)    
where vdt>=@fdate+' 00:00:00' and vdt <=@tdate+' 23:59:59'    
and (cltcode like '28%' or cltcode like '21%' or cltcode like '27%')     
and vno in (select vno from #abl_cost_a) and vtyp<>18    


set transaction isolation level read uncommitted    

select a.*,alt_cltcode=isnull(b.cltcode,''),alt_acname=isnull(b.acname,''),alt_vamt=isnull(b.vamt,0)    
into #abl_cost    
from #abl_cost_a a left outer join #file1 b on a.vno=b.vno and a.vtyp=b.vtyp     

    


set transaction isolation level read uncommitted     

select n.vdt,vtyp=isnull(v.ShortDesc,''),n.vno,n.narration as [narr],       
Debit=(case when drcr = 'D' then n.vamt else 0 end),Credit=abs(case when drcr = 'C' then -n.vamt else 0 end),       
balamt=convert(money,0.00),n.camt,n.costname,n.lno,alt_cltcode,alt_acname,alt_vamt    
into #temp1  
from #abl_cost n left outer join       
vmast v (nolock) on vtyp=vtype      

  
delete from #temp1 where credit <= 0  


select vdt,vtyp,vno,credit,costname,alt_cltcode,alt_acname,alt_vamt,  
narration=  
(CASE 
WHEN NARR LIKE 'TDS on remisier share of%' THEN  
SUBSTRING(replace(narr,'TDS on remisier share of ',''),1,CHARINDEX(' ',replace(narr,'TDS on remisier share of ',''),1))   

WHEN NARR LIKE 'TDS on share of%' THEN  
SUBSTRING(replace(narr,'TDS on share of ',''),1,CHARINDEX(' ',replace(narr,'TDS on share of ',''),1))  

WHEN NARR LIKE 'Being TDS on share of%' THEN  
SUBSTRING(replace(narr,'Being TDS on share of ',''),1,CHARINDEX(' ',replace(narr,'Being TDS on share of ',''),1))  
ELSE  
NARR  
END  
)
into #tempa  
from #temp1  
where alt_vamt < 0  
  

insert into #tempa  
select vdt,vtyp,vno,credit,costname,alt_cltcode,alt_acname,alt_vamt,  
narration=  
(CASE 
WHEN NARR LIKE 'TDS on remisier share of%' THEN  
SUBSTRING(replace(narr,'TDS on remisier share of ',''),1,CHARINDEX(' ',replace(narr,'TDS on remisier share of ',''),1))   

WHEN NARR LIKE 'TDS on share of%' THEN  
SUBSTRING(replace(narr,'TDS on share of ',''),1,CHARINDEX(' ',replace(narr,'TDS on share of ',''),1))  

WHEN NARR LIKE 'Being TDS on share of%' THEN  
SUBSTRING(replace(narr,'Being TDS on share of ',''),1,CHARINDEX(' ',replace(narr,'Being TDS on share of ',''),1))  

ELSE  
NARR  
END  
)
from #temp1  
where vno not in (select vno from #tempa)  
  


--select * from #tempa
--select * from #file1

if(@cltcode = '26100009' or @cltcode = '26100010')
begin
select a.*,state=isnull(b.state,''),Pan_no=isnull(b.pan_no,'')  
from #tempa a left outer join mis.sb_comp.dbo.SB_State_pan b on a.narration=b.sub_BRoker order by vno 
end 
else
begin
select a.*,state=isnull(b.state,''),Pan_no=isnull(b.pan_no,'') 
--from #tempa a mis.sb_comp.dbo.VendorMaster b where b.cltcode = a.alt_cltcode and b.segment = 'BSECM' order by a.vno
from #tempa a left outer join mis.sb_comp.dbo.VendorMaster b on (b.cltcode = a.alt_cltcode and b.segment = @segment ) order by vno 
end


set nocount off

GO
