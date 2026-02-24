-- Object: PROCEDURE dbo.checkangel1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE proc checkangel1
@branch varchar(10),
@vtyp smallint,
@DateFrom	datetime,
@ToDate	datetime
as

select vtyp, vno, lno, drcr, vamt, costcode, l.booktype
from ledger l  left outer join costmast on costname = rtrim(@branch)
where  vtyp = @vtyp
and vno in ( select distinct vno from ledger l, acmast a where vtyp = @vtyp and 
vdt >= @DateFrom and vdt <= @ToDate + '23:59:59' and 
l.cltcode = a.cltcode and branchcode = rtrim(@branch) )
and vno not in ( select distinct vno from ledger2 where vtype = @vtyp )
order by vno

GO
