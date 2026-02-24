-- Object: PROCEDURE dbo.rpt_PremiumCalculation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_PremiumCalculation    Script Date: 5/11/01 6:19:50 PM ******/

CREATE PROCEDURE rpt_PremiumCalculation (@partycode varchar(50), @saudadatefrom varchar(10), @saudadateto varchar(10))  AS

Select left(convert(varchar,sauda_date,105),10),
party_code,
inst_type,
symbol,
option_type,
strike_price,
markettype,
isnull(sum(PremiumReceivable),0) PremiumReceivable,
 isnull(sum(PremiumPayable),0) PremiumPayable,
isnull(Sum(NetPremium),0) NetPremium,
sec_name,
isnull(sum(pqty),0) pqty,
isnull(sum(sqty),0) sqty
from PremiumCalView
where party_code like @partycode and
left (convert(datetime,sauda_date,105),10) >= left(convert(datetime,@saudadatefrom,105),10)
and left (convert(datetime,sauda_date,105),10) <=  left(convert(datetime,@saudadateto,105),10)
group by left(convert(varchar,sauda_date,105),10),party_code,inst_type,symbol,option_type,strike_price,markettype,sec_name

GO
