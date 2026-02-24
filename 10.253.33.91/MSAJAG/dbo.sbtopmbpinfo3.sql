-- Object: PROCEDURE dbo.sbtopmbpinfo3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtopmbpinfo3    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo3    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo3    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo3    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo3    Script Date: 12/27/00 8:59:16 PM ******/

CREATE PROCEDURE 
sbtopmbpinfo3
@bet1 varchar(10),
@bet2  varchar(10),
@change char(1)
 AS
select distinct scrip_cd,series from ldbmkt 
where  TotalQty <> 0 and netPrice between convert(money,ltrim(@bet1)) and  convert(money,ltrim(@bet2))
and NetChange = ltrim(@change)
order by scrip_cd,series

GO
