-- Object: PROCEDURE dbo.ledgermismatch
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/* Query to find out vouchers where debit and credit is not matching */

CREATE proc ledgermismatch
as
/* 
select vtyp, vno, debit = ( select isnull(sum(vamt),0) from ledger l2 where l2.vtyp = l1.vtyp and l2.vno = l1.vno and l2.drcr = 'D'),
credit = ( select isnull(sum(vamt),0) from ledger l2 where l2.vtyp = l1.vtyp and l2.vno = l1.vno and l2.drcr = 'C'),
balance = ( select isnull(sum(vamt),0) from ledger l2 where l2.vtyp = l1.vtyp and l2.vno = l1.vno and l2.drcr = 'D')
          - ( select isnull(sum(vamt),0) from ledger l2 where l2.vtyp = l1.vtyp and l2.vno = l1.vno and l2.drcr = 'C')
from ledger l1
group by vtyp, vno
having ( select isnull(sum(vamt),0) from ledger l2 where l2.vtyp = l1.vtyp and l2.vno = l1.vno and l2.drcr = 'D') <> ( select isnull(sum(vamt),0) from ledger l2 where l2.vtyp = l1.vtyp and l2.vno = l1.vno and l2.drcr = 'C')
*/
select vtyp, booktype, vno, diff=sum(case when drcr = 'd' then vamt else -vamt end)
from ledger
group by vtyp, booktype, vno
having sum(case when drcr = 'd' then vamt else -vamt end) <> 0
order by vtyp, booktype, vno

GO
