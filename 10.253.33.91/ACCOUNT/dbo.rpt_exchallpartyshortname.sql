-- Object: PROCEDURE dbo.rpt_exchallpartyshortname
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartyshortname    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_exchallpartyshortname    Script Date: 11/28/2001 12:23:49 PM ******/



CREATE PROCEDURE rpt_exchallpartyshortname 

@alpha char (1)

AS

SELECT DISTINCT CL_CODE, SHORT_NAME 
FROM msajag.dbo.clientmaster 
where short_name like  ltrim(@alpha)+ '%'
order by short_name

GO
