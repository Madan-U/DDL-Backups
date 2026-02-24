-- Object: VIEW citrus_usr.client_poa_details
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[client_poa_details]
AS
select dppd_master_id cpd_poaid
,left(dpam_sba_no,8) cpd_dpid
,dpam_sba_no cpd_boid
,case when DPPD_HLD = '1st holder' then '1' when DPPD_HLD = '2nd holder' then '2' when DPPD_HLD = '3rd holder' then '3' end cpd_holderno
,poam_name1 cpd_firstname
,poam_name2 cpd_middlename
,poam_name3 cpd_searchname
,dppd_poa_id cpd_poaregno
,'' cpd_operateaccount
,'' cpd_cacharfield
,isnull(dppd_eff_fr_dt,'') cpd_effectivefrom
,isnull(dppd_eff_TO_dt,'JAN 01 2100') cpd_effectiveto
,dppd_setup cpd_setupdate
,case when dppd_gpabpa_flg ='B' then 'B' else dppd_gpabpa_flg end  cpd_Remarks
,'' cpd_POAStatus
from dp_poa_dtls,poa_mstr,dp_acct_mstr  
where dppd_master_id = poam_master_id 
and dpam_id = dppd_dpam_id

GO
