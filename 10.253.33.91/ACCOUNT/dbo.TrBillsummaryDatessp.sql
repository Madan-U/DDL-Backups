-- Object: PROCEDURE dbo.TrBillsummaryDatessp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.TrBillsummaryDatessp    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE  TrBillsummaryDatessp 
@settlementno varchar(7),
@settlementype varchar(3)
AS
select start_date,end_date from MSAJAG.DBO.sett_mst
where sett_no = @settlementno and sett_Type = @settlementype

GO
