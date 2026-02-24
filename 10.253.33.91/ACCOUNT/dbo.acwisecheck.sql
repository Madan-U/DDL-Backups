-- Object: PROCEDURE dbo.acwisecheck
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc acwisecheck
@cltcode varchar(10)

as

select distinct l.vtyp, l.vno, l.vdt, l.lno, l.drcr, vamt, substring(narr,8,7)+ ' ' + substring(narr,20,2)
from ledger l, ledger2 l2, ledger3 l3
where vdt >= 'Apr  1 2001 00:00:00' and vdt <= 'Mar 31 2002 23:59:59'
and cltcode = @cltcode
and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno 
and l.lno not in ( select distinct lno from ledger2 where l.vtyp = vtype and l.booktype = booktype and l.vno = vno )
and l.vtyp = l3.vtyp and l.booktype = l3.booktype and l.vno = l3.vno and l3.naratno = 0

GO
