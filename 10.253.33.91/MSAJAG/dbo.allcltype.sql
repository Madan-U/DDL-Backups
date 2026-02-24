-- Object: PROCEDURE dbo.allcltype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.allcltype    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.allcltype    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.allcltype    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.allcltype    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.allcltype    Script Date: 12/27/00 8:58:42 PM ******/

/****** Object:  Stored Procedure dbo.allcltype    Script Date: 12/18/99 8:24:06 AM ******/
create procedure allcltype
as 
select * from clienttype order by cl_type

GO
