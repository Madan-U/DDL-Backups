-- Object: PROCEDURE dbo.brstkscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brstkscrip    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brstkscrip    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brstkscrip    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brstkscrip    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brstkscrip    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : Stock chat
    File : mbpinfo.asp
*/
CREATE PROCEDURE brstkscrip
@scrip varchar(10),
@series1 varchar(2)
AS
select scrip_cd,series,TotalQty,DHigh,DLow,Lastrate,NetPrice,NetChange,AvgRate,
TotalBQty,TotalSQty 
from ldbmkt 
where scrip_cd =@scrip and series =@series1
group by scrip_cd,series,TotalQty,DHigh,DLow,Lastrate,NetPrice,NetChange,AvgRate,
TotalBQty,TotalSQty 
order by scrip_cd,series

GO
