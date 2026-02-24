-- Object: PROCEDURE dbo.SBTRD1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SBTRD1    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.SBTRD1    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.SBTRD1    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.SBTRD1    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.SBTRD1    Script Date: 12/27/00 8:59:16 PM ******/

CREATE PROCEDURE
SBTRD1
@ID VARCHAR(10)
AS
select * from tblscripsel where fldparty=ltrim(@ID)

GO
