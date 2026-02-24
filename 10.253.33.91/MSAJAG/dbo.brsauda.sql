-- Object: PROCEDURE dbo.brsauda
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsauda    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsauda    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsauda    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsauda    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsauda    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : mtom
   File : scriptrans.asp
*/
CREATE PROCEDURE brsauda
@br varchar(3),
@partycode varchar(10),
@scripcd varchar(10),
@series varchar(2)
AS
select sett_no,sett_type,s.party_code,Scrip_Cd,series,tradeqty,MarketRate,Sell_buy,
Sauda_date,User_id
from settlement s, client1 c1, client2 c2, branches b
where s.party_code = @partycode
and c1.cl_code = c2.cl_code
and b.short_name = c1.trader
and s.party_code = c2.party_code 
and b.branch_cd = @br
and sett_type = 'N' and billno =0 
and Scrip_Cd = @scripcd and series =@series
order by sett_no,sett_type,s.party_code,Scrip_Cd,
series,Sauda_date,Sell_buy,tradeqty,MarketRate,User_id

GO
