-- Object: PROCEDURE dbo.SBINFO10A
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SBINFO10A    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.SBINFO10A    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.SBINFO10A    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.SBINFO10A    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.SBINFO10A    Script Date: 12/27/00 8:59:15 PM ******/

CREATE PROCEDURE SBINFO10A
@SCRIP VARCHAR(20),
@SERIES1 VARCHAR(50)
 AS
select scrip_cd,series,isnull(TotalQty,0),isnull(DHigh,0),isnull(DLow,0),isnull(Lastrate,0),
isnull(NetPrice,0),NetChange,isnull(AvgRate,0),TotalBQty,TotalSQty 
        from ldbmkt where scrip_cd =ltrim(@SCRIP)
and series = ltrim(@SERIES1)
        group by scrip_cd,series,TotalQty,DHigh,DLow,
Lastrate,NetPrice,NetChange,AvgRate,TotalBQty,TotalSQty
        order by scrip_cd,series

GO
