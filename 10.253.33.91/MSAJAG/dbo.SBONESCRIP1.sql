-- Object: PROCEDURE dbo.SBONESCRIP1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SBONESCRIP1    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.SBONESCRIP1    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.SBONESCRIP1    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.SBONESCRIP1    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.SBONESCRIP1    Script Date: 12/27/00 8:59:15 PM ******/

/*** file :onescrip.asp
 report :online trading   ***/
CREATE PROCEDURE 
SBONESCRIP1 
@SCRIPNAME varchar(20),
@series varchar(50)
 AS 
select scrip_cd,series,TotalQty,DHigh,DLow,Lastrate,NetPrice,
NetChange,AvgRate,TotalBQty,TotalSQty 
       from ldbmkt 
where scrip_cd = @SCRIPNAME and series = @series
       group by scrip_cd,series,TotalQty,DHigh,DLow,
Lastrate,NetPrice,NetChange,AvgRate,TotalBQty,TotalSQty 
        order by scrip_cd,series

GO
