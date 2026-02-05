-- Object: PROCEDURE citrus_usr.pr_rpt_blacm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--
--select * from blacm_serach_criteria
--select * from balcm_clim_mapping_dtwaise mapped
--pr_rpt_blacm 'jul  1 2009','jul  1 2009'
--select * from balcm_clim_mapping_dtwaise where blacm_id = 7
CREATE procedure [citrus_usr].[pr_rpt_blacm](@pa_from_dt datetime, @pa_to_dt datetime)
as
select distinct cast(blacm.blacm_id as varchar)  blamc_id   
, BLACM_FIRST_NM
+ ' '
+  isnull(BLACM_MIDDLE_NM,'')
+' ' 
+isnull(BLACM_LAST_NM,'') blacm_name,          BLACM_PAN
, convert(varchar(11),BLACM_DT_OF_ORD,103)     BLACM_DT_OF_ORD
 
, convert(varchar(11), BLACM_BAN_TO_DT,103)    BLACM_BAN_TO_DT
, BLACM_RVK_ORD_ISS_AUTH
, convert(varchar(11), BLACM_RVK_ORD_DT,103) BLACM_RVK_ORD_DT
, BLACM_RVK_ORD_REF, BLACM_RVK_ORD_DESC
, convert(varchar(11),BLACM_ORD_EXP_DATE,103)  BLACM_ORD_EXP_DATE
, clim_name1 + ' '+ isnull(clim_name2,'') + ' ' + isnull(clim_name3,'') clim_name 
, citrus_usr.fn_ucc_entp(clim_crn_no,'pan_gir_no','') pan 
, clia_acct_no 
, [citrus_usr].[fn_find_relations_nm](clim_crn_no,'BR') branch
, stam_desc  
, convert(varchar(11),clim_created_dt ,103) clim_created_dt
,criteria_desc
from balcm_clim_mapping_dtwaise  mapped
, BLACKLISTED_CLIENT_MSTR        blacm 
, client_mstr 
, client_accounts
, status_mstr
, blacm_serach_criteria   search
where mapped.crn_no   = clim_crn_no 
and mapped.blacm_id   = blacm.BLACM_ID
and clia_crn_no       = clim_crn_no 
and clim_stam_Cd      = stam_Cd 
and mapped.sr_no   = search.id
AND mapped.CTGRY             = search.CATEGORY
--and clim_lst_upd_dt  between @pa_from_dt and @pa_to_dt
and curdate  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'
--
--select * from blacm_serach_criteria
--select * from balcm_clim_mapping_dtwaise where blacm_id = 6 and crn_no = 140990
--
--select distinct criteria_desc
--from  blacm_serach_criteria
--    ,balcm_clim_mapping_dtwaise
--where blacm_id   = id
--

GO
