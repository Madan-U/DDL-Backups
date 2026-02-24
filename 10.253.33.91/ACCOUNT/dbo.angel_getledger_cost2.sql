-- Object: PROCEDURE dbo.angel_getledger_cost2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure angel_getledger_cost2(@cltcode as varchar(25),@fdate as varchar(11),@tdate as varchar(11))  
as  
  
set transaction isolation level read uncommitted  
  
set nocount on  
  

--Exec angel_getledger_cost1 'A108','Apr 01 2004','Jan 05 2006'  
/*
drop table #abl_cost_a
declare @cltcode as varchar(11),@fdate as varchar(11),@tdate as varchar(11)  
set @cltcode='70000014 '  
set @fdate='Apr 01 2004'  
set @tdate='Dec 30 2004'  
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
from #abl_cost n left outer join   
vmast v (nolock) on vtyp=vtype  
order by n.vno,n.lno  
  
  
set nocount off

GO
