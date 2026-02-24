-- Object: PROCEDURE dbo.rpt_sbclientlist1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*
report : subbroker accounts
this query gives us the debits and credits of all partycodes for a particular subbroker
*/

CREATE proc rpt_sbclientlist1 
@statusid varchar(15),
@statusname varchar(25),
@finstartdt varchar(12),
@username varchar(25)
as
select c1.cl_code , l.cltcode ,drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
from account.dbo.ledger l ,client1 c1,client2 c2 ,subbrokers sb
WHERE 
c1.cl_code =c2.cl_code
and c2.party_code = l.cltcode
and c1.sub_broker = sb.sub_broker
and c1.sub_broker = @username
and vdt >= @finstartdt  
and VDT <= convert(varchar,getdate(),101)
group by l.cltcode ,c1.cl_code ,l.drcr
order by l.cltcode,c1.cl_code ,l.drcr

GO
