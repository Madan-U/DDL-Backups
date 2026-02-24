-- Object: PROCEDURE dbo.sbmodify
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmodify    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmodify    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmodify    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmodify    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmodify    Script Date: 12/27/00 8:59:15 PM ******/

CREATE PROCEDURE 
sbmodify 
@id varchar(10)
 AS
select * from tblscripsel where fldparty =ltrim(@id)

GO
