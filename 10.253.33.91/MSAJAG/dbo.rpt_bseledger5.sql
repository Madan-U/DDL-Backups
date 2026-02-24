-- Object: PROCEDURE dbo.rpt_bseledger5
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 04/27/2001 4:32:34 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 3/21/01 12:50:13 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseledger5    Script Date: 20-Mar-01 11:38:54 PM ******/


/*Modified by amolika on 2nd march'2001 : removed bsedb.dbo. & added account.dbo. to all accounts report*/
/* Report : Confirmation Report
   File : Tconfirmationreport.asp
   Displays the details for a particular client
*/
CREATE PROCEDURE rpt_bseledger5
@clcode varchar(6)
AS
select c1.Res_Phone1,Off_Phone1, c2.tran_cat,c1.short_name 
from client1 c1, client2 c2 
where c1.cl_code=@clcode and c2.cl_code=@clcode

GO
