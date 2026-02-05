-- Object: PROCEDURE citrus_usr.pr_ins_sel_inw_docpath_others
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_ins_sel_inw_docpath_others]
(
	@pa_inw_id numeric,
	@pa_action varchar(10),
	@pa_image varchar(10),
	@pa_doc_path varchar(8000),
	@pa_image_binary Image,
	@pa_indpo_created_by varchar(150),
	@pa_indpo_updated_by varchar(150),
	@pa_error_msg varchar(8000)	output
)
as
BEGIN
	--
	DECLARE @t_errorstr      VARCHAR(8000)        
			,@l_error           BIGINT   
	IF @pa_action ='INS'
	BEGIN
		--
			BEGIN TRANSACTION
			IF NOT EXISTS(SELECT * FROM TEMP_INWARD_DOC_PATH_OTHERS WHERE temp_indpo_inward_id = @pa_inw_id AND temp_indpo_image = @pa_image AND temp_indpo_urls= @pa_doc_path)
			BEGIN
				INSERT INTO
				TEMP_INWARD_DOC_PATH_OTHERS (TEMP_INDPO_INWARD_ID,TEMP_INDPO_IMAGE,TEMP_INDPO_URLS,TEMP_INDPO_IMAGE_BINARY,TEMP_indpo_created_dt,TEMP_indpo_created_by,temp_indpo_updated_dt,temp_indpo_updated_by)
				VALUES (@pa_inw_id,@pa_image,@pa_doc_path,@pa_image_binary,getdate(),@pa_indpo_created_by,getdate(),@pa_indpo_updated_by)
			END

			SET @l_error = @@error  
			IF @l_error <> 0
			BEGIN
				--
					SET @t_errorstr = 'ERROR'
					ROLLBACK TRANSACTION
				--
			END
			ELSE
			BEGIN
				--
					SET @t_errorstr = ''
					COMMIT TRANSACTION
				--
			END
		--
	END
	
	IF @pa_action ='EDT'
	BEGIN
		--
			BEGIN TRANSACTION
			
			--DELETE FROM INWARD_DOC_PATH_OTHERS WHERE indpo_inward_id = @pa_inw_id
			
			IF NOT EXISTS(SELECT * FROM INWARD_DOC_PATH_OTHERS WHERE indpo_inward_id = @pa_inw_id AND indpo_image = @pa_image AND indpo_urls= @pa_doc_path)
			BEGIN
--				INSERT INTO INWARD_DOC_PATH_OTHERS (indpo_inward_id,indpo_image,indpo_urls,indpo_image_binary,indpo_created_dt,indpo_created_by,indpo_updated_dt,indpo_updated_by)
--				SELECT temp_indpo_inward_id,temp_indpo_image,temp_indpo_urls,temp_indpo_image_binary,temp_indpo_created_dt,temp_indpo_created_by,temp_indpo_updated_dt,temp_indpo_updated_by
--				FROM TEMP_INWARD_DOC_PATH_OTHERS WHERE temp_indpo_inward_id = @pa_inw_id
				INSERT INTO
				INWARD_DOC_PATH_OTHERS (INDPO_INWARD_ID,INDPO_IMAGE,INDPO_URLS,INDPO_IMAGE_BINARY,indpo_created_dt,indpo_created_by,indpo_updated_dt,indpo_updated_by)
				VALUES (@pa_inw_id,@pa_image,@pa_doc_path,@pa_image_binary,getdate(),@pa_indpo_created_by,getdate(),@pa_indpo_updated_by)
			END

			SET @l_error = @@error  
			IF @l_error <> 0
			BEGIN
				--
					SET @t_errorstr = 'ERROR'
					ROLLBACK TRANSACTION
				--
			END
			ELSE
			BEGIN
				--
					SET @t_errorstr = ''
					COMMIT TRANSACTION
				--
			END
		--
	END	
	
	SET @pa_error_msg = @t_errorstr
	--
END

GO
