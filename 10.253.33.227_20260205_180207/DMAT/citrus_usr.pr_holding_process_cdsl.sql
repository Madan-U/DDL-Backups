-- Object: PROCEDURE citrus_usr.pr_holding_process_cdsl
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_holding_process_cdsl 'jun 24 2009',3,'HO',1
--rollback
CREATE procedure [citrus_usr].[pr_holding_process_cdsl](@pa_holding_date datetime,@l_dpm_id numeric(10,0),@pa_login_name varchar(25),@pa_count int)
AS 
BEGIN
--

  DECLARE @t_errorstr        VARCHAR(8000)
        , @l_error           BIGINT
        , @l_holding_dt      datetime
								, @l_max_holding_dt  datetime
        , @l_prev_holding_dt datetime
        , @l_excm_id        numeric(10,0)
        , @l_next_holding_dt datetime

  select @l_excm_id = excm_id from dp_mstr , exchange_mstr ,exch_seg_mstr where excsm_exch_cd= excm_cd and excsm_id = dpm_excsm_id and dpm_id = @l_dpm_id and dpm_deleted_ind = 1       

  BEGIN TRANSACTION
  

	
--0 internal
--1 for response(app)
--2 reject
--3 execution success
--4 execution reject 


-- holding


  


	select @l_holding_dt = @pa_holding_date



	select top 1 @l_prev_holding_dt = dphmcd_holding_dt from DP_DAILY_HLDG_CDSL WHERE dphmcd_holding_dt < @l_holding_dt order by dphmcd_holding_dt desc

	set  @l_prev_holding_dt  = isnull(@l_prev_holding_dt,'jan  1 1900')

	select top 1 @l_max_holding_dt = DPHMC_HOLDING_DT from DP_HLDG_MSTR_CDSL 
	
	set  @l_max_holding_dt  = isnull(@l_max_holding_dt,'jan  1 1900')

 
 
 if @pa_count = 1
 begin
 --
 
 
		CREATE TABLE #tmp_dp_hldg_cdsl
			(TMPHLDG_BOID VARCHAR(16)
			,TMPHLDG_ISIN VARCHAR(12)
			,TMPHLDG_BAL_TYPE VARCHAR(30)
			,TMPHLDG_CLSNG_BAL NUMERIC(18,5)
				,TMPHLDG_DPM_ID INT
				,TMPHLDG_DPAM_ID BIGINT 
				,tmphldg_cur_qty NUMERIC(18,5)
				,tmphldg_free_qty NUMERIC(18,5)
				,tmphldg_freeze_qty NUMERIC(18,5)
				,tmphldg_demat_pnd_ver_qty NUMERIC(18,5)
				,tmphldg_demat_pnd_conf_qty NUMERIC(18,5)
				,tmphldg_remat_pnd_conf_qty NUMERIC(18,5)
				,tmphldg_safe_keeping_qty NUMERIC(18,5)
				,tmphldg_lockin_qty  NUMERIC(18,5)
				,tmphldg_earmark_qty NUMERIC(18,5)
				,tmphldg_elimination_qty NUMERIC(18,5)
				,tmphldg_avail_lend_qty NUMERIC(18,5)
				,tmphldg_lend_qty NUMERIC(18,5)
				,tmphldg_borrow_qty NUMERIC(18,5)
				,tmphldg_pledge_qty NUMERIC(18,5)
				,tmphldg_holding_dt datetime,TMPHLDG_CTR_SETTID varchar(20) 
			)



			INSERT INTO #tmp_dp_hldg_cdsl
			( TMPHLDG_BOID
				,TMPHLDG_ISIN
				,TMPHLDG_BAL_TYPE
				,tmphldg_clsng_bal
				,tmphldg_dpm_id
				,tmphldg_dpam_id
				,tmphldg_cur_qty
				,tmphldg_free_qty
				,tmphldg_freeze_qty
				,tmphldg_demat_pnd_ver_qty
				,tmphldg_demat_pnd_conf_qty
				,tmphldg_remat_pnd_conf_qty
				,tmphldg_safe_keeping_qty
				,tmphldg_lockin_qty
				,tmphldg_earmark_qty
				,tmphldg_elimination_qty
				,tmphldg_avail_lend_qty
				,tmphldg_lend_qty
				,tmphldg_borrow_qty
				,tmphldg_pledge_qty
				,tmphldg_holding_dt ,TMPHLDG_CTR_SETTID
			)SELECT DISTINCT  tmphldg_boid
				,tmphldg_isin
				,tmphldg_bal_type
				,tmphldg_clsng_bal
				,tmphldg_dpm_id
				,tmphldg_dpam_id
				,tmphldg_cur_qty=0
				,tmphldg_free_qty=0
				,tmphldg_freeze_qty=0
				,tmphldg_demat_pnd_ver_qty=0
				,tmphldg_demat_pnd_conf_qty=0
				,tmphldg_remat_pnd_conf_qty=0
				,tmphldg_safe_keeping_qty=0
				,tmphldg_lockin_qty=0
				,tmphldg_earmark_qty=0
				,tmphldg_elimination_qty=0
				,tmphldg_avail_lend_qty=0
				,tmphldg_lend_qtY=0
				,tmphldg_borrow_qty=0
				,tmphldg_pledge_qty=0
				,tmphldg_holding_dt,TMPHLDG_CTR_SETTID
				FROM tmp_cdsl_trx_hldg 
				where isnull(tmphldg_dpam_id,0) <> 0

			update  #tmp_dp_hldg_cdsl
			set     tmphldg_cur_qty               = case when tmphldg_bal_type    = 'CURRENT' then tmphldg_clsng_bal else 0 end
										,tmphldg_free_qty              = case when tmphldg_bal_type    = 'FREE' then tmphldg_clsng_bal else 0  end
										,tmphldg_freeze_qty            = case when tmphldg_bal_type    = 'FREEZE' then  tmphldg_clsng_bal else 0  end
										,tmphldg_pledge_qty            = case when tmphldg_bal_type    = 'PLEDGE' then tmphldg_clsng_bal  else 0  end
										,tmphldg_demat_pnd_ver_qty     = case when tmphldg_bal_type    = 'DEMAT PENDING VERIFICATION'  then tmphldg_clsng_bal else 0  end
										,tmphldg_demat_pnd_conf_qty    = case when tmphldg_bal_type    = 'REMAT PENDING CONFERMATION' then tmphldg_clsng_bal else 0 end 
										,tmphldg_remat_pnd_conf_qty    = case when tmphldg_bal_type    = 'DEMAT PENDING CONFERMATION' then tmphldg_clsng_bal else 0 end 
										,tmphldg_safe_keeping_qty      = case when tmphldg_bal_type    = 'SAFE-KEEPING' then tmphldg_clsng_bal else 0  end 
										,tmphldg_lockin_qty            = case when tmphldg_bal_type    = 'LOCKIN' then tmphldg_clsng_bal else 0  end 
										,tmphldg_elimination_qty       = case when tmphldg_bal_type    = 'ELIMINATION' then tmphldg_clsng_bal else 0 end 
										,tmphldg_earmark_qty           = case when tmphldg_bal_type    = 'EARNMARK' then tmphldg_clsng_bal else 0 end 
										,tmphldg_avail_lend_qty        = case when tmphldg_bal_type    = 'AVAILABLE FOR LENDING' then tmphldg_clsng_bal else 0 end 
										,tmphldg_lend_qty              = case when tmphldg_bal_type    = 'LEND'then tmphldg_clsng_bal else 0 end 
										,tmphldg_borrow_qty            = case when tmphldg_bal_type    = 'BORROW' then tmphldg_clsng_bal else 0 end 



			TRUNCATE 	TABLE tmp_cdsl_trx_hldg

			INSERT INTO tmp_cdsl_trx_hldg
			(tmphldg_dpam_id
			,tmphldg_dpm_id
			,tmphldg_boid
			,tmphldg_isin
			,tmphldg_cur_qty
			,tmphldg_free_qty
			,tmphldg_freeze_qty
			,tmphldg_demat_pnd_ver_qty
			,tmphldg_demat_pnd_conf_qty
			,tmphldg_remat_pnd_conf_qty
			,tmphldg_safe_keeping_qty
			,tmphldg_lockin_qty
			,tmphldg_earmark_qty
			,tmphldg_elimination_qty
			,tmphldg_avail_lend_qty
			,tmphldg_lend_qty
			,tmphldg_borrow_qty
			,tmphldg_pledge_qty
			,tmphldg_holding_dt,TMPHLDG_CTR_SETTID) 
			SELECT tmphldg_dpam_id
			 ,tmphldg_dpm_id
			 ,tmphldg_boid
				,tmphldg_isin
				,SUM(tmphldg_cur_qty)
				,SUM(tmphldg_free_qty)
				,SUM(tmphldg_freeze_qty)
				,SUM(tmphldg_demat_pnd_ver_qty)
				,SUM(tmphldg_demat_pnd_conf_qty)
				,SUM(tmphldg_remat_pnd_conf_qty)
				,SUM(tmphldg_safe_keeping_qty)
				,SUM(tmphldg_lockin_qty)
				,SUM(tmphldg_earmark_qty)
				,SUM(tmphldg_elimination_qty)
				,SUM(tmphldg_avail_lend_qty	)	
				,SUM(tmphldg_lend_qtY)
				,SUM(tmphldg_borrow_qty)
				,SUM(tmphldg_pledge_qty)
				,tmphldg_holding_dt,TMPHLDG_CTR_SETTID
			froM #tmp_dp_hldg_cdsl
			GROUP BY tmphldg_dpam_id,tmphldg_dpm_id,tmphldg_boid,tmphldg_isin,tmphldg_holding_dt,TMPHLDG_CTR_SETTID
	
			
	--
	end
	


	create table #tmp_dp_daily_hldg_cdsl
	(dphmcd_dpam_id numeric(10,0)  
	,dphmcd_isin varchar(20)  
	,dphmcd_curr_qty numeric(18,5)  
	,dphmcd_free_qty numeric(18,5)  
	,dphmcd_freeze_qty numeric(18,5)
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
	,dphmcd_borrow_qty numeric(18,5) ,dphmcd_cntr_settm_id varchar(20)
	)



	INSERT INTO #tmp_dp_daily_hldg_cdsl
	(dphmcd_dpam_id
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
	,dphmcd_borrow_qty,dphmcd_cntr_settm_id
	)
		SELECT tmphldg_dpam_id
							, tmphldg_isin
							, tmphldg_cur_qty   
							, tmphldg_free_qty          
							, tmphldg_freeze_qty        
							, tmphldg_pledge_qty     
							, tmphldg_demat_pnd_ver_qty 
							, tmphldg_remat_pnd_conf_qty 
							, tmphldg_demat_pnd_conf_qty 
							, tmphldg_safe_keeping_qty   
							, tmphldg_lockin_qty         
							, tmphldg_elimination_qty    
							, tmphldg_earmark_qty        
							, tmphldg_avail_lend_qty     
							, tmphldg_lend_qty           
							, tmphldg_borrow_qty ,TMPHLDG_CTR_SETTID        
		FROM   tmp_cdsl_trx_hldg
		where  tmphldg_holding_dt = @l_holding_dt
		and    isnull(tmphldg_dpam_id,0) <> 0


	
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
	    and    not exists (select dphmcd_isin,dphmcd_dpam_id from #tmp_dp_daily_hldg_cdsl tmp where tmp.dphmcd_isin = dpdhcd.dphmcd_isin and tmp.dphmcd_dpam_id = dpdhcd.dphmcd_dpam_id and isnull(tmp.dphmcd_cntr_settm_id,'') = isnull(dpdhcd.dphmcd_cntr_settm_id,''))
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
			set   dphmcd_curr_qty = tmphldg_cur_qty
								,dphmcd_free_qty  = tmphldg_free_qty
								,dphmcd_freeze_qty = tmphldg_freeze_qty
								,dphmcd_pledge_qty =  tmphldg_pledge_qty
								,dphmcd_demat_pnd_ver_qty = tmphldg_demat_pnd_ver_qty
								,dphmcd_remat_pnd_conf_qty= tmphldg_remat_pnd_conf_qty
								,dphmcd_demat_pnd_conf_qty= tmphldg_demat_pnd_conf_qty
								,dphmcd_safe_keeping_qty =  tmphldg_safe_keeping_qty
								,dphmcd_lockin_qty =  tmphldg_lockin_qty
								,dphmcd_elimination_qty =  tmphldg_elimination_qty
								,dphmcd_earmark_qty =  tmphldg_earmark_qty
								,dphmcd_avail_lend_qty  =  tmphldg_avail_lend_qty
								,dphmcd_lend_qty =  tmphldg_lend_qty
								,dphmcd_borrow_qty =  tmphldg_borrow_qty
			FROM   tmp_cdsl_trx_hldg tmpcdslhld
						,   #tmp_dp_daily_hldg_cdsl tmp
			WHERE  tmpcdslhld.tmphldg_dpam_id = dphmcd_dpam_id
			AND    tmpcdslhld.tmphldg_isin    = tmp.dphmcd_isin
			AND    tmpcdslhld.tmphldg_dpm_id  = @l_dpm_id
			AND    tmphldg_holding_dt         = @l_holding_dt
			
	
			
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
		,dphmcd_borrow_qty,dphmcd_cntr_settm_id
	)
		SELECT tmphldg_dpam_id
							, tmphldg_isin
							, tmphldg_cur_qty   
							, tmphldg_free_qty          
							, tmphldg_freeze_qty        
							, tmphldg_demat_pnd_ver_qty 
							, tmphldg_demat_pnd_conf_qty 
							, tmphldg_remat_pnd_conf_qty 
							, tmphldg_safe_keeping_qty   
							, tmphldg_lockin_qty         
							, tmphldg_earmark_qty        
							, tmphldg_elimination_qty    
							, tmphldg_avail_lend_qty     
							, tmphldg_lend_qty           
							, tmphldg_borrow_qty         
							, tmphldg_pledge_qty , TMPHLDG_CTR_SETTID    
		FROM   tmp_cdsl_trx_hldg
		WHERE  tmphldg_dpm_id     = @l_dpm_id 
		and    tmphldg_holding_dt = @l_holding_dt
		AND    NOT EXISTS(select tmp.dphmcd_dpam_id from #tmp_dp_daily_hldg_cdsl tmp where tmp.dphmcd_dpam_id = tmphldg_dpam_id and tmp.dphmcd_isin= tmphldg_isin and isnull(tmp.dphmcd_cntr_settm_id,'') = isnull(TMPHLDG_CTR_SETTID,''))
		
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

	
		/*IF @l_prev_holding_dt <> @l_max_holding_dt
		BEGIN
	 --
	   set  @l_next_holding_dt = citrus_usr.GetNextWorkingDate(@l_holding_dt,@l_excm_id) 
	   
	   while  @l_next_holding_dt is not null  and @l_next_holding_dt <=  @l_max_holding_dt
	   begin
	   --
	      
	      
	     	insert into dp_daily_hldg_cdsl
							 (dphmcd_dpam_id
							 ,dphmcd_dpm_id
								,dphmcd_isin
								,dphmcd_curr_qty
								,dphmcd_free_qty
								,dphmcd_freeze_qty
								,dphmcd_demat_pnd_ver_qty
								,dphmcd_demat_pnd_conf_qty
								,dphmcd_remat_pnd_conf_qty
								,dphmcd_safe_keeping_qty
								,dphmcd_lockin_qty
								,dphmcd_earmark_qty
								,dphmcd_elimination_qty
						  ,dphmcd_avail_lend_qty
								,dphmcd_lend_qty
								,dphmcd_borrow_qty
								,dphmcd_pledge_qty
								,dphmcd_holding_dt
								,dphmcd_created_by
								,dphmcd_created_dt
								,dphmcd_lst_upd_by
								,dphmcd_lst_upd_dt
		      ,dphmcd_deleted_ind)
		      SELECT 
		      tmphldg_dpam_id
		     ,tmphldg_dpm_id
							,tmphldg_isin
							,tmphldg_cur_qty            
							,tmphldg_free_qty           
							,tmphldg_freeze_qty         
							,tmphldg_demat_pnd_ver_qty  
							,tmphldg_demat_pnd_conf_qty 
							,tmphldg_remat_pnd_conf_qty 
							,tmphldg_safe_keeping_qty   
							,tmphldg_lockin_qty         
							,tmphldg_earmark_qty        
							,tmphldg_elimination_qty    
							,tmphldg_avail_lend_qty     
							,tmphldg_lend_qty           
							,tmphldg_borrow_qty         
						 ,tmphldg_pledge_qty         
						 ,@l_next_holding_dt
							,@pa_login_name
							,getdate()
							,@pa_login_name
							,getdate()
							,1
	       FROM   tmp_cdsl_trx_hldg
	       WHERE  not exists (select dphmcd_isin from dp_daily_hldg_cdsl where dphmcd_holding_dt = @l_next_holding_dt and dphmcd_isin = tmphldg_isin and tmphldg_dpam_id = dphmcd_dpam_id)
	       
     
	       set @l_next_holding_dt = citrus_usr.GetNextWorkingDate(@l_next_holding_dt,@l_excm_id) 
	   --
	   end
	   
	  
	   if @l_next_holding_dt >  @l_max_holding_dt
	   begin
	   --
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
							,dphmc_deleted_ind)
							 SELECT 
								tmphldg_dpam_id
							,tmphldg_dpm_id
							,tmphldg_isin
							,tmphldg_cur_qty            
							,tmphldg_free_qty           
							,tmphldg_freeze_qty         
							,tmphldg_demat_pnd_ver_qty  
							,tmphldg_demat_pnd_conf_qty 
							,tmphldg_remat_pnd_conf_qty 
							,tmphldg_safe_keeping_qty   
							,tmphldg_lockin_qty         
							,tmphldg_earmark_qty        
							,tmphldg_elimination_qty    
							,tmphldg_avail_lend_qty     
							,tmphldg_lend_qty           
							,tmphldg_borrow_qty         
							,tmphldg_pledge_qty         
							,@l_max_holding_dt
							,@pa_login_name
							,getdate()
							,@pa_login_name
							,getdate()
							,1
								FROM   tmp_cdsl_trx_hldg
								WHERE  not exists (select dphmc_isin from dp_hldg_mstr_cdsl where dphmc_holding_dt = @l_max_holding_dt and dphmc_isin = tmphldg_isin and tmphldg_dpam_id = dphmc_dpam_id)
								
								
								
							update dp_hldg_mstr_cdsl
							set   dphmc_curr_qty = tmphldg_cur_qty
												,dphmc_free_qty  = tmphldg_free_qty
												,dphmc_freeze_qty = tmphldg_freeze_qty
												,dphmc_pledge_qty =  tmphldg_pledge_qty
												,dphmc_demat_pnd_ver_qty = tmphldg_demat_pnd_ver_qty
												,dphmc_remat_pnd_conf_qty= tmphldg_remat_pnd_conf_qty
												,dphmc_demat_pnd_conf_qty= tmphldg_demat_pnd_conf_qty
												,dphmc_safe_keeping_qty =  tmphldg_safe_keeping_qty
												,dphmc_lockin_qty =  tmphldg_lockin_qty
												,dphmc_elimination_qty =  tmphldg_elimination_qty
												,dphmc_earmark_qty =  tmphldg_earmark_qty
												,dphmc_avail_lend_qty  =  tmphldg_avail_lend_qty
												,dphmc_lend_qty =  tmphldg_lend_qty
												,dphmc_borrow_qty =  tmphldg_borrow_qty
							FROM   tmp_cdsl_trx_hldg tmpcdslhld
										,   dp_hldg_mstr_cdsl 
							WHERE  tmpcdslhld.tmphldg_dpam_id = dphmc_dpam_id
							AND    tmpcdslhld.tmphldg_isin    = dphmc_isin
							AND    tmpcdslhld.tmphldg_dpm_id  = @l_dpm_id
			    AND    tmphldg_holding_dt         = @l_holding_dt
	       
							
	   --
	   end
	   
	 --
	 END*/
	  
			
	 
	 
		IF isnull(@t_errorstr,'') = ''
		BEGIN
		--
				COMMIT TRANSACTION

     
		--
		END
--
end

GO
