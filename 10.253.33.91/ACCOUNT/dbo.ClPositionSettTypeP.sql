-- Object: PROCEDURE dbo.ClPositionSettTypeP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 01/04/1980 1:40:36 AM ******/



/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 11/28/2001 12:23:42 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 29-Sep-01 8:12:03 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.ClPositionSettTypeP    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE ClPositionSettTypeP
@settno varchar(7)
 AS
SELECT DISTINCT SETT_type FROM MSAJAG.DBO.SETTLEMENT 
where sett_no like @settno

GO
