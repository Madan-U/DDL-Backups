-- Object: PROCEDURE dbo.rpt_bseledger5
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 11/28/2001 12:23:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 2/17/01 3:34:17 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 20-Mar-01 11:43:35 PM ******/

/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the details for a particular client
*/
CREATE PROCEDURE rpt_bseledger5
@clcode varchar(6)
AS
select c1.Res_Phone1,Off_Phone1, c2.tran_cat,c1.short_name 
from MSAJAG.DBO.client1 c1,MSAJAG.DBO.client2 c2 
where c1.cl_code=@clcode and c2.cl_code=@clcode

GO
