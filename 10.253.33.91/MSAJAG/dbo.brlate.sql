-- Object: PROCEDURE dbo.brlate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brlate    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brlate    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brlate    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brlate    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brlate    Script Date: 12/27/00 8:58:44 PM ******/

/* Report : Management info
    File : latestrates.asp
*/
CREATE PROCEDURE brlate
@scripname varchar(10)
AS
select distinct scrip_cd, series , MARKETRATE,sell_buy 
from trade4432 t
where sauda_date = ( select max(sauda_date) from trade4432 t1 where 
t1.scrip_cd = t.scrip_cd and t1.series = t.series) 
and scrip_cd like ltrim(@scripname)+'%'
order by scrip_cd ,series,sell_buy

GO
