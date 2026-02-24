-- Object: PROCEDURE dbo.Bserearrangebillflagnew
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Procedure  [dbo].[Bserearrangebillflagnew] (@sett_no Varchar(7),@sett_type Varchar(3)) As    
Declare   
 @@trade_no Varchar(20),  
 @@party_code Varchar(10),  
 @@participantcode Varchar(25),  
 @@scrip_cd Varchar(12),    
 @@series Varchar(3),  
 @@tmark Varchar(3),  
 @@pqty Numeric(9),   
 @@sqty Numeric(9),  
 @@ltrade_no Varchar(20),  
 @@lqty Numeric(9),   
 @@pdiff Numeric(9),  
 @@flag Cursor,  
 @@loop Cursor,  
 @@sdate Varchar(11),  
 @@edate Varchar(11),  
 @@cf Int,  
 @@lo Varchar(1),  
 @@cur Varchar(1),  
 @@icf Int   

UPDATE SETTLEMENT  
SET    BILLFLAG = (CASE   
               WHEN SELL_BUY = 1 THEN 4  
               ELSE 5  
             END),  
 TMARK = 'N'  
WHERE  SETT_NO = @Sett_no  
 AND SETT_TYPE = @Sett_type  

UPDATE ISETTLEMENT  
SET    BILLFLAG = (CASE   
               WHEN SELL_BUY = 1 THEN 4  
               ELSE 5  
             END),  
 TMARK = 'N'  
WHERE  SETT_NO = @Sett_no  
             AND SETT_TYPE = @Sett_type  
  
Exec Newupdbilltax @sett_no ,@sett_type

GO
