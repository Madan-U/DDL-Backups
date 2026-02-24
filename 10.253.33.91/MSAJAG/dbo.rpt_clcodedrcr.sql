-- Object: PROCEDURE dbo.rpt_clcodedrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 01/19/2002 12:15:13 ******/

/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 01/04/1980 5:06:26 AM ******/






/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 09/07/2001 11:09:04 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 3/23/01 7:59:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 08/18/2001 8:24:05 PM ******/


/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 7/8/01 3:28:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 2/17/01 5:19:40 PM ******/


/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_clcodedrcr    Script Date: 20-Mar-01 11:38:54 PM ******/


/*Modified by amolika on 1st march'2001 : removed masajag.dbo. & added account.dbo. to all account tables*/
/* report : traderledger
   file : cumbal1.asp
*/
/* calculates debit and credit  balances of all accounts of a client */
CREATE PROCEDURE rpt_clcodedrcr
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0),
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
from account.dbo.ledger, client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 WHERE CL_CODE=@clcode)
and cltcode=party_code 
group by drcr

GO
