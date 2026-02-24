-- Object: PROCEDURE dbo.brsaudate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsaudate    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsaudate    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsaudate    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsaudate    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsaudate    Script Date: 12/27/00 8:58:45 PM ******/

/* Report : client position
    File : scriptrans
displays details of each sauda for a particular scrip for a particular client 
*/
CREATE PROCEDURE brsaudate
@br varchar(3),
@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripname varchar(10),
@series varchar(2)
AS
select s.sett_no,s.sett_type,s.party_code,s.Scrip_Cd,s.series,s.tradeqty,s.MarketRate,
s.Sell_buy,s.Sauda_date,s.User_id  
from settlement s, client1 c1 , client2 c2, branches b
where s.sett_no = @settno 
and s.sett_type = @settype 
and s.party_code = @partycode
and s.Scrip_Cd = @scripname
and s.series = @series
and c1.cl_code = c2.cl_code
and s.party_code = c2.party_code
and b.short_name = c1.trader
and b.branch_cd =@br
order by s.sett_no,s.sett_type,s.party_code,s.Scrip_Cd,s.series,s.Sauda_date,s.Sell_buy,
s.tradeqty,s.MarketRate,s.User_id

GO
