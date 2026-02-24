-- Object: PROCEDURE dbo.angel_getledger_cost
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure angel_getledger_cost(@cltcode as varchar(25),@fdate as varchar(11),@tdate as varchar(11))
as

set transaction isolation level read uncommitted

set nocount on

select a.*,b.camt,b.costname from 
(select * from ledger where cltcode=@cltcode and vdt>=@fdate+' 00:00:00' and vdt <=@tdate+' 23:59:59'
) a left outer join
(select l2.camt,l2.cltcode,l2.vno,l2.vtype,l2.lno,costname=isnull(costname,'') from ledger2 l2 left outer join costmast cm 
on l2.costcode=cm.costcode) b on a.vno=b.vno and a.lno=b.lno and a.vtyp=b.vtype and a.cltcode=b.cltcode
order by a.vno,a.lno
set nocount off

GO
