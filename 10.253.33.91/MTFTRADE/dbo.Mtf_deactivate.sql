-- Object: PROCEDURE dbo.Mtf_deactivate
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

  
CREATE Proc Mtf_deactivate (@party_code varchar(10))  
as   
  
DECLARE @CNT INT  
  
SELECT @CNT = COUNT(1) FROM TBLCLIENTMARGIN WHERE Party_Code =@party_code AND TO_DATE <=GETDATE()  
  
IF @CNT >1   
 BEGIN   
  SELECT 'Party Code Already Deactivated'  
  RETURN  
 END    
  
 SET @CNT =0  
  
SELECT @CNT =COUNT(1) FROM TBLCLIENTMARGIN WHERE Party_Code =@party_code    
IF @CNT =0  
 BEGIN   
  SELECT 'Party Code Not exist for MTF Deacivation'  
  RETURN  
END    
  
   
INSERT INTO TBLCLIENTMARGIN_MAKER_CHECKER  
SELECT UPPER(T.PARTY_CODE),MARGIN_FUNDING,MARGIN_INTEREST,SANCTIONED_AMT,MAX_AMT,MIN_COVER,FROM_DATE=CONVERT(VARCHAR(11),GETDATE(),120),TO_DATE,  
ENTERED_BY='INHOUSE',  
ENTERED_DATE=CONVERT(VARCHAR(11),GETDATE(),120),AUTO_RMS,REMARKS,DOC_TYPE='OTHER^',FY_DOC  
,'M','EDIT','Y' FROM TBLCLIENTMARGIN T WHERE Party_Code =@party_code  
  
--SELECT 'Party Code Deactivated' as MSG

GO
