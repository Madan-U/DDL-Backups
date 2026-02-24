-- Object: PROCEDURE dbo.rpt_exchallpartyname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartyname    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_exchallpartyname    Script Date: 11/28/2001 12:23:49 PM ******/



/* report : exchange wise allpartyledger */
CREATE PROCEDURE rpt_exchallpartyname 

@clcode char (7)

AS

SELECT DISTINCT  SHORT_NAME 
FROM msajag.dbo.clientmaster 
where cl_code =@clcode
order by short_name

GO
