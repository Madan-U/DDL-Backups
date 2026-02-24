-- Object: PROCEDURE dbo.sbright5
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbright5    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbright5    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbright5    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbright5    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbright5    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE
sbright5
@partycode varchar(10),
@inthismonth varchar(11)
 AS
select distinct convert(varchar,sauda_date,103) 
from history 
where party_code= @partycode and month(sauda_date)= @inthismonth
union 
select distinct convert(varchar,sauda_date,103) 
from settlement
 where party_code= @partycode and month(sauda_date)= @inthismonth 
order by convert(varchar,sauda_date,103)

GO
