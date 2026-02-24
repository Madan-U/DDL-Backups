-- Object: PROCEDURE dbo.rpt_exchallpartycoexch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartycoexch    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_exchallpartycoexch    Script Date: 01/04/1980 5:06:26 AM ******/


/* report : exchangewise allpartyledger  */
/* displays company name and its corresponding databases*/

CREATE PROCEDURE rpt_exchallpartycoexch

AS


select distinct companyname, accountdb from msajag.dbo.multicompany
order by companyname,accountdb

GO
