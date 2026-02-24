-- Object: PROCEDURE dbo.rpt_fobilldetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fobilldetails    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobilldetails    Script Date: 5/7/2001 9:02:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobilldetails    Script Date: 5/5/2001 2:43:35 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobilldetails    Script Date: 5/5/2001 1:24:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobilldetails    Script Date: 4/30/01 5:50:07 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobilldetails    Script Date: 10/26/00 6:04:40 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fobilldetails    Script Date: 12/27/00 8:59:09 PM ******/
/*
Used In      : NSE FO
Report Name  : Bill Report
File Name    : Bill Details
Tables Used  : fosettlement, client1, client2
Function     : Returns the personal details of the client
Written By   : Amolika Patil 
*/
CREATE PROCEDURE rpt_fobilldetails
@code varchar(10)
AS
select  s.amount, s.tradeqty, s.netrate, s.NBrokApp, s.NSerTax, c1.L_Address1,
c1.L_Address2,c1.L_Address3, c1.L_city,c1.L_Zip,c1.Res_Phone1,c1.Off_Phone1,s.sell_buy
from fosettlement s,client1 c1,client2 c2
where s.party_code = @code
and c1.cl_code=c2.cl_code and
c2.party_code=s.party_code

GO
