-- Object: PROCEDURE dbo.ROP_PARTY_ACCOUNT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[ROP_PARTY_ACCOUNT]  
AS  
  
SET NOCOUNT ON  
 update client1 set short_name=ltrim(rtrim(replace(short_name,'(c)',''))),  
 long_name=ltrim(rtrim(replace(long_name,'(c)','')))  
 where cl_code in (select cl_code from client2 where party_code IN   
 (SELECT CLIENT_CODE FROM ABVSKYCMIS.KYC.DBO.closing_master WHERE INACT_DATE > GETDATE() AND Segment IN ('ACDLCM','ALL')   
))    
  
 update client5 set inactivefrom=(B.inact_date) FROM   
 (SELECT X.*,Y.CL_cODE FROM ABVSKYCMIS.KYC.DBO.closing_master X, CLIENT2 Y   
 WHERE X.CLIENT_cODE=Y.PARTY_CODE AND INACT_DATE > GETDATE() AND Segment IN ('ACDLCM','ALL') ) B   
 WHERE client5.CL_cODE=B.CL_CODE    
  
 UPDATE client5 SET p_address1 =isnull(b.remark,b.reason) from   
(SELECT segment,remark,client_code,reason from ABVSKYCMIS.KYC.DBO.closing_master where INACT_DATE > GETDATE()   
AND Segment IN ('ACDLCM','ALL')) b   
where b.client_Code=client5.cl_code   
SET NOCOUNT OFF

GO
