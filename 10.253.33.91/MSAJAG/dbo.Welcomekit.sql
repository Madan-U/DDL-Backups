-- Object: PROCEDURE dbo.Welcomekit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE procedure [dbo].[Welcomekit]  as
BEGIN
 SET NOCOUNT ON  

 
SELECT DISTINCT  
   CRN_NO,  
   APP_FORM_NO,  
   BO_PARTYCODE,  
   NAME,  
   BO_CATEGORY,  
   BO_CLIENTTYPE,  
   PAN_NO,  
   CLEA_DP_ACCTNO = CASE WHEN ISNULL((SELECT DISTINCT TOP 1 ISNULL(CLIDPA_DP_ID,'') FROM  ABVSCITRUS.CRMDB_A.dbo.CLIENT_DP_ACCTS WHERE CLIDPA_CRN_NO = CRN_NO AND CLIDPA_DEF_FLG =1 ),'')= '' THEN  
                             ISNULL((SELECT DISTINCT TOP 1 ISNULL(CLEA_DP_ACCTNO,'') FROM  ABVSCITRUS.CRMDB_A.dbo.CLIENT_EXCHANGE WHERE CLEA_CRN_NO =  CRN_NO ),'')ELSE  
                             ISNULL((SELECT DISTINCT TOP 1 ISNULL(CLIDPA_DP_ID,'') FROM  ABVSCITRUS.CRMDB_A.dbo.CLIENT_DP_ACCTS WHERE CLIDPA_CRN_NO = CRN_NO AND CLIDPA_DEF_FLG =1 ),'')  END  
into #temp4                             
  FROM      
  ABVSCITRUS.CRMDB_A.dbo.CLIENT_MASTER,  
   (  
   SELECT DISTINCT CLEA_CRN_NO   
   FROM  ABVSCITRUS.CRMDB_A.dbo.CLIENT_EXCHANGE C1 (NOLOCK)  
   WHERE ISNULL(CLEA_MIGRATE_STAT,0) = 1     
   AND NOT EXISTS (SELECT C2.CLEA_CRN_NO FROM  ABVSCITRUS.CRMDB_A.dbo.CLIENT_EXCHANGE C2 (NOLOCK) WHERE C1.CLEA_CRN_NO = C2.CLEA_CRN_NO AND CLEA_MIGRATE_STAT IS NULL /*AND CLEA_EXCHANGE_ID NOT IN (6, 7)*/)  
   ) A  
  WHERE  
   CRN_NO = CLEA_CRN_NO  AND   
    STATUS IN(5,55,14)  
   AND CREATED_DT BETWEEN   
     CONVERT(VARCHAR, CONVERT(DATETIME, getdate(), 103), 106) + ' 00:00:00' AND   
     CONVERT(VARCHAR, CONVERT(DATETIME, getdate(), 103), 106) + ' 23:59:59'  
   --AND ISNULL(APP_FORM_NO,  '') <> ''  
   --AND BO_PARTYCODE BETWEEN @FROM_CL AND @TO_CL  
            AND NOT EXISTS(SELECT CLIM_CRN_NO FROM  ABVSCITRUS.CRMDB_A.dbo.CLIENT_STATUS WHERE CLIM_CRN_NO = CRN_NO AND CLIM_STATUS = 40)  
   AND  EXISTS(SELECT APP_CRN_NO FROM  ABVSCITRUS.CRMDB_A.dbo.CLIENT_KYC_DATA WHERE APP_CRN_NO = CRN_NO AND ISNULL(APP_EMAIL,'')<>'' AND APP_HOLDER='')  
  ORDER BY  
    BO_PARTYCODE         

truncate table Welcomekit_test

insert into Welcomekit_test
select A.bo_partycode,A.name,B.corres_email_id ,B.corres_mobile_no, B.dp_id
--into Welcomekit_test
from  ABVSCITRUS.CRMDB_A.dbo.client_master a , ABVSCITRUS.CRMDB_A.dbo.api_kyc b
where
a.bo_partycode=B.BOPARTYCODE AND
CORRES_EMAIL_ID IS NOT NULL and 

A.bo_partycode in ( SELECT BO_PARTYCODE FROM #TEMP4)


     
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = '\\196.1.115.242\e\Welcomekit\'                  
SET @FILE = @PATH + 'WELCOME_DATA_' + REPLACE( CONVERT(VARCHAR(19), GETDATE(), 121),':',' ') + '.txt'                  
                
      
--DECLARE @FileName varchar(50),
DECLARE @bcpCommand varchar(2000)
--SET @FileName ='\\172.29.19.15\Public\ashok\CountryRegion.txt'
SET @bcpCommand = 'bcp "SELECT bo_partycode,Name,corres_email_id,corres_mobile_no,dp_id,'''' FROM  MSAJAG.dbo.Welcomekit_test" queryout "'
SET @bcpCommand = @bcpCommand + @File  + '" -T -c -t ^|'
--SET @bcpCommand = @bcpCommand + @File + '" -Uclassmkt -Pdd$$gnfDTVs244648ysjgZAcc -c'
EXEC xp_cmdshell @bcpCommand
        

EXEC MSDB.DBO.SP_SEND_DBMAIL                                  
@PROFILE_NAME ='bo support',                                  
@RECIPIENTS ='brijesh.parikh@angelbroking.com', 
--@COPY_RECIPIENTS='bi.dba@angelbroking.com',                                  
                 
--@FILE_ATTACHMENTS= @FILE,                                 
@BODY = 'Please find ECN LOG data into \\172.29.19.15\Public\welcomekit\ ' ,                                 
@BODY_FORMAT ='HTML',                                 
@SUBJECT ='ECN LOG'         
END            
            
SET NOCOUNT OFF

GO
