-- Object: PROCEDURE dbo.missingcostvoucherold
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc missingcostvoucherold
@vtyp varchar(2),
@sdate datetime,
@edate datetime

as

select l.vtyp, l.vno, l.lno, l.cltcode, branchcode  
from ledger l, acmast a
where vtyp = @vtyp
and vdt >= @sdate and vdt <= @edate
and vno not in ( select distinct vno from ledger2 where vtype = @vtyp )
and l.cltcode = a.cltcode
order by vtyp, vno, lno

GO
