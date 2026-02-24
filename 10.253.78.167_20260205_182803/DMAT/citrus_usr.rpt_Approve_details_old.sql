-- Object: PROCEDURE citrus_usr.rpt_Approve_details_old
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--rpt_Approve_details '4','NSDL','Pending_For_App','apr  1 2008','oct  4 2008','',1,'HO|*~|'
--rpt_Approve_details '3','CDSL','Pending_For_App','apr  1 2008','oct  4 2008','',1,'HO|*~|'

--rpt_Approve_details '4','NSDL','DUAL_Checker_App','apr  1 2008','oct  4 2008','',1,'HO|*~|'
--rpt_Approve_details '3','CDSL','DUAL_Checker_App','apr  1 2008','oct  4 2008','',1,'HO|*~|'

CREATE procedure [citrus_usr].[rpt_Approve_details_old]
(@pa_id  varchar(10),
 @pa_type varchar(4),
 @pa_tab varchar(20),
 @pa_from_dt datetime,
 @pa_to_dt datetime,
 @pa_trastm_cd varchar(20),
 @pa_login_pr_entm_id numeric,    
 @pa_login_entm_cd_chain  varchar(8000)
)
as
begin
--
  
 declare @l_dpm_id bigint,
 @@l_child_entm_id  numeric 

 select @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_id and dpm_deleted_ind =1                                    
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                                      
                              
                             
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id)		
      

  
  if @pa_tab = 'Pending_For_App'
  begin
  --
			if @pa_type = 'NSDL'
			begin
					SELECT   @l_dpm_id       DPID 
					,dptd_id inst_id
					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,convert(numeric(18,3),abs(dptd_qty))               QUANTITY
					,case when dptd_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd_deleted_ind = 0 and isnull(dptd_mid_chk,'') = '' ) then isnull(dptd_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd_created_by
					,mkr_dt = dptd_created_dt
					,ORDBY=1
					,dptd_request_dt
  					 FROM    dptd_mak  dptd 
  	 						  ,#ACLIST dpam
  					 WHERE   dpam.dpam_id              = dptd.dptd_dpam_id
					 and     dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					 and	 dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     dptd_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptd_deleted_ind         IN (0,-1,4,6)

					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,ORDBY=2
					,demrm_request_dt
					from demrm_mak,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and  DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind IN (0,4,6)
 
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = convert(varchar(11),Remrm_created_dt,103)
					,ORDBY=3
					,Remrm_request_dt
					from Remrm_mak,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					and  REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
					ORDER BY 12,13

			end
			else
			begin
					SELECT   @l_dpm_id       DPID
					,dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') = '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = dptdc_created_dt
					,ORDBY=1
					,dptdc_request_dt
  					 FROM    dptdc_mak                    dptd 
  	 						  ,#ACLIST dpam
  					 WHERE   dpam.dpam_id              = dptd.dptdc_dpam_id
					 and  dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					 and	 dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind         IN (0,-1,4,6)

					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,convert(varchar(11),demrm_request_dt,103)
					,convert(varchar(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,ORDBY=2
					,demrm_request_dt
					from demrm_mak,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and  DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind IN (0,4,6)
 
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,convert(varchar(11),Remrm_request_dt,103)
					,convert(varchar(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = convert(varchar(11),Remrm_created_dt,103)
					,ORDBY=3
					,Remrm_request_dt
					from Remrm_mak,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					and  REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
					ORDER BY 12,13



			end
	 --
  end 
  
  if @pa_tab = 'DUAL_Checker_App'
  begin
  --
			if @pa_type = 'NSDL'
			begin
					SELECT   @l_dpm_id       DPID
					,dptd_id inst_id 
					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,convert(numeric(18,3),abs(dptd_qty))  QUANTITY
					,case when dptd_deleted_ind = 1 and isnull(dptd_mid_chk,'') <> '' then 'Y'
					ELSE 'N' END                        [DUAL CHECKER]
					,mkr = dptd_created_by
					,mkr_dt = dptd_created_dt
					,case when dptd_deleted_ind = 1 and isnull(dptd_mid_chk,'') <> '' then isnull(dptd_mid_chk,'') else isnull(dptd_lst_upd_by,'')  	 end [CHECKER 1]	
					,case when dptd_deleted_ind = 1 and isnull(dptd_mid_chk,'') <> '' then isnull(dptd_lst_upd_by,'') else '' end         [CHECKER 2]	
					,Last_chkr_dt = DPTD_LST_UPD_DT
					,ORDBY=1
					,dptd_request_dt
					FROM    dptd_mak                   dptd 
					,#ACLIST dpam
					WHERE   dpam.dpam_id              = dptd.dptd_dpam_id
					and		dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					and		dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
					and     dptd_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					AND     dptd_deleted_ind = 1 

					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,'N'
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,demrm_lst_upd_by 
					,''
					,demrm_lst_upd_dt
					,ORDBY=2
					,demrm_request_dt
					from demat_request_mstr,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and		DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind = 1
 
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,'N'
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,remrm_lst_upd_by 
					,''
					,remrm_lst_upd_dt
					,ORDBY=3
					,Remrm_request_dt
					from remat_request_mstr,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					and		REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
					ORDER BY 15,16



			end
			else
			begin
					SELECT   @l_dpm_id       DPID
					,dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,abs(dptdc_qty)               QUANTITY
					,case when dptdc_deleted_ind = 1 and isnull(dptdc_mid_chk,'') <> '' then 'Y'
					ELSE 'N' END                        [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = dptdc_created_dt
					,case when dptdc_deleted_ind = 1 and isnull(dptdc_mid_chk,'') <> '' then isnull(dptdc_mid_chk,'') else isnull(dptdc_lst_upd_by,'') end [CHECKER 1]	
					,case when dptdc_deleted_ind = 1 and isnull(dptdc_mid_chk,'') <> '' then isnull(dptdc_lst_upd_by,'') else '' end  [CHECKER 2]	
					,Last_chkr_dt = DPTDc_LST_UPD_DT
					,ORDBY=1
					,dptdc_request_dt
					FROM    dptdc_mak                   dptd 
					,#ACLIST  dpam
					WHERE   dpam.dpam_id              = dptd.dptdc_dpam_id
					and		dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					and		dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
					and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					AND     dptdc_deleted_ind = 1 
					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,'N'
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,demrm_lst_upd_by 
					,''
					,demrm_lst_upd_dt
					,ORDBY=2
					,demrm_request_dt
					from demat_request_mstr,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and		DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind = 1
 
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,'N'
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,remrm_lst_upd_by 
					,''
					,remrm_lst_upd_dt
					,ORDBY=3
					,Remrm_request_dt
					from remat_request_mstr,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					and		REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
					ORDER BY 15,16


			end

  --
  end 
  if @pa_tab = 'CANCELLED BY CHECKER'
  begin
  --
			if @pa_type = 'NSDL'
			begin
					SELECT   @l_dpm_id       DPID 
					,dptd_id inst_id
					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,convert(numeric(18,3),abs(dptd_qty))               QUANTITY
					,case when dptd_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd_deleted_ind = 0 and isnull(dptd_mid_chk,'') = '' ) then isnull(dptd_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd_created_by
					,mkr_dt = convert(varchar(11),dptd_created_dt,103)
					,ORDBY=1
					,dptd_request_dt
					,'BEFORE APPROVE' STATUS
  					 FROM    dptd_mak  dptd 
  	 						  ,#ACLIST dpam
  					 WHERE   dpam.dpam_id              = dptd.dptd_dpam_id
					 and     dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					 and	 dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     dptd_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd END
  					 AND     dptd_lst_upd_by = DPTD_CREATED_BY
  					 AND     dptd_deleted_ind         = 2
  					 AND     NOT EXISTS(SELECT dptd_slip_no FROM dp_trx_dtls d where d.dptd_slip_no = dptd.dptd_slip_no AND dptd_deleted_ind = 1)

					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = convert(varchar(11),demrm_created_dt,103)
					,ORDBY=2
					,demrm_request_dt
					,'BEFORE APPROVE' STATUS
					from demrm_mak demrm,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and  DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					 AND     DEMRM_LST_UPD_BY = DEMRM_CREATED_BY
					and  demrm_deleted_ind =2
                    AND     NOT EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                    
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = convert(varchar(11),Remrm_created_dt,103)
					,ORDBY=3
					,Remrm_request_dt
					,'BEFORE APPROVE' STATUS
					from Remrm_mak remrm,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					AND   remrm_LST_UPD_BY = remrm_CREATED_BY
					and  REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =2
					AND     NOT EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					
					UNION
					
					SELECT   @l_dpm_id       DPID 
					,dptd_id inst_id
					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,convert(numeric(18,3),abs(dptd_qty))               QUANTITY
					,case when dptd_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd_deleted_ind = 0 and isnull(dptd_mid_chk,'') = '' ) then isnull(dptd_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd_created_by
					,mkr_dt = convert(varchar(11),dptd_created_dt,103)
					,ORDBY=1
					,dptd_request_dt
					,'AFTER APPROVE' STATUS
  					 FROM    dptd_mak  dptd 
  	 						  ,#ACLIST dpam
  					 WHERE   dpam.dpam_id              = dptd.dptd_dpam_id
					 and     dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					 and	 dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     dptd_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd END
  					 AND     dptd_deleted_ind        = 4
  					 AND     EXISTS(SELECT dptd_slip_no FROM dp_trx_dtls d where d.dptd_slip_no = dptd.dptd_slip_no AND dptd_deleted_ind = 1)

					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = convert(varchar(11),demrm_created_dt,103)
					,ORDBY=2
					,demrm_request_dt
					,'AFTER APPROVE' STATUS
					from demrm_mak demrm,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and  DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind =4
                    AND     EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                    
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = convert(varchar(11),Remrm_created_dt,103)
					,ORDBY=3
					,Remrm_request_dt
					,'AFTER APPROVE' STATUS
					from Remrm_mak remrm,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					and  REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind = 4
					AND     EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					
					ORDER BY 12,13

			end
			else
			begin
					SELECT   @l_dpm_id       DPID
					,dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') = '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = convert(varchar(11),dptdc_created_dt,103)
					,ORDBY=1
					,dptdc_request_dt
					,'BEFORE APPROVE' STATUS
  					 FROM    dptdc_mak                    dptd 
  	 						  ,#ACLIST dpam
  					 WHERE   dpam.dpam_id              = dptd.dptdc_dpam_id
					 and     dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					 and	 dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind      =   2
  					 AND     dptdc_created_by <> dptdc_lst_upd_by 
  					 AND     NOT EXISTS(SELECT dptdc_slip_no FROM dp_trx_dtls_cdsl d where d.dptdc_slip_no = dptd.dptdc_slip_no AND dptdc_deleted_ind = 1)

					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,convert(varchar(11),demrm_request_dt,103)
					,convert(varchar(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = convert(varchar(11),demrm_created_dt,103)
					,ORDBY=2
					,demrm_request_dt
					,'BEFORE APPROVE' STATUS
					from demrm_mak demrm,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and  DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind = 2
					AND  DEMRM_CREATED_BY <> DEMRM_LST_UPD_BY
                   AND     NOT EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                   
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,convert(varchar(11),Remrm_request_dt,103)
					,convert(varchar(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = convert(varchar(11),Remrm_created_dt,103)
					,ORDBY=3
					,Remrm_request_dt
					,'BEFORE APPROVE' STATUS
					from Remrm_mak remrm,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					and  REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =2 
					AND  remrm_CREATED_BY <> remrm_LST_UPD_BY
					AND     NOT EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					
					UNION
					
					SELECT   @l_dpm_id       DPID
					,dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') = '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = convert(varchar(11),dptdc_created_dt,103)
					,ORDBY=1
					,dptdc_request_dt
					,'BEFORE APPROVE' STATUS
  					 FROM    dptdc_mak                    dptd 
  	 						  ,#ACLIST dpam
  					 WHERE   dpam.dpam_id              = dptd.dptdc_dpam_id
					 and     dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					 and	 dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind      =  4

  					 AND     EXISTS(SELECT dptdc_slip_no FROM dp_trx_dtls_cdsl d where d.dptdc_slip_no = dptd.dptdc_slip_no AND dptdc_deleted_ind = 1)

					union 
					select @l_dpm_id  DPID
					,demrm_id inst_id
					,convert(varchar(11),demrm_request_dt,103)
					,convert(varchar(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = convert(varchar(11),demrm_created_dt,103)
					,ORDBY=2
					,demrm_request_dt
					,'BEFORE APPROVE' STATUS
					from demrm_mak demrm,#ACLIST dpam
					where dpam.dpam_id = DEMRM_DPAM_ID
					and  DEMRM_request_dt >=eff_from and DEMRM_request_dt <= eff_to
					and	 DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind = 4

                   AND     EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                   
					union 
					select @l_dpm_id  DPID
					,Remrm_id inst_id
					,convert(varchar(11),Remrm_request_dt,103)
					,convert(varchar(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,dpam_sba_no
					,convert(numeric(18,3),abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = convert(varchar(11),Remrm_created_dt,103)
					,ORDBY=3
					,Remrm_request_dt
					,'BEFORE APPROVE' STATUS
					from Remrm_mak remrm,#ACLIST dpam
					where dpam.dpam_id = REMRM_DPAM_ID
					and  REMRM_request_dt >=eff_from and REMRM_request_dt <= eff_to
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =4 

					AND     EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					ORDER BY 12,13



			end
	 --
  end 
  
--
end

GO
