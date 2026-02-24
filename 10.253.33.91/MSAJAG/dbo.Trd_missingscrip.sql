-- Object: PROCEDURE dbo.Trd_missingscrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure Dbo.trd_missingscrip    Script Date: 01/15/2005 1:20:16 Pm ******/  
CREATE  Proc Trd_missingscrip As    
Set Nocount On   
  
Set Transaction Isolation Level Read Uncommitted   
  
  SELECT DISTINCT SCRIP_CD,
                  SERIES
  FROM   TRADE
  WHERE  NOT EXISTS (SELECT SCRIP_CD
                     FROM   SCRIP2 S2,
                            SCRIP1 S1
                     WHERE  TRADE.SCRIP_CD = S2.SCRIP_CD
			    AND TRADE.SERIES = S2.SERIES
                            AND S1.CO_CODE = S2.CO_CODE
                            AND S1.SERIES = S2.SERIES)

GO
