-- Object: VIEW citrus_usr.vw_getclienttypecat
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[vw_getclienttypecat]
as
select dpam_sba_no 
, enttm_cd  bc_code
, enttm_desc bc_desc
, clicm_cd category
, clicm_desc category_desc
, subcm_cd sub_type 
, subcm_desc sub_type_desc
,stam_cd 
,stam_desc
from dp_acct_mstr,sub_ctgry_mstr , client_ctgry_mstr 
, entity_type_mstr , status_mstr
where dpam_enttm_Cd = enttm_cd
and dpam_clicm_cd = clicm_Cd 
and dpam_subcm_cd = subcm_Cd
and dpam_stam_cd = stam_cd

GO
