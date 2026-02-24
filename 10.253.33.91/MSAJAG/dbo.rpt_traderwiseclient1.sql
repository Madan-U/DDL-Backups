-- Object: PROCEDURE dbo.rpt_traderwiseclient1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_traderwiseclient1    Script Date: 01/19/2002 12:15:16 ******/

/****** Object:  Stored Procedure dbo.rpt_traderwiseclient1    Script Date: 01/04/1980 5:06:28 AM ******/






/****** Object:  Stored Procedure dbo.rpt_traderwiseclient1    Script Date: 09/07/2001 11:09:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_traderwiseclient1    Script Date: 3/23/01 7:59:32 PM ******/

/****** Object:  Stored Procedure dbo.rpt_traderwiseclient1    Script Date: 08/18/2001 8:24:29 PM ******/


CREATE procedure rpt_traderwiseclient1 
@statusid varchar(12),
@statusname varchar(25),
@trader varchar(15),
@date varchar(12)
as

select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0),
crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) ,l.cltcode ,c1.cl_code
from account.dbo.ledger l ,client1 c1 ,client2 c2 ,branches br
WHERE 
c1.cl_code =c2.cl_code
and c2.party_code = l.cltcode
and c1.trader =br.short_name
and c1.trader= @trader
and vdt >= @date
and VDT <= convert(varchar,getdate(),101) + ' 23:59:59'
group by cltcode ,c1.cl_code ,drcr 
order by cltcode

GO
