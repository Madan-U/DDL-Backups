-- Object: PROCEDURE dbo.rpt_sbnewdrcr1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/*
report : Subbroker accounts
this procedure gives us list of subbrokers , clients of each and their debit and credit totals
*/
create proc rpt_sbnewdrcr1 
@statusid varchar(15),
@statusname varchar(25),
@finstartdt varchar(12)
as
if @statusid = 'broker'
begin
	select sb.sub_broker , drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and vdt >= @finstartdt 
	and VDT <= convert(varchar,getdate(),101)
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end
if @statusid = 'subbroker'
begin
	select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
	crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode
	from account.dbo.ledger l ,client1 c1 , client2 c2 ,subbrokers sb
	WHERE
	c1.cl_code =c2.cl_code
	and c2.party_code = l.cltcode
	and c1.sub_broker = sb.sub_broker
	and c1.sub_broker = @statusname
	and vdt >= @finstartdt 
	and VDT <= convert(varchar,getdate(),101)
	group by sb.sub_broker ,cltcode ,l.drcr
	order by sb.sub_broker ,cltcode ,l.drcr
end

GO
