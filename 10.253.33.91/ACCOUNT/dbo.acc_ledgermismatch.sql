-- Object: PROCEDURE dbo.acc_ledgermismatch
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/* Query to find out vouchers where debit and credit is not matching */

CREATE proc acc_ledgermismatch
as
select vtyp, booktype, vno, diff=sum(case when drcr = 'd' then vamt else -vamt end)
from ledger
group by vtyp, booktype, vno
having sum(case when drcr = 'd' then vamt else -vamt end) <> 0
order by vtyp, booktype, vno

GO
