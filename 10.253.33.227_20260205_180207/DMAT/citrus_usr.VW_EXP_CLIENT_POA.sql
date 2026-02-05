-- Object: VIEW citrus_usr.VW_EXP_CLIENT_POA
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

  
  
    
    
CREATE view [citrus_usr].[VW_EXP_CLIENT_POA]    
as    
select dpam_acct_no RECEIPT_CODE    
,RIGHT(pc1.boid,8) BENEF_ACCNO    
,CONVERT(VARCHAR(19),SetupDate)  SLIP_DATE    
,CONVERT(vARCHAR(16),pc1.boid)         CLIENT_CODE    
,'5' PURPOSE_CODE    
,CONVERT(vARCHAR(16),MasterPOAId)    POA_ID    
,CONVERT(VARCHAR(19),right (SetupDate,4 )+'-'+substring (SetupDate,3,2)+'-'+left (SetupDate,2 )) SETUP_DATE    
,CONVERT(vARCHAR(1),'Y') OPERATE_AC    
,CONVERT(vARCHAR(1),[GPABPAFlg])   GPA_BPA_FLAG    
,CONVERT(VARCHAR(19),right ([EffFormDate],4 )+'-'+substring ([EffFormDate],3,2)+'-'+left ([EffFormDate],2 ) )   FROM_DATE    
,replace (CONVERT(VARCHAR(19),right ([EffToDate],4 )+'-'+substring ([EffToDate],3,2)+'-'+left ([EffToDate],2 )) , '--','')     TO_DATE    
,'' REMARKS    
,'E'        STAGE    
,'A'        STATUS    
,'MOD'             TRXN_TYPE    
,CONVERT(VARCHAR(19),right (BOActDt,4 )+'-'+substring (BOActDt,3,2)+'-'+left (BOActDt,2 )) [DP activation date ]    
,CONVERT(VARCHAR(19),right (AcctCreatDt,4 )+'-'+substring (AcctCreatDt,3,2)+'-'+left (AcctCreatDt,2 )) [DP creation date ]    
from dp_Acct_mstr , dps8_pc1  pc1     
left outer join     
dps8_pc5 pc5     
on pc1.boid = pc5.boid  and pc5.TypeOfTrans in ('','1','2')  
--,client_list_modified     
where pc1.boid = dpam_sba_no     
--and clic_mod_action = 'POA ACTIVATION'      
--and clic_mod_dpam_sba_no= dpam_sba_no  --and  convert(varchar(11),clic_mod_created_dt ,109) = convert(varchar(11),getdate(),109)    
and SetupDate is not null

GO
