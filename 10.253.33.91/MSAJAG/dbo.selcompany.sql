-- Object: PROCEDURE dbo.selcompany
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.selcompany    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.selcompany    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.selcompany    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.selcompany    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.selcompany    Script Date: 12/27/00 8:59:16 PM ******/

/****** Object:  Stored Procedure dbo.selcompany    Script Date: 12/18/99 8:24:11 AM ******/
create procedure selcompany
 @s_name varchar(30)
 As
select * from company where short_name like @s_name 
order by short_name

GO
