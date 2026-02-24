-- Object: PROCEDURE dbo.brsettdisp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsettdisp    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsettdisp    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsettdisp    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsettdisp    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsettdisp    Script Date: 12/27/00 8:58:45 PM ******/

CREATE PROCEDURE brsettdisp
AS
select distinct sett_type 
from sett_mst

GO
