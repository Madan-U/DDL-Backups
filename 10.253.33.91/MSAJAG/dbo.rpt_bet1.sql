-- Object: PROCEDURE dbo.rpt_bet1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_bet1    Script Date: 04/27/2001 4:32:33 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bet1    Script Date: 3/21/01 12:50:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bet1    Script Date: 20-Mar-01 11:38:54 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bet1    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bet1    Script Date: 12/27/00 8:59:08 PM ******/

CREATE PROCEDURE rpt_bet1
@bet1 varchar(15),
@bet2 varchar(15),
@change varchar(3)
AS
select distinct scrip_cd,series from ldbmkt 
where  TotalQty <> 0 and netPrice between convert(money,@bet1) and convert(money,@bet2)
and NetChange = @change
order by scrip_cd,series

GO
