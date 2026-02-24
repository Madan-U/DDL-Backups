-- Object: PROCEDURE dbo.rpt_bseclientdetails1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bseclientdetails1    Script Date: 20-Mar-01 11:43:34 PM ******/

/* report : allpartyledger
   file : cumledger.asp
*/
/* displays details of a client */
CREATE PROCEDURE rpt_bseclientdetails1
@clcode varchar(6)
AS
select c1.Res_Phone1,Off_Phone1, c2.tran_cat,c1.short_name 
from bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 
where c1.cl_code=@clcode and c2.cl_code=@clcode

GO
