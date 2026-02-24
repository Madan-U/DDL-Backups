-- Object: PROCEDURE dbo.ledgermismatch3
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/* Query to find out vouchers where debit and credit is not matching */

CREATE proc ledgermismatch3
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
select vtypE, booktype, vno, diff=sum(case when drcr = 'd' then Camt else -Camt end)
from ledger2 WHERE VTYPE = 18 AND COSTCODE = 28
group by vtypE, booktype, vno
having sum(case when drcr = 'd' then Camt else -Camt end) <> 0
order by vtypE, booktype, vno

GO
