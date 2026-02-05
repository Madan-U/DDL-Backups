-- Object: PROCEDURE citrus_usr.pr_ins_upd_cod
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--exec [pr_ins_upd_cod] 'HO','IN300175',1
--select codd_trx_no, codd_isin,codd_clt_id,codd_trx_typ,codd_qty,codd_lst_r,   codd_status_chng_dttime from cod_dtls order by codd_trx_no
--select * from tmp_cod_mstr where codd_trx_no = '000269571'
--update tmp_cod_mstr set tmp_codd_lst_r = 0
CREATE procedure [citrus_usr].[pr_ins_upd_cod](@pa_login_name varchar(25)
                               ,@pa_dpmdpid    varchar(25)
                               ,@pa_task_id    numeric
							   ,@PA_MODE VARCHAR(10)
								,@PA_DB_SOURCE VARCHAR(1000)
								,@RowDelimiter varchar(10)
								,@ColDelimiter varchar(10)
								,@pa_errmsg varchar(20) output    
 )
as
begin
--
--drop table #temp_codd

    create table #temp_codd
    (trx_no varchar(20),trx_typ varchar(5),isin varchar(12),qty numeric(15,3),clt_id varchar(16),ord_status_to varchar(3))
    declare @l_dpm_id  varchar(50)
   
    select top 1 @l_dpm_id  = dpm_id from tmp_cod_mstr , dp_mstr where dpm_dpid = tmpcod_dpid and dpm_deleted_ind = 1 and dpm_dpid = @pa_dpmdpid
   
    if isnull(@l_dpm_id ,'') <> ''
    BEGIN
    --
      BEGIN TRANSACTION
    
						
						update  tmp_cod_mstr  
						set     TMPCOD_slip_no         = dptd_slip_no
						from    dp_trx_dtls
						where   TMPCOD_TRX_NO          = dptd_trans_no
						and     tmpcod_trx_typ          = dptd_trastm_cd
						and     tmpcod_isin = dptd_isin               
						and     tmpcod_status_chng_dttime >=dptd_request_dt 
						and     tmpcod_status_chng_dttime <= convert(datetime,convert(varchar(11),dptd_execution_dt,109) + ' 23:59:59')
						and     dptd_deleted_ind = 1  



						
						
						update  tmp_cod_mstr  
						set     tmpcod_slip_no         = demrm_slip_serial_no
						from    demat_request_mstr
						where   tmpcod_trx_no          = demrm_transaction_no
						and     tmpcod_trx_typ          = '901'
						and     tmpcod_isin = demrm_isin               
						and     tmpcod_status_chng_dttime >=demrm_request_dt 
						and     demrm_deleted_ind = 1  
						
						
						update  tmp_cod_mstr  
						set     tmpcod_slip_no         = remrm_slip_serial_no
						from    remat_request_mstr
						where   tmpcod_trx_no          = remrm_transaction_no
						and     tmpcod_trx_typ         = '902'
						and     tmpcod_isin = remrm_isin               
						and     tmpcod_status_chng_dttime >=remrm_request_dt 
						and     remrm_deleted_ind = 1  
					
						
						
						
						
      /*update dp_trx_dtls
						set    dptd_status =CASE WHEN tmpcod_ord_status_to <> '00' then case when tmpcod_canc_status_to <> '00' then tmpcod_canc_status_to end else tmpcod_ord_status_to  end
						from   tmp_cod_mstr
						where  tmpcod_trx_no         = dptd_trans_no
						and     tmpcod_trx_typ          = dptd_trastm_cd
					 and    tmpcod_isin           = dptd_isin              
						and    tmpcod_status_chng_dttime >=dptd_request_dt 
						and    tmpcod_status_chng_dttime <= dptd_execution_dt 
						and    dptd_deleted_ind      = 1 
	     and    dptd_status           <> 'E'
						
						
						
							update demat_request_mstr
							set    demrm_status = CASE WHEN tmpcod_ord_status_to <> '00' then case when tmpcod_canc_status_to <> '00' then tmpcod_canc_status_to end else tmpcod_ord_status_to  end
							from   tmp_cod_mstr
							where  tmpcod_trx_no         = demrm_transaction_no
							and     tmpcod_trx_typ          = '901'
							and    tmpcod_isin           = demrm_isin              
							and     tmpcod_status_chng_dttime >=demrm_request_dt 
							and    demrm_deleted_ind      = 1 
						 and    demrm_status           <> 'E'
						
							update remat_request_mstr
							set    remrm_status = CASE WHEN tmpcod_ord_status_to <> '00' then case when tmpcod_canc_status_to <> '00' then tmpcod_canc_status_to end else tmpcod_ord_status_to  end
							from   tmp_cod_mstr
							where  tmpcod_trx_no         = remrm_transaction_no
							and     tmpcod_trx_typ          = '902'
							and    tmpcod_isin           = remrm_isin              
							and     tmpcod_status_chng_dttime >=remrm_request_dt 
							and    remrm_deleted_ind      = 1 
				 		and    remrm_status           <> 'E'*/
       
     
       
						update tmp_cod_mstr
						set    tmpcod_trx_no = convert(bigint,tmpcod_trx_no)
						where  isnumeric(tmpcod_trx_no )= 1
																						
						insert into #temp_codd(trx_no,trx_typ,isin,qty,clt_id,ord_status_to)
						select  codd_trx_no,codd_trx_typ,codd_isin,codd_qty,codd_clt_id,codd_ord_status_to 
                        from cod_dtls where  
						exists(select tmpcod_trx_no,tmpcod_trx_typ,tmpcod_isin,tmpcod_isin,tmpcod_clt_id,tmpcod_ord_status_to from tmp_cod_mstr 
						where tmpcod_trx_no         = codd_trx_no
						and     tmpcod_trx_typ        = codd_trx_typ
						and     tmpcod_isin           = codd_isin           
						and     tmpcod_qty            = codd_qty
						and     tmpcod_clt_id         = codd_clt_id
						)

  			            insert into #temp_codd(trx_no,trx_typ,isin,qty,clt_id,ord_status_to)
						select tmpcod_trx_no,tmpcod_trx_typ,tmpcod_isin,tmpcod_qty,tmpcod_clt_id,tmpcod_ord_status_to 
                        from tmp_cod_mstr 
                        /*where  
						exists(select codd_trx_no,codd_trx_typ,codd_isin,codd_qty,codd_clt_id,codd_status_chng_dttime from cod_dtls 
						where codd_trx_no    = tmpcod_trx_no         
						and     codd_trx_typ = tmpcod_trx_typ        
						and     codd_isin    = tmpcod_isin           
						and     codd_qty     = tmpcod_qty            
						and     codd_clt_id  = tmpcod_clt_id          
						)*/
						
						update codd
						set    codd_lst_r = 0 
						from   cod_dtls codd
						where  codd_ord_status_to <> isnull((select max(convert(int,ord_status_to)) from #temp_codd
														where  trx_no         = codd.codd_trx_no
														and    trx_typ        = codd.codd_trx_typ
														and    isin           = codd.codd_isin           
														and    qty            = codd.codd_qty
														and    clt_id         = codd.codd_clt_id),codd_ord_status_to )

						
						update tmp
						set    tmp_codd_lst_r = 1 
                        from   tmp_cod_mstr tmp
						where  tmpcod_ord_status_to = isnull((select max(convert(int,ord_status_to)) from #temp_codd
						where trx_no = tmp.tmpcod_trx_no         
						and   trx_typ  = tmp.tmpcod_trx_typ    
						and   isin     = tmp.tmpcod_isin
						and   clt_id = tmp.tmpcod_clt_id 
						and   qty = tmp.tmpcod_qty 
									),'0')


					  
						INSERT INTO  cod_dtls
						(CODD_BR_CD
						,codd_dpm_id
						,codd_trx_typ
						,codd_trx_no
						,codd_ord_status_fr
						,codd_ord_status_to
						,codd_status_chng_usr
						,codd_canc_status_fr
						,codd_canc_status_to
						,codd_status_chng_dttime
						,codd_org_ord_refn0
						,codd_clt_id
						,codd_isin
						,codd_qty
						,codd_req_qty
						,codd_slb_accp_qty
						,codd_slb_rej_qty
						,codd_slb_qty_typ
						,codd_org_plg_qty
						,codd_closure_plg_qty
						,codd_invoked_plg_qty
						,codd_plg_closure_dt
						,codd_plgor_dpid
						,codd_plgor_cltid
						,codd_plgor_cltnm
						,codd_fh_plg_clt
						,codd_sh_plg_clt
						,codd_sender_refno
						,codd_lockin_reason_cd
						,codd_lockin_release_dt
						,codd_mkt_typ
						,codd_settno
						,codd_mkt_typ_to
						,codd_settno_to
						,codd_exec_closure_dt
						,codd_other_related_dpid
						,codd_other_cltid
						,codd_ben_acct_ctgry
						,codd_other_cmbpid
						,codd_other_mkttyp
						,codd_other_settno
						,codd_int_ref_nos
						,codd_agreementno
						,codd_trgt_cccmid
						,codd_rej_reason_cd1
						,codd_rej_reason_cd2
						,codd_rej_reason_cd3
						,codd_rej_reason_cd4
						,codd_closure_typ
						,codd_freeze_lvl
						,codd_reason_cd
						,codd_aca_ind
						,codd_src_ind
						,codd_frz_desc_lvl
						,codd_created_by
						,codd_created_dt
						,codd_lst_upd_by
						,codd_lst_upd_dt
						,codd_deleted_ind
						,codd_ln_no
                        ,codd_lst_r
						,codd_slip_no)
						SELECT TMPCOD_BR_CD
						,@l_dpm_id
						,tmpcod_trx_typ
						,tmpcod_trx_no
						,tmpcod_ord_status_fr
						,tmpcod_ord_status_to
						,tmpcod_status_chng_usr
						,tmpcod_canc_status_fr
						,tmpcod_canc_status_to
						,tmpcod_status_chng_dttime
						,tmpcod_org_ord_refn0
						,tmpcod_clt_id
						,tmpcod_isin
						,tmpcod_qty
						,tmpcod_req_qty
						,tmpcod_slb_accp_qty
						,tmpcod_slb_rej_qty
						,tmpcod_slb_qty_typ
						,tmpcod_org_plg_qty
						,tmpcod_closure_plg_qty
						,tmpcod_invoked_plg_qty
						,tmpcod_plg_closure_dt
						,tmpcod_plgor_dpid
						,tmpcod_plgor_cltid
						,tmpcod_plgor_cltnm
						,tmpcod_fh_plg_clt
						,tmpcod_sh_plg_clt
						,tmpcod_sender_refno
						,tmpcod_lockin_reason_cd
						,tmpcod_lockin_release_dt
						,tmpcod_mkt_typ
						,tmpcod_settno
						,tmpcod_mkt_typ_to
						,tmpcod_settno_to
						,tmpcod_exec_closure_dt
						,tmpcod_other_related_dpid
						,tmpcod_other_cltid
						,tmpcod_ben_acct_ctgry
						,tmpcod_other_cmbpid
						,tmpcod_other_mkttyp
						,tmpcod_other_settno
						,tmpcod_int_ref_nos
						,tmpcod_agreementno
						,tmpcod_trgt_cccmid
						,tmpcod_rej_reason_cd1
						,tmpcod_rej_reason_cd2
						,tmpcod_rej_reason_cd3
						,tmpcod_rej_reason_cd4
						,tmpcod_closure_typ
						,tmpcod_freeze_lvl
						,tmpcod_reason_cd
						,tmpcod_aca_ind
						,tmpcod_src_ind
						,tmpcod_frz_desc_lvl
					    ,'HO'
						,getdate()
						,'HO'
						,getdate()
						,1
						,tmpcod_lnno
                        ,tmp_codd_lst_r
						,tmpcod_slip_no
						FROM   tmp_cod_mstr tmp
						WHERE  not exists (select codd_trx_no,codd_trx_typ,codd_status_chng_dttime,codd_qty from cod_dtls where codd_trx_no = tmpcod_trx_no
						                                               and codd_trx_typ = tmpcod_trx_typ
						                                               and codd_status_chng_dttime =tmpcod_status_chng_dttime
						                                               and codd_isin = tmpcod_isin
						                                               and codd_qty = tmpcod_qty)
						
						

			  update   nsdl_holding_dtls    
		      set      nsdhm_trastm_cd          = tmpcod_trx_typ
		      from     tmp_cod_mstr,dp_acct_mstr  
		      where    TMPCOD_CLT_ID = dpam_sba_no
			  and	   dpam_id = nsdhm_dpam_id
			  and	   convert(numeric,tmpcod_trx_no )            = nsdhm_dpm_trans_no           
		      and      tmpcod_isin              = nsdhm_isin
		      and      convert(varchar,tmpcod_status_chng_dttime,103) = convert(varchar,nsdhm_transaction_dt,103)                 
		      and      isnull(nsdhm_trastm_cd,'') = ''   
		      and      tmp_codd_lst_r= 1 




						
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
