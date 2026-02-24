-- Object: PROCEDURE dbo.ORDER_TRADE_COUNT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[ORDER_TRADE_COUNT]      
(      
@FROMDATE VARCHAR(50),      
@TODATE  VARCHAR(50)      
)      
AS      
BEGIN       
      
      
SELECT USER_ID,count(distinct order_no)OrderNoCount      
,Sum (TRADEQty * MarketRate) ORDER_VALUE,      
COUNT(distinct CONVERT(VARCHAR, SAUDA_DATE,103)) AS TRADE_COUNT,      
SUM(MarketRate*Tradeqty)AS TRADE_VALUE,'NSE'AS EXCHANGE      
 FROM HISTORY WITH(NOLOCK)      
 WHERE USER_ID IN ('23879','33166','23919','23904','23937','23885')      
 AND Sauda_date>=@FROMDATE   AND Sauda_date<=@TODATE + ' 23:59'         
 GROUP BY USER_ID      
 UNION       
 SELECT USER_ID,count(distinct order_no)OrderNoCount      
,Sum (TRADEQty * MarketRate) ORDER_VALUE,      
COUNT(distinct CONVERT(VARCHAR, SAUDA_DATE,103)) AS TRADE_COUNT,      
SUM(MarketRate*Tradeqty)AS TRADE_VALUE,'NSE'AS EXCHANGE      
 FROM SETTLEMENT WITH(NOLOCK)      
 WHERE USER_ID IN ('23879','33166','23919','23904','23937','23885')      
 AND Sauda_date>=@FROMDATE AND Sauda_date<=@TODATE + ' 23:59'         
 GROUP BY USER_ID      
       
 UNION ALL      
 SELECT USER_ID,count(distinct order_no)OrderNoCount      
,Sum (TRADEQty * MarketRate) ORDER_VALUE,      
COUNT(distinct CONVERT(VARCHAR, SAUDA_DATE,103)) AS TRADE_COUNT,      
SUM(MarketRate*Tradeqty)AS TRADE_VALUE,'BSE'AS EXCHANGE      
 FROM [AngelBSECM].BSEDB_AB.DBO.HISTORY WITH(NOLOCK)      
 WHERE USER_ID IN ('1','295','515','138','92','37','36')      
 AND Sauda_date>=@FROMDATE AND Sauda_date<=@TODATE + ' 23:59'         
 GROUP BY USER_ID      
 UNION       
 SELECT USER_ID,count(distinct order_no)OrderNoCount      
,Sum (TRADEQty * MarketRate) ORDER_VALUE,      
COUNT(distinct CONVERT(VARCHAR, SAUDA_DATE,103)) AS TRADE_COUNT,      
SUM(MarketRate*Tradeqty)AS TRADE_VALUE,'BSE'AS EXCHANGE      
 FROM [AngelBSECM].BSEDB_AB.DBO.SETTLEMENT WITH(NOLOCK)      
 WHERE USER_ID IN ('1','295','515','138','92','37','36')      
 AND Sauda_date>=@FROMDATE AND Sauda_date<=@TODATE + ' 23:59'         
 GROUP BY USER_ID      
 UNION ALL      
       
 SELECT USER_ID,count(distinct order_no)OrderNoCount      
,Sum (TRADEQty * NETRATE) ORDER_VALUE,      
COUNT(distinct CONVERT(VARCHAR, SAUDA_DATE,103)) AS TRADE_COUNT,      
SUM(TRADE_AMOUNT)AS TRADE_VALUE,'NSEFO'AS EXCHANGE      
 FROM [AngelFO].NSEFO.DBO.FOSETTLEMENT  WITH(NOLOCK)      
 WHERE USER_ID IN ('15148','15152','15214','21380','15161')      
 AND Sauda_date>=@FROMDATE AND Sauda_date<=@TODATE + ' 23:59'           
 GROUP BY USER_ID      
 UNION ALL      
       
  SELECT USER_ID,count(distinct order_no)OrderNoCount      
,Sum (TRADEQty * NETRATE) ORDER_VALUE,      
COUNT(distinct CONVERT(VARCHAR, SAUDA_DATE,103)) AS TRADE_COUNT,      
SUM(TRADE_AMOUNT)AS TRADE_VALUE,'NSX'AS EXCHANGE      
 FROM [AngelFO].NSECURFO.DBO.FOSETTLEMENT  WITH(NOLOCK)      
 WHERE USER_ID IN ('657')      
 AND Sauda_date>=@FROMDATE AND Sauda_date<=@TODATE + ' 23:59'         
 GROUP BY USER_ID      
  UNION ALL      
       
  SELECT USER_ID,count(distinct order_no)OrderNoCount      
,Sum (TRADEQty * NETRATE) ORDER_VALUE,      
COUNT(distinct CONVERT(VARCHAR, SAUDA_DATE,103)) AS TRADE_COUNT,      
SUM(TRADE_AMOUNT)AS TRADE_VALUE,'MCX'AS EXCHANGE      
 FROM [AngelCommodity].MCDX.DBO.FOSETTLEMENT  WITH(NOLOCK)      
 WHERE USER_ID IN ('25801')      
 AND Sauda_date>=@FROMDATE AND Sauda_date<=@TODATE + ' 23:59'         
 GROUP BY USER_ID      
       
 END

GO
