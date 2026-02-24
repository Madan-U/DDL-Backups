-- Object: PROCEDURE dbo.FASTTRADE_NetPosition_NSECM
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure FASTTRADE_NetPosition_NSECM ( @TradeDate Varchar(11)) AS      
SELECT PARTY_CODE,       
TRANSDATE = CONVERT(VARCHAR,SAUDA_DATE,103),      
SELL_BUY = (CASE WHEN   
   SUM(CASE WHEN SELL_BUY = 1   
     THEN TRADEQTY   
     ELSE -TRADEQTY   
                     END) > 0   
                 THEN 'BUY'  
   ELSE 'SELL'  
            END),     
SCRIP_CD,      
QTY = SUM(CASE WHEN SELL_BUY = 1   
        THEN TRADEQTY   
        ELSE -TRADEQTY   
          END),     
EXCHG = 'NSE',      
S.SETT_NO,
AMOUNT = ABS(SUM(CASE WHEN SELL_BUY = 1   
        THEN TRADEQTY * MARKETRATE  
        ELSE -TRADEQTY * MARKETRATE  
          END)),  
AVGRATE = ABS((SUM(CASE WHEN SELL_BUY = 1   
        THEN -TRADEQTY * MARKETRATE  
        ELSE TRADEQTY * MARKETRATE  
          END)) / (SUM(CASE WHEN SELL_BUY = 1   
        THEN TRADEQTY   
        ELSE -TRADEQTY   
          END)))  
FROM SETTLEMENT S, SETT_MST SM      
WHERE S.SETT_NO = SM.SETT_NO      
AND S.SETT_TYPE = SM.SETT_TYPE       
AND SEC_PAYIN > @TradeDate      
AND AUCTIONPART NOT IN ('AP', 'AR', 'FP', 'FS', 'FL', 'FA', 'FC')       
GROUP BY PARTY_CODE, CONVERT(VARCHAR,SAUDA_DATE,103), SCRIP_CD, S.SETT_NO      
HAVING SUM(CASE WHEN SELL_BUY = 1       
         THEN TRADEQTY       
  ELSE -TRADEQTY       
           END) <> 0      
ORDER BY PARTY_CODE, CONVERT(VARCHAR,SAUDA_DATE,103), SCRIP_CD, S.SETT_NO

GO
