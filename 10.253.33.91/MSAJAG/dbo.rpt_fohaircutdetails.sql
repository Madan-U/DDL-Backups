-- Object: PROCEDURE dbo.rpt_fohaircutdetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fohaircutdetails    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohaircutdetails    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohaircutdetails    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fohaircutdetails    Script Date: 5/5/2001 1:24:12 PM ******/
CREATE PROCEDURE rpt_fohaircutdetails

@code varchar(10),
@scripcd varchar(10),
@series varchar(5),
@sdate varchar(12)

AS

select * from fohaircutinfo 
where party_code = @code
and exchange = 'NSE'
and markettype like 'FUT%' 
and scrip_cd = @scripcd
and series = @series
and edate = (select max(edate) from fohaircutinfo
	           where party_code = @code
                          and exchange = 'NSE'
	          and markettype like 'FUT%' 
	          and scrip_cd = @scripcd
	          and series = @series
	          and edate <= @sdate)

GO
