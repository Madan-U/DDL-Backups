-- Object: PROCEDURE dbo.RECEIPT_DATA_ALLINONE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[RECEIPT_DATA_ALLINONE]                          
(                          
  @FROMDATE VARCHAR(11),                          
  @TODATE VARCHAR(11),          
  @VTYP VARCHAR (11)                       
 )                                   
 AS                          
 BEGIN      
       
 EXEC [AngelBSECM].ACCOUNT_AB.DBO.RECEIPT_DATA '@FROMDATE','@TODATE',@VTYP      
       
 EXEC RECEIPT_DATA_NIK '@FROMDATE','@TODATE',@VTYP      
        
 EXEC [AngelFO].ACCOUNTFO.DBO.RECEIPT_DATA '@FROMDATE','@TODATE',@VTYP      
       
 EXEC [AngelFO].ACCOUNTCURFO.DBO.RECEIPT_DATA '@FROMDATE','@TODATE',@VTYP      
       
 EXEC [AngelCommodity].ACCOUNTMCDX.DBO.RECEIPT_DATA '@FROMDATE','@TODATE',@VTYP      
       
 EXEC [AngelCommodity].ACCOUNTMCDXCDS.DBO.RECEIPT_DATA '@FROMDATE','@TODATE',@VTYP      
       
 EXEC [AngelCommodity].ACCOUNTNCDX.DBO.RECEIPT_DATA '@FROMDATE','@TODATE',@VTYP      
       
 END

GO
