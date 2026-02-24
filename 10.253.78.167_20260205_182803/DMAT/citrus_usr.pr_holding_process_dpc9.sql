-- Object: PROCEDURE citrus_usr.pr_holding_process_dpc9
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_holding_process_dpc9](@pa_holding_date datetime,@l_dpm_id numeric(10,0),@pa_login_name varchar(25),@pa_count int)
AS 
BEGIN
--

  DECLARE @t_errorstr        VARCHAR(8000)
        , @l_error           BIGINT
        , @l_holding_dt      datetime
								, @l_max_holding_dt  datetime
        , @l_prev_holding_dt datetime
        , @l_excm_id         int
        , @l_next_holding_dt datetime

  select @l_excm_id = excm_id from dp_mstr , exchange_mstr ,exch_seg_mstr where excsm_exch_cd= excm_cd and excsm_id = dpm_excsm_id and dpm_id = @l_dpm_id and dpm_deleted_ind = 1         

  BEGIN TRANSACTION
  

	
/*TMPDPC9_HLDG_BOID
TMPDPC9_HLDG_BONM
TMPDPC9_HLDG_ISIN
TMPDPC9_HLDG_ISIN_SHRT_DESC
TMPDPC9_HLDG_TRX_DT
TMPDPC9_HLDG_CURR_QTY
TMPDPC9_HLDG_SAFEKEEP_QTY
TMPDPC9_HLDG_PLEDGE_QTY
TMPDPC9_HLDG_FREE_QTY
TMPDPC9_HLDG_LOCKEDIN_QTY
TMPDPC9_HLDG_EARMARKED_QTY
TMPDPC9_HLDG_LEND_QTY
TMPDPC9_HLDG_AVL_QTY
TMPDPC9_HLDG_BORROW_QTY
tmpdpc9_hldg_dpam_id
TMPDPC9_DPM_ID*/



