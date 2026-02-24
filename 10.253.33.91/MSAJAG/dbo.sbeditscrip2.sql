-- Object: PROCEDURE dbo.sbeditscrip2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbeditscrip2    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbeditscrip2    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbeditscrip2    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbeditscrip2    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbeditscrip2    Script Date: 12/27/00 8:59:15 PM ******/

CREATE PROCEDURE 
sbeditscrip2
@id varchar(10),
@grno varchar(1)
as
select * from tblscripsel where fldparty=ltrim(@id) and fldgrno=ltrim(@grno)

GO
