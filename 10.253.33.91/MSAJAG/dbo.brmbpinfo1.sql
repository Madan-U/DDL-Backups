-- Object: PROCEDURE dbo.brmbpinfo1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brmbpinfo1    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo1    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo1    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo1    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo1    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : Market Report
    File : mbpinfonew.asp
shows scrip highlow price, last rate etc
*/
CREATE PROCEDURE brmbpinfo1
@scrip varchar(12),
@series1 varchar(3)
AS
select scrip_cd,series,isnull(TotalQty,0),isnull(DHigh,0),isnull(DLow,0),isnull(Lastrate,0),isnull(NetPrice,0),isnull(NetChange,0),isnull(AvgRate,0),
isnull(TotalBQty,0),isnull(TotalSQty,0) 
from ldbmkt 
where scrip_cd = @scrip and series = @series1
group by scrip_cd,series,TotalQty,DHigh,DLow,Lastrate,NetPrice,NetChange,AvgRate,
TotalBQty,TotalSQty 
order by scrip_cd,series

GO
