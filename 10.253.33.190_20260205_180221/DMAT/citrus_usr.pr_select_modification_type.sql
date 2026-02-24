-- Object: PROCEDURE citrus_usr.pr_select_modification_type
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create procedure [citrus_usr].[pr_select_modification_type]
(
	@pa_action varchar(100),
	@pa_ref_cur varchar(8000) output
)
as begin
	select distinct clic_mod_action from client_list_modified where clic_mod_batch_no is null OR clic_mod_batch_no = '0'
end

GO
