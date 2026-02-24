-- Object: VIEW citrus_usr.vw_login_details
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE view [citrus_usr].[vw_login_details] 
as
select LOGN_NAME, ROL_DESC , SCR_DESC  , ACT_cd 
from screens 
,login_names 
,entity_roles 
,roles_actions 
,roles 
,actions 
where  LOGN_NAME = entro_logn_name 
and ENTRO_ROL_ID = ROL_ID 
and ROLA_ROL_ID = ROL_ID 
and ROLA_ACT_ID = ACT_ID 
and ACT_SCR_ID = scr_id

GO
