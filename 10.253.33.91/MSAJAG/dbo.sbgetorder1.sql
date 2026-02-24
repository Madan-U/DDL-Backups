-- Object: PROCEDURE dbo.sbgetorder1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbgetorder1    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder1    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder1    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder1    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbgetorder1    Script Date: 12/27/00 8:58:59 PM ******/

CREATE PROCEDURE sbgetorder1
@scripname varchar(12),
@series char(3)
AS
select scrip_cd,series from scrip2 where scrip_cd =ltrim( @scripname) and series = ltrim(@series)

GO
