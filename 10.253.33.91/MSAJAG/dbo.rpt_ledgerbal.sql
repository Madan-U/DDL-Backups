-- Object: PROCEDURE dbo.rpt_ledgerbal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 01/04/1980 5:06:27 AM ******/






/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 09/07/2001 11:09:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 7/1/01 2:26:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 06/26/2001 8:48:57 PM ******/


/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 20-Mar-01 11:38:59 PM ******/



/* report : confirmation report
   file : tconfirmationreport.asp
 */
/* displays ledger balances of all accounts of a particular client till today */
/* changed by mousami on 02/03/2001 
     removed harcoding for sharedatabase and added for account database
*/

CREATE PROCEDURE rpt_ledgerbal
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) from account.dbo.ledger, client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 
WHERE CL_CODE=@clcode)and cltcode=party_code 
group by drcr

GO
