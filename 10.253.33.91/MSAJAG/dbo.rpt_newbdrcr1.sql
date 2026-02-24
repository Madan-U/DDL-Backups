-- Object: PROCEDURE dbo.rpt_newbdrcr1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



create proc rpt_newbdrcr1 
@statusid varchar(12),
@statusname varchar(25),
@date varchar(12)
as
if @statusid ='broker'
begin
select 
br.branch_cd,
drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,
cltcode 
from account.dbo.ledger l ,client1 c1 ,client2 c2,branches br
where c1.cl_code =c2.cl_code
and c2.party_code = l.cltcode
and l.vdt >= @date
and l.vdt <= convert(varchar,getdate(),101)
and br.short_name =c1.trader
group by br.branch_cd ,cltcode ,l.drcr
order by br.branch_cd ,cltcode ,l.drcr
end

if @statusid ='branch'
begin
select 
br.branch_cd,
drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,
cltcode 
from account.dbo.ledger l ,client1 c1 ,client2 c2,branches br
where c1.cl_code =c2.cl_code
and c2.party_code = l.cltcode
and l.vdt >= @date
and l.vdt <= convert(varchar,getdate(),101)
and br.short_name =c1.trader
and br.branch_cd =@statusname
group by br.branch_cd ,cltcode ,l.drcr
order by br.branch_cd ,cltcode ,l.drcr
end

GO
