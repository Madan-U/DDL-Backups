-- Object: PROCEDURE citrus_usr.pr_ins_upd_dpc9_newtushar
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*
TMP_DPC9_CDSL_TRX_MSTR
TMP_DPC9_CDSL_TRX_hldg
*/
--[pr_ins_upd_dpc9] 'HO','12054100',24
CREATE procedure [citrus_usr].[pr_ins_upd_dpc9_newtushar](@pa_login_name varchar(25)
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

    select top 1 @l_dpmdpid = LEFT(TMPDPC9_BOID,8) , @l_dpm_id  = dpm_id from tmp_dpc9_cdsl_trx_mstr , dp_mstr where dpm_dpid = LEFT(TMPDPC9_BOID,8) and dpm_deleted_ind = 1 and dpm_dpid = @pa_dpmdpid    


   if 1 <> (select count(distinct TMPDPC9_TRX_DT) from TMP_DPC9_CDSL_TRX_MSTR)
   begin
         UPDATE filetask
        SET    usermsg = 'ERROR : Multidate dpc9 not imported' + citrus_usr.fn_merge_str('DPC9',0,'')
        WHERE  task_id = @pa_task_id
     
       --return
   end 
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
						,cdshmd_bal_type,CDSHMD_TRG_SETTM_NO
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
												,cdshm_bal_type,CDSHM_TRG_SETTM_NO
						FROM   cdsl_holding_dtls
						WHERE  cdshm_tras_dt         in  (select 	tmpdpc9_trx_dt  from tmp_dpc9_cdsl_trx_mstr) 
						AND    cdshm_dpm_id               = @l_dpm_id

					  
					 update tmp_dpc9_cdsl_trx_mstr set  tmpdpc9_dpam_id  = dpam_id , tmpdpc9_dpm_id  = @l_dpm_id  from dp_acct_mstr where rtrim(ltrim(dpam_sba_no)) = rtrim(ltrim(tmpdpc9_boid))
					 
					 update tmp_dpc9_cdsl_trx_hldg set  tmpdpc9_hldg_dpam_id  = dpam_id , tmpdpc9_hldg_dpm_id  = @l_dpm_id  from dp_acct_mstr where rtrim(ltrim(dpam_sba_no)) = rtrim(ltrim(tmpdpc9_hldg_boid))
					  
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
		                        ,cdshm_deleted_ind,CDSHM_TRG_SETTM_NO
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
							,case when isnull(tmpdpc9_dr_qty,0) <> 0 then  convert(numeric(18,5),tmpdpc9_dr_qty) * -1 else tmpdpc9_cr_qty end
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
					     	,1,TMPDPC9_CTR_SETTID
							FROM  tmp_dpc9_cdsl_trx_mstr a
							WHERE NOT EXISTS(select tmpdpc9_settno 
							,tmpdpc9_isin 
							,tmpdpc9_dr_qty
							,tmpdpc9_cr_qty
							,tmpdpc9_ctrboid-->cdshm_counter_boid
							,tmpdpc9_ctrdpid-->cdshm_counter_dpid
							,tmpdpc9_ctrcmbpid-->cdshm_counter_cmbpid
							--,convert(datetime,substring(tmpdpc9_trx_dt,1,2)+'/'+substring(tmpdpc9_trx_dt,3,2)+ '/' + substring(tmpdpc9_trx_dt,5,4),103) tmpdpc9_trx_dt-->cdshm_tras_dt--tmpeod_busn_dt
							,tmpdpc9_trx_dt
							,tmpdpc9_trx_no-->CDSHM_TRANS_NO
							from   tmp_cdsl_holding_dtls
							where  ltrim(rtrim(isnull(a.tmpdpc9_settno,'')))              = ltrim(rtrim(isnull(cdshmd_sett_no,'')))
							AND    ltrim(rtrim(isnull(a.tmpdpc9_isin,'')))                = ltrim(rtrim(isnull(cdshmd_isin,''))) 
							AND    CASE when isnull(a.tmpdpc9_dr_qty,0) <> 0 then  convert(numeric,a.tmpdpc9_dr_qty) * -1 else tmpdpc9_cr_qty end  = cdshmd_qty
							AND    ltrim(rtrim(isnull(a.tmpdpc9_ctrboid,'')))             = ltrim(rtrim(isnull(cdshmd_counter_boid,'')))
							AND    ltrim(rtrim(isnull(a.tmpdpc9_ctrdpid,'')))             = ltrim(rtrim(isnull(cdshmd_counter_dpid,'')))
							--AND    convert(datetime,substring(a.tmpdpc9_trx_dt,1,2)+'/'+substring(a.tmpdpc9_trx_dt,3,2)+ '/' + substring(a.tmpdpc9_trx_dt,5,4),103) = convert(datetime,cdshmd_tras_dt,103)
							AND    a.tmpdpc9_trx_dt = cdshmd_tras_dt                         
                            and    isnull(TMPDPC9_CTR_SETTID ,'') = isnull(CDSHMD_TRG_SETTM_NO,'')
							AND    ltrim(rtrim(isnull(a.tmpdpc9_trx_no,''))) = ltrim(rtrim(isnull(cdshmd_trans_no,''))))
							AND  isnull(tmpdpc9_dpam_id,0) <> 0  																						     
																					
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
 					         ,  cdshm_slip_no          = dptdc_slip_no
						from    dp_trx_dtls_cdsl
						where   ltrim(rtrim(isnull(cdshm_trans_no,'')))         = ltrim(rtrim(isnull(dptdc_trans_no,'')))
						and     dptdc_dpam_id           = cdshm_dpam_id
						and     ltrim(rtrim(isnull(dptdc_isin,'')))              = ltrim(rtrim(isnull(cdshm_isin,'')))
						and     cdshm_tras_dt          = case when dptdc_internal_trastm <> 'NP' then dptdc_execution_dt else cdshm_tras_dt end
						and     dptdc_deleted_ind = 1 
						
						
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
						where  ltrim(rtrim(isnull(demrm_transaction_no,'')))   = ltrim(rtrim(isnull(cdshmd_trans_no ,'')))        
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
						and    ltrim(rtrim(isnull(remrm_isin,'')))             = ltrim(rtrim(isnull(cdshmd_isin,'')))
						and    remrm_deleted_ind      = 1 
						and    remrm_status           = 'S'
						
						--for multiple date
--						select @l_date_list = replace(citrus_usr.fn_merge_str('DPC9_MUL_DT',0,''),',','|*~|') + '|*~|'
--										
--						if @l_date_list  <> ''
--						begin
--						--
--						  select @l_count = citrus_usr.ufn_countstring(@l_date_list,'|*~|')
--						  if  @l_count  = 0 set @l_count = 1
--						--
--						end
--						set @l_id = 1
--DECLARE @L_ACT_ID INT
--SET @L_ACT_ID  = 1
--						WHILE  @l_count  >= @l_id
--						BEGIN
--						--
--                           
--								set @l_date = citrus_usr.fn_splitval(@l_date_list,@l_id) 
--
--								set @l_holding_dt = case when @l_date <> '' then convert(datetime,@l_date ,103) end
--
--                                if @l_date<>''
--                                begin
--                                IF @pa_sp_flg = 'N'
--                                BEGIN 
--							    exec pr_holding_process_dpc9 @l_holding_dt,@l_dpm_id,@pa_login_name,@L_ACT_ID
--                                END 
--								ELSE 
--								BEGIN
--                                --exec pr_holding_process_dpc9_for_sp @l_holding_dt,@l_dpm_id,@pa_login_name,@L_ACT_ID
--                                exec pr_holding_process_dpc9 @l_holding_dt,@l_dpm_id,@pa_login_name,@L_ACT_ID
--								END 
--                                SET @L_ACT_ID = 2
--                                end
--								set @l_id = @l_id + 1 
--
--						--
--						END
						
						commit transaction
				--
				END


   /*select * from TMP_DPC9_CDSL_CLSRQTY order by 1 , 2--select -693+733


	--block pr_holding_process_cdsl -- pr_holding_process_dpc9 
	--insert into dp_daily_mstr_cdsl select * from tmp_dpc9_cdsl_trx_hldg

	select * from tmp_dpc9_cdsl_trx_hldg 
	where not exists(select TMPDPC9_CLSR_TRX_DT
						   ,TMPDPC9_CLSR_ISIN
						   ,TMPDPC9_CLSR_BOID 
					 from   TMP_DPC9_CDSL_CLSRQTY 
					 where  TMPDPC9_HLDG_BOID = TMPDPC9_CLSR_BOID 
					 and TMPDPC9_HLDG_ISIN    = TMPDPC9_CLSR_ISIN
					 and TMPDPC9_HLDG_TRX_DT  = TMPDPC9_CLSR_TRX_DT)
	order by 1,3

	--delete above records

	--insert into dp_daily_hldg_cdsl select * from tmp_dpc9_cdsl_trx_hldg

	--Modify report holding, statement, bill 
	*/

    TRUNCATE TABLE dp_hldg_mstr_cdsl
	  
	  
	  insert into dp_hldg_mstr_cdsl
	  (dphmc_dpm_id
	  ,dphmc_dpam_id
			,dphmc_isin
			,dphmc_curr_qty
			,dphmc_free_qty
--			,dphmc_freeze_qty
			,dphmc_pledge_qty
--			,dphmc_demat_pnd_ver_qty
--			,dphmc_remat_pnd_conf_qty
--			,dphmc_demat_pnd_conf_qty
			,dphmc_safe_keeping_qty
			,dphmc_lockin_qty
--			,dphmc_elimination_qty
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
	  ,TMPDPC9_HLDG_DPAM_ID
			,TMPDPC9_HLDG_ISIN
			,TMPDPC9_HLDG_CURR_QTY
			,TMPDPC9_HLDG_FREE_QTY
--			,dphmcd_freeze_qty
			,TMPDPC9_HLDG_PLEDGE_QTY
--			,dphmcd_demat_pnd_ver_qty
--			,dphmcd_remat_pnd_conf_qty
--			,dphmcd_demat_pnd_conf_qty
			,TMPDPC9_HLDG_SAFEKEEP_QTY
			,TMPDPC9_HLDG_LOCKEDIN_QTY
--			,dphmcd_elimination_qty
			,TMPDPC9_HLDG_EARMARKED_QTY
			,TMPDPC9_HLDG_AVL_QTY
			,TMPDPC9_HLDG_LEND_QTY
			,TMPDPC9_HLDG_BORROW_QTY
			,@l_holding_dt
			,@pa_login_name
			,getdate()
	  ,@pa_login_name
			,getdate()
			,1,TMPDPC9_HLDG_SETTID_04
			from tmp_dpc9_cdsl_trx_hldg


if 1=(
select count(distinct TMPDPC9_CLSR_TRX_DT)
from   TMP_DPC9_CDSL_CLSRQTY ) and 1=(select count(distinct TMPDPC9_HLDG_TRX_DT)
from   tmp_dpc9_cdsl_trx_hldg )
begin 
    delete  from tmp_dpc9_cdsl_trx_hldg 
	where not exists(select TMPDPC9_CLSR_TRX_DT
						   ,TMPDPC9_CLSR_ISIN
						   ,TMPDPC9_CLSR_BOID 
					 from   TMP_DPC9_CDSL_CLSRQTY 
					 where  TMPDPC9_HLDG_BOID = TMPDPC9_CLSR_BOID 
					 and TMPDPC9_HLDG_ISIN    = TMPDPC9_CLSR_ISIN
					 and TMPDPC9_HLDG_TRX_DT  = TMPDPC9_CLSR_TRX_DT)
	

    select @l_holding_dt datetime
    select top 1  @l_holding_dt  = TMPDPC9_HLDG_TRX_DT
    from   tmp_dpc9_cdsl_trx_hldg


    delete from dp_daily_hldg_cdsl where DPHMCD_HOLDING_DT = @l_holding_dt 


    insert into dp_daily_hldg_cdsl
    (DPHMCD_DPAM_ID,DPHMCD_DPM_ID,DPHMCD_ISIN,DPHMCD_CURR_QTY,DPHMCD_FREE_QTY
    ,DPHMCD_SAFE_KEEPING_QTY,DPHMCD_LOCKIN_QTY,DPHMCD_EARMARK_QTY,DPHMCD_AVAIL_LEND_QTY
    ,DPHMCD_LEND_QTY,DPHMCD_BORROW_QTY,DPHMCD_PLEDGE_QTY,dphmcd_cntr_settm_id
    ,DPHMCD_HOLDING_DT,DPHMCD_CREATED_BY,DPHMCD_CREATED_DT,DPHMCD_LST_UPD_BY,DPHMCD_LST_UPD_DT,DPHMCD_DELETED_IND
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
		 , TMPDPC9_HLDG_CTR_SETTID
         , TMPDPC9_HLDG_TRX_DT, @pa_login_name , getdate(),@pa_login_name,getdate(),1
	FROM   tmp_dpc9_cdsl_trx_hldg 

end 


    

				
--
end

GO
