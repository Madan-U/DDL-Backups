-- Object: PROCEDURE dbo.rpt_updateclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_updateclient    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_updateclient    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_updateclient    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.rpt_updateclient    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_updateclient    Script Date: 12/27/00 8:58:58 PM ******/

/* Report Confiramtion
File :  save.asp
updates details of clients
*/
CREATE PROCEDURE rpt_updateclient
@resph2 varchar(15),
@resph1 varchar(15),
@offph1 varchar(15),
@offph2 varchar(15),
@fax varchar(15),
@clcode varchar(6)
AS
update client1 set res_phone2=@resph2,
Res_Phone1=@resph1,off_phone1=@offph1,Off_Phone2=@offph2,
fax=@fax
where cl_code=@clcode

GO
