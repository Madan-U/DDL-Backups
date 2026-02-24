-- Object: PROCEDURE dbo.Rearrangetrdflag
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE [dbo].[Rearrangetrdflag]      
AS      
  UPDATE TRADE  
  SET    SETTFLAG = (CASE   
                       WHEN SELL_BUY = 1 THEN 4  
                       ELSE 5  
                     END)

GO
