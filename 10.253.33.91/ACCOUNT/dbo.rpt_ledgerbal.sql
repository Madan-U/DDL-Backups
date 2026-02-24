-- Object: PROCEDURE dbo.rpt_ledgerbal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_ledgerbal    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : confirmation report
   file : tconfirmationreport.asp
 */
/* displays ledger balances of all accounts of a particular client till today */
CREATE PROCEDURE rpt_ledgerbal
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0), 
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) from ledger, MSAJAG.DBO.client2 
where cltcode in (SELECT DISTINCT PARTY_CODE FROM MSAJAG.DBO.CLIENT2 
WHERE CL_CODE=@clcode)and cltcode=party_code 
group by drcr

GO
