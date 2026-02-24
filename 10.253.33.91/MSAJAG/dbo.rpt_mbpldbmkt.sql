-- Object: PROCEDURE dbo.rpt_mbpldbmkt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mbpldbmkt    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpldbmkt    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpldbmkt    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpldbmkt    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpldbmkt    Script Date: 12/27/00 8:59:13 PM ******/

CREATE PROCEDURE rpt_mbpldbmkt
@scripcd varchar(10),
@series varchar(2)
AS
select scrip_cd,series,isnull(TotalQty,0),isnull(DHigh,0),isnull(DLow,0),isnull(Lastrate,0),
isnull(NetPrice,0),NetChange,isnull(AvgRate,0),TotalBQty,TotalSQty 
from ldbmkt 
where scrip_cd = @scripcd and series = @series
group by scrip_cd,series,TotalQty,DHigh,DLow,Lastrate,NetPrice,
NetChange,AvgRate,TotalBQty,TotalSQty 
order by scrip_cd,series

GO
