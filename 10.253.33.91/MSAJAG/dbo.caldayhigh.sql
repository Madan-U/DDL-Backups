-- Object: PROCEDURE dbo.caldayhigh
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.caldayhigh    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.caldayhigh    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.caldayhigh    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.caldayhigh    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.caldayhigh    Script Date: 12/27/00 8:58:46 PM ******/

CREATE PROCEDURE caldayhigh
@partycode varchar(10),
@month varchar(2)
 AS
select distinct convert(varchar,sauda_date,103) from history where party_code= @partycode 
and month(sauda_date)= @month
union select distinct convert(varchar,sauda_date,103) from settlement where party_code= @partycode 
and month(sauda_date)= @month 
order by convert(varchar,sauda_date,103)

GO
