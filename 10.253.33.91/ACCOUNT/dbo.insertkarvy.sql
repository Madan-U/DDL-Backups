-- Object: PROCEDURE dbo.insertkarvy
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc insertkarvy
@branch varchar(10),
@vtyp smallint
as

insert into ledger2
select vtyp, vno, lno, drcr, vamt, costcode, l.booktype
from ledger l  left outer join costmast on costname = rtrim(@branch)
where  vtyp = @vtyp
and vno in ( select distinct vno from ledger l, acmast a where vtyp = @vtyp and 
vdt >= 'Apr  1 2002 00:00:00' and vdt <= 'Mar 31 2003 23:59:59' and 
l.cltcode = a.cltcode and branchcode = rtrim(@branch) )
and vno not in ( select distinct vno from ledger2 where vtype = @vtyp )

GO
