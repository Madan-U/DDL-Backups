-- Object: PROCEDURE dbo.TrBillTraderssp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 01/04/1980 1:40:44 AM ******/



/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.TrBillTraderssp    Script Date: 20-Mar-01 11:43:37 PM ******/

CREATE PROCEDURE TrBillTraderssp AS
SELECT DISTINCT ISNULL(TRADER,'') 
FROM MSAJAG.DBO.CLIENT1

GO
