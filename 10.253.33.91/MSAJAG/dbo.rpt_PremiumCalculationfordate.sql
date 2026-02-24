-- Object: PROCEDURE dbo.rpt_PremiumCalculationfordate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_PremiumCalculationfordate    Script Date: 5/11/01 6:19:51 PM ******/

CREATE PROCEDURE rpt_PremiumCalculationfordate (@partycode varchar(50), @saudadatefrom varchar(20))  AS

Select NetPremium = isnull(Sum(NetPremium),0)
from PremiumCalView
where party_code like @partycode and
convert(datetime,sauda_date,105) >= convert(datetime,@saudadatefrom,105)
and convert(datetime,sauda_date,105) <=  convert(datetime,@saudadatefrom,105)

GO
