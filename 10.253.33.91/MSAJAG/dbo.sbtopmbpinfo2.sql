-- Object: PROCEDURE dbo.sbtopmbpinfo2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbtopmbpinfo2    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo2    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo2    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo2    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.sbtopmbpinfo2    Script Date: 12/27/00 8:59:16 PM ******/

/***  file : topmbpinfo.asp
   report : maRKETRATE   ***/
CREATE PROCEDURE 
sbtopmbpinfo2
@bet1 VARCHAR(15),
@bet2 VARCHAR(15),
@change char(1)
AS
select distinct scrip_cd,series from ldbmkt 
where  TotalQty <> 0 and netPrice between CONVERT(MONEY,@bet1)
and CONVERT(MONEY,@bet2) and NetChange = @change
order by scrip_cd,series

GO
