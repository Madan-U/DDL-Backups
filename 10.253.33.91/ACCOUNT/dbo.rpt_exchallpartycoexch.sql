-- Object: PROCEDURE dbo.rpt_exchallpartycoexch
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartycoexch    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_exchallpartycoexch    Script Date: 11/28/2001 12:23:49 PM ******/

/* report : exchangewise allpartyledger  */
/* displays company name and its corresponding databases*/

CREATE PROCEDURE rpt_exchallpartycoexch

AS


select distinct companyname, accountdb from msajag.dbo.multicompany
order by companyname,accountdb

GO
