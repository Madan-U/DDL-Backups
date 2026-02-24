-- Object: PROCEDURE dbo.MTOMSETT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.MTOMSETT    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.MTOMSETT    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.MTOMSETT    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.MTOMSETT    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.MTOMSETT    Script Date: 12/27/00 8:58:51 PM ******/

/****** Object:  Stored Procedure dbo.MTOMSETT    Script Date: 12/18/99 8:24:10 AM ******/
/*PROCEDURE FOR SETTLEMENTWISE MARK TO MARKET*/
CREATE PROCEDURE MTOMSETT AS
SELECT c3.trader,c1.Party_Code,c3.short_name,c1.Scrip_Cd,c1.markettype,c1.user_id,c1.series,
c1.Sell_buy,c1.sett_no,c2.cl_rate,       
PQTY=ISNULL((CASE SELL_BUY 
WHEN 1 THEN SUM(TRADEQTY)
END),0),
PAMT=ISNULL((CASE SELL_BUY
WHEN 1 THEN SUM(tradeqty*marketrate)
END),0),
SQTY=ISNULL((CASE SELL_BUY
WHEN 2 THEN SUM(TRADEQTY)
END),0),
SAMT=ISNULL((CASE SELL_BUY
WHEN 2 THEN SUM(tradeqty*marketrate)
END),0)
FROM settlement c1,closing c2,client1 c3,client2 c4
WHERE c1.scrip_cd = c2.scrip_cd And
      c1.series = c2.series And
      c2.market = 'NORMAL'and
      c1.party_code=c4.party_code and
      c3.cl_code=c4.cl_code  
GROUP BY c1.Party_Code,c3.short_name,c1.Scrip_Cd,c1.markettype,c1.user_id,c1.series,
c1.Sell_buy,c1.sett_no,c2.cl_rate,c3.trader
order by short_name

GO
