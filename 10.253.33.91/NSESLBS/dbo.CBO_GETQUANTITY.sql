-- Object: PROCEDURE dbo.CBO_GETQUANTITY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

create  procedure CBO_GETQUANTITY 
 (  
  @Dpid       VARCHAR(16),  
  @partycode  char(10),   
  @scripcd    VARCHAR(12),  
  @setttype   VARCHAR(3),
  @settno     varchar(7),
  @series     VARCHAR(3),
  @dpClientID VARCHAR(16),  
  @STATUSID   VARCHAR(25) = 'BROKER',  
  @STATUSNAME VARCHAR(25) = 'BROKER'  
 )  
 AS  
  IF @STATUSID <> 'BROKER'  
  BEGIN  
   RAISERROR ('This Procedure is accessible to Broker', 16, 1)  
   RETURN  
  END  
 	BEGIN  
         Select  
           Isnull(Sum(Qty),0) AS QTY  
         From  
           DelTrans   
         Where  
           Party_Code = @partycode And Scrip_Cd = @scripcd And Series = @series And Certno <> 'AUCTION'  
					 And Filler2 = 1 And DrCr = 'D' And Delivered = '0' And BDpId = @Dpid And BCltDpId = @dpClientID
					 And Party_code <> 'BROKER' AND Sett_Type = @setttype and Sett_No = @settno
       END

GO
