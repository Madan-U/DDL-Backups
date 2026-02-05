-- Object: PROCEDURE citrus_usr.pr_ins_upd_group_trans
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_ins_upd_group_trans]	(@pa_id             		VARCHAR(50)  
																																								, @pa_action         VARCHAR(20)  
																																								, @pa_login_name     VARCHAR(20)
																																								, @pa_group_name     VARCHAR(20)
																																								, @pa_parent_group     VARCHAR(20)
																																								, @pa_parent_group_cd  VARCHAR(20)
																																								, @pa_chk_yn         INT  
																																								, @pa_values         VARCHAR(8000)
																																								, @rowdelimiter      CHAR(4)       = '*|~*'  
																																								, @coldelimiter      CHAR(4)       = '|*~|'  
																																								, @pa_errmsg         VARCHAR(8000) output  
																																								)
																																								
AS
BEGIN
--
			DECLARE @t_errorstr   VARCHAR(8000)
				, @l_error         		BIGINT
				, @l_group_id        INT
				, @l_group_trans_id  INT
				, @l_sub_group_code		INT
				, @l_reccount								BIGINT
				
		IF @pa_chk_yn =0
		BEGIN
		--
			
				IF @PA_ACTION ='INS'
				BEGIN
				--
													
						IF EXISTS(SELECT * FROM fin_group_mstr WHERE FINGM_GROUP_NAME = @pa_group_name AND  fingm_deleted_ind = 1)
						BEGIN
						--
							SET	@t_errorstr ='ERROR:-GROUP NAME IS ALREADY EXISTS'
						--
						END
						ELSE
						BEGIN
						--
								
						 	BEGIN TRANSACTION
								
								SELECT @l_group_id = ISNULL(MAX(fingm_group_code),0) + 1 FROM fin_group_mstr
								
								INSERT INTO fin_group_mstr
								( FINGM_GROUP_CODE
										,FINGM_GROUP_NAME
										,FINGM_CREATED_BY
										,FINGM_CREATED_DT
										,FINGM_LST_UPD_BY
										,FINGM_LST_UPD_DT
										,FINGM_DELETED_IND
								)
								VALUES
								( @l_group_id
										,@pa_group_name
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,1
								)
																								
								INSERT INTO fin_group_trans
								( FINGT_GROUP_CODE
										,FINGT_SUB_GROUP_CODE
										,FINGT_GROUP_NAME
										,FINGT_SUB_GROUP_NAME
										,FINGT_CREATED_BY
										,FINGT_CREATED_DT
										,FINGT_LST_UPD_BY
										,FINGT_LST_UPD_DT
										,FINGT_DELETED_IND
								)
								VALUES
								( @pa_parent_group_cd
										, @l_group_id
										, @pa_parent_group
										, @pa_group_name
										,	@pa_login_name
										,	getdate()
										,	@pa_login_name
										,	getdate()
										,	1
								)
								
								exec pr_upd_fingroup_priority
															
								SET @l_error = @@error
								IF @l_error <> 0
								BEGIN
								--
										IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)
										BEGIN
										--
												SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)
										--
										END
										ELSE
										BEGIN
										--
												SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'
										--
										END

											ROLLBACK TRANSACTION 

										RETURN
								--
								END
								ELSE
								BEGIN
								--
											 
										 COMMIT TRANSACTION
								--
  						END
						--
						END
				--
				END   --END INS
				
				IF @PA_ACTION = 'EDIT'
				BEGIN
				--
						UPDATE fin_group_mstr
						SET  FINGM_GROUP_NAME  = @pa_group_name
										,FINGM_lst_upd_by  = @pa_login_name
										,FINGM_lst_upd_dt  = getdate()
					 WHERE 	FINGM_GROUP_CODE		= CONVERT(INT,@pa_id)	
					 AND 			FINGM_DELETED_IND  = 1
					 
					 UPDATE fin_group_trans
						SET 			FINGT_SUB_GROUP_NAME = @pa_group_name
											 ,FINGT_LST_UPD_BY  = @pa_login_name
												,FINGT_LST_UPD_DT  = getdate()
						WHERE FINGT_SUB_GROUP_CODE = CONVERT(INT,@pa_id)
					 AND   FINGT_DELETED_IND  = 1			
					 
					 UPDATE fin_group_trans
					 SET  FINGT_GROUP_CODE =  @pa_parent_group_cd
					 				,FINGT_GROUP_NAME =  @pa_parent_group
					 				,FINGT_LST_UPD_BY  = @pa_login_name
										,FINGT_LST_UPD_DT  = getdate()
						WHERE 	FINGT_SUB_GROUP_CODE		= CONVERT(INT,@pa_id)	
					 AND 			FINGT_DELETED_IND  = 1			
					 
					 	exec pr_upd_fingroup_priority
					--
				END
				
				IF @PA_ACTION = 'DEL'
				BEGIN
				--
							SELECT @l_reccount = ISNULL(count(*),0) FROM fin_group_trans where fingt_group_code = convert(INT,@pa_id) and FINGT_DELETED_IND = 1
							IF @l_reccount <> 0 
							BEGIN
							--
									SET	@t_errorstr ='ERROR:-Please delete sub groups falling under current group first'
							--
							END
							ELSE
							BEGIN
							--
										UPDATE fin_group_trans
										SET  FINGT_DELETED_IND  = 0
														,FINGT_LST_UPD_BY  = @pa_login_name
														,FINGT_LST_UPD_DT  = getdate()
										WHERE 	FINGT_GROUP_CODE		= CONVERT(INT,@pa_parent_group_cd)	
										AND    FINGT_SUB_GROUP_CODE = CONVERT(INT,@pa_id)
										AND 			FINGT_DELETED_IND  = 1		
										
										UPDATE fin_group_mstr
										SET  FINGM_DELETED_IND  = 0
														,FINGM_lst_upd_by  = @pa_login_name
														,FINGM_lst_upd_dt  = getdate()
										WHERE 	FINGM_GROUP_CODE		= CONVERT(INT,@pa_id)	
										AND 			FINGM_DELETED_IND  = 1

										
							--
							END
									
				--
				END
		--
		END      --END NO MAKER CHECKER
		
		SET @pa_errmsg = @t_errorstr
		
--
END

GO
