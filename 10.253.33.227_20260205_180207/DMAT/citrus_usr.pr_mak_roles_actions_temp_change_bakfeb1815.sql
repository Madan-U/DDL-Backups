-- Object: PROCEDURE citrus_usr.pr_mak_roles_actions_temp_change_bakfeb1815
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select distinct rol_id,rol_cd from roles , roles_actions where rola_rol_id = rol_id and rola_access1 =0
--exec [pr_mak_roles_actions_temp_change] 'HETAL'
create proc [citrus_usr].[pr_mak_roles_actions_temp_change_bakfeb1815](@pa_template_rol_cd varchar(150))
as
begin
--
--select distinct rola_rol_id , rola_access1 into #tempdata from roles_actions 
--, roles 
--where rola_rol_id = rol_id 
--and rol_deleted_ind =  1
--and rola_deleted_ind = 1 
--and rola_access1 <>0
--and rol_cd like @pa_template_rol_cd + '_%'
--
--
--delete from a from roles_actions a
--, roles 
--where rola_rol_id = rol_id 
--and rol_deleted_ind =  1
--and rola_deleted_ind = 1 
--and rol_cd like @pa_template_rol_cd + '_%'


select distinct rola_rol_id , rola_access1 into #tempdata from roles_actions 
, roles , login_names , entity_roles 
where rola_rol_id = rol_id 
and rol_deleted_ind =  1
and rola_deleted_ind = 1 and ENTRO_LOGN_NAME = logn_name and ENTRO_ROL_ID = rol_id 
and rola_access1 <>0
and replace(rol_cd,'_'+LOGN_NAME, '') = @pa_template_rol_cd

--and rol_cd like @pa_template_rol_cd + '_%'


delete from a from roles_actions a
, roles , login_names , entity_roles 
where rola_rol_id = rol_id 
and rol_deleted_ind =  1
and rola_deleted_ind = 1 and ENTRO_LOGN_NAME = logn_name and ENTRO_ROL_ID = rol_id 
and rola_access1 <> 0
and replace(rol_cd,'_'+LOGN_NAME, '') = @pa_template_rol_cd



insert into roles_actions 
select a.rola_rol_id , b.rola_act_id , a.rola_access1, 'mig',getdate(),'mig',getdate(),1
from #tempdata a, roles_actions b, roles
where b.rola_rol_id = rol_id
and b.ROLA_ACCESS1 =0  
and rol_cd = @pa_template_rol_cd
and rola_deleted_ind = 1 
and rol_deleted_ind = 1
order by 1 



end

GO
