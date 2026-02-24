-- Object: PROCEDURE dbo.rpt_exchallpartyname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartyname    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_exchallpartyname    Script Date: 01/04/1980 5:06:26 AM ******/



/* report : exchange wise allpartyledger */
CREATE PROCEDURE rpt_exchallpartyname 

@clcode char (7)

AS

SELECT DISTINCT  SHORT_NAME 
FROM clientmaster 
where cl_code =@clcode
order by short_name

GO
