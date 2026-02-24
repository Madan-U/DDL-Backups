-- Object: PROCEDURE dbo.brstockinfo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brstockinfo    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brstockinfo    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brstockinfo    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brstockinfo    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brstockinfo    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : Stock chat
    File : mbpinfo.asp
*/
CREATE PROCEDURE brstockinfo
@series varchar(2),
@scripname varchar(10)
AS
Select * from MBPINFO1 
where scrip_cd like ltrim(@scripname)+'%'
and series = @series
order by scrip_cd,series

GO
