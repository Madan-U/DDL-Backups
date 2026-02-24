-- Object: PROCEDURE dbo.check_tb_diff
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create procedure check_tb_diff
as
set nocount on
set transaction isolation level read uncommitted

select cltcode,vamt=sum(case when drcr='D' then vamt else -vamt end)
into #file1
from ledger 
where vdt >='Apr 1 2005 00:00:00' and vdt <= 'Mar 31 2006 23:59:59'
group by cltcode

select cltcode,vamt=sum(case when drcr='D' then vamt else -vamt end)
into #file2
from ledger 
where vdt >='Apr 1 2006 00:00:00' and vdt <= 'Mar 31 2007 23:59:59' and vtyp=18
group by cltcode

select cltcode=isnull(a.cltcode,b.cltcode),Cls_amt=isnull(a.vamt,0),
Opn_amt=isnull(b.vamt,0),Diff_amt=isnull(a.vamt,0)-isnull(b.vamt,0)
from #file1 a full outer join #file2 b on a.cltcode=b.cltcode
where isnull(a.vamt,0)-isnull(b.vamt,0) <> 0
order by isnull(a.cltcode,b.cltcode)

set nocount off

GO
