-- Object: PROCEDURE dbo.sp_clientmarginledger
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create proc sp_clientmarginledger

@ledgerdate as varchar(11)

as

select cltcode,amount=isnull(sum(case when upper(drcr)='D' then (0-isnull(vamt,0)) else isnull(vamt,0) end),0) 
from account.dbo.ledger	
where vdt <= @ledgerdate + ' 23:59:59'
and cltcode in (select distinct party_code from client2)
and vno not in (select distinct vno from account.dbo.ledger A where A.vdt like @ledgerdate+'%'  AND A.CLTCODE = CLTCODE)
group by cltcode
order by cltcode

GO
