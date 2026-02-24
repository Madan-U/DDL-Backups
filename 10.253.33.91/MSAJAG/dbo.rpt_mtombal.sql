-- Object: PROCEDURE dbo.rpt_mtombal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtombal    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtombal    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtombal    Script Date: 20-Mar-01 11:39:00 PM ******/
/* report : newmtom report  
   file : mtomtablefill.asp 
*/
/* calculates debit and credit amounts for a particular client code */
CREATE PROCEDURE rpt_mtombal
@clcode varchar(6)
AS
select dramt=isnull((case drcr when 'd' then SUM(vamt)end),0),
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0)  
from account.dbo.ledger where cltcode in 
(SELECT PARTY_CODE FROM CLIENT2 WHERE CL_CODE = @clcode)
group by drcr

GO
