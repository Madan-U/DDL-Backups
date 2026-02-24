-- Object: PROCEDURE citrus_usr.pr_mak_roles_actions_newlogic
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_mak_roles_actions_newlogic]
(@pa_rol_template numeric
,@pa_values_excsm_list varchar(8000)
,@pa_login_name varchar(250)
,@pa_errmsg varchar(25) output)
as
begin
declare @l_template_name varchar(500)
,@l_access1 numeric(18,0)
,@l_rol_id numeric

set @l_template_name =''
select @l_template_name = rol_cd from roles where rol_id = @pa_rol_template and rol_deleted_ind = 1

if @l_template_name <> '' and @pa_login_name <> ''
begin 
delete from roles_actions where ROLA_ROL_ID in (select rol_id from roles where ROL_DESC = @l_template_name  +'_'+ @pa_login_name)
end 

if @l_template_name <> '' and @pa_login_name <> ''
begin 

	insert into roles 
	select max(ROL_ID)+1,@l_template_name+'_'+@pa_login_name, @l_template_name+'_'+@pa_login_name
	,'MIG',GETDATE(),'MIG',getdate(),1 from roles 
	
	select @l_rol_id  = rol_id from roles where rol_desc = @l_template_name+'_'+@pa_login_name
	and rol_deleted_ind = 1 

	select @l_access1  = citrus_usr.fn_get_accesscode(@pa_values_excsm_list)
	
	insert into roles_actions 
	select @l_rol_id  , rola_act_id ,@l_access1
	,'MIG',getdate(),'MIG',getdate(),1
	from roles_actions where rola_rol_id = @pa_rol_template
	and rola_deleted_ind = 1
	

end 

set @pa_errmsg = @l_rol_id

end

GO
