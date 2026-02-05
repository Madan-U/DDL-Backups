-- Object: PROCEDURE citrus_usr.pr_ins_sel_inw_docpath_others_edit
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_ins_sel_inw_docpath_others_edit]
(
	@pa_indpo_id numeric,
	@pa_inw_id numeric,
	@pa_action varchar(10),
	@pa_image varchar(10),
	@pa_doc_path varchar(8000),
	--@pa_check varchar(10),
	@pa_indpo_created_by varchar(150),
	@pa_indpo_updated_by varchar(150),
	@pa_error_msg varchar(8000)	output
)
as
BEGIN
	if @pa_action = 'EDT' 
	begin
			update INWARD_DOC_PATH_OTHERS
			set indpo_urls = @pa_doc_path,
			indpo_created_dt = getdate(),
			indpo_created_by = @pa_indpo_created_by,
			indpo_updated_dt= getdate()
			where indpo_id = @pa_indpo_id
			and indpo_inward_id = @pa_inw_id
			and indpo_image = @pa_image
--		if @pa_doc_path = ''
--		begin
--			delete from INWARD_DOC_PATH_OTHERS
--			where indpo_id = @pa_indpo_id
--			and indpo_inward_id = @pa_inw_id
--			and indpo_image = @pa_image
--		end
--		else
--		begin
--			update INWARD_DOC_PATH_OTHERS
--			set indpo_urls = @pa_doc_path,
--			indpo_created_dt = getdate(),
--			indpo_created_by = @pa_indpo_created_by,
--			indpo_updated_dt= getdate()
--			where indpo_id = @pa_indpo_id
--			and indpo_inward_id = @pa_inw_id
--			and indpo_image = @pa_image
--		end
	end
	if @pa_action = 'DEL'
	begin
			delete from INWARD_DOC_PATH_OTHERS
			where indpo_id = @pa_indpo_id
			and indpo_inward_id = @pa_inw_id
			and indpo_image = @pa_image
	end
end

GO
