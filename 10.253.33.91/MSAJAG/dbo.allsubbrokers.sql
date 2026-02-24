-- Object: PROCEDURE dbo.allsubbrokers
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.allsubbrokers    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.allsubbrokers    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.allsubbrokers    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.allsubbrokers    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.allsubbrokers    Script Date: 12/27/00 8:58:43 PM ******/

/****** Object:  Stored Procedure dbo.allsubbrokers    Script Date: 12/18/99 8:24:07 AM ******/
create procedure allsubbrokers
as 
select * from subbrokers order by sub_broker

GO
