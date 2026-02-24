-- Object: PROCEDURE dbo.missingcostvoucher
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc missingcostvoucher
@vtyp varchar(2),
@sdate datetime,
@edate datetime

as

delete from tempacdlledger2

insert into tempacdlledger2
select category='BRANCH', branchcode, vamt, vtyp, vno, lno, drcr, costcode=0, l.booktype, sessionid=vno, l.cltcode, costflag=0, rowid=lno 
/*select l.vtyp, l.vno, l.lno, l.cltcode, branchcode  */
from ledger l, acmast a
where vtyp = @vtyp
and vdt >= @sdate and vdt <= @edate
and vno not in ( select distinct vno from ledger2 where vtype = @vtyp )
and l.cltcode = a.cltcode

GO
