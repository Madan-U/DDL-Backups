-- Object: PROCEDURE dbo.brbet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brbet    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brbet    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brbet    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brbet    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brbet    Script Date: 12/27/00 8:59:06 PM ******/

CREATE PROCEDURE brbet
@bet1 varchar(15),
@bet2 varchar(15),
@netchange varchar(1)
AS
select distinct scrip_cd,series from ldbmkt
where  TotalQty <> 0 and netPrice BETWEEN convert(money,@bet1)
and convert(money,@bet2)
and NetChange =@netchange
order by scrip_cd,series

GO
