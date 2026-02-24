-- Object: PROCEDURE dbo.brtrader
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brtrader    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brtrader    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brtrader    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brtrader    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brtrader    Script Date: 12/27/00 8:58:46 PM ******/

/* Report Confirmation
File : Confirmationmain.asp
selects trader list for a particular branch
*/
   
CREATE PROCEDURE brtrader
@br varchar(3)
AS
select distinct trader 
from client1 c1,client2 c2,branches b
where c1.cl_code = c2.cl_code and b.short_name = c1.trader and b.branch_cd = @br
order by trader

GO
