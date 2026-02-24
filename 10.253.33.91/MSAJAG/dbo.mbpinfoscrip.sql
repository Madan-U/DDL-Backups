-- Object: PROCEDURE dbo.mbpinfoscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.mbpinfoscrip    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.mbpinfoscrip    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.mbpinfoscrip    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.mbpinfoscrip    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.mbpinfoscrip    Script Date: 12/27/00 8:59:08 PM ******/

CREATE PROCEDURE 
mbpinfoscrip
@scripname varchar(10)
AS
select distinct scrip_cd,series from ldbmkt
 where scrip_cd like @scripname and TotalQty <> 0 
order by scrip_cd,series

GO
