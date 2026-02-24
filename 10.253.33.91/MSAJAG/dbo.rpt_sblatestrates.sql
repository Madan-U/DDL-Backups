-- Object: PROCEDURE dbo.rpt_sblatestrates
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sblatestrates    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sblatestrates    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sblatestrates    Script Date: 20-Mar-01 11:39:02 PM ******/





/****** Object:  Stored Procedure dbo.rpt_sblatestrates    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sblatestrates    Script Date: 12/27/00 8:58:57 PM ******/

/** file :latest rates.asp
 reports : management info   ***/
CREATE PROCEDURE  rpt_sblatestrates
@scripname varchar(10)
AS
select distinct scrip_cd, series , MARKETRATE,sell_buy 
from trade4432 t
where sauda_date = ( select max(sauda_date)  
                    from trade4432 t1 where t1.scrip_cd = t.scrip_cd and t1.series = t.series) 
and scrip_cd like ltrim(@scripname)+'%'
order by scrip_cd ,series,sell_buy

GO
