-- Object: PROCEDURE dbo.brmbpinfo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brmbpinfo    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brmbpinfo    Script Date: 12/27/00 8:59:06 PM ******/

/* Report : Market rate 
    File : mbpinfoscrips.asp
displays selected scrip from ldbmkt
*/
CREATE PROCEDURE brmbpinfo
@scripcd varchar(12)
AS
select distinct scrip_cd,series 
from ldbmkt 
where scrip_cd like ltrim(@scripcd)+'%' and TotalQty <> 0 
order by scrip_cd,series

GO
