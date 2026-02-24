-- Object: PROCEDURE dbo.client_fund_balance_NSECM
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--select * from acmast where cltcode='02008'


CREATE proc [dbo].[client_fund_balance_NSECM]

AS

declare @acyearfrom as datetime,@acyearto as datetime
select @acyearfrom=sdtcur,@acyearto=ldtcur from parameter (nolock) 
where sdtcur <=getdate() and ldtcur >=getdate()


select a.* into
#temp
from
(

select a.cltcode,b.acname,Fund_balance=sum(case when drcr='D' then -vamt else vamt end)  from ledger a (nolock)
left outer join
acmast b
on a.cltcode=b.cltcode
where a.vdt >=@acyearfrom and a.vdt<=getdate()
and a.cltcode in 
(select cltcode from acmast where grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode where segment='NSECM')
and cltcode not in (select cltcode from intranet.roe.dbo.ff_bank_details where segment='NSECM' and cltcode <> 0)
and cltcode not in (select cltcode from intranet.roe.dbo.ff_rej_bank_details where  segment='NSECM')
)
group by a.cltcode, b.acname

) a

select * from #temp
union all
select 'TOTAL','' ,sum(fund_balance) from #temp

RETURN

GO
