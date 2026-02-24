-- Object: PROCEDURE dbo.rpt_ledgerbal1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledgerbal1    Script Date: 01/19/2002 12:15:15 ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal1    Script Date: 12/14/2001 1:25:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal1    Script Date: 11/30/01 4:48:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ledgerbal1    Script Date: 11/5/01 1:29:01 PM ******/


/* report : confirmation report
   file : tconfirmationreport.asp
 */
/* displays ledger balances of all accounts of a particular client from opening entrydate till today */


CREATE PROCEDURE rpt_ledgerbal1
@clcode varchar(6),
@openingentrydate varchar(12)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) from account.dbo.ledger, client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM CLIENT2 
WHERE CL_CODE=@clcode)and cltcode=party_code 
and vdt >= @openingentrydate
group by drcr

GO
