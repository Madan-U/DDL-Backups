-- Object: PROCEDURE citrus_usr.pr_ins_upd_cham_18032011_bak
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--0	INS	HO	CDSL	r	F	IN0019780025|*~|IN0019780074|*~|	M					A|*~||*~||*~|4|*~|*|~*		0	*|~*	|*~|	
CREATE PROCEDURE [citrus_usr].[pr_ins_upd_cham_18032011_bak](@pa_id              VARCHAR(8000)  
											,@pa_action          VARCHAR(20)  
											,@pa_login_name      VARCHAR(20)  
											,@pa_excsm_cd        VARCHAR(50)
											,@pa_slab_name       VARCHAR(50)
											,@pa_charge_type     VARCHAR(20)
                                            ,@pa_charge_base     VARCHAR(25)
											,@pa_subcm            VARCHAR(8000) 
											,@pa_billing_period	 VARCHAR(20) 
											,@pa_months   		 VARCHAR(11)
											,@pa_days     		 VARCHAR(11)
											,@pa_based_on 		 VARCHAR(20)
											,@pa_calculationtype VARCHAR(20)
											,@pa_cham_post_toacct NUMERIC
                                            ,@pa_values      	 VARCHAR(8000)
											,@pa_rmks        	 VARCHAR(250)
											,@pa_chk_yn          INT  
											,@rowdelimiter       CHAR(4)       = '*|~*'  
											,@coldelimiter       CHAR(4)       = '|*~|'  
											,@pa_errmsg          VARCHAR(8000) output 
)
AS
/*
*********************************************************************************
 SYSTEM         : dp
 MODULE NAME    : pr_ins_upd_cham
 DESCRIPTION    : this procedure will contain the maker checker facility for charge_mstr
 COPYRIGHT(C)   : marketplace technologies 
 VERSION HISTORY: 1.0
 VERS.  AUTHOR            DATE          REASON
 -----  -------------     ------------  --------------------------------------------------
 1.0    TUSHAR            09-JAN-2008   VERSION.
-----------------------------------------------------------------------------------*/
BEGIN
--
  DECLARE @t_errorstr      VARCHAR(8000)
      , @l_error         BIGINT
      , @delimeter       VARCHAR(10)
      , @remainingstring VARCHAR(8000)
      , @currstring      VARCHAR(8000)
      , @foundat         INTEGER
      , @delimeterlength INT
      , @delimeter_value varchar(10)
					, @delimeterlength_value varchar(10)
					, @remainingstring_value varchar(8000)
		 			, @currstring_value varchar(8000)
		 			, @l_action varchar(20)
		 			, @l_from_no  varchar(20)
		 			, @l_to_no  varchar(20)
		 			, @l_charge_val  varchar(20)
		 			, @l_val_per  varchar(20)
		 			, @l_mim_charge_val varchar(20)
		 			, @l_cham_id numeric(10,0)
		 			, @l_excsm_id numeric(10,0)
		 			, @l_count    numeric(10,0)
		 			, @l_id    varchar(25)
		 			, @l_chai_id numeric
		 			, @i_subcm varchar(25)
		 			, @l_dtls_id  numeric(10,0)
		 			, @l_dtlsm_id numeric(10,0)
		 			, @l_chamm_id numeric(10,0)
                    , @l_chai_id1 numeric(10,0)
		 			, @l_min numeric
                    , @l_max numeric
		 			
