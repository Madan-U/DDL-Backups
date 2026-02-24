-- Object: PROCEDURE dbo.AUTO_PARYOUT_MARK_VIEW
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[AUTO_PARYOUT_MARK_VIEW] ( @PARTY_CODE VARCHAR(10))  
AS  
  
--INSERT INTO Client_AUTO_PARYOUT_MARK (PARTY_CODE,PROCESS_FLAG,REF_SOURCE,PROCESS_DATE)  
--SELECT @PARTY_CODE,@PROCESS_FLAG,@REF_SOURCE,@PROCESS_DATE  
  
  
--Declare @Client_Status varchar(2)  
  
--select @Client_Status =count(1) FROM CLIENT_BROK_DETAILS WHERE CL_CODE = @PARTY_CODE AND SEGMENT ='CAPITAL' AND ISNULL(DEACTIVE_VALUE,'')<>'C'  
  
--IF @Client_Status='0'  
--    BEGIN   
--  Select Remark = 'Client Not Registered in EQUITY Segment'  
--  Return   
--    End   
  
SELECT  Sec_PARYOUT = 'Yes' ---(CASE WHEN Debit_Balance ='0' Then 'Yes' Else 'No' end)  
---FROM CLIENT_BROK_DETAILS C WHERE   CL_CODE = @PARTY_CODE AND SEGMENT ='CAPITAL'

GO
