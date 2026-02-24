-- Object: PROCEDURE dbo.brchange
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brchange    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brchange    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brchange    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brchange    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brchange    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : Market Report
    File : topmbpinfo.asp
displays % change in prices
*/
CREATE PROCEDURE brchange  
@change varchar(1)
AS
select distinct scrip_cd,series from ldbmkt 
where  TotalQty <> 0 and netPrice >= 10 and NetChange = @change 
order by scrip_cd,series

GO
