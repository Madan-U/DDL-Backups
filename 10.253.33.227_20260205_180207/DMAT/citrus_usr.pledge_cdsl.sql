-- Object: VIEW citrus_usr.pledge_cdsl
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE view [citrus_usr].[pledge_cdsl]  
as
select  dpm_dpid source_dpid , CDSHM_BEN_ACCT_NO source_account  
,isnull(ACCP_VALUE ,'') bbo_code  
 ,CDSHM_ISIN isin  
 ,ISIN_NAME [isin name]  
 ,case when cdshm_tratm_cd in ('2230','2246') and cdshm_tratm_type_desc = 'PLEDGE' then sum(cdshm_qty) 
when cdshm_tratm_cd in ('2280') and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE') then 
sum(cdshm_qty)
 else 0 end QTY 
   
,CDSHM_COUNTER_DPID  target_dpid  
 ,CDSHM_COUNTER_BOID  target_account   
 --,CDSHM_TRANSACTION_DT tras_dt  
,CDSHM_TRANS_NO pledgeno  
from cdsl_holding_dtls with(nolock)  
left outer join account_properties with(nolock) on ACCP_CLISBA_ID = CDSHM_DPAM_ID and ACCP_ACCPM_PROP_CD ='bbo_code'  
,isin_mstr  with(nolock)  
,dp_mstr  with(nolock)  
where cdshm_tratm_cd in ('2246','2277','2201','2230','5101','2280')  
and CDSHM_dpm_id = dpm_id   
and ISIN_CD= CDSHM_isin  
and cdshm_tratm_type_desc in ('UNPLEDGE','CONFISCATE','AUTO PLEDGE','PLEDGE')
group by dpm_dpid , CDSHM_BEN_ACCT_NO   
,isnull(ACCP_VALUE ,'')   
 ,CDSHM_ISIN   
 ,ISIN_NAME   
 ,CDSHM_COUNTER_DPID    
 ,CDSHM_COUNTER_BOID    
,CDSHM_trans_no   ,cdshm_tratm_cd,cdshm_tratm_type_desc
having sum(CDSHM_QTY) > 0

GO
