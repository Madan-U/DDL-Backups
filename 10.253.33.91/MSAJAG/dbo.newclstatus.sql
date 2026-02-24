-- Object: PROCEDURE dbo.newclstatus
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newclstatus    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.newclstatus    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.newclstatus    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.newclstatus    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.newclstatus    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.newclstatus    Script Date: 12/18/99 8:24:10 AM ******/
create procedure newclstatus
@cl_code varchar(30),
@desc varchar(30) OUTPUT
as 
select description from clientstatus where cl_status like @cl_code

GO
