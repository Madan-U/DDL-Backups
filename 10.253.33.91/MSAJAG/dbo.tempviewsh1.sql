-- Object: PROCEDURE dbo.tempviewsh1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.tempviewsh1    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.tempviewsh1    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.tempviewsh1    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.tempviewsh1    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.tempviewsh1    Script Date: 12/27/00 8:59:04 PM ******/

create proc tempviewsh1
as 
select * from tempviewsh where party_code like '1%'

GO
