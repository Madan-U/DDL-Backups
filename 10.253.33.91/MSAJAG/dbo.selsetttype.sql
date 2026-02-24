-- Object: PROCEDURE dbo.selsetttype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.selsetttype    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.selsetttype    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.selsetttype    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.selsetttype    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.selsetttype    Script Date: 12/27/00 8:59:16 PM ******/

/****** Object:  Stored Procedure dbo.selsetttype    Script Date: 12/18/99 8:24:11 AM ******/
create procedure selsetttype
@desc varchar (30)
as
select * from sett_type where description like @desc 
order by exchange, sett_type

GO
