-- Object: PROCEDURE dbo.RECEIPT_DATA_NEW_ALLINONE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[RECEIPT_DATA_NEW_ALLINONE]                            
(                            
  @FROMDATE VARCHAR(11),                            
  @TODATE VARCHAR(11)                        
 )                                     
 AS                            
 BEGIN        
         
 EXEC [AngelBSECM].ACCOUNT_AB.DBO.RECEIPT_DATA_NEW '@FROMDATE','@TODATE'       
         
 EXEC RECEIPT_DATA_NEW '@FROMDATE','@TODATE'        
          
 EXEC [AngelFO].ACCOUNTFO.DBO.RECEIPT_DATA_NEW '@FROMDATE','@TODATE'       
         
 EXEC [AngelFO].ACCOUNTCURFO.DBO.RECEIPT_DATA_NEW '@FROMDATE','@TODATE'      
         
 EXEC [AngelCommodity].ACCOUNTMCDX.DBO.RECEIPT_DATA_NEW '@FROMDATE','@TODATE'        
         
 EXEC [AngelCommodity].ACCOUNTMCDXCDS.DBO.RECEIPT_DATA_NEW '@FROMDATE','@TODATE'       
         
 EXEC [AngelCommodity].ACCOUNTNCDX.DBO.RECEIPT_DATA_NEW '@FROMDATE','@TODATE'        
         
 END

GO
