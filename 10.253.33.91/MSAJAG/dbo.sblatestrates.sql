-- Object: PROCEDURE dbo.sblatestrates
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sblatestrates    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sblatestrates    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sblatestrates    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sblatestrates    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sblatestrates    Script Date: 12/27/00 8:59:00 PM ******/

/** file :latest rates.asp
 reports : management info   ***/
CREATE PROCEDURE  sblatestrates
@scripname varchar(10)
AS
select distinct scrip_cd, series , MARKETRATE,sell_buy 
from trade4432 t
where sauda_date = ( select max(sauda_date)  
                    from trade4432 t1 where t1.scrip_cd = t.scrip_cd and t1.series = t.series) 
and scrip_cd like ltrim(@scripname)+'%'
order by scrip_cd ,series,sell_buy

GO
