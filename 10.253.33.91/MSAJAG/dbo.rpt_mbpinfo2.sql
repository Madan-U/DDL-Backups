-- Object: PROCEDURE dbo.rpt_mbpinfo2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mbpinfo2    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo2    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo2    Script Date: 20-Mar-01 11:39:00 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo2    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mbpinfo2    Script Date: 12/27/00 8:59:13 PM ******/

CREATE PROCEDURE rpt_mbpinfo2
@scripcd varchar(7),
@series varchar(2)
AS
select scrip_cd,series,isnull(TotalQty,0),isnull(DHigh,0),isnull(DLow,0),isnull(Lastrate,0),
isnull(NetPrice,0),isnull(NetChange,0),isnull(AvgRate,0),isnull(TotalBQty,0),isnull(TotalSQty ,0)
from ldbmkt where scrip_cd = @scripcd and series = @series
group by scrip_cd,series,TotalQty,DHigh,DLow,Lastrate,NetPrice,NetChange,AvgRate,
TotalBQty,TotalSQty 
order by scrip_cd,series

GO
