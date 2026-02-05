-- Object: PROCEDURE citrus_usr.rpt_Approve_details_bgse
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--A=Maker
--U=Checker
--V=Checker2
--D=Deleted

--rpt_Approve_details '4','NSDL','Pending_For_App','apr  1 2008','oct  4 2008','',1,'HO|*~|'
--rpt_Approve_details '3','CDSL','Pending_For_App','apr  1 2008','oct  4 2008','',1,'HO|*~|'

--rpt_Approve_details '4','NSDL','DUAL_Checker_App','jan 13 2009','jan 13 2009','904',1,'HO|*~|'
--rpt_Approve_details '3','CDSL','DUAL_Checker_App','jan 29 2009','jan 29 2009','',1,'HO|*~|'

--rpt_Approve_details '4','NSDL','CANCELLED BY CHECKER','apr  1 2008','oct  4 2008','',1,'HO|*~|'
--rpt_Approve_details '3','CDSL','CANCELLED BY CHECKER','apr  1 2008','oct  4 2008','',1,'HO|*~|'


CREATE procedure [citrus_usr].[rpt_Approve_details_bgse]
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
 @@l_child_entm_id  numeric,
 @@finId  int,
 @@subtype varchar(10),
 @@ssql varchar(8000)
set @@subtype = '' 

 if @pa_trastm_cd = '904_P2C' 
 begin
		set @pa_trastm_cd = '904'
		set @@subtype = 'P2C'
 end

 SET @pa_trastm_cd=CASE WHEN @pa_trastm_cd = '904_ACT' THEN '904' ELSE @pa_trastm_cd END


	 select @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_id and dpm_deleted_ind =1                                    
	 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                                      
                              
                             
		CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id)		

		Create table #BALANCES(
		dpam_id bigint,
		outstand_amt numeric(18,2)
		)
		select @@finId = isnull(fin_id,0) from financial_yr_mstr where FIN_DPM_ID = @l_dpm_id AND @PA_TO_DT between fin_start_dt and fin_end_dt and fin_deleted_ind = 1
		set @@ssql ='insert into #BALANCES(dpam_id,outstand_amt)
		select LDG_ACCOUNT_ID,sum(isnull(ldg_amount,0)) * -1
		from Ledger' + convert(varchar,@@finId) + ' where ldg_account_type = ''P'' and ldg_voucher_dt < ''' + convert(varchar(11),@pa_to_dt,109) + ''' and ldg_deleted_ind = 1
		group by LDG_ACCOUNT_ID'
		exec(@@ssql)
      
  
  if @pa_tab = 'Pending_For_App'
  begin
  --
			if @pa_type = 'NSDL'
			begin
					select 
					 @l_dpm_id DPID 
					,inst_id
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp          
					,SLIPNO 
					,dpam_sba_no ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr
					,mkr_dt
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptd_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] ,counter_account
					,[Status1]
					from 
					(
					SELECT  dptd_id inst_id
					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptd_qty))               QUANTITY
					,case when dptd_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd_deleted_ind = 0 and isnull(dptd_mid_chk,'') != '' ) then isnull(dptd_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd_created_by
					,mkr_dt = dptd_created_dt
					,ORDBY=1
					,DPTD_ISIN ISIN
					,dptd_request_dt
					,dptd_dpam_id dpam_id
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTD_SETTLEMENT_NO,'') [settlementno] , isnull(dptd.DPTD_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTD_COUNTER_CMBP_ID,'') [cmbp], isnull(dptd.DPTD_COUNTER_DEMAT_ACCT_NO,'') counter_account 
					, case when dptd_deleted_ind = -1 then 'V' 
						   When dptd_deleted_ind = 0 then 'A'
						   When dptd_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
  					 FROM    dptd_mak  dptd 
                    left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id)= dptd.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					
  					 WHERE   dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     case when dptd.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 and case when @@subtype <> '' then dptd.dptd_internal_trastm else '' end = @@subtype
					 AND     dptd_deleted_ind         IN (0,-1,4,6)
					union 
					select demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,ORDBY=2
					,DEMRM_ISIN ISIN
					,demrm_request_dt
					,DEMRM_DPAM_ID 
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account 
					,''
					from demrm_mak
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd = 'DMAT'
 					union 
					select Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,ORDBY=3
					,REMRM_ISIN ISIN
					,Remrm_request_dt
					,REMRM_DPAM_ID
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account 
					,''
					from Remrm_mak
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,ISIN_MSTR
					where tmpview.dpam_id = a.dpam_id
					AND TMPVIEW.ISIN = ISIN_CD
					and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					ORDER BY 13,15

			end
			else
			begin

					SELECT inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,mkr_dt 
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptdc_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] ,counter_account
					,[Status1]
					FROM
					(
					SELECT dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') != '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = dptdc_created_dt
					,ORDBY=1
					,dptdc_ISIN ISIN
					,dptdc_request_dt
					,DPTDC_DPAM_ID DPAM_ID
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] , isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp]  , isnull(dptd.DPTDc_COUNTER_DEMAT_ACCT_NO,'') counter_account 
					, case when dptdc_deleted_ind = -1 then 'V' 
						   When dptdc_deleted_ind = 0 then 'A'
						   When dptdc_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
  					 FROM    dptdc_mak                    dptd 
                     left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				
  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind         IN (0,-1,4,6)

					union 
					select demrm_id inst_id
					,convert(varchar(11),demrm_request_dt,103)
					,convert(varchar(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,ORDBY=2
					,DEMRM_ISIN
					,demrm_request_dt
					,DEMRM_DPAM_ID
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account 
					,''
					from demrm_mak
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd = 'DMAT'
 
					union 
					select Remrm_id inst_id
					,convert(varchar(11),Remrm_request_dt,103)
					,convert(varchar(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,ORDBY=3
					,remrm_isin isin
					,Remrm_request_dt
					,REMRM_DPAM_ID
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account 
					,''
					from Remrm_mak
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
                     and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					and dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					ORDER BY 13,15



			end
	 --
  end 
  
  if @pa_tab = 'DUAL_Checker_App'
  begin
  --

			if @pa_type = 'NSDL'
			begin

					SELECT   @l_dpm_id       DPID
					,inst_id
					,TRNSNO 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp 
					,SLIPNO 
					,BATCHNO
					,dpam_sba_no                 ACCOUNTNO
					,dpam_sba_name				 ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,mkr_dt 
					,[CHECKER 1]	
					,[CHECKER 2]	
					,Last_chkr_dt 
					,ORDBY
					,dptd_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
					,qty=CONVERT(NUMERIC(18,3),abs(QTY))
					,isin_name
					,isin
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp],counter_account
					,[Status1]
                   	from
					(
					SELECT dptd1.dptd_id inst_id 
					,TRNSNO = ISNULL(dptd1.DPTD_TRANS_NO,'')
					,convert(varchar(11),dptd1.dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd1.dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(dptd1.DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET   PAYOUT'),'C2P','ONMARKET   PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd1.dptd_slip_no                SLIPNO 
					,BATCHNO = ISNULL(dptd1.DPTD_BATCH_NO,'')		
					,convert(numeric(18,3),abs(dptd1.dptd_qty))  QUANTITY 
					,case when dptd.dptd_deleted_ind = 1 and isnull(dptd.dptd_mid_chk,'') <> '' then 'Y'
					ELSE 'N' END                        [DUAL CHECKER]
					,mkr = dptd.dptd_created_by
					,mkr_dt = dptd.dptd_created_dt
					,case when dptd.dptd_deleted_ind = 1 and isnull(dptd.dptd_mid_chk,'') <> '' then isnull(dptd.dptd_mid_chk,'') else isnull(dptd.dptd_lst_upd_by,'')  	 end [CHECKER 1]	
					,case when dptd.dptd_deleted_ind = 1 and isnull(dptd.dptd_mid_chk,'') <> '' then isnull(dptd.dptd_lst_upd_by,'') else '' end         [CHECKER 2]	
					,Last_chkr_dt = dptd.DPTD_LST_UPD_DT
					,ORDBY=1
					,dptd1.dptd_request_dt
					,dptd1.dptd_dpam_id dpam_id
					,dptd1.dptd_isin isin
					,abs(dptd1.DPTD_QTY) qty
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd1.DPTD_SETTLEMENT_NO,'') [settlementno] , isnull(dptd1.DPTD_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd1.DPTD_COUNTER_CMBP_ID,'') [cmbp] , isnull(dptd1.DPTD_COUNTER_DEMAT_ACCT_NO,'') counter_account 
					, case when dptd.dptd_deleted_ind = -1 then 'V' 
						   When dptd.dptd_deleted_ind = 0 then 'A'
						   When dptd.dptd_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
					FROM    dptd_mak dptd
                   , DP_TRX_DTLS dptd1 left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd1.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd1.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					
                   
					WHERE   dptd.dptd_id = dptd1.dptd_id 
					and dptd1.dptd_request_dt >= @pa_from_dt and dptd1.dptd_request_dt <= @pa_to_dt
					and     case when dptd1.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd1.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					and case when @@subtype <> '' then dptd1.dptd_internal_trastm else '' end = @@subtype
					AND     dptd1.dptd_deleted_ind = 1 
					AND     dptd.dptd_deleted_ind in(0,1)
 

					union 
					select demrm_id inst_id
					,TRNSNO = ISNULL(DEMRM_TRANSACTION_NO,'')
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,BATCHNO = ISNULL(DEMRM_BATCH_NO,'')
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,'N'
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,demrm_lst_upd_by 
					,''
					,demrm_lst_upd_dt
					,ORDBY=2
					,demrm_request_dt
					,DEMRM_dpam_id
					,Demrm_isin isin
					,abs(Demrm_Qty) qty , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account 
					,''
					from demat_request_mstr
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
                    and @pa_trastm_cd = 'DMAT'
					and  demrm_deleted_ind = 1
 
					union 
					select Remrm_id inst_id
					,TRNSNO = ISNULL(REMRM_TRANSACTION_NO,'')
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,BATCHNO = ISNULL(REMRM_BATCH_NO,'')
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,'N'
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,remrm_lst_upd_by 
					,''
					,remrm_lst_upd_dt
					,ORDBY=3
					,Remrm_request_dt
					,Remrm_dpam_id
					,Remrm_isin isin 
					,abs(Remrm_Qty) Qty , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account 
					,''
					from remat_request_mstr
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
                    and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					, isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					ORDER BY 18,17



			end
			else
			begin
					SELECT   @l_dpm_id       DPID
					,inst_id 
					,TRNSNO
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp       
					,SLIPNO 
					,BATCHNO
					,dpam_sba_no                 ACCOUNTNO
					,dpam_sba_name				 ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,mkr_dt 
					,[CHECKER 1]	
					,[CHECKER 2]	
					,Last_chkr_dt 
					,ORDBY
					,dptdc_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
					,qty=CONVERT(NUMERIC(18,3),abs(QTY))
					,isin_name
					,isin
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp],counter_account
					,[Status1]
					from
					(
					SELECT   dptd1.dptdc_id inst_id 
					,TRNSNO = ISNULL(dptd1.DPTDC_TRANS_NO,'')
					,convert(varchar(11),dptd1.dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd1.dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(dptd1.DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptd1.dptdc_slip_no                SLIPNO 
					,BATCHNO = ISNULL(dptd1.DPTDC_BATCH_NO,'')	
					,abs(dptd1.dptdc_qty)               QUANTITY
					,case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then 'Y'
					ELSE 'N' END                        [DUAL CHECKER]
					,mkr = dptd.dptdc_created_by
					,mkr_dt = dptd.dptdc_created_dt
					,case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then isnull(dptd.dptdc_mid_chk,'') else isnull(dptd.dptdc_lst_upd_by,'') end [CHECKER 1]	
					,case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then isnull(dptd.dptdc_lst_upd_by,'') else '' end  [CHECKER 2]	
					,Last_chkr_dt = dptd.DPTDc_LST_UPD_DT
					,ORDBY=1
					,dptd1.dptdc_request_dt
					,dptd1.dptdc_dpam_id dpam_id
					,abs(dptd1.dptdc_qty) qty ,dptd1.dptdc_isin isin
                   , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd1.DPTDC_SETTLEMENT_NO,'') [settlementno] , isnull(dptd1.DPTDC_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd1.DPTDC_COUNTER_CMBP_ID,'') [cmbp] , isnull(dptd1.DPTDC_COUNTER_DEMAT_ACCT_NO,'') counter_account
					, case when dptd.dptdc_deleted_ind = -1 then 'V' 
						   When dptd.dptdc_deleted_ind = 0 then 'A'
						   When dptd.dptdc_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
					FROM    dptdc_mak dptd 
                   ,DP_TRX_DTLS_CDSL dptd1 
                    left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd1.DPTDC_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd1.DPTDC_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					WHERE   dptd.dptdc_id = dptd1.dptdc_id 
					and dptd1.dptdc_request_dt >= @pa_from_dt and dptd1.dptdc_request_dt <= @pa_to_dt
					and     dptd1.dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					AND     dptd1.dptdc_deleted_ind = 1 
					AND     dptd.dptdc_deleted_ind in(0,1)
					union 
					select demrm_id inst_id
					,TRNSNO = ISNULL(DEMRM_TRANSACTION_NO,'')
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,BATCHNO = ISNULL(DEMRM_BATCH_NO,'')
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,'N'
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,demrm_lst_upd_by 
					,''
					,demrm_lst_upd_dt
					,ORDBY=2
					,demrm_request_dt
					,demrm_dpam_id
					,abs(demrm_qty) qty
					,demrm_isin isin , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
					,''
					from demat_request_mstr
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind = 1
                    and @pa_trastm_cd = 'RMAT'
 
					union 
					select Remrm_id inst_id
					,TRNSNO = ISNULL(REMRM_TRANSACTION_NO,'')
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,BATCHNO = ISNULL(REMRM_BATCH_NO,'')
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,'N'
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,remrm_lst_upd_by 
					,''
					,remrm_lst_upd_dt
					,ORDBY=3
					,Remrm_request_dt
					,Remrm_dpam_id
					,abs(Remrm_qty) qty
					,Remrm_isin isin  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
					,''
					from remat_request_mstr
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
                    and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					and dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					ORDER BY 18,17


			end

  --
  end 
  if @pa_tab = 'CANCELLED BY CHECKER'
  begin
  --
			if @pa_type = 'NSDL'
			begin
					SELECT   @l_dpm_id       DPID 
					,inst_id
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp          
					,SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,dpam_sba_name                 ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,mkr_dt 
					,ORDBY
					,isin
					,isin_name
					,dptd_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
					,STATUS
					,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp], counter_account
					,[Status1]
					FROM
					(
					SELECT  dptd_id inst_id
					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptd_qty))               QUANTITY
					,case when dptd_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd_deleted_ind = 0 and isnull(dptd_mid_chk,'') != '' ) then isnull(dptd_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd_created_by
					,mkr_dt = dptd_created_dt
					,ORDBY=1
					,dptd_isin isin
					,dptd_request_dt
					,'BEFORE APPROVE' STATUS
					,DPTD_DPAM_ID dpam_id
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTD_SETTLEMENT_NO,'') [settlementno] , isnull(dptd.DPTD_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTD_COUNTER_CMBP_ID,'') [cmbp],  isnull(dptd.DPTD_COUNTER_DEMAT_ACCT_NO,'') counter_account
					, case when dptd_deleted_ind = -1 then 'V' 
						   When dptd_deleted_ind = 0 then 'A'
						   When dptd_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
  					 FROM    dptd_mak  dptd 
                      left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				
  					 WHERE   dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     case when dptd.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 and case when @@subtype <> '' then dptd.dptd_internal_trastm else '' end = @@subtype
					 AND     dptd_lst_upd_by = DPTD_CREATED_BY
  					 AND     dptd_deleted_ind         = 2
  					 AND     NOT EXISTS(SELECT dptd_slip_no FROM dp_trx_dtls d where d.dptd_slip_no = dptd.dptd_slip_no AND dptd_deleted_ind = 1)

					union 
					select demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,ORDBY=2
					,demrm_isin isin
					,demrm_request_dt
					,'BEFORE APPROVE' STATUS
					,demrm_DPAM_ID  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account
					,''
					from demrm_mak demrm
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					AND   DEMRM_LST_UPD_BY = DEMRM_CREATED_BY
					and  demrm_deleted_ind =2
                     and @pa_trastm_cd = 'RMAT'
                    AND  NOT EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                    
					union 
					select Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,ORDBY=3
					,Remrm_isin isin
					,Remrm_request_dt
					,'BEFORE APPROVE' STATUS
					,remrm_DPAM_ID  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account
					,''
					from Remrm_mak remrm
					where remrm_LST_UPD_BY = remrm_CREATED_BY
					and	 REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =2
					and @pa_trastm_cd = 'RMAT'
					AND     NOT EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					
					UNION
					
					SELECT dptd_id inst_id
					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
					,dptd_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptd_qty))               QUANTITY
					,case when dptd_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd_deleted_ind = 0 and isnull(dptd_mid_chk,'') != '' ) then isnull(dptd_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd_created_by
					,mkr_dt = convert(varchar(11),dptd_created_dt,103)
					,ORDBY=1
					,dptd_isin isin
					,dptd_request_dt
					,'AFTER APPROVE' STATUS
					,DPTD_DPAM_ID
                   , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTD_SETTLEMENT_NO,'') [settlementno] , isnull(dptd.DPTD_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTD_COUNTER_CMBP_ID,'') [cmbp], isnull(dptd.DPTD_COUNTER_DEMAT_ACCT_NO,'') counter_account
					, case when dptd_deleted_ind = -1 then 'V' 
						   When dptd_deleted_ind = 0 then 'A'
						   When dptd_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
  					 FROM    dptd_mak  dptd 
                     left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				
  					 WHERE   dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     dptd_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd END
  					 AND     dptd_deleted_ind        = 4
  					 AND     EXISTS(SELECT dptd_slip_no FROM dp_trx_dtls d where d.dptd_slip_no = dptd.dptd_slip_no AND dptd_deleted_ind = 1)

					union 
					select demrm_id inst_id
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,CONVERT(VARCHAR(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),Abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = convert(varchar(11),demrm_created_dt,103)
					,ORDBY=2
					,demrm_isin isin
					,demrm_request_dt
					,'AFTER APPROVE' STATUS
					,demrm_DPAM_ID  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account
					,''
					from demrm_mak demrm
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind =4
                    and @pa_trastm_cd = 'DMAT'
                    AND  EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                    
					union 
					select Remrm_id inst_id
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),Abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = convert(varchar(11),Remrm_created_dt,103)
					,ORDBY=3
					,Remrm_isin isin
					,Remrm_request_dt
					,'AFTER APPROVE' STATUS
					,Remrm_DPAM_ID  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],isnull('','') counter_account
					,''
					from Remrm_mak remrm
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind = 4
                    and @pa_trastm_cd = 'RMAT'
					AND  EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr	
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = ISIN_CD 
					and dptd_request_dt >= eff_from and dptd_request_dt <= eff_to
					ORDER BY 13,15

			end
			else
			begin
					SELECT   @l_dpm_id       DPID
					,inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,SLIPNO 
					,dpam_sba_no                 ACCOUNTNO
					,dpam_sba_name                 ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,mkr_dt
					,ORDBY
					,isin
					,isin_name	
					,dptdc_request_dt
					,STATUS
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
					,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp], counter_account
                    ,[Status1]
					FROM
					(
 					SELECT dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') != '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = dptdc_created_dt
					,ORDBY=1
					,dptdc_isin isin
					,dptdc_request_dt
					,'BEFORE APPROVE' STATUS
					,dptdc_dpam_id dpam_id
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] , isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp],isnull(dptd.DPTDC_COUNTER_DEMAT_ACCT_NO,'') counter_account
					, case when dptdc_deleted_ind = -1 then 'V' 
						   When dptdc_deleted_ind = 0 then 'A'
						   When dptdc_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
  					 FROM    dptdc_mak                    dptd 
                     left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				
  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind      =   2
  					 AND     dptdc_created_by <> dptdc_lst_upd_by 
  					 AND     NOT EXISTS(SELECT dptdc_slip_no FROM dp_trx_dtls_cdsl d where d.dptdc_slip_no = dptd.dptdc_slip_no AND dptdc_deleted_ind = 1)

					union 
					select demrm_id inst_id
					,convert(varchar(11),demrm_request_dt,103)
					,convert(varchar(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,ORDBY=2
					,demrm_isin isin
					,demrm_request_dt
					,'BEFORE APPROVE' STATUS
					,demrm_dpam_id , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account
					,''
					from demrm_mak demrm
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind = 2
                    and @pa_trastm_cd = 'DMAT'
					AND  DEMRM_CREATED_BY <> DEMRM_LST_UPD_BY
                    AND  NOT EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                   
					union 
					select Remrm_id inst_id
					,convert(varchar(11),Remrm_request_dt,103)
					,convert(varchar(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,ORDBY=3
					,Remrm_isin isin	
					,Remrm_request_dt
					,'BEFORE APPROVE' STATUS
					,Remrm_dpam_id , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],isnull('','') counter_account
					,''
					from Remrm_mak remrm
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =2 
                    and @pa_trastm_cd = 'RMAT'
					AND  remrm_CREATED_BY <> remrm_LST_UPD_BY
					AND     NOT EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					
					UNION
					
					SELECT   dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') = '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = dptdc_created_dt
					,ORDBY=1
					,dptdc_isin isin
					,dptdc_request_dt
					,'AFTER APPROVE' STATUS
					,dptdc_dpam_id 
                   , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] , isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp],isnull(dptd.DPTDC_COUNTER_DEMAT_ACCT_NO,'') counter_account
					, case when dptdc_deleted_ind = -1 then 'V' 
						   When dptdc_deleted_ind = 0 then 'A'
						   When dptdc_deleted_ind = 1 then 'U'
					  else 'D' end as [Status1]
  					 FROM    dptdc_mak                    dptd 
                       left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                      left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				
  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind      =  4
  					 AND     EXISTS(SELECT dptdc_slip_no FROM dp_trx_dtls_cdsl d where d.dptdc_slip_no = dptd.dptdc_slip_no AND dptdc_deleted_ind = 1)

					union 

					select demrm_id inst_id
					,convert(varchar(11),demrm_request_dt,103)
					,convert(varchar(11),demrm_request_dt,103)
					,'DEMAT REQUEST'
					,DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(DEMRM_QTY))
					,''
					,mkr=demrm_created_by
					,mkr_dt = demrm_created_dt
					,ORDBY=2
					,demrm_isin isin
					,demrm_request_dt
					,'AFTER APPROVE' STATUS
					,DEMRM_DPAM_ID , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account
					,''
					from demrm_mak demrm
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind = 4
                    and  EXISTS(SELECT demrm_SLIP_SERIAL_NO FROM citrus_usr.demat_REQUEST_MSTR d where d.DEMRM_SLIP_SERIAL_NO = demrm.DEMRM_SLIP_SERIAL_NO AND demrm_deleted_ind = 1)
                    and @pa_trastm_cd = 'DMAT'

					union 

					select Remrm_id inst_id
					,convert(varchar(11),Remrm_request_dt,103)
					,convert(varchar(11),Remrm_request_dt,103)
					,'REMAT REQUEST'
					,REMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(REMRM_QTY))
					,''
					,mkr=Remrm_created_by
					,mkr_dt = Remrm_created_dt
					,ORDBY=3
					,Remrm_isin isin
					,Remrm_request_dt
					,'AFTER APPROVE' STATUS
					,Remrm_dpam_id , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account
					,''
					from Remrm_mak remrm
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =4 
                    and @pa_trastm_cd = 'RMAT'
					AND     EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					and dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to

					ORDER BY 12,13



			end
	 --
  end 
  
--
end

GO
