-- Object: PROCEDURE dbo.rpt_ibranchtype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ibranchtype    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchtype    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchtype    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchtype    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchtype    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trading */
/* report : branchwise turnover 
   file : brokerbranchwise.asp
 */
/* displays settlement types in which a particular branch have done trading  */
CREATE PROCEDURE rpt_ibranchtype
@branch varchar(10)
AS
select distinct sett_type from isettlement h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @branch
order by sett_type

GO