if @PA_ACTION <> 'app'  AND @PA_ACTION <> 'rej'       
begin
--
		create table #cham_mak
		(cham_slab_no numeric(10,0)
		,cham_slab_name varchar(150)
		,cham_charge_type varchar(50)
		,cham_charge_base varchar(25) 
		,cham_bill_period varchar(25)
		,cham_bill_interval char(1)
		,cham_charge_baseon char(1)
		,cham_from_factor varchar(25)
		,cham_to_factor   varchar(25)
		,cham_val_pers    char(1)
		,cham_charge_value numeric(10,0)
		,cham_charge_minval numeric(10,0)
		,cham_charge_graded int 
		,cham_post_toacct NUMERIC(10,0)
		,cham_chargebitfor char(1)
		,cham_remarks varchar(250)
		,cham_created_by varchar(25)
		,cham_created_dt datetime
		,cham_lst_upd_by varchar(25) 
		,cham_lst_upd_dt datetime
		,cham_deleted_ind smallint 
		)
		insert into #cham_mak
		(cham_slab_no
		,cham_slab_name
		,cham_charge_type
		,cham_charge_base
		,cham_bill_period
		,cham_bill_interval
		,cham_charge_baseon
		,cham_from_factor
		,cham_to_factor
		,cham_val_pers
		,cham_charge_value
		,cham_charge_minval
		,cham_charge_graded
		,cham_chargebitfor
		,cham_remarks
		,cham_post_toacct
		,cham_created_by
		,cham_created_dt
		,cham_lst_upd_by
		,cham_lst_upd_dt
		,cham_deleted_ind 
		)
		select cham_slab_no
		,cham_slab_name
		,cham_charge_type
		,cham_charge_base
		,cham_bill_period
		,cham_bill_interval
		,cham_charge_baseon
		,cham_from_factor
		,cham_to_factor
		,cham_val_pers
		,cham_charge_value
		,cham_charge_minval
		,cham_charge_graded
		,cham_chargebitfor
		,cham_remarks
		,cham_post_toacct
		,cham_created_by
		,cham_created_dt
		,cham_lst_upd_by
		,cham_lst_upd_dt
		,cham_deleted_ind 
		FROM cham_mak
		where cham_slab_no = @pa_id
--
end
IF @pa_chk_yn = 0 AND  @PA_ACTION = 'INS'
BEGIN
--
  SELECT @l_dtls_id   = ISNULL(MAX(cham_slab_no),0) + 1 FROM charge_mstr
--
END
ELSE IF @pa_chk_yn = 1 AND  @PA_ACTION = 'INS'
BEGIN
--

  SELECT @l_dtls_id   = ISNULL(MAX(cham_slab_no),0) + 1 FROM charge_mstr
																
		SELECT @l_dtlsm_id   = ISNULL(MAX(cham_slab_no),0) + 1 FROM cham_mak
		
		IF @l_dtlsm_id  > @l_dtls_id   
		BEGIN
		--
		  set @l_dtls_id = @l_dtlsm_id   
		--
		END 
		
  
--
END

