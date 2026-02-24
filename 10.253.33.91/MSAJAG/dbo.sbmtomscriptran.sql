-- Object: PROCEDURE dbo.sbmtomscriptran
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomscriptran    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptran    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptran    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptran    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomscriptran    Script Date: 12/27/00 8:59:00 PM ******/

/***  file :scriptrans.asp
      report : mtom   ***/
CREATE PROCEDURE
sbmtomscriptran
@partycode varchar(10),
@scripname varchar(10),
@series varchar(2),
@sub_broker varchar(15)
AS
select s.sett_no,s.sett_type,s.party_code,s.Scrip_Cd,s.series,s.tradeqty,s.MarketRate,s.Sell_buy,s.Sauda_date,User_id 
from settlement s,client1 c1,client2 c2,subbrokers sb
where s.party_code =@partycode and s.sett_type = 'N' and s.billno =0 and s.Scrip_Cd = @scripname  and s.series =@series
and c1.cl_code=c2.cl_code and s.party_code=c2.party_code and 
c1.sub_broker=sb.sub_broker and sb.sub_broker=@sub_broker
order by s.sett_no,s.sett_type,s.party_code,s.Scrip_Cd,s.series,s.Sauda_date,s.Sell_buy,s.tradeqty,s.MarketRate,User_id

GO
