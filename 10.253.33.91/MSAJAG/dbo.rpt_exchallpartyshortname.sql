-- Object: PROCEDURE dbo.rpt_exchallpartyshortname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchallpartyshortname    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_exchallpartyshortname    Script Date: 01/04/1980 5:06:26 AM ******/



CREATE PROCEDURE rpt_exchallpartyshortname 

@alpha char (1)

AS

SELECT DISTINCT CL_CODE, SHORT_NAME 
FROM clientmaster 
where short_name like  ltrim(@alpha)+ '%'
order by short_name

GO
