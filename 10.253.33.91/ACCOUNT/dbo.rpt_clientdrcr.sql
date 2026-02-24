-- Object: PROCEDURE dbo.rpt_clientdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientdrcr    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : confirmation 
   file : tconfirmationreport.asp
*/
/* calculates debit and credit  balances of all accounts of a client */
CREATE PROCEDURE rpt_clientdrcr
@acname varchar(35)
AS
select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger l , vmast, msajag.dbo.client2 c2 , msajag.dbo.client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code 
and c2.party_code=l.cltcode and l.acname = @acname
and vtyp=vtype 
group by drcr

GO
