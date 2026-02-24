-- Object: PROCEDURE citrus_usr.pr_dpb9_missingclient_bak_21102022
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE    procedure [citrus_usr].[pr_dpb9_missingclient_bak_21102022]
(
-- exec pr_dpb9_missingclient 'Aug 02 2022' , 'Aug 02 2022' , 'Ho'

------begin tran
------insert into client_mstr
------select CLIM_CRN_NO,CLIM_NAME1,CLIM_NAME2,CLIM_NAME3,CLIM_SHORT_NAME,CLIM_GENDER,CLIM_DOB,CLIM_ENTTM_CD,
------CLIM_STAM_CD,CLIM_CLICM_CD,CLIM_SBUM_ID,CLIM_RMKS,CLIM_CREATED_BY,CLIM_CREATED_DT,CLIM_LST_UPD_BY,CLIM_LST_UPD_DT,
------'1',null,null from clim_hst where CLIM_CRN_NO = '8510757' and CLIM_ACTION = 'D'

------commit


@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_login_name varchar(100)
)
AS
BEGIN

select  ''''+ boid MISSINGBOID,'main table missing' descr
   from    dps8_pc1 where boid not in (select  dpam_sba_no from dp_acct_mstr) 
   union all

   
select ''''+ boid  ,'account opening date missing'  from dps8_pc1 where boid  in (
select DPAM_SBA_NO  from dp_acct_mstr where DPAM_ID not  in (select accp_clisba_id from account_properties
where ACCP_ACCPM_PROP_CD = 'bill_start_Dt')
and DPAM_SBA_NO <> DPAM_ACCT_NO 
and DPAM_STAM_CD = 'ACTIVE' )

UNION ALL

select ''''+ DPAM_SBA_NO BOID , 'Active Client Deleted From Client Master' descr from dp_acct_mstr  WHERE DPAM_CRN_NO NOT IN (SELECT CLIM_CRN_NO FROM CLIENT_MSTR)
and exists (select 1 from clim_hst where CLIM_CRN_NO=DPAM_CRN_NO and CLIM_ACTION='D')
AND DPAM_SBA_NO <> DPAM_ACCT_NO AND DPAM_DELETED_IND = 1 and DPAM_STAM_CD = 'ACTIVE'


   order by 1 


end

GO
