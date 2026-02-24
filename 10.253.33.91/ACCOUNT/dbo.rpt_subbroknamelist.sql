-- Object: PROCEDURE dbo.rpt_subbroknamelist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_subbroknamelist    Script Date: 20-Mar-01 11:43:36 PM ******/

/* report : allpartyledger
   file : namelist.asp
*/
/*shows list of names of clients from ledger corresponding to an alphabet*/
CREATE PROCEDURE rpt_subbroknamelist
@statusid varchar(15),
@statusname varchar(25)
AS
SELECT DISTINCT C1.CL_CODE, C1.SHORT_NAME 
FROM MSAJAG.DBO.CLIENT1 C1, MSAJAG.DBO.CLIENT2 C2, ledger l , msajag.dbo.subbrokers sb
WHERE C1.CL_CODE=C2.CL_CODE
and c2.party_code=l.cltcode 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@statusname
order by c1.short_name

GO
