-- Object: PROCEDURE dbo.allbrokers
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.allbrokers    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.allbrokers    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.allbrokers    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.allbrokers    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.allbrokers    Script Date: 12/27/00 8:58:42 PM ******/

/****** Object:  Stored Procedure dbo.allbrokers    Script Date: 12/18/99 8:24:11 AM ******/
create procedure allbrokers
as 
select * from Brokview order by broker_code

GO
