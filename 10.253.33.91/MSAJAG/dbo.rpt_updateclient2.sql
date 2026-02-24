-- Object: PROCEDURE dbo.rpt_updateclient2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_updateclient2    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_updateclient2    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_updateclient2    Script Date: 20-Mar-01 11:39:04 PM ******/





/****** Object:  Stored Procedure dbo.rpt_updateclient2    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_updateclient2    Script Date: 12/27/00 8:58:58 PM ******/

/* report :confirmation
   file : save.asp
   update demat details of client
*/
CREATE PROCEDURE rpt_updateclient2
@bankid varchar(10),
@cltdpno varchar(10),
@clcode varchar(6)
AS
update client2 
set BankId=@bankid ,CltDpNo=@cltdpno
where cl_code=@clcode

GO