SET @l_error         = 0
SET @t_errorstr      = ''
SET @delimeter        = '%'+ @ROWDELIMITER + '%'
SET @delimeterlength = LEN(@ROWDELIMITER)
SET @remainingstring = @pa_id  

		WHILE @remainingstring <> ''
		BEGIN
		--
				SET @foundat = 0
				SET @foundat =  PATINDEX('%'+@delimeter+'%',@remainingstring)
				--
				IF @foundat > 0
				BEGIN
				--
						SET @currstring      = SUBSTRING(@remainingstring, 0,@foundat)
						SET @remainingstring = SUBSTRING(@remainingstring, @foundat+@delimeterlength,LEN(@remainingstring)- @foundat+@delimeterlength)
				--
				END
				ELSE
				BEGIN
				--
						SET @currstring      = @remainingstring
						SET @remainingstring = ''
				--
				END
				--
				IF @currstring <> ''
				BEGIN
				--
				  SET @delimeter_value        = '%'+ @rowdelimiter + '%'
						SET @delimeterlength_value = LEN(@rowdelimiter)
						SET @remainingstring_value = @pa_values
						--
						WHILE @remainingstring_value <> ''
						BEGIN
						--

								SET @foundat = 0
								SET @foundat = PATINDEX('%'+@delimeter_value+'%',@remainingstring_value)
								--
								IF @foundat > 0
								BEGIN
										--
										SET @currstring_value      = SUBSTRING(@remainingstring_value, 0,@foundat)
										SET @remainingstring_value = SUBSTRING(@remainingstring_value, @foundat+@delimeterlength_value,LEN(@remainingstring_value)- @foundat+@delimeterlength_value)
										--
								END
								ELSE
								BEGIN
										--
										SET @CURRSTRING_VALUE = @REMAININGSTRING_VALUE
										SET @REMAININGSTRING_VALUE = ''
								--
								END
								--
								IF @currstring_value <> ''
								BEGIN
								--
								  SET @l_action             = citrus_usr.fn_splitval(@currstring_value,1)      
																		  
										IF @l_action = 'A' OR @l_action ='E'
										BEGIN
										--
												SET @l_from_no           = CASE WHEN citrus_usr.fn_splitval(@currstring_value,2) = '' THEN '0' ELSE   citrus_usr.fn_splitval(@currstring_value,2)  END    				     							  
												SET @l_to_no             = CASE WHEN citrus_usr.fn_splitval(@currstring_value,3) = '' THEN '0' ELSE   citrus_usr.fn_splitval(@currstring_value,3)  END    				     							  
												SET @l_val_per           = citrus_usr.fn_splitval(@currstring_value,4) 
												SET @l_charge_val        = citrus_usr.fn_splitval(@currstring_value,5) 
												SET @l_mim_charge_val    = citrus_usr.fn_splitval(@currstring_value,6)
                                                if (citrus_usr.fn_splitval(@currstring_value,7)='')
												begin 
												set @l_min='0'
												end 
												else        										
                                                begin 
												SET @l_min    = citrus_usr.fn_splitval(@currstring_value,7)
                                                end

												--SET @l_min    = case when citrus_usr.fn_splitval(@currstring_value,7) = '' then '0' else citrus_usr.fn_splitval(@currstring_value,7) end 
												SET @l_max    = case when citrus_usr.fn_splitval(@currstring_value,8) = '' then '0' else citrus_usr.fn_splitval(@currstring_value,8) end  
										--
										END
								  
								  IF @pa_chk_yn = 0 
								  BEGIN
								  --
								    IF @PA_ACTION = 'INS' OR @l_action = 'A'
												BEGIN
												--
												  BEGIN TRANSACTION

														SELECT @l_cham_id   = ISNULL(MAX(cham_dtls_id),0) + 1 FROM charge_mstr
													
														
														
														SELECT top 1 @l_excsm_id = excsm_id from exch_seg_mstr  where excsm_exch_cd = @pa_excsm_cd order by 1 

														INSERT INTO charge_mstr
														(cham_slab_no
														,cham_dtls_id
														,cham_slab_name
														,cham_charge_type
														,cham_charge_base
														,cham_bill_period
														,cham_bill_interval
														,cham_charge_baseon
														,cham_from_factor
														,cham_to_factor
														,cham_val_pers
														,cham_charge_value
														,cham_charge_minval
														,cham_charge_graded
														,cham_chargebitfor
														,cham_remarks
														,cham_post_toacct
														,cham_created_by
														,cham_created_dt
														,cham_lst_upd_by
														,cham_lst_upd_dt
														,cham_deleted_ind
														,CHAM_PER_MIN
														,CHAM_PER_MAX 
														)VALUES 
														(@l_dtls_id
														,@l_cham_id 
														,@pa_slab_name
														,@pa_charge_type
														,@pa_charge_base
														,case when @pa_billing_period	 ='' then @pa_months ELSE @pa_billing_period end
														,case when @pa_months <> '' then @pa_days when @pa_billing_period	 = 'Y' then '12'
															when @pa_billing_period	 = 'Q' then '3'
															when @pa_billing_period	 = 'H'	then '6'					                                     
																																												when @pa_billing_period	 = 'M' then '1'			end 		                                     
														,@pa_based_on
														,CONVERT(NUMERIC(20,2),@l_from_no)
														,CONVERT(NUMERIC(20,2),@l_to_no)
														,@l_val_per
														,@l_charge_val
														,@l_mim_charge_val
														,@pa_calculationtype
														,case when @pa_excsm_cd <> 'ALL' then @l_excsm_id else '0' end 
                                                        ,@pa_rmks
                                                        ,@pa_cham_post_toacct
														,@pa_login_name
														,getdate()
														,@pa_login_name
														,getdate()
														,1,@l_min,@l_max
														)

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
														--
														END
														ELSE
														BEGIN
														--
                                                          
														  select @l_count = citrus_usr.ufn_countstring(@pa_subcm,'|*~|')
														  set @l_id = 1
														  
														  WHILE  @l_count  >= @l_id
														  BEGIN
														  --
														    set @i_subcm = citrus_usr.fn_splitval(@pa_subcm,@l_id) 
														    select @l_chai_id = isnull(max(chacm_id),0) + 1 from charge_ctgry_mapping
														    
																		insert into charge_ctgry_mapping 
																		(chacm_id 
                                                                        ,chacm_cham_id 
                                                                        ,chacm_subcm_cd 
                                                                        ,chacm_created_dt 
                                                                        ,chacm_created_by 
                                                                        ,chacm_lst_upd_dt 
                                                                        ,chacm_lst_upd_by 
                                                                        ,chacm_deleted_ind )
																		select @l_chai_id 
																		, @l_dtls_id      
																		, CASE WHEN @i_subcm = 'ALL' THEN '0' ELSE @i_subcm END
																		,getdate()
                                                                        ,@pa_login_name
                                                                        ,getdate()
																		,@pa_login_name
																		,1
																		
																		
																		set @l_id = @l_id + 1 
																		
														  --
														  END
														
														  

																COMMIT TRANSACTION
														--
														END
              
												--
												END
										--
										END
										ELSE IF @pa_chk_yn = 1 
										BEGIN
										--
										  IF @PA_ACTION = 'INS' OR @l_action = 'A'
												BEGIN
												--
														BEGIN TRANSACTION

														SELECT @l_cham_id      = ISNULL(MAX(cham_dtls_id),0) + 1 FROM charge_mstr  
														
														SELECT @l_chamm_id      = ISNULL(MAX(cham_dtls_id),0) + 1 FROM cham_mak
														
														IF @l_chamm_id   > @l_cham_id   
														BEGIN
														--
														  SET @l_cham_id = @l_chamm_id   
														--
														END


														SELECT top 1 @l_excsm_id = excsm_id from exch_seg_mstr  where excsm_exch_cd = @pa_excsm_cd order by 1 

														INSERT INTO cham_mak
														(cham_slab_no
														,cham_dtls_id
														,cham_slab_name
														,cham_charge_type
														,cham_charge_base
														,cham_bill_period
														,cham_bill_interval
														,cham_charge_baseon
														,cham_from_factor
														,cham_to_factor
														,cham_val_pers
														,cham_charge_value
														,cham_charge_minval
														,cham_charge_graded
														,cham_chargebitfor
														,cham_remarks
														,cham_post_toacct
														,cham_created_by
														,cham_created_dt
														,cham_lst_upd_by
														,cham_lst_upd_dt
														,cham_deleted_ind ,CHAM_PER_MIN,CHAM_PER_MAX
														)VALUES 
														(@l_dtls_id
														,@l_cham_id 
														,@pa_slab_name
														,@pa_charge_type
														,@pa_charge_base
														,case when @pa_billing_period	 ='' then @pa_months ELSE @pa_billing_period end
														,case when @pa_months <> '' then @pa_days when @pa_billing_period	 = 'Y' then '12'
														 when @pa_billing_period	 = 'Q' then '3'
														 when @pa_billing_period	 = 'H'	then '6'					                                     
														 when @pa_billing_period	 = 'M' then '1'			end 		                                     
														,@pa_based_on
												,CONVERT(NUMERIC(20,2),@l_from_no)
														,CONVERT(NUMERIC(20,2),@l_to_no)
														,@l_val_per
														,@l_charge_val
														,@l_mim_charge_val
														,@pa_calculationtype
														,case when @pa_excsm_cd <> 'ALL' then @l_excsm_id else '0' end 
														,@pa_rmks
														,@pa_cham_post_toacct
														,@pa_login_name
														,getdate()
														,@pa_login_name
														,getdate()
														,0,@l_min, @l_max
														)

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
														--
														END
														ELSE
														BEGIN
														--
																select @l_count = citrus_usr.ufn_countstring(@pa_subcm,'|*~|')
																set @l_id = 1

																WHILE  @l_count  >= @l_id
																BEGIN
																--
																		set @i_subcm = citrus_usr.fn_splitval(@pa_subcm,@l_id) 
																		select @l_chai_id = isnull(max(chacm_id),0) + 1 from charge_ctgry_mapping
                                                                        select @l_chai_id1 = isnull(max(chacm_id),0) + 1 from chacm_mak
   
                                                                        if @l_chai_id1 > @l_chai_id 
                                                                        set  @l_chai_id = @l_chai_id1

																		insert into chacm_mak 
																		(chacm_id 
                                                                        ,chacm_cham_id 
                                                                        ,chacm_subcm_cd 
                                                                        ,chacm_created_dt 
                                                                        ,chacm_created_by 
                                                                        ,chacm_lst_upd_dt 
                                                                        ,chacm_lst_upd_by 
                                                                        ,chacm_deleted_ind )
																		select @l_chai_id 
																		, @l_dtls_id      
																		, CASE WHEN @i_subcm = 'ALL' THEN '0' ELSE @i_subcm END
																		,getdate()
                                                                        ,@pa_login_name
                                                                        ,getdate()
																		,@pa_login_name
																		,0
																		


																		set @l_id = @l_id + 1 

																--
																END



																COMMIT TRANSACTION
														--
														END

												--
												END
										--
										END
										IF @pa_action = 'APP'
										begin
										--
										  BEGIN TRANSACTION
										  
										  IF EXISTS(select cham_deleted_ind  from cham_mak where cham_deleted_ind = 0 and cham_slab_no = convert(INT,@currstring))
										  BEGIN
										  --
										    	INSERT INTO charge_mstr
															(cham_slab_no
															,cham_dtls_id
															,cham_slab_name
															,cham_charge_type
															,cham_charge_base
															,cham_bill_period
															,cham_bill_interval
															,cham_charge_baseon
															,cham_from_factor
															,cham_to_factor
															,cham_val_pers
															,cham_charge_value
															,cham_charge_minval
															,cham_charge_graded
															,cham_chargebitfor
															,cham_remarks
															,cham_post_toacct
															,cham_created_by
															,cham_created_dt
															,cham_lst_upd_by
															,cham_lst_upd_dt
														 ,cham_deleted_ind,CHAM_PER_MIN,CHAM_PER_MAX)
														 SELECT cham_slab_no
															,cham_dtls_id
															,cham_slab_name
															,cham_charge_type
															,cham_charge_base
															,cham_bill_period
															,cham_bill_interval
															,cham_charge_baseon
															,cham_from_factor
															,cham_to_factor
															,cham_val_pers
															,cham_charge_value
															,cham_charge_minval
															,cham_charge_graded
															,cham_chargebitfor
															,cham_remarks
															,cham_post_toacct
															,cham_created_by
															,cham_created_dt
															,cham_lst_upd_by
															,cham_lst_upd_dt
														 ,1,CHAM_PER_MIN,CHAM_PER_MAX
														 FROM cham_mak
														 WHERE cham_deleted_ind = 0 
														 AND   cham_slab_no     = convert(INT,@currstring)
														 
														 
														 update cham_mak
														 set    cham_lst_upd_dt = getdate()
														      , cham_lst_upd_by = @pa_login_name
														      , cham_deleted_ind = 1
														 where  cham_deleted_ind = 0   
														 AND   cham_slab_no     = convert(INT,@currstring)
										    
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
														--
														END
														ELSE
														BEGIN
														--
														  	insert into charge_ctgry_mapping 
																		(chacm_id 
                                                                        ,chacm_cham_id 
                                                                        ,chacm_subcm_cd 
                                                                        ,chacm_created_dt 
                                                                        ,chacm_created_by 
                                                                        ,chacm_lst_upd_dt 
                                                                        ,chacm_lst_upd_by 
                                                                        ,chacm_deleted_ind )
																	SELECT chacm_id
																	,chacm_cham_id
																	,chacm_subcm_cd
																	,chacm_created_dt
																	,chacm_created_by
																	,chacm_lst_upd_dt
																	,chacm_lst_upd_by
																	,chacm_deleted_ind
																	FROM charge_ctgry_mapping 
																	,    charge_mstr 
																	WHERE chacm_cham_id = cham_slab_no
																	AND   cham_slab_no = convert(INT,@currstring) 
																	AND   chacm_deleted_ind = 0
														  
														  update chacm_mak
																set    chacm_lst_upd_dt = getdate()
																					, chacm_lst_upd_by = @pa_login_name
																					, chacm_deleted_ind = 1
																FROM   chacm_mak 
																	,     charge_mstr 					
																where  chacm_deleted_ind = 0   
														  AND    cham_slab_no = convert(INT,@currstring)
														  AND    chacm_cham_id = cham_slab_no 
														   
																COMMIT TRANSACTION
														--
												  END
										    
										  --
										  END
										  
										  
										  
										  
										  
										  
										--
										END
										IF @pa_action = 'REJ'
										BEGIN
										--
										  update chacm_mak
												set    chacm_lst_upd_dt = getdate()
																	, chacm_lst_upd_by = @pa_login_name
																	, chacm_deleted_ind = 3
												FROM   chacm_mak 
													,     cham_mak			
												where  chacm_deleted_ind = 0   
												AND    cham_slab_no     = convert(INT,@currstring)
												AND    chacm_cham_id     = cham_slab_no 
												
												 update cham_mak
													set    cham_lst_upd_dt = getdate()
																		, cham_lst_upd_by = @pa_login_name
																		, cham_deleted_ind = 3
													where  cham_deleted_ind = 0   
													AND   cham_slab_no      = convert(INT,@currstring)
												
										--
										END
										
												
										
										
								END
						--
						END
				--
				END
		--
		END
		SET @pa_errmsg = @t_errorstr
--
END

GO
