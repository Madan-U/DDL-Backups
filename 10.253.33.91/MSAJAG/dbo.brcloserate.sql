-- Object: PROCEDURE dbo.brcloserate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brcloserate    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brcloserate    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brcloserate    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brcloserate    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brcloserate    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : Closing Report
    File : closingreport.asp
displays closing rates
*/
CREATE PROCEDURE brcloserate
@scripcd varchar(10)
AS
select distinct MARKET,SCRIP_CD,SERIES, Cl_Rate 
from closing 
where scrip_cd like ltrim(@scripcd)+'%' 
order by scrip_cd

GO
