-- Object: PROCEDURE dbo.rpt_branchname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_branchname    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchname    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchname    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchname    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_branchname    Script Date: 12/27/00 8:58:53 PM ******/

/* report : Branch Turnover
   file : branchwise.asp
selects names a branch
*/
CREATE PROCEDURE rpt_branchname
@statusname varchar(25)
 AS
SELECT distinct branch_cd FROM BRANCHES 
where branch_cd=@statusname

GO
