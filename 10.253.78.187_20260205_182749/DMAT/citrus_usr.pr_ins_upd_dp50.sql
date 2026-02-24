-- Object: PROCEDURE citrus_usr.pr_ins_upd_dp50
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[pr_ins_upd_dp50] 'ho','12054100',21
--SELECT * FROM DP_MSTR
CREATE procedure [citrus_usr].[pr_ins_upd_dp50](@pa_login_name varchar(25)
                               ,@pa_dpmdpid    varchar(25)
                               ,@pa_task_id    numeric(10)
                               ,@pa_sp_flg char(1)
                               )
as
begin
--
  
  
    declare @l_dpmdpid varchar(50)
          , @l_dpm_id  varchar(50)
          , @l_holding_dt datetime
          , @l_date_list varchar(8000)
          , @l_id        numeric
          , @l_count     numeric
          , @l_date      varchar(11)
--   ,@pa_sp_flg char(1)
--   set @pa_sp_flg = 'N'
    select top 1 @l_dpmdpid = LEFT(tmphldg_boid,8) , @l_dpm_id  = dpm_id from tmp_cdsl_trx_hldg , dp_mstr where dpm_dpid = LEFT(tmphldg_boid,8) and dpm_deleted_ind = 1 and dpm_dpid = @pa_dpmdpid
    
   
    if isnull(@l_dpmdpid,'') <> '' and isnull(@l_dpm_id ,'') <> ''
    BEGIN
    --
      BEGIN TRANSACTION
  
     		

					  
					 update tmp_cdsl_trx_mstr set  tmpeod_dpam_id  = dpam_id , tmpeod_dpm_id  = @l_dpm_id  from dp_acct_mstr where dpam_sba_no = tmpeod_boid
					 
					 update tmp_cdsl_trx_hldg set  tmphldg_dpam_id  = dpam_id , tmphldg_dpm_id  = @l_dpm_id  from dp_acct_mstr where dpam_sba_no = tmphldg_boid
					  
					 
      
      DELETE FROM cdsl_holding_dtls WHERE cdshm_tras_dt    IN    (select 	tmpeod_busn_dt  from tmp_cdsl_trx_mstr) 
      
                        update  tmp_cdsl_trx_mstr  
						set     TMPEOD_internal_trastm  = dptdc_internal_trastm
						       ,TMPEOD_slip_no          = dptdc_slip_no
						from    dp_trx_dtls_cdsl
						where   ltrim(rtrim(isnull(tmpeod_trx_no,'')))         = ltrim(rtrim(isnull(dptdc_trans_no,'')))
						and     dptdc_dpam_id           = tmpeod_dpam_id
						and     isnull(dptdc_isin,'')              = isnull(tmpeod_isin,'')
						and     tmpeod_busn_dt          = case when dptdc_internal_trastm <> 'NP' then dptdc_execution_dt else tmpeod_busn_dt end
					    and     dptdc_deleted_ind = 1 
					  
						insert into cdsl_holding_dtls
						(cdshm_id 
						,cdshm_dpm_id
						,cdshm_ben_acct_no
						,cdshm_dpam_id
						,cdshm_isin
						,cdshm_tratm_cd
						,cdshm_tratm_desc
						,cdshm_int_ref_no
						,cdshm_tras_dt
						,cdshm_qty
						,cdshm_trans_no
						,cdshm_tratm_type_desc
						,cdshm_counter_boid
						,cdshm_counter_dpid
						,cdshm_counter_cmbpid
						,cdshm_sett_no
						,cdshm_sett_type
						,cdshm_excm_id
						,cdshm_trade_no
						,cdshm_opn_bal
						,cdshm_bal_type
						,cdshm_created_by
						,cdshm_created_dt
						,cdshm_lst_upd_by
						,cdshm_lst_upd_dt
		    ,cdshm_deleted_ind,cdshm_slip_no,cdshm_internal_trastm,CDSHM_TRG_SETTM_NO
						)select tmpeod_id
						     ,@l_dpm_id
											,tmpeod_boid-->cdshm_ben_acct_no
											,tmpeod_dpam_id
											,tmpeod_isin-->cdshm_isin
											,tmpeod_trx_cd-->cdshm_tratm_cd
											,tmpeod_trx_desc-->cdshm_tratm_desc
											,tmpeod_dp_intrefno-->cdshm_int_ref_no
											--,convert(datetime,substring(tmpeod_busn_dt,1,2)+'/'+substring(tmpeod_busn_dt,3,2)+ '/' + substring(tmpeod_busn_dt,5,4),103) tmpeod_busn_dt-->cdshm_tras_dt--tmpeod_busn_dt
											,tmpeod_busn_dt
											,case when isnull(tmpeod_dr_qty,0) <> 0 then  tmpeod_dr_qty * -1 else tmpeod_cr_qty end
											,tmpeod_trx_no-->cdshm_trans_no
											,tmpeod_trx_type_desc-->cdshm_tratm_desc
											,tmpeod_ctrboid-->cdshm_counter_boid
											,tmpeod_ctrdpid-->cdshm_counter_dpid
											,tmpeod_ctrcmbpid-->cdshm_counter_cmbpid
											,tmpeod_settno-->cdshm_sett_no
											,tmpeod_setttyp-->cdshm_sett_type
											,tmpeod_exch_id-->cdshm_excm_id
					     	,tmpeod_trade_no-->cdshm_trade_no
					     	,tmpeod_opng_bal
					     	,tmpeod_bal_typ
							,@pa_login_name
							,getdate()
							,@pa_login_name
							,getdate()
							,1,TMPEOD_slip_no,TMPEOD_internal_trastm,TMPEOD_CTR_SETTID
							FROM  tmp_cdsl_trx_mstr a
							where  isnull(tmpeod_dpam_id,0) <> 0
												
																					
      IF EXISTS(SELECT tmpeod_boid FROM tmp_cdsl_trx_mstr WHERE isnull(tmpeod_dpam_id,0) = 0 ) 																					
      BEGIN
      --
        UPDATE filetask
        SET    usermsg = 'ERROR : Following Client Not Mapped ' + citrus_usr.fn_merge_str('DP50',0,'')
        WHERE  task_id = @pa_task_id
      --
      END
      
      
						
						
						
					 update dp_trx_dtls_cdsl
						set    dptdc_status = 'E'
						from   tmp_cdsl_holding_dtls
						where  ltrim(rtrim(isnull(cdshmd_trans_no,'')))        = ltrim(rtrim(isnull(dptdc_trans_no,'')))
						and    dptdc_dpam_id          = cdshmd_dpam_id
						and    ltrim(rtrim(isnull(dptdc_isin,'')))             = ltrim(rtrim(isnull(cdshmd_isin,'')))
						and    cdshmd_tras_dt          = case when dptdc_internal_trastm <> 'NP' then dptdc_execution_dt else cdshmd_tras_dt end
						and    dptdc_deleted_ind= 1 
						and    dptdc_status           = 'S'
						and    CDSHMD_TRATM_CD  in ('2277','2246','2230','2280') 

						
                        update demat_request_mstr
						set    demrm_status = 'E'
					     , DEMRM_CREDIT_RECD = CASE WHEN isnull(DEMRM_CREDIT_RECD,'N') = 'N' THEN CASE WHEN cdshmd_tratm_type_desc = 'DEMAT' AND CDSHMD_TRATM_CD = '2246' THEN  'Y' ELSE 'N' END ELSE isnull(DEMRM_CREDIT_RECD,'N') end
						from   tmp_cdsl_holding_dtls
						where  ltrim(rtrim(isnull(demrm_transaction_no,'')))   = ltrim(rtrim(isnull(cdshmd_trans_no,'')))         
						and    demrm_dpam_id          = cdshmd_dpam_id
						and    ltrim(rtrim(isnull(demrm_isin,'')))             = ltrim(rtrim(isnull(cdshmd_isin,'')))
						and    demrm_deleted_ind      = 1 
						and    demrm_status           = 'S'
						
						update remat_request_mstr
						set    remrm_status = 'E'
						, REMRM_CREDIT_RECD = CASE WHEN isnull(REMRM_CREDIT_RECD,'N') = 'N' THEN CASE WHEN cdshmd_tratm_type_desc = 'REMAT' AND CDSHMD_TRATM_CD = '2277' THEN  'Y' ELSE 'N' END ELSE isnull(REMRM_CREDIT_RECD,'N') end
						from   tmp_cdsl_holding_dtls
						where  ltrim(rtrim(isnull(remrm_transaction_no,'')))   = ltrim(rtrim(isnull(cdshmd_trans_no,'')))         
						and    remrm_dpam_id          = cdshmd_dpam_id
						and    ltrim(rtrim(isnull(remrm_isin ,'')))            = ltrim(rtrim(isnull(cdshmd_isin,'')))
						and    remrm_deleted_ind      = 1 
						and    remrm_status           = 'S'
						
						--for multiple date
						
						
					 select @l_date_list = replace(citrus_usr.fn_merge_str('DP50_MUL_DT',0,''),',','|*~|') + '|*~|'
						
						if @l_date_list  <> ''
						begin 
						--
								select @l_count = citrus_usr.ufn_countstring(@l_date_list,'|*~|')
								if @l_count = 0 set @l_count = 1
						--
						end
						
							set @l_id = 1
						DECLARE @L_ACT_ID INT
						SET @L_ACT_ID = 1 
							WHILE  @l_count  >= @l_id
							BEGIN
							--
									set @l_date = citrus_usr.fn_splitval(@l_date_list,@l_id) 
									
         --set @l_date = substring(@l_date,1,2)+'/'+substring(@l_date,3,2)+ '/' + substring(@l_date,5,4)
									if @l_date<>''
									begin
									set @l_holding_dt = convert(datetime,@l_date ,103)
                                    IF @pa_sp_flg = 'N'
                                    BEGIN
                                 
                                      exec pr_holding_process_cdsl @l_holding_dt,@l_dpm_id,@pa_login_name,@L_ACT_ID
                                   
                                    END 
                                    ELSE 
                                    BEGIN

                                      --exec pr_holding_process_cdsl_for_sp @l_holding_dt,@l_dpm_id,@pa_login_name,@L_ACT_ID      
                                      exec pr_holding_process_cdsl @l_holding_dt,@l_dpm_id,@pa_login_name,@L_ACT_ID
                                    END 

                                    SET @L_ACT_ID = 2
									end
                      
									set @l_id = @l_id + 1 
			
							--
							END
						
						
						
						
						
						
						COMMIT TRANSACTION
						
						
				--
				END
				ELSE
				BEGIN
				--
				  return
				--
				END
				
--
end

GO
