-- Object: PROCEDURE dbo.onlinetransaction
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.onlinetransaction    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.onlinetransaction    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.onlinetransaction    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.onlinetransaction    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.onlinetransaction    Script Date: 12/27/00 8:58:52 PM ******/

CREATE PROCEDURE onlinetransaction
@partycode varchar(10),
@mydate varchar(13)
 AS
select c1.short_name,s.party_code,s.scrip_cd,s.series,s.user_id, s.sell_buy,s.tradeqty,s.sauda_date,s.marketrate 
from trade4432 s,client1 c1,client2 c2 
where s.party_code = c2.party_code and c1.cl_code = c2.cl_code 
and s.party_code = @partycode  and s.sauda_date like @mydate +  '%'
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.user_id, s.sell_buy,s.tradeqty,s.sauda_date,s.marketrate 
UNION  
select c1.short_name,s.party_code,s.scrip_cd,s.series,s.user_id, s.sell_buy,s.tradeqty,s.sauda_date,s.marketrate
 from settlement s,client1 c1,client2 c2 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code and 
s.party_code = @partycode and s.sauda_date like  @mydate + '%' 
group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.user_id, s.sell_buy,s.tradeqty,s.sauda_date,s.marketrate 
UNION 
select c1.short_name,s.party_code,s.scrip_cd,s.series,s.user_id, s.sell_buy,s.tradeqty,s.sauda_date,s.marketrate 
from history s,client1 c1,client2 c2 where s.party_code = c2.party_code and c1.cl_code = c2.cl_code and 
s.party_code = @partycode and s.sauda_date like @mydate + '%'
 group by c1.short_name,s.party_code,s.scrip_cd,s.series,s.user_id, s.sell_buy,s.tradeqty,s.sauda_date,s.marketrate

GO
