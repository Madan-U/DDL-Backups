-- Object: PROCEDURE dbo.TrBillBillNossp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.TrBillBillNossp    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE TrBillBillNossp 
@settno varchar(7),
@setttype varchar(3),
@partycode varchar(10)
AS
select distinct billno from MSAJAG.DBO.settlement
 where sett_no like @settno  and sett_type like @setttype  and party_code like @partycode

GO
