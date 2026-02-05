-- Object: VIEW citrus_usr.VW_CITRUS_DPACCACTIVATIOn_new
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


    
    
    
CREATE View [citrus_usr].[VW_CITRUS_DPACCACTIVATIOn_new]    
as    
select * from (    
select DP_ID,A.bopartycode as BO_PARTYCODE,UPPER(DP_sCHEME) as TEMPLATE_CODE,ECN_FLAG='Yes',DIS_FLAG='No',RELATIONSHIP_BRANCH as BRANCH_CD,    
RELATIONSHIP_SUBBROKER as SUBBROKER, RELATIONSHIP_TRADER as TRADER, RELATIONSHIP_REGION as REGION,RELATIONSHIP_AREA as AREA,    
ECS_FLAG =(case when LEFT(ecs,1)='Y' Then 'Yes' else 'No' END),CREATED_DATE  as CREATION_DATE    
 from ABVSCITRUS.CRMDB_A.dbo.api_kyc a,ABVSCITRUS.CRMDB_A.dbo.api_brokerage b where  Exists  (    
select  DPAM_SBA_NO from DP_ACCT_MSTR where isnull(dpam_bbo_code ,'')='' and dp_id=DPAM_SBA_NO    
and application_no=DPAM_ACCT_NO    
and DPAM_CREATED_DT>=GETDATE()-180) AND A.BOPARTYCODE=B.BOPARTYCODE      
and EXCHANGE='CDSL'    
union all    
select DP_ID,A.bopartycode,(case when DP_sCHEME='1YEAR' THEN 'ANGEL PREFERRED' else UPPER(DP_sCHEME) end) as TEMPLATE_CODE,ECN_FAG='Yes',DIS_FLAG='No', BRANCH_CD,    
 SUBBROKER=SUB_BROKER, TRADER,  REGION, AREA,    
ECS='Yes',CREATED_DATE =create_dt    
 from ABVSCITRUS.CRMDB_A.dbo.AP_ADDSEG a,ABVSCITRUS.CRMDB_A.dbo.ANAND1MSAJAGClient_Details b where dp_id in (    
select  DPAM_SBA_NO from DP_ACCT_MSTR where isnull(dpam_bbo_code ,'')=''    
and DPAM_CREATED_DT>=GETDATE()-180) AND A.BOPARTYCODE=B.CL_CODE     
and EXCHANGE='CDSL'    
 )a  --order by CREATED_DATE

GO
