-- Object: PROCEDURE dbo.sbdel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbdel    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbdel    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbdel    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbdel    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbdel    Script Date: 12/27/00 8:59:14 PM ******/

/** file :modifygroup1redirectdelscrip.asp
 report  :online trading
delete a particular group of a client
 ***/
CREATE PROCEDURE sbdel
@id varchar(10),
@item char(1)
 AS
Delete from tblscripsel where fldparty = @id and fldgrno = @item

GO
