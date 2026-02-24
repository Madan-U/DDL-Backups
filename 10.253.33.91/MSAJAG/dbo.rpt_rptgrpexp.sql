-- Object: PROCEDURE dbo.rpt_rptgrpexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_rptgrpexp    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_rptgrpexp    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_rptgrpexp    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_rptgrpexp    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_rptgrpexp    Script Date: 12/27/00 8:59:14 PM ******/

/* file: positionreport.asp
   report :position report
    
*/  
CREATE PROCEDURE rpt_rptgrpexp AS
select count(*) from RptGrpExp

GO
