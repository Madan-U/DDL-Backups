-- Object: PROCEDURE citrus_usr.pr_holding_process_dpc9_new
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_holding_process_dpc9_new](@pa_holding_date datetime,@l_dpm_id numeric(10,0),@pa_login_name varchar(25),@pa_count int)
AS 
BEGIN
--

  DECLARE @t_errorstr        VARCHAR(8000)
        , @l_error           BIGINT
        , @l_holding_dt      datetime
		, @l_maxdate		 datetime

  BEGIN TRANSACTION
  				select @l_holding_dt = @pa_holding_date

				delete from tmp_dpc9_cdsl_trx_hldg where tmpdpc9_hldg_dpam_id = 0 

				DELETE FROM tmp_dpc9_cdsl_trx_hldg 
				WHERE NOT EXISTS (SELECT TMPDPC9_DPAM_ID,TMPDPC9_ISIN from tmp_dpc9_cdsl_trx_mstr t 
				where t.TMPDPC9_DPAM_ID = tmpdpc9_hldg_dpam_id
				and t.TMPDPC9_ISIN =  tmpdpc9_hldg_isin
				AND T.TMPDPC9_CTR_SETTID = TMPDPC9_HLDG_CTR_SETTID)


				DELETE dphmcd
				FROM   dp_daily_hldg_cdsl dphmcd,tmp_dpc9_cdsl_trx_hldg
				WHERE  dphmcd_holding_dt = @l_holding_dt
				AND    dphmcd_dpam_id = tmpdpc9_hldg_dpam_id
				and	   dphmcd_isin = tmpdpc9_hldg_isin
				AND    dphmcd_dpm_id = @l_dpm_id
				AND    dphmcd_cntr_settm_id  = TMPDPC9_HLDG_CTR_SETTID
				
				
                UPDATE dphmcd SET DPHMCD_HOLDING_TO_DT = @l_holding_dt
                FROM   dp_daily_hldg_cdsl dphmcd,tmp_dpc9_cdsl_trx_hldg T
				WHERE t.TMPDPC9_HLDG_DPAM_ID = DPHMCD_DPAM_ID
				and t.TMPDPC9_HLDG_ISIN =  DPHMCD_ISIN
				AND T.TMPDPC9_HLDG_CTR_SETTID = dphmcd_cntr_settm_id
				AND DPHMCD_HOLDING_TO_DT IS NULL 
				AND DPHMCD_HOLDING_DT < @l_holding_dt 
				




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
				,dphmcd_deleted_ind)
				select @l_dpm_id  
				,TMPDPC9_HLDG_DPAM_ID
				,TMPDPC9_HLDG_ISIN
				,TMPDPC9_HLDG_CURR_QTY
				,TMPDPC9_HLDG_FREE_QTY
				,freeze_qty=0
				,TMPDPC9_HLDG_PLEDGE_QTY
				,demat_pnd_ver_qty=0
				,remat_pnd_conf_qty=0
				,demat_pnd_conf_qty=0
				,TMPDPC9_HLDG_SAFEKEEP_QTY
				,TMPDPC9_HLDG_LOCKEDIN_QTY
				,elimination_qty=0
				,TMPDPC9_HLDG_EARMARKED_QTY
				,TMPDPC9_HLDG_AVL_QTY
				,TMPDPC9_HLDG_LEND_QTY
				,TMPDPC9_HLDG_BORROW_QTY
				,@l_holding_dt
				,@pa_login_name
				,getdate()
				,@pa_login_name
				,getdate()
				,1
			from tmp_dpc9_cdsl_trx_hldg
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
			,dphmc_deleted_ind)
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
			,1
			from fn_dailyholding_cdsl_HO(@l_dpm_id,@l_maxdate,'','','','')  
			
			
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
