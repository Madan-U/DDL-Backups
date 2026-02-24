-- Object: PROCEDURE dbo.FoUnDoShortFallAdjustment
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC FoUnDoShortFallAdjustment    
 (    
  @mdate varchar(11)     
 ) AS        
BEGIN         
    
 --- UPDATE TRTYPE IN DETLTRANS TABLE (MSAJAG)    
 UPDATE MSAJAG.DBO.DELTRANS SET TRTYPE = 904 FROM MSAJAG.DBO.FoMarginShortFallAdjusted AS A, MSAJAG.DBO.DELTRANS  AS B     
  WHERE A.Sno = B.Sno AND InternalExchange= 'NSE' --A.Exchange = 'NSE' AND A.Segment = 'CAPITAL'    
  AND MarginDate LIKE @mdate +'%' AND Delivered = '0' AND TrType = 1002  
    
 --- UPDATE TRTYPE IN DETLTRANS TABLE (BSEDB)    
 UPDATE BSEDB.DBO.DELTRANS SET TRTYPE = 904 FROM MSAJAG.DBO.FoMarginShortFallAdjusted AS A, BSEDB.DBO.DELTRANS  AS B     
  WHERE A.Sno = B.Sno AND A.Exchange = 'BSE' AND A.Segment = 'CAPITAL'     
  AND MarginDate LIKE @mdate +'%' AND Delivered = '0' AND TrType = 1002 
    
-- --  --- Update the ShortFallAdjustedMargin    
 UPDATE MSAJAG.DBO.FoClientMarginReliable SET     
  ShortFallMarginAdjustedNSE = 0,    
  ShortFallMarginAdjustedBSE = 0,    
  ShortFallMarginAdjustedPOA = 0,    
  RMSExcessAmount = 0    
  FROM MSAJAG.DBO.FoClientMarginReliable AS A, MSAJAG.DBO.FoMarginShortFallAdjusted AS B    
  WHERE A.Margindate LIKE @mdate +'%' AND A.Party_Code = B.Party_Code    

/*
 --- Remove the records in ShortFallAdjustedMargin 
 DELETE FROM NSEFO.DBO.FoClientMarginReliable WHERE Margindate LIKE @mdate +'%'     

 --- Remove the records in ShortFallAdjustedMargin 
 DELETE FROM MSAJAG.DBO.FoClientMarginReliable WHERE Margindate LIKE @mdate +'%'     
*/
    
 --- Remove the MarginFall Adjustment entries    
 DELETE FROM MSAJAG.DBO.FoMarginShortFallAdjusted WHERE Margindate LIKE @mdate +'%'     
    
 --- Remove the adjusted free balance entries    
 DELETE FROM MSAJAG.DBO.FoPOAMarginShortFallAdjusted WHERE Start_Date LIKE @mdate +'%'     
    
END    
      
/*    
    
EXEC FoUnDoShortFallAdjustment 'JUL 24 2007'    

    
*/

GO
