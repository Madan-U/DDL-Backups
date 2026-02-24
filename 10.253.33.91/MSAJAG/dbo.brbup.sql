-- Object: PROCEDURE dbo.brbup
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brbup    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brbup    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brbup    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brbup    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brbup    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : Market Report
     File : mbpinfobup.asp
*/
CREATE PROCEDURE  brbup
@scripname varchar(10),
@series varchar(2)
AS
Select * from MBPINFO 
where scrip_cd like ltrim(@scripname)+'%'
and series = @series 
order by scrip_cd,series,recno

GO
