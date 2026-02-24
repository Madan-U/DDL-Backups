-- Object: PROCEDURE dbo.rpt_positionsettscrip1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_positionsettscrip1    Script Date: 04/27/2001 4:32:48 PM ******/

CREATE PROCEDURE rpt_positionsettscrip1
@settno varchar(7),
@settype varchar(3),
@partycode varchar(6),
@scripcd varchar(12),
@series varchar(3),
@sdate varchar(12)
AS
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,N_NetRate = NetRate,Sell_buy,
Sauda_date,User_id,amount = TradeQty*NetRate
from settlement 
where sett_no = @settno and sett_type = @settype and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series and left(convert(varchar,sauda_date,109),11) = @sdate
union all
select sett_no,sett_type,party_code,Scrip_Cd,series,tradeqty,N_NetRate=NetRate,Sell_buy,
Sauda_date,User_id,amount = TradeQty*NetRate
from history 
where sett_no = @settno and sett_type = @settype and party_code = @partycode
and Scrip_Cd = @scripcd and series =@series and  left(convert(varchar,sauda_date,109),11) = @sdate

GO
