-- Object: VIEW citrus_usr.VW_EXP_NEWCLIENT_POA_TEST
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

  
  
  
  
CREATE view [citrus_usr].[VW_EXP_NEWCLIENT_POA_TEST]        
as        
select DISTINCT dpam_acct_no RECEIPT_CODE        
,RIGHT(dpam_sba_no,8) BENEF_ACCNO        
,CONVERT(VARCHAR(19),SUBSTRING(SetupDate,5,4) + '-' + SUBSTRING(SetupDate,3,2) + '-' + SUBSTRING(SetupDate,1,2))  SLIP_DATE        
,CONVERT(vARCHAR(16),dpam_sba_no)  CLIENT_CODE        
,'5' PURPOSE_CODE        
,CONVERT(vARCHAR(16),MasterPOAId) POA_ID        
,CONVERT(VARCHAR(19),SUBSTRING(SetupDate,5,4) + '-' + SUBSTRING(SetupDate,3,2) + '-' + SUBSTRING(SetupDate,1,2))    SETUP_DATE        
,'Y' OPERATE_AC        
,convert(varchar(1),[GPABPAFlg] )          GPA_BPA_FLAG        
,CONVERT(VARCHAR(19),SUBSTRING(SetupDate,5,4) + '-' + SUBSTRING(SetupDate,3,2) + '-' + SUBSTRING(SetupDate,1,2))      FROM_DATE        
,CONVERT(VARCHAR(19),null)       TO_DATE        
,''   REMARKS        
,'I'  STAGE        
,'A'  STATUS        
,'' TRXN_TYPE        
,CONVERT(VARCHAR(16),dpam_sba_no) CDSL_CLIENT_CODE        
,CONVERT(VARCHAR(10),[DPAM_BBO_CODE]) NISE_PARTY_CODE        
--,CONVERT(VARCHAR(19),SUBSTRING(BOActDt,5,4) + '-' + SUBSTRING(BOActDt,3,2) + '-' + SUBSTRING(BOActDt,1,2))  [DP_activation_date]        
--,CONVERT(VARCHAR(19),SUBSTRING(AcctCreatDt,5,4) + '-' + SUBSTRING(AcctCreatDt,3,2) + '-' + SUBSTRING(AcctCreatDt,1,2))  [DP_creation_date]        
from citrus_usr.dp_acct_mstr --, citrus_usr.dps8_pc1 pc1        
left outer join citrus_usr.dps8_pc5 pc5 on  dpam_sba_no = pc5.boid  and pc5.TypeOfTrans in ('','1','2')        
--where dpam_sba_no = pc1.boid ---AND SetupDate IS NOT NULL  
  --SELECT * FROM dp_acct_mstr

GO
