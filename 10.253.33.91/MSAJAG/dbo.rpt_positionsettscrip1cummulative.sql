-- Object: PROCEDURE dbo.rpt_positionsettscrip1cummulative
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_positionsettscrip1cummulative    Script Date: 04/27/2001 4:32:48 PM ******/
CREATE PROCEDURE rpt_positionsettscrip1cummulative
@settno varchar(7),
@settype varchar(3),
@partycode varchar(6),
@scripcd varchar(12),
@series varchar(3)
AS
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)
from settlement 
where sett_no = @settno and sett_type = @settype and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series
group by sell_buy, sauda_date
union all
select qty = sum(tradeqty), sell_buy, sauda_date = left(convert(varchar,sauda_date,109),11)
from history 
where sett_no = @settno and sett_type = @settype and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series
group by sell_buy, sauda_date

GO
