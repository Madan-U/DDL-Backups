-- Object: PROCEDURE dbo.sbupdatecldet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbupdatecldet    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecldet    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecldet    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecldet    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecldet    Script Date: 12/27/00 8:59:02 PM ******/

CREATE PROCEDURE sbupdatecldet
@clcode varchar(6),
@resph2 varchar(15),
@resph1 varchar(15),
@offph1 varchar(15),
@offph2 varchar(15),
@fax varchar(15)
AS
update client1 set res_phone2=@resph2,
Res_Phone1=@resph1,off_phone1=@offph1,Off_Phone2=@offph2,
fax=@fax 
where cl_code=@clcode

GO
