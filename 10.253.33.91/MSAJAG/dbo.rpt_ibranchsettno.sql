-- Object: PROCEDURE dbo.rpt_ibranchsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ibranchsettno    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchsettno    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchsettno    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchsettno    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ibranchsettno    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trades*/
CREATE PROCEDURE rpt_ibranchsettno
@branch varchar(10)
AS
select distinct h.sett_no, end_date  from isettlement h,  CLIENT1 C1, CLIENT2 C2, BRANCHES B, sett_mst st
WHERE B.SHORT_NAME=C1.TRADER AND h.party_code=c2.party_code and C1.CL_CODE=C2.CL_CODE AND 
B.BRANCH_CD= @branch
and st.sett_no=h.sett_no and st.sett_type=h.sett_type
order by end_date desc

GO
