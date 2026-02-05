-- Object: PROCEDURE citrus_usr.pr_ins_sel_inw_docpath
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_ins_sel_inw_docpath](
									@pa_inw_id numeric,
									@pa_action varchar(10),
									@pa_doc_path varchar(8000),
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
			UPDATE INWARD_SLIP_REG
			SET inwsr_doc_path = @pa_doc_path
			WHERE INWSR_ID = @pa_inw_id
			AND INWSR_DELETED_IND = 1

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
