-- Object: PROCEDURE dbo.rpt_fobrokser1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fobrokser1    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobrokser1    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobrokser1    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobrokser1    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobrokser1    Script Date: 4/30/01 5:50:07 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fobrokser1    Script Date: 10/26/00 6:04:40 PM ******/


CREATE PROCEDURE rpt_fobrokser1

@fdate varchar(12),
@tdate varchar(12),
@fpartycode varchar(10),
@tpartycode varchar(10),
@flag int

AS

if @flag = 0 
begin
	select brokapplied = sum(brokapplied*tradeqty), servicetax = sum(service_tax), sdate = convert(varchar,sauda_date,106),ndate=convert(varchar,sauda_date,101),
	party_code
	from fosettlement
	where sauda_date >= @fdate and sauda_date  <= @tdate + ' 23:59'
	and party_code  >=  @fpartycode  and party_code  <=  @tpartycode  
	group by convert(varchar,sauda_date,101),convert(varchar,sauda_date,106), party_code
	order by party_code,convert(varchar,sauda_date,101)
end 
else if @flag = 1 
begin
	select brokapplied = sum(brokapplied*tradeqty), servicetax = sum(service_tax), sdate = convert(varchar,sauda_date,106),ndate=convert(varchar,sauda_date,101),
	party_code
	from fosettlement
	where sauda_date >= @fdate and sauda_date  <= @tdate + ' 23:59'
	and party_code  like ltrim(@fpartycode) + '%'
	group by convert(varchar,sauda_date,101),convert(varchar,sauda_date,106), party_code
	order by party_code,convert(varchar,sauda_date,101)
end

GO
