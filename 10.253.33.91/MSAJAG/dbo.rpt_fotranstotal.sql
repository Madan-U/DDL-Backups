-- Object: PROCEDURE dbo.rpt_fotranstotal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotranstotal    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotranstotal    Script Date: 5/7/2001 9:02:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotranstotal    Script Date: 5/5/2001 2:43:41 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotranstotal    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotranstotal    Script Date: 4/30/01 5:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotranstotal    Script Date: 10/26/00 6:04:45 PM ******/


/*
written by neelambari on 27 feb 2001
*/
 CREATE procedure rpt_fotranstotal 
@fdatest smalldatetime,
@fdateend smalldatetime,
@partycode varchar(10)
as
select ts.series_code ,tradingfees = sum(ts.tradingfees),
 clearingfees = sum(ts.clearingfees) from fotmsettlement ts ,fotminfo tm
where ts.sauda_date >= @fdatest
 and ts.sauda_date <= @fdateend 
and  ts.tm_code=tm.tm_code and
      tm.tm_code=(select tm_code from bfotminfo where party_code =@partycode)
group by ts.series_code

GO
