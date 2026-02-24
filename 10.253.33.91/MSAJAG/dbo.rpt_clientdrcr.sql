-- Object: PROCEDURE dbo.rpt_clientdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clientdrcr    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_clientdrcr    Script Date: 12/26/2001 1:23:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_clientdrcr    Script Date: 7/8/01 3:28:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientdrcr    Script Date: 2/17/01 5:19:41 PM ******/


/****** Object:  Stored Procedure dbo.rpt_clientdrcr    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clientdrcr    Script Date: 20-Mar-01 11:38:55 PM ******/


/*Modified by amolika on 1st march'2001 : removed msajag.dbo. & added account.dbo. to all accounts reports*/
/* report : confirmation 
   file : tconfirmationreport.asp
*/
/* calculates debit and credit  balances of all accounts of a client */
CREATE PROCEDURE rpt_clientdrcr
@acname varchar(35)
AS
select dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
from account.dbo.ledger l , account.dbo.vmast, client2 c2 , client1 c1 
where l.acname = c1.short_Name and c1.cl_code = c2.cl_code 
and c2.party_code=l.cltcode and l.acname = @acname
and vtyp=vtype 
group by drcr

GO
