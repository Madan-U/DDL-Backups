-- Object: PROCEDURE dbo.Kaddbankledger2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

create proc Kaddbankledger2
@branch varchar(10)

as

delete from Kmissingv2

insert into Kmissingv2  select distinct vno from Kledger l, Kacmast a where vtyp = 2 and 
vdt >= 'Apr  1 2002 00:00:00' and vdt <= 'Mar 31 2003 23:59:59' and 
l.cltcode = a.cltcode and branchcode = @branch 
and vno not in ( select distinct vno from Kledger2 where vtyp = 2 )

insert into Kbankledger222
select vtyp, vno, lno, drcr, vamt, costcode, l.booktype
from Kledger l  left outer join kcostmast on costname = @branch
where  vtyp = 2
and vno in ( select distinct vno from kmissingv2 )

delete from kmissingv2

insert into kmissingv2  select distinct vno from kledger l, kacmast a where vtyp = 3 and 
vdt >= 'Apr  1 2002 00:00:00' and vdt <= 'Mar 31 2003 23:59:59' and 
l.cltcode = a.cltcode and branchcode = @branch 
and vno not in ( select distinct vno from kledger2 where vtyp = 3 )

insert into kbankledger222
select vtyp, vno, lno, drcr, vamt, costcode, l.booktype
from kledger l  left outer join kcostmast on costname = @branch
where  vtyp = 3
and vno in ( select distinct vno from kmissingv2 )

GO
