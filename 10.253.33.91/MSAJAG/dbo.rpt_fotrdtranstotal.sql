-- Object: PROCEDURE dbo.rpt_fotrdtranstotal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotrdtranstotal    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrdtranstotal    Script Date: 5/7/2001 9:02:53 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrdtranstotal    Script Date: 5/5/2001 2:43:41 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrdtranstotal    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrdtranstotal    Script Date: 4/30/01 5:50:21 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotrdtranstotal    Script Date: 10/26/00 6:04:46 PM ******/


CREATE procedure rpt_fotrdtranstotal 

@fdatest varchar(12),
@fdateend varchar(12),
@partycode varchar(10)

as

select ts.expirydate , condate=convert(varchar,ts.expirydate,106), ts.inst_type , ts.symbol ,tradingfees = sum(ts.tradingfees),
clearingfees = sum(ts.clearingfees) , Strike_price, Option_type
from fotmsettlement ts ,fotminfo tm
where left(convert(varchar,ts.ActivityTime,109),11) >= @fdatest
and left(convert(varchar,ts.ActivityTime,109),11)  <= @fdateend +' 23:59:59'
and  ts.tm_code=tm.tm_code and
tm.tm_code=(select tm_code from fotminfo where party_code =@partycode)
group by ts.expirydate , ts.inst_type , ts.symbol , Strike_price, Option_type

GO
