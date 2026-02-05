-- Object: PROCEDURE citrus_usr.pr_ins_upd_dpc9_new
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--[pr_ins_upd_dpc9] 'HO','12054100',24
CREATE procedure [citrus_usr].[pr_ins_upd_dpc9_new](@pa_login_name varchar(25)
												   ,@pa_dpmdpid    varchar(25)
												   ,@pa_task_id    numeric(10))
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
   
    select top 1 @l_dpmdpid = LEFT(tmpdpc9_boid,8) , @l_dpm_id  = dpm_id from tmp_dpc9_cdsl_trx_mstr , dp_mstr where dpm_dpid = LEFT(tmpdpc9_boid,8) and dpm_deleted_ind = 1 and dpm_dpid = @pa_dpmdpid
    
       
   
    if isnull(@l_dpm_id ,'') <> ''
    BEGIN
    --
 
				BEGIN TRANSACTION
  
						TRUNCATE TABLE tmp_cdsl_holding_dtls

						INSERT INTO  tmp_cdsl_holding_dtls(CDSHMD_DPM_ID
						,cdshmd_ben_acct_no
						,cdshmd_dpam_id
						,cdshmd_tratm_cd
						,cdshmd_tratm_desc
						,cdshmd_tras_dt
						,cdshmd_isin
						,cdshmd_qty
						,cdshmd_int_ref_no
						,cdshmd_trans_no
						,cdshmd_sett_type
						,cdshmd_sett_no
						,cdshmd_counter_boid
						,cdshmd_counter_dpid
						,cdshmd_counter_cmbpid
						,cdshmd_excm_id
						,cdshmd_trade_no
						,cdshmd_created_by
						,cdshmd_created_dt
						,cdshmd_lst_upd_by
						,cdshmd_lst_upd_dt
						,cdshmd_deleted_ind
						,cdshmd_slip_no
						,cdshmd_tratm_type_desc
						,cdshmd_opn_bal
						,cdshmd_bal_type
						) 
						SELECT cdshm_dpm_id
						,cdshm_ben_acct_no
						,cdshm_dpam_id
						,cdshm_tratm_cd
						,cdshm_tratm_desc
						,cdshm_tras_dt
						,cdshm_isin
						,cdshm_qty
						,cdshm_int_ref_no
						,cdshm_trans_no
						,cdshm_sett_type
						,cdshm_sett_no
						,cdshm_counter_boid
						,cdshm_counter_dpid
						,cdshm_counter_cmbpid
						,cdshm_excm_id
						,cdshm_trade_no
						,cdshm_created_by
						,cdshm_created_dt
						,cdshm_lst_upd_by
						,cdshm_lst_upd_dt
						,cdshm_deleted_ind
						,cdshm_slip_no
						,cdshm_tratm_type_desc
						,cdshm_opn_bal
						,cdshm_bal_type
						FROM   cdsl_holding_dtls
						WHERE  cdshm_tras_dt         in  (select 	tmpdpc9_trx_dt  from tmp_dpc9_cdsl_trx_mstr) 
						AND    cdshm_dpm_id               = @l_dpm_id

					  



					 update tmp_dpc9_cdsl_trx_mstr set  tmpdpc9_dpam_id  = dpam_id , tmpdpc9_dpm_id  = @l_dpm_id  from dp_acct_mstr where rtrim(ltrim(dpam_sba_no)) = rtrim(ltrim(tmpdpc9_boid))
					 
					 update tmp_dpc9_cdsl_trx_hldg set  tmpdpc9_hldg_dpam_id  = dpam_id , tmpdpc9_hldg_dpm_id  = @l_dpm_id  from dp_acct_mstr where rtrim(ltrim(dpam_sba_no)) = rtrim(ltrim(tmpdpc9_hldg_boid))
					  

							delete A from tmp_dpc9_cdsl_trx_mstr A
							WHERE EXISTS(select tmpdpc9_settno 
											,tmpdpc9_isin 
											,tmpdpc9_dr_qty
											,tmpdpc9_cr_qty
											,tmpdpc9_ctrboid-->cdshm_counter_boid
											,tmpdpc9_ctrdpid-->cdshm_counter_dpid
											,tmpdpc9_ctrcmbpid-->cdshm_counter_cmbpid
											--,convert(datetime,substring(tmpdpc9_trx_dt,1,2)+'/'+substring(tmpdpc9_trx_dt,3,2)+ '/' + substring(tmpdpc9_trx_dt,5,4),103) tmpdpc9_trx_dt-->cdshm_tras_dt--tmpeod_busn_dt
							,tmpdpc9_trx_dt
							,tmpdpc9_dp_intrefno-->cdshm_int_ref_no
							from   tmp_cdsl_holding_dtls
							where  a.tmpdpc9_settno              = cdshmd_sett_no 
							AND    a.tmpdpc9_isin                = cdshmd_isin 
							AND    CASE when isnull(a.tmpdpc9_dr_qty,0) <> 0 then  convert(numeric,a.tmpdpc9_dr_qty) * -1 else tmpdpc9_cr_qty end  = cdshmd_qty
							AND    a.tmpdpc9_ctrboid             = cdshmd_counter_boid
							AND    a.tmpdpc9_ctrdpid             = cdshmd_counter_dpid
							AND    a.tmpdpc9_ctrcmbpid           = cdshmd_counter_cmbpid
							--AND    convert(datetime,substring(a.tmpdpc9_trx_dt,1,2)+'/'+substring(a.tmpdpc9_trx_dt,3,2)+ '/' + substring(a.tmpdpc9_trx_dt,5,4),103) = convert(datetime,cdshmd_tras_dt,103)
							AND    a.tmpdpc9_trx_dt = cdshmd_tras_dt                         
							AND    a.tmpdpc9_dp_intrefno         = cdshmd_int_ref_no)
							AND  isnull(tmpdpc9_dpam_id,0) <> 0  

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
							,cdshm_deleted_ind
							)select tmpdpc9_id
							,@l_dpm_id
							,tmpdpc9_boid-->cdshm_ben_acct_no
							,tmpdpc9_dpam_id
							,tmpdpc9_isin-->cdshm_isin
							,tmpdpc9_trx_cd-->cdshm_tratm_cd
							,tmpdpc9_trx_desc-->cdshm_tratm_desc
							,tmpdpc9_dp_intrefno-->cdshm_int_ref_no
							--,convert(datetime,substring(tmpdpc9_trx_dt,1,2)+'/'+substring(tmpdpc9_trx_dt,3,2)+ '/' + substring(tmpdpc9_trx_dt,5,4),103) tmpdpc9_trx_dt-->cdshm_tras_dt--tmpeod_busn_dt
							,tmpdpc9_trx_dt
							,case when isnull(tmpdpc9_dr_qty,0) <> 0 then  convert(numeric,tmpdpc9_dr_qty) * -1 else tmpdpc9_cr_qty end
							,tmpdpc9_trx_no-->cdshm_trans_no
							,tmpdpc9_trx_type_desc-->cdshm_tratm_desc
							,tmpdpc9_ctrboid-->cdshm_counter_boid
							,tmpdpc9_ctrdpid-->cdshm_counter_dpid
							,tmpdpc9_ctrcmbpid-->cdshm_counter_cmbpid
							,tmpdpc9_settno-->cdshm_sett_no
							,tmpdpc9_setttyp-->cdshm_sett_type
							,tmpdpc9_exch_id-->cdshm_excm_id
							,''-->cdshm_trade_no
							,tmpdpc9_opng_bal
							,''
							,@pa_login_name
							,getdate()
							,@pa_login_name
							,getdate()
							,1
							FROM  tmp_dpc9_cdsl_trx_mstr a
							where   isnull(tmpdpc9_dpam_id,0) <> 0  	


      																						     
																					
						  IF EXISTS(SELECT tmpdpc9_boid, tmpdpc9_isin FROM tmp_dpc9_cdsl_trx_mstr WHERE isnull(tmpdpc9_dpam_id,0) = 0 ) 																					
						  BEGIN
						  --
							UPDATE filetask
							SET    usermsg = 'ERROR : Following Client Not Mapped ' + citrus_usr.fn_merge_str('DPC9',0,'')
							WHERE  task_id = @pa_task_id
						  --
						  END
      
      
						update  cdsl_holding_dtls  
						set     cdshm_internal_trastm  = dptdc_internal_trastm
								,cdshm_slip_no          = dptdc_slip_no
						from    dp_trx_dtls_cdsl
						where   cdshm_trans_no         = dptdc_trans_no
						and     dptdc_dpam_id           = cdshm_dpam_id
						and     dptdc_isin              = cdshm_isin
						and     cdshm_tras_dt          = dptdc_execution_dt
						and     dptdc_deleted_ind = 1 
						
						
						update dp_trx_dtls_cdsl
						set    dptdc_status = 'E'
						from   tmp_cdsl_holding_dtls
						where  cdshmd_trans_no        = dptdc_trans_no
						and    dptdc_dpam_id          = cdshmd_dpam_id
						and    dptdc_isin             = cdshmd_isin
						and    cdshmd_tras_dt          = dptdc_execution_dt
						and    dptdc_deleted_ind= 1 
						and    dptdc_status           = 'S'
						and    dptdc_trastm_cd  in ('2277','2246','2230','2280') 

						
						update demat_request_mstr
						set    demrm_status = 'E'
						from   tmp_cdsl_holding_dtls
						where  demrm_transaction_no   = cdshmd_trans_no         
						and    demrm_dpam_id          = cdshmd_dpam_id
						and    demrm_isin             = cdshmd_isin
						and    demrm_deleted_ind      = 1 
						and    demrm_status           = 'S'

						update remat_request_mstr
						set    remrm_status = 'E'
						from   tmp_cdsl_holding_dtls
						where  remrm_transaction_no   = cdshmd_trans_no         
						and    remrm_dpam_id          = cdshmd_dpam_id
						and    remrm_isin             = cdshmd_isin
						and    remrm_deleted_ind      = 1 
						and    remrm_status           = 'S'
						
						exec pr_holding_process_dpc9 @l_holding_dt,@l_dpm_id,@pa_login_name,0

				COMMIT TRANSACTION
				--
				END
				
--
end

GO
