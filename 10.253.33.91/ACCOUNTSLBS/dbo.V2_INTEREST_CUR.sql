-- Object: PROCEDURE dbo.V2_INTEREST_CUR
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE PROCEDURE [dbo].[V2_INTEREST_CUR]      
(      
        @@FROMDATE VARCHAR(11),  
        @@TODATE VARCHAR(11)  
)      
      
AS      
      
/*==============================================================================================================      
        EXEC V2_INTEREST_CUR      
                @@FROMDATE VARCHAR(11),  
                @@TODATE VARCHAR(11)  
==============================================================================================================*/      
      
        SET NOCOUNT ON    
    
 DECLARE     
  @@VDATE DATETIME,     
  @@BALDATE INT     
    
 SET @@VDATE = @@FROMDATE     
    
 WHILE @@VDATE <= @@TODATE     
 BEGIN     
  SET @@BALDATE = CONVERT(INT,CONVERT(VARCHAR,@@VDATE,112))    
    
  DELETE FROM V2_INTEREST WHERE INTDATE = @@BALDATE    
    
  INSERT INTO V2_INTEREST EXEC V2_INTEREST_CAL @@BALDATE    
    
  SET @@VDATE = @@VDATE + 1    
 END

GO
