-- Object: PROCEDURE citrus_usr.PR_clnt_WO_SIGN
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_clnt_WO_SIGN] --1,'FEB 10 2010','FEB 10 2015'

(  

@PA_DPM_ID NUMERIC  
,@PA_FROM_DATE DATETIME 
,@PA_TO_DATE DATETIME 

)
AS  
BEGIN   
--select distinct DPAM_SBA_NO,DPAM_SBA_NAME,kit_no from dp_acct_mstr_mak,kyc.dbo.API_CLIENT_MASTER_SYNERGY
--where DPAM_DELETED_IND=0 and not exists( select accd_clisba_id from accd_mak where ACCD_CLISBA_ID=DPAM_ID and ACCD_DELETED_IND=0)
--AND DPAM_LST_UPD_DT BETWEEN @PA_FROM_DATE and @PA_TO_DATE
--and dpam_crn_no in (select CLIM_CRN_NO from client_list )  
--and DPAM_ACCT_NO=dp_internal_ref
--and DPAM_CREATED_DT>='Jul  4 2015'
--union 
select distinct DPAM_SBA_NO,DPAM_SBA_NAME,convert (varchar(11) ,DPAM_CREATED_DT,103) kit_no from dp_acct_mstr---_mak,kyc.dbo.API_CLIENT_MASTER_SYNERGY
where DPAM_DELETED_IND=1 and not exists( select accd_clisba_id from account_documents where ACCD_CLISBA_ID=DPAM_ID )
AND DPAM_CREATED_DT BETWEEN @PA_FROM_DATE+' 00:00:000'  and @PA_TO_DATE+' 23:59:000'
and DPAM_SBA_NO like '120%'
and DPAM_STAM_CD = 'active'
and DPAM_CREATED_DT >= 'Jan 01 2020'
--and dpam_crn_no in (select CLIM_CRN_NO from client_list )  
--and DPAM_ACCT_NO=dp_internal_ref
END

GO
