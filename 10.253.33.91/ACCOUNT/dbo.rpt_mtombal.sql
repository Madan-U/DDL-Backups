-- Object: PROCEDURE dbo.rpt_mtombal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_mtombal    Script Date: 20-Mar-01 11:43:35 PM ******/

/* report : newmtom report  
   file : mtomtablefill.asp 
*/
/* calculates debit and credit amounts for a particular client code */
CREATE PROCEDURE rpt_mtombal
@clcode varchar(6)
AS
select dramt=isnull((case drcr when 'd' then SUM(vamt)end),0),
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0)  
from ledger where cltcode in 
(SELECT PARTY_CODE FROM MSAJAG.DBO.CLIENT2 WHERE CL_CODE = @clcode)
group by drcr

GO
