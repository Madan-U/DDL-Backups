-- Object: PROCEDURE dbo.sbmtomclosingrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomclosingrate    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomclosingrate    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomclosingrate    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomclosingrate    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomclosingrate    Script Date: 12/27/00 8:59:00 PM ******/

CREATE PROCEDURE
sbmtomclosingrate
@scrip varchar(10),
@ser varchar(2)
AS
select Cl_Rate from closing c
 where c.scrip_cd =ltrim(@scrip)  and c.series =ltrim( @ser ) and c.MARKET='NORMAL'

GO
