-- Object: PROCEDURE dbo.sbupdatecl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbupdatecl    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecl    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecl    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecl    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbupdatecl    Script Date: 12/27/00 8:59:02 PM ******/

CREATE PROCEDURE sbupdatecl
@bankid varchar(15),
@dpno varchar(10),
@clcode varchar(6)
AS
update client2 set BankId=@bankid ,CltDpNo=ltrim(@dpno)
where cl_code=ltrim(@clcode)

GO
