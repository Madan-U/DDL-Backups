-- Object: PROCEDURE dbo.CBO_GETDELIVERYDP2
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE  procedure CBO_GETDELIVERYDP2  
 (  
  @Dpid       VARCHAR(16),  
  @partycode  char(10),   
  @scripcd    VARCHAR(12),  
  @setttype   VARCHAR(3),  
  @series     VARCHAR(3),
  @dpClientID VARCHAR(16),  
  @flag       VARCHAR(1),  
	@STATUSID   VARCHAR(25) = 'BROKER',  
  @STATUSNAME VARCHAR(25) = 'BROKER'  
 )  
 AS  
  DECLARE  
	  @SQLVAR  int,  
	  @SQL Varchar(2000),  
	  @SB_COUNT INT  
    
 IF @STATUSID <> 'BROKER'  
  BEGIN  
   RAISERROR ('This Procedure is accessible to Broker', 16, 1)  
   RETURN  
  END  
  IF @FLAG <> 'A' AND @FLAG <> 'B' AND @FLAG <> 'C' AND @FLAG <> 'D' AND @FLAG <> 'E'AND @FLAG <> 'F'AND @FLAG <> 'G'AND @FLAG <> 'H'AND @FLAG <> 'I'AND @FLAG <> 'k'  
   BEGIN  
   RAISERROR ('Flags Not Set Properly', 16, 1)  
  RETURN  
 END  
  IF @flag = 'A'  
  BEGIN  
   SELECT  
    distinct Dpid  
    FROM  
      DeliveryDp  
   END  
  Else IF @flag = 'B'  
    BEGIN  
         Select  
           Distinct DpCltNo   
         From  
           DeliveryDp   
         Where   
           Description not Like '%POOL%' And DpId = @dpid  
         END    
   Else IF @flag = 'C'  
         BEGIN   
                      Select  
                         Distinct PARTY_CODE   
                      From  
                                      CLIENT2   
                      Where   
                                    PARTY_CODE = @partycode  
                     END  
    Else IF @flag = 'D'  
    BEGIN  
         Select  
           Distinct Series  
         From  
           scrip2   
         where  
          Scrip_CD = @scripcd  
         END   
     Else IF @flag = 'E'  
    BEGIN  
         Select  
           Distinct sett_type  
         From  
           Msajag.Dbo.Sett_Mst   
         END  
       Else IF @flag = 'F'  
    BEGIN  
         Select  
           Distinct sett_type  
         From  
           bsedb.DBO.Sett_Mst   
         END    
       Else IF @flag = 'G'  
    BEGIN  
         Select  
           Distinct sett_no  
         From  
           Msajag.Dbo.Sett_Mst   
         Where  
           sett_type = @setttype  
         END   
       Else IF @flag = 'H'  
    BEGIN  
         Select  
           Distinct sett_no  
         From  
           bsedb.DBO.Sett_Mst   
         Where  
           sett_type = @setttype  
         END  
      Else IF @flag = 'I'  
    	BEGIN  
         Select  
           Isnull(Sum(Qty),0) AS QTY  
         From  
           DelTrans   
         Where  
           Party_Code = @partycode And Scrip_Cd = @scripcd And Series = @series And Certno <> 'AUCTION'  
					 And Filler2 = 1 And DrCr = 'D' And Delivered = '0'And BCltDpId = @dpClientID
	     END  
       Else IF @flag = 'k'  

    	BEGIN  
         Select  
           Distinct RefNo  
         From  
           DelSegment  
         END

GO