-- holding


  


	select @l_holding_dt = @pa_holding_date

	select top 1 @l_prev_holding_dt = dphmcd_holding_dt from DP_DAILY_HLDG_CDSL WHERE dphmcd_holding_dt < @l_holding_dt order by dphmcd_holding_dt desc

	set  @l_prev_holding_dt  = isnull(@l_prev_holding_dt,'jan  1 1900')

	select top 1 @l_max_holding_dt = DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL 

 set  @l_max_holding_dt  = isnull(@l_max_holding_dt,'jan  1 1900')
 
 
 
 
			create table #tmp_dp_daily_hldg_cdsl
			(dphmcd_dpam_id numeric(10,0)  
			,dphmcd_dpm_id  numeric(10,0)  
			,dphmcd_isin varchar(20)  
			,dphmcd_curr_qty numeric(18,5)  
			,dphmcd_free_qty numeric(18,5)  
			,dphmcd_freeze_qty numeric(18,0)
			,dphmcd_pledge_qty numeric(18,5)  
			,dphmcd_demat_pnd_ver_qty numeric(18,5) 
			,dphmcd_remat_pnd_conf_qty numeric(18,5)  
			,dphmcd_demat_pnd_conf_qty numeric(18,5)  
			,dphmcd_safe_keeping_qty numeric(18,5) 
			,dphmcd_lockin_qty numeric(18,5) 
			,dphmcd_elimination_qty numeric(18,5) 
			,dphmcd_earmark_qty numeric(18,5) 
			,dphmcd_avail_lend_qty numeric(18,5)  
			,dphmcd_lend_qty numeric(18,5) 
			,dphmcd_borrow_qty numeric(18,5) , dphmcd_cntr_settm_id varchar(20) 
			)


			INSERT INTO #tmp_dp_daily_hldg_cdsl
			(dphmcd_dpam_id
			,dphmcd_dpm_id
			,dphmcd_isin 
			,dphmcd_curr_qty 
			,dphmcd_free_qty 
			,dphmcd_pledge_qty 
			,dphmcd_safe_keeping_qty 
			,dphmcd_lockin_qty 
			,dphmcd_earmark_qty 
			,dphmcd_avail_lend_qty 
			,dphmcd_lend_qty 
			,dphmcd_borrow_qty,dphmcd_cntr_settm_id
			)
				SELECT tmpdpc9_hldg_dpam_id
									, @l_dpm_id
									, tmpdpc9_hldg_isin
									, tmpdpc9_hldg_curr_qty   
									, tmpdpc9_hldg_free_qty 
									, tmpdpc9_hldg_pledge_qty
									, tmpdpc9_hldg_safekeep_qty   
									, tmpdpc9_hldg_lockedin_qty         
									, tmpdpc9_hldg_earmarked_qty        
									, tmpdpc9_hldg_avl_qty
									, tmpdpc9_hldg_lend_qty                
									, tmpdpc9_hldg_borrow_qty  ,TMPDPC9_HLDG_SETTID_04       
				FROM   tmp_dpc9_cdsl_trx_hldg
				where  tmpdpc9_hldg_trx_dt = @l_holding_dt
				and    isnull(tmpdpc9_hldg_dpam_id,0) <> 0 

		
	
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

				INSERT INTO #tmp_dp_daily_hldg_cdsl
				(dphmcd_dpam_id
				,dphmcd_dpm_id
				,dphmcd_isin 
				,dphmcd_curr_qty 
				,dphmcd_free_qty 
				,dphmcd_freeze_qty 
				,dphmcd_pledge_qty 
				,dphmcd_demat_pnd_ver_qty 
				,dphmcd_remat_pnd_conf_qty
				,dphmcd_demat_pnd_conf_qty
				,dphmcd_safe_keeping_qty 
				,dphmcd_lockin_qty 
				,dphmcd_elimination_qty 
				,dphmcd_earmark_qty 
				,dphmcd_avail_lend_qty 
				,dphmcd_lend_qty 
				,dphmcd_borrow_qty ,dphmcd_cntr_settm_id
				)
				SELECT  dphmcd_dpam_id
											,dphmcd_dpm_id
											,dphmcd_isin
											,dphmcd_curr_qty 
											,dphmcd_free_qty 
											,dphmcd_freeze_qty 
											,dphmcd_pledge_qty 
											,dphmcd_demat_pnd_ver_qty 
											,dphmcd_remat_pnd_conf_qty
											,dphmcd_demat_pnd_conf_qty
											,dphmcd_safe_keeping_qty 
											,dphmcd_lockin_qty 
											,dphmcd_elimination_qty 
											,dphmcd_earmark_qty 
											,dphmcd_avail_lend_qty 
											,dphmcd_lend_qty 
											,dphmcd_borrow_qty ,dphmcd_cntr_settm_id
					FROM   dp_daily_hldg_cdsl  dpdhcd
					WHERE  dphmcd_holding_dt = @l_prev_holding_dt
					AND    dphmcd_dpm_id     = @l_dpm_id 
					and    not exists (select dphmcd_isin,dphmcd_dpam_id from #tmp_dp_daily_hldg_cdsl tmp where tmp.dphmcd_isin = dpdhcd.dphmcd_isin and tmp.dphmcd_dpam_id = dpdhcd.dphmcd_dpam_id and isnull(dphmcd_cntr_settm_id,'') = isnull(dphmcd_cntr_settm_id,''))
					
	
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
	
			update #tmp_dp_daily_hldg_cdsl
			set   dphmcd_curr_qty = ISNULL(tmpdpc9_hldg_curr_qty,0)
								,dphmcd_free_qty  = ISNULL(tmpdpc9_hldg_free_qty,0)
								,dphmcd_pledge_qty =  ISNULL(tmpdpc9_hldg_pledge_qty,0)
								,dphmcd_safe_keeping_qty =  ISNULL(tmpdpc9_hldg_safekeep_qty,0)
								,dphmcd_lockin_qty =  ISNULL(tmpdpc9_hldg_lockedin_qty,0)
								,dphmcd_earmark_qty =  ISNULL(tmpdpc9_hldg_earmarked_qty,0)
								,dphmcd_avail_lend_qty  =  ISNULL(tmpdpc9_hldg_avl_qty,0)
								,dphmcd_lend_qty =  ISNULL(tmpdpc9_hldg_lend_qty,0)
								,dphmcd_borrow_qty =  ISNULL(tmpdpc9_hldg_borrow_qty,0)
			FROM   tmp_dpc9_cdsl_trx_hldg tmpcdslhld
						,   #tmp_dp_daily_hldg_cdsl tmp
			WHERE  tmpcdslhld.tmpdpc9_hldg_dpam_id= dphmcd_dpam_id
			AND    tmpcdslhld.tmpdpc9_hldg_isin   = tmp.dphmcd_isin
			AND    tmpcdslhld.tmpdpc9_hldg_dpm_id = @l_dpm_id
			AND    tmpdpc9_hldg_trx_dt       = @l_holding_dt
	
			
			
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
	

	INSERT INTO #tmp_dp_daily_hldg_cdsl
		(dphmcd_dpam_id
		,dphmcd_dpm_id
		,dphmcd_isin 
		,dphmcd_curr_qty 
		,dphmcd_free_qty 
		,dphmcd_safe_keeping_qty 
		,dphmcd_lockin_qty 
		,dphmcd_earmark_qty 
		,dphmcd_avail_lend_qty 
		,dphmcd_lend_qty 
		,dphmcd_borrow_qty
		,dphmcd_pledge_qty ,dphmcd_cntr_settm_id
	)
		SELECT tmpdpc9_hldg_dpam_id
		     , tmpdpc9_hldg_dpm_id
							, tmpdpc9_hldg_isin
							, tmpdpc9_hldg_curr_qty   
							, tmpdpc9_hldg_free_qty          
							, tmpdpc9_hldg_safekeep_qty   
							, tmpdpc9_hldg_lockedin_qty         
							, tmpdpc9_hldg_earmarked_qty        
							, tmpdpc9_hldg_avl_qty    
							, tmpdpc9_hldg_lend_qty     
							, tmpdpc9_hldg_borrow_qty           
							, tmpdpc9_hldg_pledge_qty         
							,TMPDPC9_HLDG_CTR_SETTID
		FROM   tmp_dpc9_cdsl_trx_hldg 
		WHERE  tmpdpc9_hldg_dpm_id = @l_dpm_id 
		and    tmpdpc9_hldg_trx_dt = @l_holding_dt
		AND    NOT EXISTS(select tmp.dphmcd_dpam_id from #tmp_dp_daily_hldg_cdsl tmp where tmp.dphmcd_dpam_id = tmpdpc9_hldg_dpam_id and tmp.dphmcd_isin= tmpdpc9_hldg_isin and isnull(TMPDPC9_HLDG_CTR_SETTID,'') = isnull(dphmcd_cntr_settm_id,''))
		
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

	IF (@l_prev_holding_dt = @l_max_holding_dt OR @pa_holding_date = @l_max_holding_dt)
	begin
	--
	TRUNCATE TABLE dp_hldg_mstr_cdsl
	  
	  
	  insert into dp_hldg_mstr_cdsl
	  (dphmc_dpm_id
	  ,dphmc_dpam_id
			,dphmc_isin
			,dphmc_curr_qty
			,dphmc_free_qty
			,dphmc_freeze_qty
			,dphmc_pledge_qty
			,dphmc_demat_pnd_ver_qty
			,dphmc_remat_pnd_conf_qty
			,dphmc_demat_pnd_conf_qty
			,dphmc_safe_keeping_qty
			,dphmc_lockin_qty
			,dphmc_elimination_qty
			,dphmc_earmark_qty
			,dphmc_avail_lend_qty
			,dphmc_lend_qty
			,dphmc_borrow_qty
			,dphmc_holding_dt
			,dphmc_created_by
			,dphmc_created_dt
			,dphmc_lst_upd_by
			,dphmc_lst_upd_dt
			,dphmc_deleted_ind,dphmc_cntr_settm_id)
	  select @l_dpm_id 
	  ,dphmcd_dpam_id
			,dphmcd_isin
			,dphmcd_curr_qty
			,dphmcd_free_qty
			,dphmcd_freeze_qty
			,dphmcd_pledge_qty
			,dphmcd_demat_pnd_ver_qty
			,dphmcd_remat_pnd_conf_qty
			,dphmcd_demat_pnd_conf_qty
			,dphmcd_safe_keeping_qty
			,dphmcd_lockin_qty
			,dphmcd_elimination_qty
			,dphmcd_earmark_qty
			,dphmcd_avail_lend_qty
			,dphmcd_lend_qty
			,dphmcd_borrow_qty
			,@l_holding_dt
			,@pa_login_name
			,getdate()
	  ,@pa_login_name
			,getdate()
			,1,dphmcd_cntr_settm_id
			from #tmp_dp_daily_hldg_cdsl
			
			
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
	--
	end
	
	
		DELETE dphmcd
		FROM   dp_daily_hldg_cdsl dphmcd
								,dp_acct_mstr
		WHERE  dphmcd_holding_dt = @l_holding_dt
		AND    dphmcd_dpam_id = dpam_id 
		AND    dpam_dpm_id = @l_dpm_id



		insert into dp_daily_hldg_cdsl
		(dphmcd_dpm_id
		,dphmcd_dpam_id
		,dphmcd_isin
		,dphmcd_curr_qty
		,dphmcd_free_qty
		,dphmcd_freeze_qty
		,dphmcd_pledge_qty
		,dphmcd_demat_pnd_ver_qty
		,dphmcd_remat_pnd_conf_qty
		,dphmcd_demat_pnd_conf_qty
		,dphmcd_safe_keeping_qty
		,dphmcd_lockin_qty
		,dphmcd_elimination_qty
		,dphmcd_earmark_qty
		,dphmcd_avail_lend_qty
		,dphmcd_lend_qty
		,dphmcd_borrow_qty
		,dphmcd_holding_dt
		,dphmcd_created_by
		,dphmcd_created_dt
		,dphmcd_lst_upd_by
		,dphmcd_lst_upd_dt
		,dphmcd_deleted_ind,dphmcd_cntr_settm_id)
		select @l_dpm_id  
		,dphmcd_dpam_id
		,dphmcd_isin
		,dphmcd_curr_qty
		,dphmcd_free_qty
		,dphmcd_freeze_qty
		,dphmcd_pledge_qty
		,dphmcd_demat_pnd_ver_qty
		,dphmcd_remat_pnd_conf_qty
		,dphmcd_demat_pnd_conf_qty
		,dphmcd_safe_keeping_qty
		,dphmcd_lockin_qty
		,dphmcd_elimination_qty
		,dphmcd_earmark_qty
		,dphmcd_avail_lend_qty
		,dphmcd_lend_qty
		,dphmcd_borrow_qty
		,@l_holding_dt
		,@pa_login_name
		,getdate()
		,@pa_login_name
		,getdate()
		,1,dphmcd_cntr_settm_id
	from #tmp_dp_daily_hldg_cdsl
	
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

	
  IF isnull(@t_errorstr,'') = ''
		BEGIN
		--
				COMMIT TRANSACTION
		--
		END
--
end

GO
