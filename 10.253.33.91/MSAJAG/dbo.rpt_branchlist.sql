-- Object: PROCEDURE dbo.rpt_branchlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_branchlist    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchlist    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchlist    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchlist    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchlist    Script Date: 12/27/00 8:58:53 PM ******/

/* report : branchwise turnover 
   file : brokerbranchwise.asp
*/
/* displays list of all available branches */
CREATE PROCEDURE rpt_branchlist
AS
select distinct branch_cd from branches

GO
