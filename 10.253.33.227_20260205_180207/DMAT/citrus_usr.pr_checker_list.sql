-- Object: PROCEDURE citrus_usr.pr_checker_list
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_checker_list](@pa_scr_id numeric)
as
select * from login_names where logn_name 
in (select entro_logn_name from entity_roles 
,roles, roles_actions
,actions 
,screens
where scr_id = act_scr_id 
and   act_id = rola_act_id 
and   rol_id = rola_rol_id 
and   entro_rol_id = rol_id
and   SCR_CHECKER_YN = 1
and   scr_name = (select scr_name from screens where scr_id = @pa_scr_id and scr_deleted_ind = 1 ))

GO
