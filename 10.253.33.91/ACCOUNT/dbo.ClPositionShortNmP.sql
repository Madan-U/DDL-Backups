-- Object: PROCEDURE dbo.ClPositionShortNmP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.ClPositionShortNmP    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE ClPositionShortNmP
@shortname varchar(21)
 AS
SELECT DISTINCT SHORT_NAME, Res_Phone1 
FROM MSAJAG.DBO.CLIENT1 where trader like @shortname

GO
