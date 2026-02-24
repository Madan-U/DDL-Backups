-- Object: PROCEDURE dbo.ledgermismatch2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/* Query to find out vouchers where debit and credit is not matching */

CREATE proc ledgermismatch2
as
select vtype, vno, sum(case when upper(drcr) = 'D' then camt else -camt end )
from ledger2 
group by vtype, vno
having sum(case when drcr = 'D' then camt else -camt end) <> 0
order by vtype, vno

GO
