-- Object: PROCEDURE dbo.rpt_fomemberpremium
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomemberpremium    Script Date: 5/11/01 6:19:48 PM ******/
CREATE PROCEDURE rpt_fomemberpremium

@sdate varchar(12)

AS

Select NetPremium = isnull(Sum(NetPremium),0), party_code
from PremiumCalView
where left(convert(datetime,sauda_date,109),11) >= left(convert(datetime,@sdate,109),11)
and left(convert(datetime,sauda_date,109),11) <=  left(convert(datetime,@sdate,109),11)
group by party_code

GO
