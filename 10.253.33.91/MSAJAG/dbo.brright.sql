-- Object: PROCEDURE dbo.brright
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brright    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brright    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brright    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brright    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brright    Script Date: 12/27/00 8:58:45 PM ******/

/*  Report : Market Report 
     File : tirght.asp
*/
CREATE PROCEDURE brright
@partycode varchar(10),
@sdate varchar(10)
AS
select distinct convert(varchar,sauda_date,103) 
from history 
where party_code= @partycode and month(sauda_date)=@sdate
union 
select distinct convert(varchar,sauda_date,103) 
from settlement 
where party_code= @partycode and month(sauda_date)=@sdate
order by convert(varchar,sauda_date,103)

GO
