-- Object: PROCEDURE dbo.brmbpscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brmbpscrip    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brmbpscrip    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brmbpscrip    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brmbpscrip    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brmbpscrip    Script Date: 12/27/00 8:59:06 PM ******/

/*  Report : Market Report
     File : mbpinfo.asp
*/
CREATE PROCEDURE brmbpscrip
@scripname varchar(20),
@series varchar(3)
AS
Select * from MBPINFO1 
where scrip_cd like ltrim(@scripname)+'%'
and series = @series order by scrip_cd,series

GO
