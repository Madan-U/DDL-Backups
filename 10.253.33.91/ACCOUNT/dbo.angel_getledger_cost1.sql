-- Object: PROCEDURE dbo.angel_getledger_cost1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure angel_getledger_cost1(@cltcode as varchar(25),@fdate as varchar(11),@tdate as varchar(11),@segment as varchar(11))          
as          
          
set transaction isolation level read uncommitted          
          
set nocount on          
          
/*          
Exec angel_getledger_cost1 'A108','Apr 01 2004','Jan 05 2006'          
declare @cltcode as varchar(11),@fdate as varchar(11),@tdate as varchar(11)          
set @cltcode='a108'          
set @fdate='Apr 01 2004'          
set @tdate='Jan 05 2006'          
*/          
          
select a.*,camt=isnull(b.camt,0),costname=isnull(b.costname,' - ')          
into #abl_cost          
from           
(select * from ledger(nolock) where cltcode=@cltcode and vdt>=@fdate+' 00:00:00' and vdt <=@tdate+' 23:59:59'          
) a left outer join          
(select  l2.camt,l2.cltcode,l2.vno,l2.vtype,l2.lno,costname=isnull(costname,'')           
from ledger2 l2           
left outer join costmast cm           
on l2.costcode=cm.costcode) b           
on a.vno=b.vno and a.lno=b.lno and a.vtyp=b.vtype and a.cltcode=b.cltcode          
          
          
select n.vdt,vtyp=isnull(v.ShortDesc,''),n.vno,n.narration as [narr],           
Debit=(case when drcr = 'D' then n.vamt else 0 end),Credit=(case when drcr = 'C' then n.vamt else 0 end),           
balamt=convert(money,0.00),n.camt,n.costname,Segment=@segment,n.acname,@cltcode as accountcode,n.lno as [LineNo]  from #abl_cost n left outer join           
vmast v on vtyp=vtype          
order by n.vno,n.lno          
          
          
set nocount off

GO
