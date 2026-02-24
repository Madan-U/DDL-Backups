-- Object: PROCEDURE dbo.rpt_branchsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_branchsettno    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchsettno    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchsettno    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchsettno    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchsettno    Script Date: 12/27/00 8:58:53 PM ******/

/* displays settlement numbers in which a particular branch has done trading */
/* file : brokerbranchwise.asp
   report : branch
*/
CREATE PROCEDURE rpt_branchsettno
@branch varchar(10)
AS
select distinct h.sett_no, end_date from settlement h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B, sett_mst st
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @branch
and st.sett_no=h.sett_no and st.sett_type=h.sett_type
order by end_date desc

GO
