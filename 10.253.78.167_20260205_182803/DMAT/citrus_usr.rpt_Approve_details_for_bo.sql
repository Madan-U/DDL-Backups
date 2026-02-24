-- Object: PROCEDURE citrus_usr.rpt_Approve_details_for_bo
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------
















--exec rpt_Approve_details_bak22112012 @pa_id='--ALL--',@pa_tab='DUAL_CHECKER_APP',@pa_type='',@pa_from_dt='NOV 22 2012',@pa_to_dt='NOV 22 2012 23:55:55',@pa_trastm_cd='',@pa_login_pr_entm_id=1,@pa_login_entm_cd_chain='HO|*~|',@pa_slip_no='10521624',@pa_clientid=''



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


create  procedure [citrus_usr].[rpt_Approve_details_for_bo]
(@pa_id  varchar(10),
 @pa_type varchar(4),
 @pa_tab varchar(20),
 @pa_from_dt datetime,
 @pa_to_dt datetime,
 @pa_trastm_cd varchar(20),
 @pa_login_pr_entm_id numeric,    
 @pa_login_entm_cd_chain  varchar(8000),
 @pa_slip_no varchar(20),
 @pa_clientid varchar(16),
 @pa_drnno varchar(20)
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

if @pa_drnno <> ''
begin
	set @pa_from_dt = 'jan  1 1900'
	set @pa_to_dt = 'jan  1 2089'
end

 if @pa_trastm_cd = '904_P2C' 
 begin
		set @pa_trastm_cd = '904'
		set @@subtype = 'P2C'
 end
 SET @pa_trastm_cd=CASE WHEN @pa_trastm_cd = '904_ACT' THEN '904' ELSE @pa_trastm_cd END
 if @pa_id = '--ALL--'
  begin 
	  set @l_dpm_id= '999'
  end
  else
  begin
	 select @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_id and dpm_deleted_ind =1                                    
  end

	 --select @l_dpm_id = dpm_id from dp_mstr where default_dp = @pa_id and dpm_deleted_ind =1                                    
	 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                                      
          

          
                    
                             
		CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)


--if @pa_tab = 'DUAL_Checker_App'
--begin 
--select dptdc_dpam_id id into #tempid from (select dptdc_dpam_id from dptdc_mak  where dptdc_dpam_id is not null and dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
--											union 
--											select demrm_dpam_id from demrm_mak  where demrm_dpam_id is not null and demrm_request_dt >= @pa_from_dt and demrm_request_dt <= @pa_to_dt
--											union 
--											select remrm_dpam_id from remrm_mak  where remrm_dpam_id is not null and remrm_request_dt >= @pa_from_dt and remrm_request_dt <= @pa_to_dt
--											) a 
--
--create clustered index ix_1 on #tempid(id)
--
--INSERT INTO #ACLIST 
--SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'DEC 31 2100') 
--FROM citrus_usr.fn_acct_list(@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id) 
--where dpam_sba_no like case when isnull(@pa_clientid,'') = '' then '%' else '' + isnull(@pa_clientid,'%') +'' end
--and  exists(select 1 from #tempid where id = dpam_id )
--
--end 
print @pa_from_dt
print @pa_to_dt
		if @l_dpm_id <> '3' 
		begin
print 'came here '
--			INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'DEC 31 2100')
-- FROM citrus_usr.fn_acct_list(@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id) 
--where dpam_sba_no like case when isnull(@pa_clientid,'') = '' then '%' else '' + isnull(@pa_clientid,'%') +'' end
--
--TP comment on JUn 30 2014

select dptdc_dpam_id id into #tempid from (select dptdc_dpam_id from dptdc_mak with (nolock) where dptdc_dpam_id is not null and dptdc_request_dt >= case when convert(varchar(11),@pa_from_dt,109) = 'Jan  1 1900' then 'Jan  1 1900' else @pa_from_dt end  and dptdc_request_dt <= case when convert(varchar(11),@pa_to_dt,109) = 'Jan  1 1900' then 'Jan  1 2100' else @pa_to_dt end
											union 
											select demrm_dpam_id from demrm_mak  with (nolock) where demrm_dpam_id is not null and demrm_request_dt >= case when convert(varchar(11),@pa_from_dt,109) = 'Jan  1 1900' then 'Jan  1 1900' else @pa_from_dt end and demrm_request_dt <= case when convert(varchar(11),@pa_to_dt,109) = 'Jan  1 1900' then 'Jan  1 2100' else @pa_to_dt end
											union 
											select remrm_dpam_id from remrm_mak  with (nolock) where remrm_dpam_id is not null and remrm_request_dt >= case when convert(varchar(11),@pa_from_dt,109) = 'Jan  1 1900' then 'Jan  1 1900' else @pa_from_dt end and remrm_request_dt <= case when convert(varchar(11),@pa_to_dt,109) = 'Jan  1 1900' then 'Jan  1 2100' else @pa_to_dt end
											) a 
--select * from #tempid where id =1128851
create clustered index ix_1 on #tempid(id)
print @l_dpm_id
print @pa_login_pr_entm_id
print @@l_child_entm_id
INSERT INTO #ACLIST 
SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'DEC 31 2100') 
FROM citrus_usr.fn_acct_list(@l_dpm_id ,@pa_login_pr_entm_id,@@l_child_entm_id) 
where dpam_sba_no like case when isnull(@pa_clientid,'') = '' then '%' else '' + isnull(@pa_clientid,'%') +'' end
and  exists(select 1 from #tempid with (nolock) where id = dpam_id )
--select * from #ACLIST where  dpam_id = 1128851 
--TP comment on JUn 30 2014

		end
		else
		begin
		INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,'',isnull('','DEC 31 2100') 
		FROM dp_acct_mstr where dpam_sba_no like case when isnull(@pa_clientid,'') = '' then '%' else '' + isnull(@pa_clientid,'%') +'' end
			end



create clustered index ix_1 on #ACLIST(dpam_id )

		Create table #BALANCES(
		dpam_id bigint,
		outstand_amt numeric(18,2)
		)
		select @@finId = isnull(fin_id,0) from financial_yr_mstr where case when @l_dpm_id= '999' then '1' else FIN_DPM_ID end = case when @l_dpm_id= '999' then '1' else @l_dpm_id end  AND @PA_TO_DT between fin_start_dt and fin_end_dt and fin_deleted_ind = 1
		set @@ssql ='insert into #BALANCES(dpam_id,outstand_amt)
		select LDG_ACCOUNT_ID,sum(isnull(ldg_amount,0)) * -1
		from citrus_usr.Ledger' + convert(varchar,@@finId) + ' with (nolock) where ldg_account_type = ''P'' and ldg_voucher_dt < ''' + convert(varchar(11),@pa_to_dt,109) + ''' and ldg_deleted_ind = 1
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
					,[Rate]
					,ABS([Valuation]) as [Valuation]
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd_execution_dt,DPTD_ISIN,DPTD_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd_execution_dt,DPTD_ISIN,DPTD_QTY),2,'|*~|') as Valuation
  					 FROM    dptd_mak  dptd 
                    left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id)= dptd.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					 WHERE   dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     case when dptd.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 and case when @@subtype <> '' then dptd.dptd_internal_trastm else '' end = @@subtype
					 AND     dptd_deleted_ind         IN (0,-1,4,6)
                     AND    dptd.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from Remrm_mak
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,ISIN_MSTR
					where tmpview.dpam_id = a.dpam_id
					AND TMPVIEW.ISIN = ISIN_CD
					--and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					ORDER BY 13,15

			end
			else
			begin

					SELECT distinct inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,SLIPNO 
					,dpam_sba_no   ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,convert(varchar(11),mkr_dt ,103)  + ' ' + convert(varchar(8),mkr_dt ,108) mkr_dt 
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptdc_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] ,counter_account,counter_dpid
					,[Status1]
					,ISNULL([auth_rmks],'') [auth_rmks]
					,ISNULL([checker1],'') [checker1]
					,case when convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) = '01/01/1900 00:00:00' then '' else  convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) end    [checker1_dt]--ISNULL([checker1_dt],'') [checker1_dt]
					,ISNULL([checker2],'') [checker2]
					,case when convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) = '01/01/1900 00:00:00' then '' else    convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) end [checker2_dt]--ISNULL([checker2_dt],'') [checker2_dt]
					, slip_reco
					, image_scan
					, scan_dt
					, dptdc_rmks
					, backoffice_code
					, reason
					, batchno ,  recon_datetime,'' RejectionDate,'' courier,'' podno,'' dispdate
					,[Rate]
					,ABS([Valuation]) as [Valuation]
					FROM
					(
					SELECT dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') <> '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = CASE WHEN isnull(convert(varchar(11),dptdc_created_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptdc_created_dt END 
					,ORDBY=1
					,dptdc_ISIN ISIN
					,CASE WHEN isnull(convert(varchar(11),dptdc_request_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptdc_request_dt END dptdc_request_dt
					,DPTDC_DPAM_ID DPAM_ID
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] 
					, isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp]  , isnull(dptd.DPTDc_COUNTER_DEMAT_ACCT_NO,'') counter_account , isnull(DPTDC_COUNTER_DP_ID,'') counter_dpid
--					, case when dptdc_deleted_ind = -1 then 'V' 
--						   When dptdc_deleted_ind = 0 then 'A'
--						   When dptdc_deleted_ind = 1 then 'U'
--					  else 'D' end as [Status1]
					, case when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '' then 'REJECTED'
						  when dptdc_deleted_ind = -1 and isnull(dptdc_res_cd,'') = '' then 'MAKER ENTERED (INSTRUCTION WITH HIGH VALUE OR DORMANT)'
                          when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')='' then 'MAKER ENTERED (INSTRUCTION WITHOUT HIGH VALUE OR DORMANT)' 
						  when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'' then '1ST CHECKER DONE' 
                          ELSE '' END AS [STATUS1]
                    , dptdc_rmks + '' + dptdc_res_desc as auth_rmks
					--, case when dptdc_deleted_ind = 0  then isnull(DPTDC_LST_UPD_BY,'') end as checker1
					, case when (dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '')  then isnull(dptdc_mid_chk,'') else '' end as checker1
					--, case when dptdc_deleted_ind = 0 then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DPTDC_LST_UPD_dt,109) END else '' end checker1_dt
					, case when (dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'') then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE DPTDC_LST_UPD_dt END else '' end checker1_dt
--convert(varchar(11),DPTDC_LST_UPD_dt,103) else '' end as checker1_dt
					, case when dptdc_deleted_ind = 1 then isnull(DPTDC_LST_UPD_BY,'') end as checker2
					, case when dptdc_deleted_ind = 1 then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE DPTDC_LST_UPD_dt END else '' end checker2_dt
--convert(varchar(11),DPTDC_LST_UPD_dt,103) else '' end as checker2_dt
					, case when recon_flag ='Y' then 'YES' else 'NO' end slip_reco
					, case when isnull(client_id,'')='' then 'NO' else 'YES' end image_scan
					--, case when isnull(convert(varchar(11),created_dt,106),'') = '01 Jan 1900' then '' else created_dt end  as scan_dt
					, case when isnull(convert(varchar(11),lst_upd_dt,106),'') = '01 Jan 1900' then '' else lst_upd_dt end  as scan_dt
					, isnull(dptdc_rmks,'') dptdc_rmks
					, ISNULL(CITRUS_USR.FN_UCC_ACCP(dptd.DPTDC_DPAM_ID,'BBO_CODE',''),'') backoffice_code
--					, case  when dptdc_reason_cd= '1' then 'Gift' 
--						    when dptdc_reason_cd= '2' then 'For offmkt sale/pur' 
--						    when dptdc_reason_cd= '3' then 'For onmkt sale/pur' 
--							when dptdc_reason_cd= '4' then 'Trnsfr of a/c from dp to dp' 
--							when dptdc_reason_cd= '5' then 'Trnsfr between 2 a/c of same hldr' 
--							when dptdc_reason_cd= '6' then 'Others' 
--							when dptdc_reason_cd= '7' then 'Trnsfr between family members'
--							when dptdc_reason_cd= '10' then 'Implementation of Government / Regulatory directions or orders'
--when dptdc_reason_cd= '11' then 'Erroneous transfers pertaining to client’s securities'
--when dptdc_reason_cd= '12' then 'Meeting legitimate dues of the stock broker'
--when dptdc_reason_cd= '13' then 'For Open Offer / Buy-Back'
--when dptdc_reason_cd= '14' then 'For Margin Purpose'
-- else '' end reason
, case  when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Gift' 
when dptd.dptdc_reason_cd= '2'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For offmkt sale/pur' 
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '4' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr of a/c from dp to dp' 
when dptd.dptdc_reason_cd= '5'and dptd.dptdc_Request_dt < 'Aug 04 2019'  then 'Trnsfr between 2 a/c of same hldr' 
when dptd.dptdc_reason_cd= '6'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Others' 
when dptd.dptdc_reason_cd= '7' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr between family members'
when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Gift'
when dptd.dptdc_reason_cd= '2' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For offmkt sale/pur'
when dptd.dptdc_reason_cd= '5' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to own account(s)'
when dptd.dptdc_reason_cd= '10' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Implementation of Government / Regulatory directions or orders'
when dptd.dptdc_reason_cd= '11' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Erroneous transfers pertaining to clients securities'
when dptd.dptdc_reason_cd= '12' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Meeting legitimate dues of the stock broker'
when dptd.dptdc_reason_cd= '13' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Open Offer for Acquisition'
when dptd.dptdc_reason_cd= '14' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin to stock broker/ PCM'
when dptd.dptdc_reason_cd= '15' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Refund of securities by IEPF Authority Existing'
when dptd.dptdc_reason_cd= '16' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Donation'
when dptd.dptdc_reason_cd= '17' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For Buy-Back'
when dptd.dptdc_reason_cd= '18' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin returned by stock broker/ PCM '
when dptd.dptdc_reason_cd= '19' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'ESOP/Transfer to employee'
when dptd.dptdc_reason_cd= '20' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Payout - On payments for unpaid securities'
when dptd.dptdc_reason_cd= '21' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to PMS Account'
when dptd.dptdc_reason_cd= '22' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer from PMS Account'
when dptd.dptdc_reason_cd= '23' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'On Market IDT transfer'
when dptd.dptdc_reason_cd= '24' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Redemption of Mutual Fund units'
when dptd.dptdc_reason_cd= '25' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Conversion of Depository Receipt (DR) to underlying Securities and vice versa'
when dptd.dptdc_reason_cd= '26' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transposition'
when dptd.dptdc_reason_cd= '27' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Merger/Demerger of Corporate entity'
when dptd.dptdc_reason_cd= '28' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Dissolution/ Restructuring/Winding up of Partnership firm/Trust'
when dptd.dptdc_reason_cd= '29' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Trust to Beneficiaries/On HUF dissolution to Karta & Coparceners'
when dptd.dptdc_reason_cd= '30' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Minor Account and Guardian Account'
when dptd.dptdc_reason_cd= '31' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members'
when dptd.dptdc_reason_cd= '32' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Partner and Firm or Director and Company'
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '34'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Certificate of Deposit Redemption' 
when dptd.dptdc_reason_cd= '311'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-1(Spouse)' 
when dptd.dptdc_reason_cd= '312'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-2(Father(including step-father))' 
when dptd.dptdc_reason_cd= '313'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-3(Mother(including step-mother))' 
when dptd.dptdc_reason_cd= '314'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-4(Son(including step-son))' 
when dptd.dptdc_reason_cd= '315'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-5(Sons wife)' 
when dptd.dptdc_reason_cd= '316'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-6(Daughter)' 
when dptd.dptdc_reason_cd= '317'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-7(Daughters husband)' 
when dptd.dptdc_reason_cd= '318'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-8(Brother(including step-brother))' 
when dptd.dptdc_reason_cd= '319'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-9(Sister(including step-sister))' 
when dptd.dptdc_reason_cd= '3110'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-10(Members of same HUF)' 
 else '' end reason 
      
					,'' batchno,isnull(recon_datetime,'') recon_datetime
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),2,'|*~|') as Valuation
   					 FROM    dptdc_mak                    dptd  with (nolock)
					 left outer join maker_scancopy  with (nolock) on DPTDC_SLIP_NO = slip_no and deleted_ind=1
                     left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				     
  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind         IN (0,-1,4,6)
                     AND     dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end					
					and     isnull(dptd.dptdc_res_cd,'') = ''
					union 
					select demrm_id  inst_id
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
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account ,'' counter_dpid
					--,''
					, case when demrm_deleted_ind = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <> '') then 'REJECTED'
						  --when demrm_deleted_ind = -1 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') = '') then 'MAKER ENTERED (INSTRUCTION WITH HIGH VALUE OR DORMANT)'
                          when demrm_deleted_ind = 0 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') = '') then 'MAKER ENTERED' 
						  --when demrm_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'' then '1ST CHECKER DONE' 
                          ELSE '' END AS [STATUS1]
					, DEMRM_RMKS + '' + demrm_res_desc_intobj + '' + demrm_res_desc_compobj as auth_rmks
					, case when (DEMRM_DELETED_IND = 1 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') <>''))  then isnull(DEMRM_LST_UPD_BY,'') else '' end as checker1
					, case when (DEMRM_DELETED_IND = 1 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') <>'')) then CASE WHEN isnull(convert(varchar(11),DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DEMRM_LST_UPD_DT,109) END else '' end checker1_dt
--isnull(convert(varchar(11),DEMRM_LST_UPD_DT,103),'') end as checker1_dt
					, '' checker2 --case when DEMRM_DELETED_IND = 1 then isnull(DEMRM_LST_UPD_BY,'') end as checker2
					, '' checker2_dt--case when DEMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DEMRM_LST_UPD_DT,109) END else '' end checker2_dt
--isnull(convert(varchar(11),DEMRM_LST_UPD_DT,103),'') end as checker2_dt	
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(demrm_rmks,'') demrm_rmks
					, '' backoffice_code
					, '' reason	
					,'' batchno		,'' recon_datetime
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation
					from demrm_mak with (nolock)
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd like case when isnull(@pa_trastm_cd,'')= '' then  '%' else 'DMAT' end
					AND demrm_slip_serial_no like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					and isnull(demrm_res_cd_intobj,'') = ''	and isnull(demrm_res_cd_compobj,'') = ''
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
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account, '' counter_dpid 
					,''
					,REMRM_RMKS as auth_rmks
					, case when REMRM_DELETED_IND = 0 then isnull(REMRM_LST_UPD_BY,'') end as checker1
					, case when REMRM_DELETED_IND = 0 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),REMRM_LST_UPD_DT,109) END else '' end checker1_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker1_dt
					, case when REMRM_DELETED_IND = 1 then isnull(REMRM_LST_UPD_BY,'') end as checker2
					, case when REMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),REMRM_LST_UPD_DT,109) END else '' end checker2_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker2_dt	
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(remrm_rmks,'') remrm_rmks
					, '' backoffice_code
					, '' reason
					,'' batchno,'' recon_datetime
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from Remrm_mak with (nolock)
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
                     and @pa_trastm_cd like case when isnull(@pa_trastm_cd,'')= '' then  '%' else  'RMAT' end
					AND remrm_slip_serial_no like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					and isnull(REMRM_INTERNAL_REJ,'') = ''	and isnull(REMRM_COMPANY_OBJ,'') = ''
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					--ORDER BY 13,15
						order by slipno,inst_id



			end
	 --
  end 

if @pa_tab = 'Pending_For_App_Rej'
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
					,batchno
					,[Rate]
					,ABS([Valuation]) as [Valuation]
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
					,'' batchno
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),2,'|*~|') as Valuation
  					 FROM    dptd_mak  dptd 
                    left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id)= dptd.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					 WHERE   dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     case when dptd.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 and case when @@subtype <> '' then dptd.dptd_internal_trastm else '' end = @@subtype
					 AND     dptd_deleted_ind         IN (0,-1,4,6)
                     AND    dptd.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
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
					,'' batchno
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation
					from demrm_mak
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					and  demrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd = 'DMAT'
                    AND    DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
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
					,'' batchno
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from Remrm_mak
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd = 'RMAT'
                    AND    rEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,ISIN_MSTR
					where tmpview.dpam_id = a.dpam_id
					AND TMPVIEW.ISIN = ISIN_CD
					--and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					ORDER BY 13,15

			end
			else
			begin
print 'ddd'
					SELECT distinct inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,SLIPNO 
					,dpam_sba_no   ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,convert(varchar(11),mkr_dt ,103)  + ' ' + convert(varchar(8),mkr_dt ,108) mkr_dt 
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptdc_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] ,counter_account,counter_dpid
					,[Status1]
					,ISNULL([auth_rmks],'') [auth_rmks]
					,ISNULL([checker1],'') [checker1]
					,case when convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) = '01/01/1900 00:00:00' then '' else  convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) end    [checker1_dt]--ISNULL([checker1_dt],'') [checker1_dt]
					,ISNULL([checker2],'') [checker2]
					,case when convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) = '01/01/1900 00:00:00' then '' else    convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) end [checker2_dt]--ISNULL([checker2_dt],'') [checker2_dt]
					, slip_reco
					, image_scan
					, convert(varchar(11),scan_dt ,103)  + ' ' + convert(varchar(8),scan_dt ,108) scan_dt 
					, dptdc_rmks
					, backoffice_code
					, reason
					, batchno, recon_datetime,'' RejectionDate,'' courier,'' podno,'' dispdate
					,[Rate]
					,ABS([Valuation]) as [Valuation]
					FROM
					(
					SELECT dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') <> '' ) then isnull(dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptdc_created_by
					,mkr_dt = CASE WHEN isnull(convert(varchar(11),dptdc_created_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptdc_created_dt END 
					,ORDBY=1
					,dptdc_ISIN ISIN
					,CASE WHEN isnull(convert(varchar(11),dptdc_request_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptdc_request_dt END dptdc_request_dt
					,DPTDC_DPAM_ID DPAM_ID
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] 
					, isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp]  , isnull(dptd.DPTDc_COUNTER_DEMAT_ACCT_NO,'') counter_account , isnull(DPTDC_COUNTER_DP_ID,'') counter_dpid
--					, case when dptdc_deleted_ind = -1 then 'V' 
--						   When dptdc_deleted_ind = 0 then 'A'
--						   When dptdc_deleted_ind = 1 then 'U'
--					  else 'D' end as [Status1]
					, case when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '' then 'REJECTED'
						  when dptdc_deleted_ind = -1 and isnull(dptdc_res_cd,'') = '' then 'MAKER ENTERED'
						  when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' then '1ST CHECKER DONE' ELSE '' END AS [STATUS1]
                    , dptdc_rmks + '' + dptdc_res_desc as auth_rmks
					--, case when dptdc_deleted_ind = 0  then isnull(DPTDC_LST_UPD_BY,'') end as checker1
					, case when (dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '')  then case when isnull(dptdc_mid_chk,'') <> '' then dptdc_mid_chk else dptdc_lst_upd_by end  else '' end as checker1--case when (dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '')  then isnull(dptdc_mid_chk,'') else '' end as checker1
					--, case when dptdc_deleted_ind = 0 then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DPTDC_LST_UPD_dt,109) END else '' end checker1_dt
					, case when (dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '') then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE DPTDC_LST_UPD_dt END else '' end checker1_dt
--convert(varchar(11),DPTDC_LST_UPD_dt,103) else '' end as checker1_dt
					, case when dptdc_deleted_ind = 1 then isnull(DPTDC_LST_UPD_BY,'') end as checker2
					, case when dptdc_deleted_ind = 1 then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE DPTDC_LST_UPD_dt END else '' end checker2_dt
--convert(varchar(11),DPTDC_LST_UPD_dt,103) else '' end as checker2_dt
					, case when recon_flag ='Y' then 'YES' else 'NO' end slip_reco
					, case when isnull(client_id,'')='' then 'NO' else 'YES' end image_scan
--					, case when isnull(convert(varchar(11),created_dt,106),'') = '01 Jan 1900' then '' else created_dt end  as scan_dt
					, case when isnull(convert(varchar(11),lst_upd_dt,106),'') = '01 Jan 1900' then '' else lst_upd_dt end  as scan_dt
					, isnull(dptdc_rmks,'') dptdc_rmks
					, ISNULL(CITRUS_USR.FN_UCC_ACCP(dptd.DPTDC_DPAM_ID,'BBO_CODE',''),'') backoffice_code
--					, case  when dptdc_reason_cd= '1' then 'Gift' 
--						    when dptdc_reason_cd= '2' then 'For offmkt sale/pur' 
--						    when dptdc_reason_cd= '3' then 'For onmkt sale/pur' 
--							when dptdc_reason_cd= '4' then 'Trnsfr of a/c from dp to dp' 
--							when dptdc_reason_cd= '5' then 'Trnsfr between 2 a/c of same hldr' 
--							when dptdc_reason_cd= '6' then 'Others' 
--							when dptdc_reason_cd= '7' then 'Trnsfr between family members' 
--							when dptdc_reason_cd= '10' then 'Implementation of Government / Regulatory directions or orders'
--when dptdc_reason_cd= '11' then 'Erroneous transfers pertaining to client’s securities'
--when dptdc_reason_cd= '12' then 'Meeting legitimate dues of the stock broker'
--when dptdc_reason_cd= '13' then 'For Open Offer / Buy-Back'
--when dptdc_reason_cd= '14' then 'For Margin Purpose'
--else '' end reason
, case  when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Gift' 
when dptd.dptdc_reason_cd= '2'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For offmkt sale/pur' 
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '4' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr of a/c from dp to dp' 
when dptd.dptdc_reason_cd= '5'and dptd.dptdc_Request_dt < 'Aug 04 2019'  then 'Trnsfr between 2 a/c of same hldr' 
when dptd.dptdc_reason_cd= '6'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Others' 
when dptd.dptdc_reason_cd= '7' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr between family members'
when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Gift'
when dptd.dptdc_reason_cd= '2' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For offmkt sale/pur'
when dptd.dptdc_reason_cd= '5' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to own account(s)'
when dptd.dptdc_reason_cd= '10' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Implementation of Government / Regulatory directions or orders'
when dptd.dptdc_reason_cd= '11' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Erroneous transfers pertaining to clients securities'
when dptd.dptdc_reason_cd= '12' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Meeting legitimate dues of the stock broker'
when dptd.dptdc_reason_cd= '13' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Open Offer for Acquisition'
when dptd.dptdc_reason_cd= '14' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin to stock broker/ PCM'
when dptd.dptdc_reason_cd= '15' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Refund of securities by IEPF Authority Existing'
when dptd.dptdc_reason_cd= '16' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Donation'
when dptd.dptdc_reason_cd= '17' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For Buy-Back'
when dptd.dptdc_reason_cd= '18' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin returned by stock broker/ PCM '
when dptd.dptdc_reason_cd= '19' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'ESOP/Transfer to employee'
when dptd.dptdc_reason_cd= '20' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Payout - On payments for unpaid securities'
when dptd.dptdc_reason_cd= '21' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to PMS Account'
when dptd.dptdc_reason_cd= '22' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer from PMS Account'
when dptd.dptdc_reason_cd= '23' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'On Market IDT transfer'
when dptd.dptdc_reason_cd= '24' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Redemption of Mutual Fund units'
when dptd.dptdc_reason_cd= '25' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Conversion of Depository Receipt (DR) to underlying Securities and vice versa'
when dptd.dptdc_reason_cd= '26' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transposition'
when dptd.dptdc_reason_cd= '27' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Merger/Demerger of Corporate entity'
when dptd.dptdc_reason_cd= '28' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Dissolution/ Restructuring/Winding up of Partnership firm/Trust'
when dptd.dptdc_reason_cd= '29' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Trust to Beneficiaries/On HUF dissolution to Karta & Coparceners'
when dptd.dptdc_reason_cd= '30' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Minor Account and Guardian Account'
when dptd.dptdc_reason_cd= '31' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members'
when dptd.dptdc_reason_cd= '32' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Partner and Firm or Director and Company'
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '34'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Certificate of Deposit Redemption' 
when dptd.dptdc_reason_cd= '311'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-1(Spouse)' 
when dptd.dptdc_reason_cd= '312'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-2(Father(including step-father))' 
when dptd.dptdc_reason_cd= '313'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-3(Mother(including step-mother))' 
when dptd.dptdc_reason_cd= '314'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-4(Son(including step-son))' 
when dptd.dptdc_reason_cd= '315'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-5(Sons wife)' 
when dptd.dptdc_reason_cd= '316'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-6(Daughter)' 
when dptd.dptdc_reason_cd= '317'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-7(Daughters husband)' 
when dptd.dptdc_reason_cd= '318'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-8(Brother(including step-brother))' 
when dptd.dptdc_reason_cd= '319'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-9(Sister(including step-sister))' 
when dptd.dptdc_reason_cd= '3110'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-10(Members of same HUF)'
 else '' end reason 
      
					, '' batchno, isnull(recon_datetime,'') recon_datetime
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),2,'|*~|') as Valuation
   					 FROM    dptdc_mak                    dptd  with (nolock)
					 left outer join maker_scancopy  with (nolock) on DPTDC_SLIP_NO = slip_no 
                     left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				     
  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind         IN (0,-1,4,6)
                     AND     dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end					
					 and     isnull(dptd.dptdc_res_cd,'') <> ''
					union 
					select demrm_id  inst_id
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
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account ,'' counter_dpid
					--,''
					, case when demrm_deleted_ind = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'')<>'') then 'REJECTED' end status1
					, DEMRM_RMKS + '' + demrm_res_desc_intobj + '' + demrm_res_desc_compobj as auth_rmks
					, case when (DEMRM_DELETED_IND = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <>''))  then isnull(DEMRM_LST_UPD_BY,'') else '' end as checker1
					, case when (DEMRM_DELETED_IND = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <>'')) then CASE WHEN isnull(convert(varchar(11),DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DEMRM_LST_UPD_DT,109) END else '' end checker1_dt
--isnull(convert(varchar(11),DEMRM_LST_UPD_DT,103),'') end as checker1_dt
					, case when DEMRM_DELETED_IND = 1 then isnull(DEMRM_LST_UPD_BY,'') end as checker2
					, case when DEMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DEMRM_LST_UPD_DT,109) END else '' end checker2_dt
--isnull(convert(varchar(11),DEMRM_LST_UPD_DT,103),'') end as checker2_dt	
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(demrm_rmks,'') demrm_rmks
					, '' backoffice_code
					, '' reason	
					, '' batchno,'' recon_datetime
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation		
					from demrm_mak with (nolock)
					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
					AND    DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					and  demrm_deleted_ind IN (0,4,6)
                    and @pa_trastm_cd like case when isnull(@pa_trastm_cd,'')= '' then  '%' else 'DMAT' end
					and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <> '')
					AND    DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
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
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account, '' counter_dpid 
					,''
					,REMRM_RMKS as auth_rmks
					, case when REMRM_DELETED_IND = 0 then isnull(REMRM_LST_UPD_BY,'') end as checker1
					, case when REMRM_DELETED_IND = 0 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),REMRM_LST_UPD_DT,109) END else '' end checker1_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker1_dt
					, case when REMRM_DELETED_IND = 1 then isnull(REMRM_LST_UPD_BY,'') end as checker2
					, case when REMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),REMRM_LST_UPD_DT,109) END else '' end checker2_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker2_dt	
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(remrm_rmks,'') remrm_rmks
					, '' backoffice_code
					, '' reason
					, '' batchno,'' recon_datetime
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from Remrm_mak with (nolock)
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind IN (0,4,6)
                     and @pa_trastm_cd like case when isnull(@pa_trastm_cd,'')= '' then  '%' else  'RMAT' end
				AND    rEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					) tmpview left outer join  isin_mstr on  tmpview.isin = isin_cd left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					 
					where tmpview.dpam_id = a.dpam_id
					
					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
					--ORDER BY 13,15
					order by SLIPNO,inst_id



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
					,[Rate]
					,ABS([Valuation]) as [Valuation]
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
					  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),1,'|*~|') as Rate
					  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),2,'|*~|') as Valuation
					FROM    dptd_mak dptd 
                   , DP_TRX_DTLS dptd1 left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd1.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd1.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					,isin_mstr
					WHERE   dptd.dptd_id = dptd1.dptd_id 
					and dptd1.dptd_request_dt >= @pa_from_dt and dptd1.dptd_request_dt <= @pa_to_dt
					and     case when dptd1.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd1.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					and case when @@subtype <> '' then dptd1.dptd_internal_trastm else '' end = @@subtype
					AND     dptd1.dptd_deleted_ind = 1 
					AND     dptd.dptd_deleted_ind in(0,1)
                    AND     dptd.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                    AND     dptd1.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					union 
					select CONVERT(VARCHAR(50),demrm_id) + ' / ' + CONVERT(VARCHAR(50)	,ISNULL(demrm_transaction_no,''))  inst_id
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from remat_request_mstr
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
                    and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					ORDER BY 18,17



			end
			else
			begin


                    --Changed By Priya
--					SELECT   @l_dpm_id       DPID
--					,inst_id 
--					,TRNSNO
--					,REQUESTDATE 
--					,EXECUTIONDATE
--					,trans_descp       
--					,SLIPNO 
--					,BATCHNO
--					,dpam_sba_no                 ACCOUNTNO
--					,dpam_sba_name				 ACCOUNTNAME
--					,QUANTITY
--					,[DUAL CHECKER]
--					,mkr 
--					,mkr_dt 
--					,[CHECKER 1]	
--					,[CHECKER 2]	
--					,Last_chkr_dt 
--					,ORDBY
--					,dptdc_request_dt
--					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
--					,qty=CONVERT(NUMERIC(18,3),abs(QTY))
--					,isin_name
--					,isin
--                    ,mkt_type 
--                    ,other_mkt_type 
--                    ,[settlementno] 
--                    ,[othersettmno]
--                    ,[cmbp],counter_account
--					,[Status1]

			select	distinct inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,SLIPNO 
					,dpam_sba_no   ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,convert(varchar(11),mkr_dt ,103)  + ' ' + convert(varchar(8),mkr_dt ,108)   mkr_dt 
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptdc_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] ,counter_account,counter_dpid
					,[Status1]
					,ISNULL([auth_rmks],'') [auth_rmks]
					,ISNULL([checker1],'') [checker1]
					,case when convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) = '01/01/1900 00:00:00' then '' else  convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) end    [checker1_dt]
					,ISNULL([checker2],'') [checker2]
					,case when convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) = '01/01/1900 00:00:00' then '' else    convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) end [checker2_dt]
					, slip_reco
					, image_scan
					, case when scan_dt='1900-01-01 00:00:00.000' then '' when scan_dt='1/1/1900' then '' else convert(varchar(11),scan_dt ,103)  + ' ' + convert(varchar(8),scan_dt ,108) end scan_dt
					, isnull(dptdc_rmks,'') dptdc_rmks
					, backoffice_code
					, reason
					--, isnull(recon_datetime,'') recon_datetime
					, case when scan_dt='1900-01-01 00:00:00.000' then '' when recon_datetime='1/1/1900' then '' else convert(varchar(11),recon_datetime ,103)  + ' ' + convert(varchar(8),recon_datetime ,108) end recon_datetime					
					, isnull(dptdc_batch_no,'') batchno, '' RejectionDate,'' courier,'' podno,'' dispdate
					,[Rate]
					,ABS([Valuation]) as [Valuation]
					from
					(
--					SELECT   dptd1.dptdc_id inst_id 
--					,TRNSNO = ISNULL(dptd1.DPTDC_TRANS_NO,'')
--					,convert(varchar(11),dptd1.dptdc_request_dt,103)             REQUESTDATE 
--					,convert(varchar(11),dptd1.dptdc_execution_dt,103)           EXECUTIONDATE
--					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(dptd1.DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
--					,dptd1.dptdc_slip_no                SLIPNO 
--					,BATCHNO = ISNULL(dptd1.DPTDC_BATCH_NO,'')	
--					,abs(dptd1.dptdc_qty)               QUANTITY
--					,case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then 'Y'
--					ELSE 'N' END                        [DUAL CHECKER]
--					,mkr = dptd.dptdc_created_by
--					,mkr_dt = dptd.dptdc_created_dt
--					,case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then isnull(dptd.dptdc_mid_chk,'') else isnull(dptd.dptdc_lst_upd_by,'') end [CHECKER 1]	
--					,case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then isnull(dptd.dptdc_lst_upd_by,'') else '' end  [CHECKER 2]	
--					,Last_chkr_dt = dptd.DPTDc_LST_UPD_DT
--					,ORDBY=1
--					,dptd1.dptdc_request_dt
--					,dptd1.dptdc_dpam_id dpam_id
--					,abs(dptd1.dptdc_qty) qty ,dptd1.dptdc_isin isin
--                   , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd1.DPTDC_SETTLEMENT_NO,'') [settlementno] , isnull(dptd1.DPTDC_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd1.DPTDC_COUNTER_CMBP_ID,'') [cmbp] , isnull(dptd1.DPTDC_COUNTER_DEMAT_ACCT_NO,'') counter_account
--					, case when dptd.dptdc_deleted_ind = -1 then 'V' 
--						   When dptd.dptdc_deleted_ind = 0 then 'A'
--						   When dptd.dptdc_deleted_ind = 1 then 'U'
--					  else 'D' end as [Status1]
					SELECT distinct convert(varchar(50),dptd1.DPTDC_ID) inst_id 
					,convert(varchar(11),dptd1.dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd1.dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(dptd1.DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptd1.dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptd1.dptdc_qty))               QUANTITY
					,case when dptd1.dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd.dptdc_deleted_ind = 0 and isnull(dptd.dptdc_mid_chk,'') <> '' ) then isnull(dptd.dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd1.dptdc_created_by
					,mkr_dt = CASE WHEN isnull(convert(varchar(11),dptd1.dptdc_created_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptd1.dptdc_created_dt END 
					,ORDBY=1
					,dptd1.dptdc_ISIN ISIN
					,CASE WHEN isnull(convert(varchar(11),dptd1.dptdc_request_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptd1.dptdc_request_dt END dptdc_request_dt
					,dptd1.DPTDC_DPAM_ID DPAM_ID
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] 
					, isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp]  , isnull(dptd.DPTDc_COUNTER_DEMAT_ACCT_NO,'') counter_account , isnull(dptd.DPTDC_COUNTER_DP_ID,'') counter_dpid
--					, case when dptdc_deleted_ind = -1 then 'V' 
--						   When dptdc_deleted_ind = 0 then 'A'
--						   When dptdc_deleted_ind = 1 then 'U'
--					  else 'D' end as [Status1]
					, case when citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(dptd1.dptdc_dpam_id,''))<> '' then citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(dptd1.dptdc_dpam_id,''))
when ISNULL(dptd1.dptdc_trans_no,'') = '0' 
						then 'REJECTED FROM CDSL' +'-' + isnull(citrus_usr.fn_get_errordesc(dptd1.DPTDC_ERRMSG),'')
when ISNULL(dptd1.dptdc_trans_no,'') <> '' 
						then 'RESPONSE FILE IMPORTED'
						
						when ISNULL(dptd1.dptdc_batch_no,'') <> '' 
						then 'BATCH GENERATED' 
						when dptd1.dptdc_deleted_ind = 1 
						then 'CHECKER DONE' ELSE '' END AS [STATUS1]
                    , dptd.dptdc_rmks + '' + dptd.dptdc_res_desc as auth_rmks
					--, case when dptd.dptdc_deleted_ind = 0 then isnull(dptd.DPTDC_LST_UPD_BY,'') end as checker1
					, case when dptd.dptdc_mid_chk <> '' then dptd.dptdc_mid_chk else isnull(dptd.DPTDC_LST_UPD_BY,'') end as checker1
					, case when dptd.dptdc_deleted_ind in (0,1) and isnull(dptd.dptdc_mid_chk,'') <> '' then CASE WHEN isnull(convert(varchar(11),dptd1.DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE dptd1.DPTDC_LST_UPD_dt END 
						   when dptd.dptdc_deleted_ind in (0,1) and isnull(dptd.dptdc_mid_chk,'') = '' then CASE WHEN isnull(convert(varchar(11),dptd.DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE dptd.DPTDC_LST_UPD_dt END else '' end checker1_dt
--convert(varchar(11),dptd.DPTDC_LST_UPD_dt,103) else '' end as checker1_dt
					, case when dptd1.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then isnull(dptd.DPTDC_LST_UPD_BY,'') else '' end as checker2
					, case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then CASE WHEN isnull(convert(varchar(11),dptd.DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE dptd.DPTDC_LST_UPD_dt END else '' end checker2_dt										
					, case when recon_flag ='Y' then 'YES' else 'NO' end  slip_reco
					, case when isnull(client_id,'')='' then 'NO' else 'YES' end image_scan
					--, case when isnull(convert(varchar(11),created_dt,106),'') = '01 Jan 1900' then '' else created_dt end  as scan_dt
					, case when isnull(convert(varchar(11),lst_upd_dt,106),'') = '01 Jan 1900' then '' else lst_upd_dt end  as scan_dt
					, isnull(dptd1.dptdc_rmks,'') dptdc_rmks
					, dpam_bbo_code backoffice_code
--					, case  when dptd.dptdc_reason_cd= '1' then 'Gift' 
--						    when dptd.dptdc_reason_cd= '2' then 'For offmkt sale/pur' 
--						    when dptd.dptdc_reason_cd= '3' then 'For onmkt sale/pur' 
--							when dptd.dptdc_reason_cd= '4' then 'Trnsfr of a/c from dp to dp' 
--							when dptd.dptdc_reason_cd= '5' then 'Trnsfr between 2 a/c of same hldr' 
--							when dptd.dptdc_reason_cd= '6' then 'Others' 
--							when dptd.dptdc_reason_cd= '7' then 'Trnsfr between family members' 
--							when dptd.dptdc_reason_cd= '10' then 'Implementation of Government / Regulatory directions or orders'
--when dptd.dptdc_reason_cd= '11' then 'Erroneous transfers pertaining to client’s securities'
--when dptd.dptdc_reason_cd= '12' then 'Meeting legitimate dues of the stock broker'
--when dptd.dptdc_reason_cd= '13' then 'For Open Offer / Buy-Back'
--when dptd.dptdc_reason_cd= '14' then 'For Margin Purpose'
--else '' end reason
, case  when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Gift' 
when dptd.dptdc_reason_cd= '2'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For offmkt sale/pur' 
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '4' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr of a/c from dp to dp' 
when dptd.dptdc_reason_cd= '5'and dptd.dptdc_Request_dt < 'Aug 04 2019'  then 'Trnsfr between 2 a/c of same hldr' 
when dptd.dptdc_reason_cd= '6'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Others' 
when dptd.dptdc_reason_cd= '7' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr between family members'
when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Gift'
when dptd.dptdc_reason_cd= '2' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For offmkt sale/pur'
when dptd.dptdc_reason_cd= '5' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to own account(s)'
when dptd.dptdc_reason_cd= '10' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Implementation of Government / Regulatory directions or orders'
when dptd.dptdc_reason_cd= '11' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Erroneous transfers pertaining to clients securities'
when dptd.dptdc_reason_cd= '12' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Meeting legitimate dues of the stock broker'
when dptd.dptdc_reason_cd= '13' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Open Offer for Acquisition'
when dptd.dptdc_reason_cd= '14' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin to stock broker/ PCM'
when dptd.dptdc_reason_cd= '15' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Refund of securities by IEPF Authority Existing'
when dptd.dptdc_reason_cd= '16' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Donation'
when dptd.dptdc_reason_cd= '17' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For Buy-Back'
when dptd.dptdc_reason_cd= '18' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin returned by stock broker/ PCM '
when dptd.dptdc_reason_cd= '19' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'ESOP/Transfer to employee'
when dptd.dptdc_reason_cd= '20' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Payout - On payments for unpaid securities'
when dptd.dptdc_reason_cd= '21' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to PMS Account'
when dptd.dptdc_reason_cd= '22' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer from PMS Account'
when dptd.dptdc_reason_cd= '23' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'On Market IDT transfer'
when dptd.dptdc_reason_cd= '24' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Redemption of Mutual Fund units'
when dptd.dptdc_reason_cd= '25' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Conversion of Depository Receipt (DR) to underlying Securities and vice versa'
when dptd.dptdc_reason_cd= '26' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transposition'
when dptd.dptdc_reason_cd= '27' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Merger/Demerger of Corporate entity'
when dptd.dptdc_reason_cd= '28' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Dissolution/ Restructuring/Winding up of Partnership firm/Trust'
when dptd.dptdc_reason_cd= '29' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Trust to Beneficiaries/On HUF dissolution to Karta & Coparceners'
when dptd.dptdc_reason_cd= '30' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Minor Account and Guardian Account'
when dptd.dptdc_reason_cd= '31' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members'
when dptd.dptdc_reason_cd= '32' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Partner and Firm or Director and Company'
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '34'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Certificate of Deposit Redemption' 
when dptd.dptdc_reason_cd= '311'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-1(Spouse)' 
when dptd.dptdc_reason_cd= '312'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-2(Father(including step-father))' 
when dptd.dptdc_reason_cd= '313'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-3(Mother(including step-mother))' 
when dptd.dptdc_reason_cd= '314'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-4(Son(including step-son))' 
when dptd.dptdc_reason_cd= '315'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-5(Sons wife)' 
when dptd.dptdc_reason_cd= '316'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-6(Daughter)' 
when dptd.dptdc_reason_cd= '317'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-7(Daughters husband)' 
when dptd.dptdc_reason_cd= '318'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-8(Brother(including step-brother))' 
when dptd.dptdc_reason_cd= '319'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-9(Sister(including step-sister))' 
when dptd.dptdc_reason_cd= '3110'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-10(Members of same HUF)'
 else '' end reason 
      
					,recon_datetime as recon_datetime
					,dptd1.dptdc_batch_no
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),2,'|*~|') as Valuation
					FROM   dp_acct_mstr with(nolock) , dptdc_mak dptd  with (nolock) left outer join maker_scancopy  with (nolock) on DPTDC_SLIP_NO = slip_no and deleted_ind =1
                   ,DP_TRX_DTLS_CDSL dptd1  with (nolock) 
                    left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd1.DPTDC_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd1.DPTDC_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					--left outer join cdsl_holding_dtls on cdshm_dpam_id = dptdc_dpam_id and cdshm_trans_no = dptd1.dptdc_trans_no
					WHERE  dpam_id = dptd.dptdc_dpam_id and  dptd.dptdc_id = dptd1.dptdc_id 
					and dptd1.dptdc_request_dt >= @pa_from_dt and dptd1.dptdc_request_dt <= @pa_to_dt
					--and dptd1.dptdc_trastm_cd   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					and case when dptd1.dptdc_trastm_cd='CMBO' then 'BOCM' else dptd1.dptdc_trastm_cd end   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					AND dptd1.dptdc_deleted_ind = 1 
					--AND dptd.dptdc_deleted_ind in(0,1)
					AND dptd.dptdc_deleted_ind in(1)
                    AND dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                    AND dptd1.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                    and dptd1.dptdc_id = dptd.dptdc_id  
                    --End
					union  
--					select demrm_id inst_id
--					,TRNSNO = ISNULL(DEMRM_TRANSACTION_NO,'')
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,'DEMAT REQUEST'
--					,DEMRM_SLIP_SERIAL_NO
--					,BATCHNO = ISNULL(DEMRM_BATCH_NO,'')
--					,convert(numeric(18,3),Abs(DEMRM_QTY))
--					,'N'
--					,mkr=demrm_created_by
--					,mkr_dt = demrm_created_dt
--					,demrm_lst_upd_by 
--					,''
--					,demrm_lst_upd_dt
--					,ORDBY=2
--					,demrm_request_dt
--					,demrm_dpam_id
--					,abs(demrm_qty) qty
--					,demrm_isin isin , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
--					,''
					select distinct CONVERT(VARCHAR(50),d.demrm_id) + '/' + CONVERT(VARCHAR(50),ISNULL(demrm_transaction_no,''))  inst_id
					,convert(varchar(11),d.demrm_request_dt,103)
					,convert(varchar(11),d.demrm_request_dt,103)
					,'DEMAT REQUEST'
					,d.DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(d.DEMRM_QTY))
					,''
					,mkr=d1.demrm_created_by
					,mkr_dt = d1.demrm_created_dt
					,ORDBY=2
					,d.DEMRM_ISIN
					,d.demrm_request_dt
					,d.DEMRM_DPAM_ID
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account ,'' counter_dpid
					--,''
					,case when citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(d.DEMRM_dpam_id,''))<> '' then citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(d.DEMRM_dpam_id,''))
when ISNULL(d.DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL' +'-'  + isnull(citrus_usr.fn_get_errordesc(d.DEMRM_ERRMSG),'')  
					when ISNULL(d.DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'  

					when ISNULL(d.DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED' when d.demrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS [STATUS1]
--					,case when citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(d.DEMRM_DPAM_ID,''))<> '' then citrus_usr.gettranstype(ISNULL(d1.DEMRM_TRANSACTION_NO,''),ISNULL(d1.demrm_dpam_id,''))
--						when ISNULL(d.DEMRM_TRANSACTION_NO,'') <> '' 
--						then 'RESPONSE FILE IMPORTED'
--						when ISNULL(d.DEMRM_BATCH_NO,'') <> '' 
--						then 'BATCH GENERATED' 
--						when d.demrm_deleted_ind = 1 
--						then 'CHECKER DONE' ELSE '' END AS [STATUS1]
					, d1.DEMRM_RMKS + '' + d1.demrm_res_desc_intobj + '' + d1.demrm_res_desc_compobj as auth_rmks
					, case when d1.DEMRM_DELETED_IND = 1 then isnull(d1.DEMRM_LST_UPD_BY,'') end as checker1
					, case when d1.DEMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),d1.DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE d1.DEMRM_LST_UPD_DT END else '' end checker1_dt

					, '' as checker2
					, '' as checker2_dt
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(d.demrm_rmks,'') demrm_rmks
					, '' backoffice_code
					, '' reason	
					, '' recon_datetime
					, d.DEMRM_BATCH_NO
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(d.DEMRM_EXECUTION_DT,d.DEMRM_ISIN,d.DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(d.DEMRM_EXECUTION_DT,d.DEMRM_ISIN,d.DEMRM_QTY),2,'|*~|') as Valuation
					from demat_request_mstr d with (nolock),demrm_mak d1 with (nolock)
					where d.DEMRM_request_dt >= @pa_from_dt and d.DEMRM_request_dt <= @pa_to_dt
					and  d.demrm_deleted_ind = 1
					and  d1.demrm_deleted_ind = 1
                    and @pa_trastm_cd like  case when isnull(@pa_trastm_cd,'')= '' then  '%' else 'DMAT' end
					AND d.DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					AND d1.DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					and d.DEMRM_DPAM_ID = d1.DEMRM_DPAM_ID
                    and d.demrm_id = d1.demrm_id					
 
					union 
--					select Remrm_id inst_id
--					,TRNSNO = ISNULL(REMRM_TRANSACTION_NO,'')
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,'REMAT REQUEST'
--					,REMRM_SLIP_SERIAL_NO
--					,BATCHNO = ISNULL(REMRM_BATCH_NO,'')
--					,convert(numeric(18,3),Abs(REMRM_QTY))
--					,'N'
--					,mkr=Remrm_created_by
--					,mkr_dt = Remrm_created_dt
--					,remrm_lst_upd_by 
--					,''
--					,remrm_lst_upd_dt
--					,ORDBY=3
--					,Remrm_request_dt
--					,Remrm_dpam_id
--					,abs(Remrm_qty) qty
--					,Remrm_isin isin  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
--					,''
					select distinct convert(varchar(50),Remrm_id) inst_id
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
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account, '' counter_dpid 
					--,''
					,case when citrus_usr.gettranstype(ISNULL(REMRM_TRANSACTION_NO,''),ISNULL(REMRM_dpam_id,''))<> '' then citrus_usr.gettranstype(ISNULL(REMRM_TRANSACTION_NO,''),ISNULL(REMRM_dpam_id,''))
when ISNULL(REMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL' +'-'  + isnull(citrus_usr.fn_get_errordesc(REMRM_ERRMSG),'')  
					when ISNULL(REMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'  

					when ISNULL(REMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED' when remrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS [STATUS1]
					,REMRM_RMKS as auth_rmks
					, case when REMRM_DELETED_IND = 0 then isnull(REMRM_LST_UPD_BY,'') end as checker1
					, case when REMRM_DELETED_IND = 0 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE REMRM_LST_UPD_DT END else '' end checker1_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker1_dt
					, case when REMRM_DELETED_IND = 1 then isnull(REMRM_LST_UPD_BY,'') end as checker2
					, case when REMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE REMRM_LST_UPD_DT END else '' end checker2_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker2_dt	
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(remrm_rmks,'') remrm_rmks
					, '' backoffice_code
					, '' reason
					, '' recon_datetime
					, remrm_batch_no
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from remat_request_mstr with (nolock)
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
                    and @pa_trastm_cd like  case when isnull(@pa_trastm_cd,'')= '' then  '%' else 'RMAT' end
					AND REMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= isnull(eff_to,'DEc 31 2100')
					--ORDER BY 18,17			
					order by slipno,inst_id

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
					,[Rate]
					,ABS([Valuation]) as [Valuation]
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
					  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),1,'|*~|') as Rate
					  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),2,'|*~|') as Valuation
  					 FROM    dptd_mak  dptd 
                      left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				     
  					 WHERE   dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
  					 and     case when dptd.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 and case when @@subtype <> '' then dptd.dptd_internal_trastm else '' end = @@subtype
					 AND     dptd_lst_upd_by = DPTD_CREATED_BY
  					 AND     dptd_deleted_ind         = 2
  					 AND     NOT EXISTS(SELECT dptd_slip_no FROM dp_trx_dtls d where d.dptd_slip_no = dptd.dptd_slip_no AND dptd_deleted_ind = 1)
                     AND     dptd.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
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
					 , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),1,'|*~|') as Rate
					 , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),2,'|*~|') as Valuation
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation	
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from Remrm_mak remrm
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind = 4
                    and @pa_trastm_cd = 'RMAT'
					AND  EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr	
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd 
					--and dptd_request_dt >= eff_from and dptd_request_dt <= eff_to
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
                    ,[Rate]
					,ABS([Valuation]) as [Valuation]
					FROM
					(
 					SELECT dptdc_id inst_id 
					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') <> '' ) then isnull(dptdc_mid_chk,'') 
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),2,'|*~|') as Valuation
  					 FROM    dptdc_mak                    dptd  with (nolock)
                     left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                     left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				
  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind      =   2
  					 AND     dptdc_created_by <> dptdc_lst_upd_by 
  					 AND     NOT EXISTS(SELECT dptdc_slip_no FROM dp_trx_dtls_cdsl d with (nolock) where d.dptdc_slip_no = dptd.dptdc_slip_no AND dptdc_deleted_ind = 1)
                     AND     dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation
					from demrm_mak demrm with (nolock)
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from Remrm_mak remrm with (nolock)
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
					  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),2,'|*~|') as Valuation
  					 FROM    dptdc_mak                    dptd with (nolock) 
                       left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                      left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
				
  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
  					 AND     dptdc_deleted_ind      =  4
  					 AND     EXISTS(SELECT dptdc_slip_no FROM dp_trx_dtls_cdsl d with (nolock) where d.dptdc_slip_no = dptd.dptdc_slip_no AND dptdc_deleted_ind = 1)
                     AND     dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation
					from demrm_mak demrm with (nolock)
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from Remrm_mak remrm with (nolock)
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =4 
                    and @pa_trastm_cd = 'RMAT'
					AND     EXISTS(SELECT REMRM_SLIP_SERIAL_NO FROM citrus_usr.REMAT_REQUEST_MSTR d where d.REMRM_SLIP_SERIAL_NO = remrm.REMRM_SLIP_SERIAL_NO AND remrm_deleted_ind = 1)
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to

					--ORDER BY 12,13
				order by slipno,inst_id



			end
	 --
  end 
  
--if @pa_tab = 'ALL_RECORD_TYPE'  --Added for all oprion of record type on 20 May 2013
--  begin
--  --
--			if @pa_type = 'NSDL'
--			begin
--					select 
--					 @l_dpm_id DPID 
--					,inst_id
--					,REQUESTDATE 
--					,EXECUTIONDATE
--					,trans_descp          
--					,SLIPNO 
--					,dpam_sba_no ACCOUNTNO
--					,dpam_sba_name ACCOUNTNAME
--					,QUANTITY
--					,[DUAL CHECKER]
--					,mkr
--					,mkr_dt
--					,ORDBY
--					,ISIN_NAME
--					,ISIN
--					,dptd_request_dt
--					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
--                    ,mkt_type 
--                    ,other_mkt_type 
--                    ,[settlementno] 
--                    ,[othersettmno]
--                    ,[cmbp] ,counter_account
--					,[Status1]
--					from 
--					(
--					SELECT  dptd_id inst_id
--					,convert(varchar(11),dptd_request_dt,103)             REQUESTDATE 
--					,convert(varchar(11),dptd_execution_dt,103)           EXECUTIONDATE
--					,Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(DPTD_INTERNAL_TRASTM,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL') trans_descp          
--					,dptd_slip_no                SLIPNO 
--					,convert(numeric(18,3),abs(dptd_qty))               QUANTITY
--					,case when dptd_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
--						  When (dptd_deleted_ind = 0 and isnull(dptd_mid_chk,'') != '' ) then isnull(dptd_mid_chk,'') 
--						  else 'NOT APPLICABLE' end [DUAL CHECKER]
--					,mkr = dptd_created_by
--					,mkr_dt = dptd_created_dt
--					,ORDBY=1
--					,DPTD_ISIN ISIN
--					,dptd_request_dt
--					,dptd_dpam_id dpam_id
--                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTD_SETTLEMENT_NO,'') [settlementno] , isnull(dptd.DPTD_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTD_COUNTER_CMBP_ID,'') [cmbp], isnull(dptd.DPTD_COUNTER_DEMAT_ACCT_NO,'') counter_account 
--					, case when dptd_deleted_ind = -1 then 'V' 
--						   When dptd_deleted_ind = 0 then 'A'
--						   When dptd_deleted_ind = 1 then 'U'
--					  else 'D' end as [Status1]
--  					 FROM    dptd_mak  dptd 
--                    left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
--                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id)= dptd.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
--					 WHERE   dptd_request_dt >= @pa_from_dt and dptd_request_dt <= @pa_to_dt
--  					 and     case when dptd.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
--  					 and case when @@subtype <> '' then dptd.dptd_internal_trastm else '' end = @@subtype
--					 AND     dptd_deleted_ind         IN (0,-1,4,6)
--                     AND    dptd.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
--    				union 
--					select demrm_id inst_id
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,'DEMAT REQUEST'
--					,DEMRM_SLIP_SERIAL_NO
--					,convert(numeric(18,3),Abs(DEMRM_QTY))
--					,''
--					,mkr=demrm_created_by
--					,mkr_dt = demrm_created_dt
--					,ORDBY=2
--					,DEMRM_ISIN ISIN
--					,demrm_request_dt
--					,DEMRM_DPAM_ID 
--                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account 
--					,''
--					from demrm_mak
--					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
--					and  demrm_deleted_ind IN (0,4,6)
--                    and @pa_trastm_cd = 'DMAT'
-- 					union 
--					select Remrm_id inst_id
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,'REMAT REQUEST'
--					,REMRM_SLIP_SERIAL_NO
--					,convert(numeric(18,3),Abs(REMRM_QTY))
--					,''
--					,mkr=Remrm_created_by
--					,mkr_dt = Remrm_created_dt
--					,ORDBY=3
--					,REMRM_ISIN ISIN
--					,Remrm_request_dt
--					,REMRM_DPAM_ID
--                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account 
--					,''
--					from Remrm_mak
--					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
--					and  Remrm_deleted_ind IN (0,4,6)
--                    and @pa_trastm_cd = 'RMAT'
--					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
--					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
--					,ISIN_MSTR
--					where tmpview.dpam_id = a.dpam_id
--					AND TMPVIEW.ISIN = ISIN_CD
--					--and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
--					ORDER BY 13,15
--
--			end
--			else
--			begin
--
--					SELECT distinct inst_id 
--					,REQUESTDATE 
--					,EXECUTIONDATE
--					,trans_descp     
--					,SLIPNO 
--					,dpam_sba_no   ACCOUNTNO
--					,dpam_sba_name ACCOUNTNAME
--					,QUANTITY
--					,[DUAL CHECKER]
--					,mkr 
--					,convert(varchar(11),mkr_dt ,103)  + ' ' + convert(varchar(8),mkr_dt ,108) mkr_dt 
--					,ORDBY
--					,ISIN_NAME
--					,ISIN
--					,dptdc_request_dt
--					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
--                    ,mkt_type 
--                    ,other_mkt_type 
--                    ,[settlementno] 
--                    ,[othersettmno]
--                    ,[cmbp] ,counter_account,counter_dpid
--					,[Status1]
--					,ISNULL([auth_rmks],'') [auth_rmks]
--					,ISNULL([checker1],'') [checker1]
--					,case when convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) = '01/01/1900 00:00:00' then '' else  convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) end    [checker1_dt]--ISNULL([checker1_dt],'') [checker1_dt]
--					,ISNULL([checker2],'') [checker2]
--					,case when convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) = '01/01/1900 00:00:00' then '' else    convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) end [checker2_dt]--ISNULL([checker2_dt],'') [checker2_dt]
--					, slip_reco
--					, image_scan
--					, scan_dt
--					, dptdc_rmks
--					, backoffice_code
--					, reason
--					, batchno
--					FROM
--					(
--					SELECT dptdc_id inst_id 
--					,convert(varchar(11),dptdc_request_dt,103)             REQUESTDATE 
--					,convert(varchar(11),dptdc_execution_dt,103)           EXECUTIONDATE
--					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
--					,dptdc_slip_no                SLIPNO 
--					,convert(numeric(18,3),abs(dptdc_qty))               QUANTITY
--					,case when dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
--						  When (dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') <> '' ) then isnull(dptdc_mid_chk,'') 
--						  else 'NOT APPLICABLE' end [DUAL CHECKER]
--					,mkr = dptdc_created_by
--					,mkr_dt = CASE WHEN isnull(convert(varchar(11),dptdc_created_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptdc_created_dt END 
--					,ORDBY=1
--					,dptdc_ISIN ISIN
--					,CASE WHEN isnull(convert(varchar(11),dptdc_request_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptdc_request_dt END dptdc_request_dt
--					,DPTDC_DPAM_ID DPAM_ID
--                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] 
--					, isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp]  , isnull(dptd.DPTDc_COUNTER_DEMAT_ACCT_NO,'') counter_account , isnull(DPTDC_COUNTER_DP_ID,'') counter_dpid
----					, case when dptdc_deleted_ind = -1 then 'V' 
----						   When dptdc_deleted_ind = 0 then 'A'
----						   When dptdc_deleted_ind = 1 then 'U'
----					  else 'D' end as [Status1]
--					, case when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '' then 'REJECTED'
--						  when dptdc_deleted_ind = -1 and isnull(dptdc_res_cd,'') = '' then 'MAKER ENTERED (INSTRUCTION WITH HIGH VALUE OR DORMANT)'
--                          when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')='' then 'MAKER ENTERED (INSTRUCTION WITHOUT HIGH VALUE OR DORMANT)' 
--						  when dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'' then '1ST CHECKER DONE' 
--						  when dptdc_deleted_ind = 1 then 'APPROVED'
--                          ELSE '' END AS [STATUS1]
--                    , dptdc_rmks + '' + dptdc_res_desc as auth_rmks
--					--, case when dptdc_deleted_ind = 0  then isnull(DPTDC_LST_UPD_BY,'') end as checker1
--					, case when (dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '')  then isnull(dptdc_mid_chk,'') else '' end as checker1
--					--, case when dptdc_deleted_ind = 0 then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DPTDC_LST_UPD_dt,109) END else '' end checker1_dt
--					, case when (dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'') then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE DPTDC_LST_UPD_dt END else '' end checker1_dt
----convert(varchar(11),DPTDC_LST_UPD_dt,103) else '' end as checker1_dt
--					, case when dptdc_deleted_ind = 1 then isnull(DPTDC_LST_UPD_BY,'') end as checker2
--					, case when dptdc_deleted_ind = 1 then CASE WHEN isnull(convert(varchar(11),DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE DPTDC_LST_UPD_dt END else '' end checker2_dt
----convert(varchar(11),DPTDC_LST_UPD_dt,103) else '' end as checker2_dt
--					, case when recon_flag ='Y' then 'YES' else 'NO' end slip_reco
--					, case when isnull(client_id,'')='' then 'NO' else 'YES' end image_scan
--					, case when isnull(convert(varchar(11),created_dt,106),'') = '01 Jan 1900' then '' else created_dt end  as scan_dt
--					, isnull(dptdc_rmks,'') dptdc_rmks
--					, ISNULL(CITRUS_USR.FN_UCC_ACCP(dptd.DPTDC_DPAM_ID,'BBO_CODE',''),'') backoffice_code
--					, case  when dptdc_reason_cd= '1' then 'Gift' 
--						    when dptdc_reason_cd= '2' then 'For offmkt sale/pur' 
--						    when dptdc_reason_cd= '3' then 'For onmkt sale/pur' 
--							when dptdc_reason_cd= '4' then 'Trnsfr of a/c from dp to dp' 
--							when dptdc_reason_cd= '5' then 'Trnsfr between 2 a/c of same hldr' 
--							when dptdc_reason_cd= '6' then 'Others' 
--							when dptdc_reason_cd= '7' then 'Trnsfr between family members' else '' end reason
--					,'' batchno
--   					 FROM    dptdc_mak                    dptd 
--					 left outer join maker_scancopy  on DPTDC_SLIP_NO = slip_no and deleted_ind=1
--                     left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd.DPTDc_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
--                     left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd.DPTDc_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
--				     
--  					 WHERE   dptdc_request_dt >= @pa_from_dt and dptdc_request_dt <= @pa_to_dt
--  					 and     dptdc_trastm_cd            like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
--  					-- AND     dptdc_deleted_ind         IN (0,-1,4,6)
--                     AND     dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end					
--					--and     isnull(dptd.dptdc_res_cd,'') = ''
--					union 
--					select demrm_id  inst_id
--					,convert(varchar(11),demrm_request_dt,103)
--					,convert(varchar(11),demrm_request_dt,103)
--					,'DEMAT REQUEST'
--					,DEMRM_SLIP_SERIAL_NO
--					,convert(numeric(18,3),abs(DEMRM_QTY))
--					,''
--					,mkr=demrm_created_by
--					,mkr_dt = demrm_created_dt
--					,ORDBY=2
--					,DEMRM_ISIN
--					,demrm_request_dt
--					,DEMRM_DPAM_ID
--                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account ,'' counter_dpid
--					--,''
--					, case when demrm_deleted_ind = 0 and (isnull(demrm_res_cd_intobj,'') <> '' or isnull(demrm_res_cd_compobj,'') <> '') then 'REJECTED'
--						  --when demrm_deleted_ind = -1 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') = '') then 'MAKER ENTERED (INSTRUCTION WITH HIGH VALUE OR DORMANT)'
--                          when demrm_deleted_ind = 0 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') = '') then 'MAKER ENTERED' 
--						  --when demrm_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'' then '1ST CHECKER DONE' 
--                          ELSE '' END AS [STATUS1]
--					, DEMRM_RMKS + '' + demrm_res_desc_intobj + '' + demrm_res_desc_compobj as auth_rmks
--					, case when (DEMRM_DELETED_IND = 1 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') <>''))  then isnull(DEMRM_LST_UPD_BY,'') else '' end as checker1
--					, case when (DEMRM_DELETED_IND = 1 and (isnull(demrm_res_cd_intobj,'') = '' or isnull(demrm_res_cd_compobj,'') <>'')) then CASE WHEN isnull(convert(varchar(11),DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DEMRM_LST_UPD_DT,109) END else '' end checker1_dt
----isnull(convert(varchar(11),DEMRM_LST_UPD_DT,103),'') end as checker1_dt
--					, '' checker2 --case when DEMRM_DELETED_IND = 1 then isnull(DEMRM_LST_UPD_BY,'') end as checker2
--					, '' checker2_dt--case when DEMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),DEMRM_LST_UPD_DT,109) END else '' end checker2_dt
----isnull(convert(varchar(11),DEMRM_LST_UPD_DT,103),'') end as checker2_dt	
--					, '' slip_reco
--					, '' image_scan
--					, '' scan_dt
--					, isnull(demrm_rmks,'') demrm_rmks
--					, '' backoffice_code
--					, '' reason	
--					,'' batchno		
--					from demrm_mak
--					where DEMRM_request_dt >= @pa_from_dt and DEMRM_request_dt <= @pa_to_dt
--					--and  demrm_deleted_ind IN (0,4,6)
--                    and @pa_trastm_cd like case when isnull(@pa_trastm_cd,'')= '' then  '%' else 'DMAT' end
--					AND demrm_slip_serial_no like case when @pa_slip_no = '' then '%' else @pa_slip_no end
--					and isnull(demrm_res_cd_intobj,'') = ''	and isnull(demrm_res_cd_compobj,'') = ''
--					union 
--					select Remrm_id inst_id
--					,convert(varchar(11),Remrm_request_dt,103)
--					,convert(varchar(11),Remrm_request_dt,103)
--					,'REMAT REQUEST'
--					,REMRM_SLIP_SERIAL_NO
--					,convert(numeric(18,3),abs(REMRM_QTY))
--					,''
--					,mkr=Remrm_created_by
--					,mkr_dt = Remrm_created_dt
--					,ORDBY=3
--					,remrm_isin isin
--					,Remrm_request_dt
--					,REMRM_DPAM_ID
--                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account, '' counter_dpid 
--					,''
--					,REMRM_RMKS as auth_rmks
--					, case when REMRM_DELETED_IND = 0 then isnull(REMRM_LST_UPD_BY,'') end as checker1
--					, case when REMRM_DELETED_IND = 0 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),REMRM_LST_UPD_DT,109) END else '' end checker1_dt
----isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker1_dt
--					, case when REMRM_DELETED_IND = 1 then isnull(REMRM_LST_UPD_BY,'') end as checker2
--					, case when REMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),REMRM_LST_UPD_DT,109) END else '' end checker2_dt
----isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker2_dt	
--					, '' slip_reco
--					, '' image_scan
--					, '' scan_dt
--					, isnull(remrm_rmks,'') remrm_rmks
--					, '' backoffice_code
--					, '' reason
--					,'' batchno
--					from Remrm_mak
--					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
--					--and  Remrm_deleted_ind IN (0,4,6)
--                     and @pa_trastm_cd like case when isnull(@pa_trastm_cd,'')= '' then  '%' else  'RMAT' end
--					AND remrm_slip_serial_no like case when @pa_slip_no = '' then '%' else @pa_slip_no end
--					and isnull(REMRM_INTERNAL_REJ,'') = ''	and isnull(REMRM_COMPANY_OBJ,'') = ''
--					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
--					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
--					,isin_mstr
--					where tmpview.dpam_id = a.dpam_id
--					and tmpview.isin = isin_cd
--					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= eff_to
--					--ORDER BY 13,15
--						order by slipno,inst_id
--
--
--
--			end
--	 --
--  end --
 if @pa_tab = 'ALL_RECORD_TYPE'
  begin
  --
	if @pa_slip_no = ''
	begin
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
					,[Rate]
					,ABS([Valuation]) as [Valuation]
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
					  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTd_QTY),1,'|*~|') as Rate
					  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptd_execution_dt,dptd.DPTD_ISIN,dptd.DPTD_QTY),2,'|*~|') as Valuation

					FROM    dptd_mak dptd
                   , DP_TRX_DTLS dptd1 left outer join settlement_type_mstr settm1 on convert(varchar,settm1.settm_id) = dptd1.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 on convert(varchar,settm2.settm_id) = dptd1.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					,isin_mstr
					WHERE   dptd.dptd_id = dptd1.dptd_id 
					and dptd1.dptd_request_dt >= @pa_from_dt and dptd1.dptd_request_dt <= @pa_to_dt
					and     case when dptd1.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd1.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					and case when @@subtype <> '' then dptd1.dptd_internal_trastm else '' end = @@subtype
					AND     dptd1.dptd_deleted_ind = 1 
					AND     dptd.dptd_deleted_ind in(0,1)
                    AND     dptd.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                    AND     dptd1.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					union 
					select CONVERT(VARCHAR(50),demrm_id) + ' / ' + CONVERT(VARCHAR(50)	,ISNULL(demrm_transaction_no,''))  inst_id
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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),1,'|*~|') as Rate
				  , citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(DEMRM_EXECUTION_DT,DEMRM_ISIN,DEMRM_QTY),2,'|*~|') as Valuation	

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
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from remat_request_mstr
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
                    and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					ORDER BY 18,17



			end
			else
			begin

print 'much'
                    --Changed By Priya
--					SELECT   @l_dpm_id       DPID
--					,inst_id 
--					,TRNSNO
--					,REQUESTDATE 
--					,EXECUTIONDATE
--					,trans_descp       
--					,SLIPNO 
--					,BATCHNO
--					,dpam_sba_no                 ACCOUNTNO
--					,dpam_sba_name				 ACCOUNTNAME
--					,QUANTITY
--					,[DUAL CHECKER]
--					,mkr 
--					,mkr_dt 
--					,[CHECKER 1]	
--					,[CHECKER 2]	
--					,Last_chkr_dt 
--					,ORDBY
--					,dptdc_request_dt
--					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
--					,qty=CONVERT(NUMERIC(18,3),abs(QTY))
--					,isin_name
--					,isin
--                    ,mkt_type 
--                    ,other_mkt_type 
--                    ,[settlementno] 
--                    ,[othersettmno]
--                    ,[cmbp],counter_account
--					,[Status1]

print 'yogesh'
			select	distinct inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,SLIPNO 
					,dpam_sba_no   ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,convert(varchar(11),mkr_dt ,103)  + ' ' + convert(varchar(8),mkr_dt ,108)   mkr_dt 
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptdc_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] ,counter_account,counter_dpid
					,[Status1]
					,ISNULL([auth_rmks],'') [auth_rmks]
					,ISNULL([checker1],'') [checker1]
					,case when convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) = '01/01/1900 00:00:00' then '' else  convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) end    [checker1_dt]
					,ISNULL([checker2],'') [checker2]
					,case when convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) = '01/01/1900 00:00:00' then '' else    convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) end [checker2_dt]
					, slip_reco
					, image_scan
					, case when scan_dt='1900-01-01 00:00:00.000' then '' when scan_dt='1/1/1900' then '' else convert(varchar(11),scan_dt ,103)  + ' ' + convert(varchar(8),scan_dt ,108) end scan_dt
					, isnull(dptdc_rmks,'') dptdc_rmks
					, backoffice_code
					, reason
					--, isnull(recon_datetime,'') recon_datetime
					, case when scan_dt='1900-01-01 00:00:00.000' then '' when recon_datetime='1/1/1900' then '' else convert(varchar(11),recon_datetime ,103)  + ' ' + convert(varchar(8),recon_datetime ,108) end recon_datetime					
					, isnull(dptdc_batch_no,'') batchno
					--,  case when convert(varchar(11),convert(datetime,RejectionDate),103)='01/01/1900' then '' else convert(varchar(11),convert(datetime,RejectionDate),103) end RejectionDate --RejectionDate
					,RejectionDate
					,  courier
					,  podno -- ,dispdate
					,  case when dispdate='1900-01-01 00:00:00.000' then '' else convert(varchar(11),convert(datetime,dispdate),103) end dispdate
					,[Rate]
					,ABS([Valuation]) as [Valuation]

					from
					(

					SELECT distinct convert(varchar(50),dptd.DPTDC_ID) inst_id 
					,convert(varchar(11),dptd.dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd.dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(dptd.DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptd.dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptd.dptdc_qty))               QUANTITY
					,case when dptd1.dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd.dptdc_deleted_ind = 0 and isnull(dptd.dptdc_mid_chk,'') <> '' ) then isnull(dptd.dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd.dptdc_created_by
					,mkr_dt = CASE WHEN isnull(convert(varchar(11),dptd.dptdc_created_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptd.dptdc_created_dt END 
					,ORDBY=1
					,dptd.dptdc_ISIN ISIN
					,CASE WHEN isnull(convert(varchar(11),dptd.dptdc_request_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptd.dptdc_request_dt END dptdc_request_dt
					,dptd.DPTDC_DPAM_ID DPAM_ID
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] 
					, isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp]  , isnull(dptd.DPTDc_COUNTER_DEMAT_ACCT_NO,'') counter_account , isnull(dptd.DPTDC_COUNTER_DP_ID,'') counter_dpid
--					, case when dptdc_deleted_ind = -1 then 'V' 
--						   When dptdc_deleted_ind = 0 then 'A'
--						   When dptdc_deleted_ind = 1 then 'U'
--					  else 'D' end as [Status1]
					, case when citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(convert(varchar,dptd1.dptdc_dpam_id),'0'))<> '' then citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(convert(varchar,dptd1.dptdc_dpam_id),'0'))
when ISNULL(dptd1.dptdc_trans_no,'') = '0' then 'REJECTED FROM CDSL' +'-'  + isnull(citrus_usr.fn_get_errordesc(dptd1.DPTDC_ERRMSG),'')
						when ISNULL(dptd1.dptdc_trans_no,'') <> '' then 'RESPONSE FILE IMPORTED'

						when ISNULL(dptd1.dptdc_batch_no,'') <> '' then 'BATCH GENERATED' 
						--when dptd1.dptdc_deleted_ind = 1 then 'CHECKER DONE' 
						when dptd.dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '' then 'REJECTED'
						when dptd.dptdc_deleted_ind = -1 and isnull(dptdc_res_cd,'') = '' then 'MAKER ENTERED (INSTRUCTION WITH HIGH VALUE OR DORMANT)'
                        when dptd.dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')='' then 'MAKER ENTERED (INSTRUCTION WITHOUT HIGH VALUE OR DORMANT)' 
						when dptd.dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'' then '1ST CHECKER DONE' 
						when dptd1.dptdc_deleted_ind = 1 then 'CHECKER DONE'
						ELSE '' END AS [STATUS1]
                    , dptd.dptdc_rmks + '' + dptd.dptdc_res_desc as auth_rmks
					--, case when dptd.dptdc_deleted_ind = 0 then isnull(dptd.DPTDC_LST_UPD_BY,'') end as checker1
					, case when dptd.dptdc_mid_chk <> '' then dptd.dptdc_mid_chk else isnull(dptd.DPTDC_LST_UPD_BY,'') end as checker1
					, case when dptd.dptdc_deleted_ind in (0,1) and isnull(dptd.dptdc_mid_chk,'') <> '' then CASE WHEN isnull(convert(varchar(11),dptd1.DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE dptd1.DPTDC_LST_UPD_dt END 
						   when dptd.dptdc_deleted_ind in (0,1) and isnull(dptd.dptdc_mid_chk,'') = '' then CASE WHEN isnull(convert(varchar(11),dptd.DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE dptd.DPTDC_LST_UPD_dt END else '' end checker1_dt
--convert(varchar(11),dptd.DPTDC_LST_UPD_dt,103) else '' end as checker1_dt
					, case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then isnull(dptd.DPTDC_LST_UPD_BY,'') else '' end as checker2
					, case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then CASE WHEN isnull(convert(varchar(11),dptd.DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE dptd.DPTDC_LST_UPD_dt END else '' end checker2_dt										
					, case when recon_flag ='Y' then 'YES' else 'NO' end  slip_reco
					, case when isnull(client_id,'')='' then 'NO' else 'YES' end image_scan
					--, case when isnull(convert(varchar(11),created_dt,106),'') = '01 Jan 1900' then '' else created_dt end  as scan_dt
					, case when isnull(convert(varchar(11),lst_upd_dt,106),'') = '01 Jan 1900' then '' else lst_upd_dt end  as scan_dt
					, isnull(dptd1.dptdc_rmks,'') dptdc_rmks
					, ISNULL(CITRUS_USR.FN_UCC_ACCP(dptd.DPTDC_DPAM_ID,'BBO_CODE',''),'') backoffice_code
--					, case  when dptd.dptdc_reason_cd= '1' then 'Gift' 
--						    when dptd.dptdc_reason_cd= '2' then 'For offmkt sale/pur' 
--						    when dptd.dptdc_reason_cd= '3' then 'For onmkt sale/pur' 
--							when dptd.dptdc_reason_cd= '4' then 'Trnsfr of a/c from dp to dp' 
--							when dptd.dptdc_reason_cd= '5' then 'Trnsfr between 2 a/c of same hldr' 
--							when dptd.dptdc_reason_cd= '6' then 'Others' 
--							when dptd.dptdc_reason_cd= '7' then 'Trnsfr between family members' 
--							when dptd.dptdc_reason_cd= '10' then 'Implementation of Government / Regulatory directions or orders'
--when dptd.dptdc_reason_cd= '11' then 'Erroneous transfers pertaining to client’s securities'
--when dptd.dptdc_reason_cd= '12' then 'Meeting legitimate dues of the stock broker'
--when dptd.dptdc_reason_cd= '13' then 'For Open Offer / Buy-Back'
--when dptd.dptdc_reason_cd= '14' then 'For Margin Purpose'
--else '' end reason
, case  when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Gift' 
when dptd.dptdc_reason_cd= '2'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For offmkt sale/pur' 
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '4' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr of a/c from dp to dp' 
when dptd.dptdc_reason_cd= '5'and dptd.dptdc_Request_dt < 'Aug 04 2019'  then 'Trnsfr between 2 a/c of same hldr' 
when dptd.dptdc_reason_cd= '6'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Others' 
when dptd.dptdc_reason_cd= '7' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr between family members'
when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Gift'
when dptd.dptdc_reason_cd= '2' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For offmkt sale/pur'
when dptd.dptdc_reason_cd= '5' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to own account(s)'
when dptd.dptdc_reason_cd= '10' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Implementation of Government / Regulatory directions or orders'
when dptd.dptdc_reason_cd= '11' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Erroneous transfers pertaining to clients securities'
when dptd.dptdc_reason_cd= '12' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Meeting legitimate dues of the stock broker'
when dptd.dptdc_reason_cd= '13' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Open Offer for Acquisition'
when dptd.dptdc_reason_cd= '14' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin to stock broker/ PCM'
when dptd.dptdc_reason_cd= '15' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Refund of securities by IEPF Authority Existing'
when dptd.dptdc_reason_cd= '16' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Donation'
when dptd.dptdc_reason_cd= '17' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For Buy-Back'
when dptd.dptdc_reason_cd= '18' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin returned by stock broker/ PCM '
when dptd.dptdc_reason_cd= '19' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'ESOP/Transfer to employee'
when dptd.dptdc_reason_cd= '20' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Payout - On payments for unpaid securities'
when dptd.dptdc_reason_cd= '21' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to PMS Account'
when dptd.dptdc_reason_cd= '22' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer from PMS Account'
when dptd.dptdc_reason_cd= '23' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'On Market IDT transfer'
when dptd.dptdc_reason_cd= '24' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Redemption of Mutual Fund units'
when dptd.dptdc_reason_cd= '25' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Conversion of Depository Receipt (DR) to underlying Securities and vice versa'
when dptd.dptdc_reason_cd= '26' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transposition'
when dptd.dptdc_reason_cd= '27' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Merger/Demerger of Corporate entity'
when dptd.dptdc_reason_cd= '28' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Dissolution/ Restructuring/Winding up of Partnership firm/Trust'
when dptd.dptdc_reason_cd= '29' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Trust to Beneficiaries/On HUF dissolution to Karta & Coparceners'
when dptd.dptdc_reason_cd= '30' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Minor Account and Guardian Account'
when dptd.dptdc_reason_cd= '31' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members'
when dptd.dptdc_reason_cd= '32' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Partner and Firm or Director and Company'
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '34'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Certificate of Deposit Redemption' 
when dptd.dptdc_reason_cd= '311'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-1(Spouse)' 
when dptd.dptdc_reason_cd= '312'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-2(Father(including step-father))' 
when dptd.dptdc_reason_cd= '313'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-3(Mother(including step-mother))' 
when dptd.dptdc_reason_cd= '314'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-4(Son(including step-son))' 
when dptd.dptdc_reason_cd= '315'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-5(Sons wife)' 
when dptd.dptdc_reason_cd= '316'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-6(Daughter)' 
when dptd.dptdc_reason_cd= '317'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-7(Daughters husband)' 
when dptd.dptdc_reason_cd= '318'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-8(Brother(including step-brother))' 
when dptd.dptdc_reason_cd= '319'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-9(Sister(including step-sister))' 
when dptd.dptdc_reason_cd= '3110'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-10(Members of same HUF)'
 else '' end reason 
      
					,recon_datetime as recon_datetime
					,dptd1.dptdc_batch_no
					, '' RejectionDate
					, '' courier
					, '' podno
					, '' dispdate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),2,'|*~|') as Valuation
					FROM    dptdc_mak dptd  with (nolock) left outer join maker_scancopy  with (nolock) on DPTDC_SLIP_NO = slip_no and deleted_ind =1
                    left outer join DP_TRX_DTLS_CDSL dptd1 with (nolock) on dptd.dptdc_id = dptd1.dptdc_id 
                    left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd1.DPTDC_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd1.DPTDC_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					--left outer join cdsl_holding_dtls on cdshm_dpam_id = dptdc_dpam_id and cdshm_trans_no = dptd1.dptdc_trans_no
					WHERE   --dptd.dptdc_id = dptd1.dptdc_id 
					 dptd.dptdc_request_dt >= @pa_from_dt and dptd.dptdc_request_dt <= @pa_to_dt
					--and dptd1.dptdc_trastm_cd   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					and case when dptd.dptdc_trastm_cd='CMBO' then 'BOCM' else dptd.dptdc_trastm_cd end   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					--AND dptd1.dptdc_deleted_ind = 1 
					--AND dptd.dptdc_deleted_ind in(0,1)
                    AND dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					AND dptd.dptdc_deleted_ind not in(2,4,6)
                    --AND dptd1.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                  
                    --End
					union  
--					select demrm_id inst_id
--					,TRNSNO = ISNULL(DEMRM_TRANSACTION_NO,'')
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,'DEMAT REQUEST'
--					,DEMRM_SLIP_SERIAL_NO
--					,BATCHNO = ISNULL(DEMRM_BATCH_NO,'')
--					,convert(numeric(18,3),Abs(DEMRM_QTY))
--					,'N'
--					,mkr=demrm_created_by
--					,mkr_dt = demrm_created_dt
--					,demrm_lst_upd_by 
--					,''
--					,demrm_lst_upd_dt
--					,ORDBY=2
--					,demrm_request_dt
--					,demrm_dpam_id
--					,abs(demrm_qty) qty
--					,demrm_isin isin , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
--					,''
					select distinct CONVERT(VARCHAR(50),d1.demrm_id) + '/' + CONVERT(VARCHAR(50),ISNULL(demrm_transaction_no,''))  inst_id
					,convert(varchar(11),d1.demrm_request_dt,103)
					,convert(varchar(11),d1.demrm_request_dt,103)
					,'DEMAT REQUEST'
					,d1.DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(d1.DEMRM_QTY))
					,''
					,mkr=d1.demrm_created_by
					,mkr_dt = d1.demrm_created_dt
					,ORDBY=2
					,d1.DEMRM_ISIN
					,d1.demrm_request_dt
					,d1.DEMRM_DPAM_ID
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account ,'' counter_dpid
					--,''
					,case when citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,d.DEMRM_dpam_id),'0'))<> '' then citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,d.DEMRM_dpam_id),'0'))
when ISNULL(d.DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL' +'-'   + isnull(citrus_usr.fn_get_errordesc(d.DEMRM_ERRMSG),'')
					when ISNULL(d.DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'  

					when ISNULL(d.DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED' when d.demrm_deleted_ind = 1 then 'CHECKER DONE' 
					when d1.demrm_deleted_ind = 0 and (isnull(d1.demrm_res_cd_intobj,'') <> '' or isnull(d1.demrm_res_cd_compobj,'')<>'') then 'REJECTED' 
					when d1.demrm_deleted_ind = 0 and (isnull(d1.demrm_res_cd_intobj,'') = '' or isnull(d1.demrm_res_cd_compobj,'') = '') then 'MAKER ENTERED'  ELSE '' END AS [STATUS1]
--					,case when citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(d.DEMRM_DPAM_ID,''))<> '' then citrus_usr.gettranstype(ISNULL(d1.DEMRM_TRANSACTION_NO,''),ISNULL(d1.demrm_dpam_id,''))
--						when ISNULL(d.DEMRM_TRANSACTION_NO,'') <> '' 
--						then 'RESPONSE FILE IMPORTED'
--						when ISNULL(d.DEMRM_BATCH_NO,'') <> '' 
--						then 'BATCH GENERATED' 
--						when d.demrm_deleted_ind = 1 
--						then 'CHECKER DONE' ELSE '' END AS [STATUS1]
					, d1.DEMRM_RMKS + '' + d1.demrm_res_desc_intobj + '' + d1.demrm_res_desc_compobj as auth_rmks
--	commented on 11032014				, case when d1.DEMRM_DELETED_IND = 1 then isnull(d1.DEMRM_LST_UPD_BY,'') end as checker1
--	commented on 11032014				, case when d1.DEMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),d1.DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),d1.DEMRM_LST_UPD_DT,109) END else '' end checker1_dt
    				, case when d1.DEMRM_DELETED_IND in(0,1) then isnull(d1.DEMRM_LST_UPD_BY,'') end as checker1
					, case when d1.DEMRM_DELETED_IND in (0,1) then CASE WHEN isnull(convert(varchar(11),d1.DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE d1.DEMRM_LST_UPD_DT END else '' end checker1_dt

					, '' as checker2
					, '' as checker2_dt
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(d.demrm_rmks,'') demrm_rmks
					, '' backoffice_code
					, '' reason	
					, '' recon_datetime
					, d.DEMRM_BATCH_NO
--,case when isnull(d1.demrm_internal_rej,'') <> '' then d1.demrm_lst_upd_dt 
--	 when isnull(d.demrm_company_obj,'') <> '' then d.demrm_lst_upd_dt 
--when isnull(d1.demrm_res_cd_intobj,'') <> '' then d1.demrm_lst_upd_dt 
--when isnull(d1.demrm_res_cd_compobj,'') <> '' then d1.demrm_lst_upd_dt 
--else ''  end RejectionDate --d1.demrm_lst_upd_dt 
,case when citrus_usr.gettranstype(ISNULL(d.demrm_transaction_no,''),ISNULL(convert(varchar,d.demrm_dpam_id),'0')) <> '' then
citrus_usr.gettranstype_date(ISNULL(d.demrm_transaction_no,''),ISNULL(convert(varchar,d.demrm_dpam_id),'0')) 
when isnull(d1.demrm_internal_rej,'') <> '' then convert(varchar(10),d1.demrm_lst_upd_dt ,103)
	 when isnull(d.demrm_company_obj,'') <> '' then convert(varchar(10),d.demrm_lst_upd_dt ,103)
when isnull(d1.demrm_res_cd_intobj,'') <> '' then convert(varchar(10),d1.demrm_lst_upd_dt ,103)
when isnull(d1.demrm_res_cd_compobj,'') <> '' then convert(varchar(10),d1.demrm_lst_upd_dt,103) 
else ''  end RejectionDate
					--, case when (isnull(d1.demrm_internal_rej,'') <> '' or isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_intobj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'' ) then  case when isnull(disp_cons_no,'') = '' then 'Original DRF yet to receive from RTA' else isnull(DISP_NAME,'') end else '' end courier
					, case when (isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'') then  case when isnull(disp_cons_no,'') = '' then 'Original DRF yet to receive from RTA' else isnull(DISP_NAME,'') end  else isnull(DISP_NAME,'') end courier
					, case when (isnull(d1.demrm_internal_rej,'') <> '' or isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_intobj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'' ) then  isnull(disp_cons_no,'') else isnull(disp_cons_no,'') end   podno
					, case when (isnull(d1.demrm_internal_rej,'') <> '' or isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_intobj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'' ) then  isnull(DISP_DT,'') else isnull(DISP_DT,'') end   dispdate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(d1.DEMRM_EXECUTION_DT,d1.DEMRM_ISIN,d1.DEMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(d1.DEMRM_EXECUTION_DT,d1.DEMRM_ISIN,d1.DEMRM_QTY),2,'|*~|') as Valuation
					from demrm_mak d1 with (nolock) left outer join demat_request_mstr d  with (nolock)  on d.demrm_id = d1.demrm_id 	
					and d.DEMRM_DPAM_ID = d1.DEMRM_DPAM_ID left outer join dmat_dispatch with (nolock) on  d1.demrm_id = disp_demrm_id and  (DISP_TO = 'C' or isnull(disp_cons_no,'') <>'') --isnull(DISP_TYPE,'') = case when (isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'') then 'N' else 'IR' end --<> 'IR' --DISP_TO = 'C' and
					where 
					d1.DEMRM_request_dt >= @pa_from_dt and d1.DEMRM_request_dt <= @pa_to_dt

					--and  d.demrm_deleted_ind = 1
					--and  d1.demrm_deleted_ind = 1
					AND d1.demrm_deleted_ind not in(2,4,6)
                    and  @pa_trastm_cd like  case when isnull(@pa_trastm_cd,'')= '' then  '1' else 'DMAT' end
					--AND d.DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					AND d1.DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end			
                  	--and d.DEMRM_TRANSACTION_NO like case when @pa_drnno = '' then '%' else @pa_drnno end  -- added on 19 jan 2015		 				
 
					union 
--					select Remrm_id inst_id
--					,TRNSNO = ISNULL(REMRM_TRANSACTION_NO,'')
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,'REMAT REQUEST'
--					,REMRM_SLIP_SERIAL_NO
--					,BATCHNO = ISNULL(REMRM_BATCH_NO,'')
--					,convert(numeric(18,3),Abs(REMRM_QTY))
--					,'N'
--					,mkr=Remrm_created_by
--					,mkr_dt = Remrm_created_dt
--					,remrm_lst_upd_by 
--					,''
--					,remrm_lst_upd_dt
--					,ORDBY=3
--					,Remrm_request_dt
--					,Remrm_dpam_id
--					,abs(Remrm_qty) qty
--					,Remrm_isin isin  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
--					,''
					select distinct convert(varchar(50),Remrm_id) inst_id
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
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account, '' counter_dpid 
					--,''
					,case when citrus_usr.gettranstype(ISNULL(REMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,REMRM_dpam_id),'0'))<> '' then citrus_usr.gettranstype(ISNULL(REMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,REMRM_dpam_id),'0'))
					when ISNULL(REMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL' +'-'    + isnull(citrus_usr.fn_get_errordesc(REMRM_ERRMSG),'')
					when ISNULL(REMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'  

					when ISNULL(REMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED' when remrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS [STATUS1]
					,REMRM_RMKS as auth_rmks
					, case when REMRM_DELETED_IND = 0 then isnull(REMRM_LST_UPD_BY,'') end as checker1
					, case when REMRM_DELETED_IND = 0 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE REMRM_LST_UPD_DT END else '' end checker1_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker1_dt
					, case when REMRM_DELETED_IND = 1 then isnull(REMRM_LST_UPD_BY,'') end as checker2
					, case when REMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE REMRM_LST_UPD_DT END else '' end checker2_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker2_dt	
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(remrm_rmks,'') remrm_rmks
					, '' backoffice_code
					, '' reason
					, '' recon_datetime
					, remrm_batch_no
, '' RejectionDate
					, '' courier
					, '' podno
					, '' dispdate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from remat_request_mstr with (nolock)
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
                    and @pa_trastm_cd like  case when isnull(@pa_trastm_cd,'')= '' then  '1' else 'RMAT' end
					AND REMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd

					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= isnull(eff_to,'DEc 31 2100')
					--ORDER BY 18,17			
					order by slipno,inst_id

			end

  --
  end 
--end
else
begin
print 'shilpa'

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
					FROM    dptd_mak dptd with (nolock)
                   , DP_TRX_DTLS dptd1 with (nolock) left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd1.DPTD_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd1.DPTD_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					,isin_mstr with (nolock)
					WHERE   dptd.dptd_id = dptd1.dptd_id 
					and dptd1.dptd_request_dt >= @pa_from_dt and dptd1.dptd_request_dt <= @pa_to_dt
					and     case when dptd1.dptd_trastm_cd = '912' and isnull(@pa_trastm_cd,'') <> '' then '906' else dptd1.dptd_trastm_cd  end like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					and case when @@subtype <> '' then dptd1.dptd_internal_trastm else '' end = @@subtype
					AND     dptd1.dptd_deleted_ind = 1 
					AND     dptd.dptd_deleted_ind in(0,1)
                    AND     dptd.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                    AND     dptd1.DPTD_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					union 
					select CONVERT(VARCHAR(50),demrm_id) + ' / ' + CONVERT(VARCHAR(50)	,ISNULL(demrm_transaction_no,''))  inst_id
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
					from demat_request_mstr with (nolock)
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
					from remat_request_mstr with (nolock)
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind =1
                    and @pa_trastm_cd = 'RMAT'
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptd_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptd_request_dt >=eff_from and dptd_request_dt <= eff_to
					ORDER BY 18,17



			end
			else
			begin
print 'dddddddddddddddddddd'

                    --Changed By Priya
--					SELECT   @l_dpm_id       DPID
--					,inst_id 
--					,TRNSNO
--					,REQUESTDATE 
--					,EXECUTIONDATE
--					,trans_descp       
--					,SLIPNO 
--					,BATCHNO
--					,dpam_sba_no                 ACCOUNTNO
--					,dpam_sba_name				 ACCOUNTNAME
--					,QUANTITY
--					,[DUAL CHECKER]
--					,mkr 
--					,mkr_dt 
--					,[CHECKER 1]	
--					,[CHECKER 2]	
--					,Last_chkr_dt 
--					,ORDBY
--					,dptdc_request_dt
--					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
--					,qty=CONVERT(NUMERIC(18,3),abs(QTY))
--					,isin_name
--					,isin
--                    ,mkt_type 
--                    ,other_mkt_type 
--                    ,[settlementno] 
--                    ,[othersettmno]
--                    ,[cmbp],counter_account
--					,[Status1]

			select	distinct inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,SLIPNO 
					,dpam_sba_no   ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,mkr 
					,convert(varchar(11),mkr_dt ,103)  + ' ' + convert(varchar(8),mkr_dt ,108)   mkr_dt 
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptdc_request_dt
					,Amt_charged = isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] ,counter_account,counter_dpid
					,[Status1]
					,ISNULL([auth_rmks],'') [auth_rmks]
					,ISNULL([checker1],'') [checker1]
					,case when convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) = '01/01/1900 00:00:00' then '' else  convert(varchar(11),ISNULL([checker1_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker1_dt],'') ,108) end    [checker1_dt]
					,ISNULL([checker2],'') [checker2]
					,case when convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) = '01/01/1900 00:00:00' then '' else    convert(varchar(11),ISNULL([checker2_dt],'') ,103)  + ' ' + convert(varchar(8),ISNULL([checker2_dt],'') ,108) end [checker2_dt]
					, slip_reco
					, image_scan
					, case when scan_dt='1900-01-01 00:00:00.000' then '' when scan_dt='1/1/1900' then '' else convert(varchar(11),scan_dt ,103)  + ' ' + convert(varchar(8),scan_dt ,108) end scan_dt
					, isnull(dptdc_rmks,'') dptdc_rmks
					, backoffice_code
					, reason
					--, isnull(recon_datetime,'') recon_datetime
					, case when scan_dt='1900-01-01 00:00:00.000' then '' when recon_datetime='1/1/1900' then '' else convert(varchar(11),recon_datetime ,103)  + ' ' + convert(varchar(8),recon_datetime ,108) end recon_datetime					
					, isnull(dptdc_batch_no,'') batchno
					, case when scan_dt='1900-01-01 00:00:00.000' then '' when recon_datetime='1/1/1900' then '' else convert(varchar(11),recon_datetime ,103)  + ' ' + convert(varchar(8),recon_datetime ,108) end recon_datetime					
					, isnull(dptdc_batch_no,'') batchno
					--,  case when convert(varchar(11),convert(datetime,RejectionDate),103)='01/01/1900' then '' else convert(varchar(11),convert(datetime,RejectionDate),103) end RejectionDate --RejectionDate
					,  RejectionDate
					,  courier
					,  podno -- ,dispdate
					,  case when dispdate='1900-01-01 00:00:00.000' then '' else convert(varchar(11),convert(datetime,dispdate),103) end dispdate
					
					,[Rate]
					,ABS([Valuation]) as [Valuation]

					from
					(
					 SELECT distinct convert(varchar(50),dptd.DPTDC_ID) inst_id 
					,convert(varchar(11),dptd.dptdc_request_dt,103)             REQUESTDATE 
					,convert(varchar(11),dptd.dptdc_execution_dt,103)           EXECUTIONDATE
					,REPLACE(Replace(Replace(Replace(Replace(Replace(Replace(dptd.DPTDC_INTERNAL_TRASTM,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'BOBO','OFF MARKET - BO TO BO'),'BOCM','OFF MARKET - BO TO CM'),'CMBO','OFF MARKET - CM TO BO') trans_descp     
					,dptd.dptdc_slip_no                SLIPNO 
					,convert(numeric(18,3),abs(dptd.dptdc_qty))               QUANTITY
					,case when dptd1.dptdc_deleted_ind = -1 then 'APPLICABLE DUAL CHECKER' 
						  When (dptd.dptdc_deleted_ind = 0 and isnull(dptd.dptdc_mid_chk,'') <> '' ) then isnull(dptd.dptdc_mid_chk,'') 
						  else 'NOT APPLICABLE' end [DUAL CHECKER]
					,mkr = dptd.dptdc_created_by
					,mkr_dt = CASE WHEN isnull(convert(varchar(11),dptd.dptdc_created_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptd.dptdc_created_dt END 
					,ORDBY=1
					,dptd.dptdc_ISIN ISIN
					,CASE WHEN isnull(convert(varchar(11),dptd.dptdc_request_dt,106),'') ='01 Jan 1900' THEN '' ELSE dptd.dptdc_request_dt END dptdc_request_dt
					,dptd.DPTDC_DPAM_ID DPAM_ID
                    , isnull(settm1.settm_Desc ,'') mkt_type , isnull(settm2.settm_Desc ,'') other_mkt_type , isnull(dptd.DPTDc_SETTLEMENT_NO,'') [settlementno] 
					, isnull(dptd.DPTDc_OTHER_SETTLEMENT_NO,'') [othersettmno], isnull(dptd.DPTDc_COUNTER_CMBP_ID,'') [cmbp]  , isnull(dptd.DPTDc_COUNTER_DEMAT_ACCT_NO,'') counter_account , isnull(dptd.DPTDC_COUNTER_DP_ID,'') counter_dpid
--					, case when dptdc_deleted_ind = -1 then 'V' 
--						   When dptdc_deleted_ind = 0 then 'A'
--						   When dptdc_deleted_ind = 1 then 'U'
--					  else 'D' end as [Status1]
					, 
--case when isnull(dptd1.dptdc_errmsg,'') <> '' then dptd1.dptdc_errmsg else 
case when citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(convert(varchar,dptd1.dptdc_dpam_id),'0'))<> '' then citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(convert(varchar,dptd1.dptdc_dpam_id),'0'))
when ISNULL(dptd1.dptdc_trans_no,'') = '0' then 'REJECTED FROM CDSL' + ' - '  + upper(isnull(citrus_usr.fn_get_errordesc(dptd1.DPTDC_ERRMSG),''))
						when ISNULL(dptd1.dptdc_trans_no,'') <> '' then 'RESPONSE FILE IMPORTED'

						when ISNULL(dptd1.dptdc_batch_no,'') <> '' then 'BATCH GENERATED' 
						--when dptd1.dptdc_deleted_ind = 1 then 'CHECKER DONE' 
						when dptd.dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') <> '' then 'REJECTED'
						when dptd.dptdc_deleted_ind = -1 and isnull(dptdc_res_cd,'') = '' then 'MAKER ENTERED (INSTRUCTION WITH HIGH VALUE OR DORMANT)'
                        when dptd.dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')='' then 'MAKER ENTERED (INSTRUCTION WITHOUT HIGH VALUE OR DORMANT)' 
						when dptd.dptdc_deleted_ind = 0 and isnull(dptdc_res_cd,'') = '' and isnull(dptdc_mid_chk,'')<>'' then '1ST CHECKER DONE' 
						when dptd1.dptdc_deleted_ind = 1 then 'CHECKER DONE'
						ELSE '' END   
--end
AS [STATUS1] 
                    , dptd.dptdc_rmks + '' + dptd.dptdc_res_desc as auth_rmks
					--, case when dptd.dptdc_deleted_ind = 0 then isnull(dptd.DPTDC_LST_UPD_BY,'') end as checker1
					, case when dptd.dptdc_mid_chk <> '' then dptd.dptdc_mid_chk else isnull(dptd.DPTDC_LST_UPD_BY,'') end as checker1
					, case when dptd.dptdc_deleted_ind in (0,1) and isnull(dptd.dptdc_mid_chk,'') <> '' then CASE WHEN isnull(convert(varchar(11),dptd1.DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE dptd1.DPTDC_LST_UPD_dt END 
						   when dptd.dptdc_deleted_ind in (0,1) and isnull(dptd.dptdc_mid_chk,'') = '' then CASE WHEN isnull(convert(varchar(11),dptd.DPTDC_LST_UPD_dt,109),'') ='jan 01 1900' THEN '' ELSE dptd.DPTDC_LST_UPD_dt END else '' end checker1_dt
--convert(varchar(11),dptd.DPTDC_LST_UPD_dt,103) else '' end as checker1_dt
					, case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then isnull(dptd.DPTDC_LST_UPD_BY,'') else '' end as checker2
					, case when dptd.dptdc_deleted_ind = 1 and isnull(dptd.dptdc_mid_chk,'') <> '' then CASE WHEN isnull(convert(varchar(11),dptd.DPTDC_LST_UPD_dt,106),'') ='jan 01 1900' THEN '' ELSE dptd.DPTDC_LST_UPD_dt END else '' end checker2_dt										
					, case when recon_flag ='Y' then 'YES' else 'NO' end  slip_reco
					, case when isnull(client_id,'')='' then 'NO' else 'YES' end image_scan
					--, case when isnull(convert(varchar(11),created_dt,106),'') = '01 Jan 1900' then '' else created_dt end  as scan_dt
					, case when isnull(convert(varchar(11),lst_upd_dt,106),'') = '01 Jan 1900' then '' else lst_upd_dt end  as scan_dt
					, isnull(dptd1.dptdc_rmks,'') dptdc_rmks
					, ISNULL(CITRUS_USR.FN_UCC_ACCP(dptd.DPTDC_DPAM_ID,'BBO_CODE',''),'') backoffice_code
--					, case  when dptd.dptdc_reason_cd= '1' then 'Gift' 
--						    when dptd.dptdc_reason_cd= '2' then 'For offmkt sale/pur' 
--						    when dptd.dptdc_reason_cd= '3' then 'For onmkt sale/pur' 
--							when dptd.dptdc_reason_cd= '4' then 'Trnsfr of a/c from dp to dp' 
--							when dptd.dptdc_reason_cd= '5' then 'Trnsfr between 2 a/c of same hldr' 
--							when dptd.dptdc_reason_cd= '6' then 'Others' 
--							when dptd.dptdc_reason_cd= '7' then 'Trnsfr between family members'
--							when dptd.dptdc_reason_cd= '10' then 'Implementation of Government / Regulatory directions or orders'
--when dptd.dptdc_reason_cd= '11' then 'Erroneous transfers pertaining to client’s securities'
--when dptd.dptdc_reason_cd= '12' then 'Meeting legitimate dues of the stock broker'
--when dptd.dptdc_reason_cd= '13' then 'For Open Offer / Buy-Back'
--when dptd.dptdc_reason_cd= '14' then 'For Margin Purpose'
-- else '' end reason
, case  when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Gift' 
when dptd.dptdc_reason_cd= '2'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For offmkt sale/pur' 
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '4' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr of a/c from dp to dp' 
when dptd.dptdc_reason_cd= '5'and dptd.dptdc_Request_dt < 'Aug 04 2019'  then 'Trnsfr between 2 a/c of same hldr' 
when dptd.dptdc_reason_cd= '6'  and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Others' 
when dptd.dptdc_reason_cd= '7' and dptd.dptdc_Request_dt < 'Aug 04 2019' then 'Trnsfr between family members'
when dptd.dptdc_reason_cd= '1' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Gift'
when dptd.dptdc_reason_cd= '2' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For offmkt sale/pur'
when dptd.dptdc_reason_cd= '5' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to own account(s)'
when dptd.dptdc_reason_cd= '10' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Implementation of Government / Regulatory directions or orders'
when dptd.dptdc_reason_cd= '11' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Erroneous transfers pertaining to clients securities'
when dptd.dptdc_reason_cd= '12' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Meeting legitimate dues of the stock broker'
when dptd.dptdc_reason_cd= '13' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Open Offer for Acquisition'
when dptd.dptdc_reason_cd= '14' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin to stock broker/ PCM'
when dptd.dptdc_reason_cd= '15' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Refund of securities by IEPF Authority Existing'
when dptd.dptdc_reason_cd= '16' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Donation'
when dptd.dptdc_reason_cd= '17' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For Buy-Back'
when dptd.dptdc_reason_cd= '18' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Margin returned by stock broker/ PCM '
when dptd.dptdc_reason_cd= '19' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'ESOP/Transfer to employee'
when dptd.dptdc_reason_cd= '20' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Payout - On payments for unpaid securities'
when dptd.dptdc_reason_cd= '21' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer to PMS Account'
when dptd.dptdc_reason_cd= '22' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer from PMS Account'
when dptd.dptdc_reason_cd= '23' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'On Market IDT transfer'
when dptd.dptdc_reason_cd= '24' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Redemption of Mutual Fund units'
when dptd.dptdc_reason_cd= '25' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Conversion of Depository Receipt (DR) to underlying Securities and vice versa'
when dptd.dptdc_reason_cd= '26' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transposition'
when dptd.dptdc_reason_cd= '27' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Merger/Demerger of Corporate entity'
when dptd.dptdc_reason_cd= '28' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Dissolution/ Restructuring/Winding up of Partnership firm/Trust'
when dptd.dptdc_reason_cd= '29' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Trust to Beneficiaries/On HUF dissolution to Karta & Coparceners'
when dptd.dptdc_reason_cd= '30' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Minor Account and Guardian Account'
when dptd.dptdc_reason_cd= '31' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members'
when dptd.dptdc_reason_cd= '32' and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between Partner and Firm or Director and Company'
when dptd.dptdc_reason_cd= '3'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'For onmkt sale/pur' 
when dptd.dptdc_reason_cd= '34'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Certificate of Deposit Redemption' 
when dptd.dptdc_reason_cd= '311'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-1(Spouse)' 
when dptd.dptdc_reason_cd= '312'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-2(Father(including step-father))' 
when dptd.dptdc_reason_cd= '313'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-3(Mother(including step-mother))' 
when dptd.dptdc_reason_cd= '314'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-4(Son(including step-son))' 
when dptd.dptdc_reason_cd= '315'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-5(Sons wife)' 
when dptd.dptdc_reason_cd= '316'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-6(Daughter)' 
when dptd.dptdc_reason_cd= '317'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-7(Daughters husband)' 
when dptd.dptdc_reason_cd= '318'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-8(Brother(including step-brother))' 
when dptd.dptdc_reason_cd= '319'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-9(Sister(including step-sister))' 
when dptd.dptdc_reason_cd= '3110'  and dptd.dptdc_Request_dt >= 'Aug 04 2019' then 'Transfer between specified family members-10(Members of same HUF)'
 else '' end reason 
      
					,recon_datetime as recon_datetime
					,dptd1.dptdc_batch_no
, '' RejectionDate
					, '' courier
					, '' podno
					, '' dispdate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(dptd.dptdc_execution_dt,dptd.DPTDc_ISIN,dptd.DPTDc_QTY),2,'|*~|') as Valuation

					FROM    dptdc_mak dptd  with (nolock) left outer join maker_scancopy  with (nolock) on DPTDC_SLIP_NO = slip_no and deleted_ind =1
                    left outer join DP_TRX_DTLS_CDSL dptd1 with (nolock) on dptd.dptdc_id = dptd1.dptdc_id 
                    left outer join settlement_type_mstr settm1 with (nolock) on convert(varchar,settm1.settm_id) = dptd1.DPTDC_MKT_TYPE and isnull(settm1.settm_deleted_ind,1) = 1 
                    left outer join settlement_type_mstr settm2 with (nolock) on convert(varchar,settm2.settm_id) = dptd1.DPTDC_OTHER_SETTLEMENT_TYPE and isnull(settm2.settm_deleted_ind,1) = 1 
					--left outer join cdsl_holding_dtls on cdshm_dpam_id = dptdc_dpam_id and cdshm_trans_no = dptd1.dptdc_trans_no
					WHERE   --dptd.dptdc_id = dptd1.dptdc_id 
					 --dptd.dptdc_request_dt >= @pa_from_dt and dptd.dptdc_request_dt <= @pa_to_dt
					--and dptd1.dptdc_trastm_cd   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					 case when dptd.dptdc_trastm_cd='CMBO' then 'BOCM' else dptd.dptdc_trastm_cd end   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					--AND dptd1.dptdc_deleted_ind = 1 
					AND dptd.dptdc_deleted_ind in(0,1,-1)
					--and dptd.dptdc_res_desc <> case when dptd.dptdc_deleted_ind = 0 then '' else '%' end
					and case when (dptd.dptdc_deleted_ind = 0 and isnull(dptd.dptdc_res_desc,'')<>'') then dptd.dptdc_res_desc else '1'  end --commented on 12082013
						<> case when (dptd.dptdc_deleted_ind = 0 and isnull(dptd.dptdc_res_desc,'')<>'') then '' else '0' end   --commented on 12082013
                    AND dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                    --AND dptd1.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
                  
                    --End
					union  
--					select demrm_id inst_id
--					,TRNSNO = ISNULL(DEMRM_TRANSACTION_NO,'')
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,CONVERT(VARCHAR(11),demrm_request_dt,103)
--					,'DEMAT REQUEST'
--					,DEMRM_SLIP_SERIAL_NO
--					,BATCHNO = ISNULL(DEMRM_BATCH_NO,'')
--					,convert(numeric(18,3),Abs(DEMRM_QTY))
--					,'N'
--					,mkr=demrm_created_by
--					,mkr_dt = demrm_created_dt
--					,demrm_lst_upd_by 
--					,''
--					,demrm_lst_upd_dt
--					,ORDBY=2
--					,demrm_request_dt
--					,demrm_dpam_id
--					,abs(demrm_qty) qty
--					,demrm_isin isin , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
--					,''
					select distinct CONVERT(VARCHAR(50),d1.demrm_id) + '/' + CONVERT(VARCHAR(50),ISNULL(demrm_transaction_no,''))  inst_id
					,convert(varchar(11),d1.demrm_request_dt,103)
					,convert(varchar(11),d1.demrm_request_dt,103)
					,'DEMAT REQUEST'
					,d1.DEMRM_SLIP_SERIAL_NO
					,convert(numeric(18,3),abs(d1.DEMRM_QTY))
					,''
					,mkr=d1.demrm_created_by
					,mkr_dt = d1.demrm_created_dt
					,ORDBY=2
					,d1.DEMRM_ISIN
					,d1.demrm_request_dt
					,d1.DEMRM_DPAM_ID
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp], isnull('','') counter_account ,'' counter_dpid
					--,''
					,case when citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,d.DEMRM_dpam_id),'0'))<> '' then citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,d.DEMRM_dpam_id),'0'))

when ISNULL(d.DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL' +'-'    + isnull(citrus_usr.fn_get_errordesc(d.DEMRM_ERRMSG),'')
					when ISNULL(d.DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'  

					when ISNULL(d.DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED' when d.demrm_deleted_ind = 1 then 'CHECKER DONE' 
					when d1.demrm_deleted_ind = 0 and (isnull(d1.demrm_res_cd_intobj,'') <> '' or isnull(d1.demrm_res_cd_compobj,'')<>'') then 'REJECTED' 
					when d1.demrm_deleted_ind = 0 and (isnull(d1.demrm_res_cd_intobj,'') = '' or isnull(d1.demrm_res_cd_compobj,'') = '') then 'MAKER ENTERED'  ELSE '' END AS [STATUS1]
--					,case when citrus_usr.gettranstype(ISNULL(d.DEMRM_TRANSACTION_NO,''),ISNULL(d.DEMRM_DPAM_ID,''))<> '' then citrus_usr.gettranstype(ISNULL(d1.DEMRM_TRANSACTION_NO,''),ISNULL(d1.demrm_dpam_id,''))
--						when ISNULL(d.DEMRM_TRANSACTION_NO,'') <> '' 
--						then 'RESPONSE FILE IMPORTED'
--						when ISNULL(d.DEMRM_BATCH_NO,'') <> '' 
--						then 'BATCH GENERATED' 
--						when d.demrm_deleted_ind = 1 
--						then 'CHECKER DONE' ELSE '' END AS [STATUS1]
					, d1.DEMRM_RMKS + '' + d1.demrm_res_desc_intobj + '' + d1.demrm_res_desc_compobj as auth_rmks
--		commented on 11/03/2014			, case when d1.DEMRM_DELETED_IND = 1 then isnull(d1.DEMRM_LST_UPD_BY,'') end as checker1
--		commented on 11/03/2014			, case when d1.DEMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),d1.DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE convert(varchar(24),d1.DEMRM_LST_UPD_DT,109) END else '' end checker1_dt
, case when d1.DEMRM_DELETED_IND in(0,1) then isnull(d1.DEMRM_LST_UPD_BY,'') end as checker1
					, case when d1.DEMRM_DELETED_IND in (0,1) then CASE WHEN isnull(convert(varchar(11),d1.DEMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE d1.DEMRM_LST_UPD_DT END else '' end checker1_dt

					, '' as checker2
					, '' as checker2_dt
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(d.demrm_rmks,'') demrm_rmks
					, '' backoffice_code
					, '' reason	
					, '' recon_datetime
					, d.DEMRM_BATCH_NO
--,case when isnull(d1.demrm_internal_rej,'') <> '' then d1.demrm_lst_upd_dt 
--	  when isnull(d.demrm_company_obj,'') <> '' then d.demrm_lst_upd_dt 
--	  when isnull(d1.demrm_res_cd_intobj,'') <> '' then d1.demrm_lst_upd_dt 
--	  when isnull(d1.demrm_res_cd_compobj,'') <> '' then d1.demrm_lst_upd_dt 
--	  else ''  end RejectionDate --d1.demrm_lst_upd_dt 
--,case when citrus_usr.gettranstype(ISNULL(d.demrm_transaction_no,''),ISNULL(convert(varchar,d.demrm_dpam_id),'0')) <> '' then
,case when citrus_usr.gettranstype(ISNULL(d.demrm_transaction_no,''),ISNULL(convert(varchar,d.demrm_dpam_id),'0')) like '%reject%' then
citrus_usr.gettranstype_date(ISNULL(d.demrm_transaction_no,''),ISNULL(convert(varchar,d.demrm_dpam_id),'0')) 
when isnull(d1.demrm_internal_rej,'') <> '' then convert(varchar(10),d1.demrm_lst_upd_dt ,103)
	 when isnull(d.demrm_company_obj,'') <> '' then convert(varchar(10),d.demrm_lst_upd_dt ,103)
when isnull(d1.demrm_res_cd_intobj,'') <> '' then convert(varchar(10),d1.demrm_lst_upd_dt ,103)
when isnull(d1.demrm_res_cd_compobj,'') <> '' then convert(varchar(10),d1.demrm_lst_upd_dt,103) 
else ''  end RejectionDate
					--, case when (isnull(d1.demrm_internal_rej,'') <> '' or isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_intobj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'' ) then  case when isnull(disp_cons_no,'') = '' then 'Original DRF yet to receive from RTA' else isnull(DISP_NAME,'') end else '' end courier
					, case when (isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'') then  case when isnull(disp_cons_no,'') = '' then 'Original DRF yet to receive from RTA' else isnull(DISP_NAME,'') end else isnull(DISP_NAME,'') end courier
					, case when (isnull(d1.demrm_internal_rej,'') <> '' or isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_intobj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'' ) then  isnull(disp_cons_no,'') else isnull(disp_cons_no,'') end   podno
					, case when (isnull(d1.demrm_internal_rej,'') <> '' or isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_intobj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'' ) then  isnull(DISP_DT,'') else isnull(DISP_DT,'') end   dispdate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(D1.DEMRM_EXECUTION_DT,D1.DEMRM_ISIN,D1.DEMRM_QTY),1,'|*~|') as Rate
, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(D1.DEMRM_EXECUTION_DT,D1.DEMRM_ISIN,D1.DEMRM_QTY),2,'|*~|') as Valuation	

					
					from  demrm_mak d1 with (nolock) left outer join demat_request_mstr d  with (nolock) on d.demrm_id = d1.demrm_id 	
and d.DEMRM_DPAM_ID = d1.DEMRM_DPAM_ID left outer join dmat_dispatch with (nolock) on  (DISP_TO = 'C' or isnull(disp_cons_no,'') <>'')--isnull(DISP_TYPE,'') = case when (isnull(d.demrm_company_obj,'')<>'' or isnull(d1.demrm_res_cd_compobj,'')<>'') then 'N' else 'IR' end --and DISP_TO = 'C' 
and d1.demrm_id = disp_demrm_id
					where 
					--d1.DEMRM_request_dt >= @pa_from_dt and d1.DEMRM_request_dt <= @pa_to_dt
					--and  d.demrm_deleted_ind = 1
					  d1.demrm_deleted_ind in(0,1,-1)
--					and (d1.demrm_res_desc_intobj <> case when d1.demrm_deleted_ind = 0 then '' end or 
--						 d1.demrm_res_desc_compobj <> case when d1.demrm_deleted_ind = 0 then '' end )
					and (case when d1.demrm_deleted_ind = 0 AND ISNULL(d1.demrm_res_desc_intobj,'')<> '' then d1.demrm_res_desc_intobj else '1'  end 
						<> case when d1.demrm_deleted_ind = 0 then '' else '0' end
					or case when d1.demrm_deleted_ind = 0 AND ISNULL(d1.demrm_res_desc_compobj,'')<>'' then d1.demrm_res_desc_compobj else '1'  end 
						<> case when d1.demrm_deleted_ind = 0 then '' else '0' end)
                     and @pa_trastm_cd like  case when isnull(@pa_trastm_cd,'')= '' then  '1' else 'DMAT' end
					--AND d.DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					AND d1.DEMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end			
                  					
 
					union 
--					select Remrm_id inst_id
--					,TRNSNO = ISNULL(REMRM_TRANSACTION_NO,'')
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,CONVERT(VARCHAR(11),Remrm_request_dt,103)
--					,'REMAT REQUEST'
--					,REMRM_SLIP_SERIAL_NO
--					,BATCHNO = ISNULL(REMRM_BATCH_NO,'')
--					,convert(numeric(18,3),Abs(REMRM_QTY))
--					,'N'
--					,mkr=Remrm_created_by
--					,mkr_dt = Remrm_created_dt
--					,remrm_lst_upd_by 
--					,''
--					,remrm_lst_upd_dt
--					,ORDBY=3
--					,Remrm_request_dt
--					,Remrm_dpam_id
--					,abs(Remrm_qty) qty
--					,Remrm_isin isin  , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp],  isnull('','') counter_account
--					,''
					select distinct convert(varchar(50),Remrm_id) inst_id
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
                    , isnull('' ,'') mkt_type , isnull('' ,'') other_mkt_type , isnull('','') [settlementno] , isnull('','') [othersettmno], isnull('','') [cmbp] , isnull('','') counter_account, '' counter_dpid 
					--,''
					,case when citrus_usr.gettranstype(ISNULL(REMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,REMRM_dpam_id),'0'))<> '' then citrus_usr.gettranstype(ISNULL(REMRM_TRANSACTION_NO,''),ISNULL(convert(varchar,REMRM_dpam_id),'0'))

when ISNULL(REMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL' +'-'    + isnull(citrus_usr.fn_get_errordesc(REMRM_ERRMSG),'')
					when ISNULL(REMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'  

					when ISNULL(REMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED' when remrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS [STATUS1]
					,REMRM_RMKS as auth_rmks
					, case when REMRM_DELETED_IND = 0 then isnull(REMRM_LST_UPD_BY,'') end as checker1
					, case when REMRM_DELETED_IND = 0 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE REMRM_LST_UPD_DT END else '' end checker1_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker1_dt
					, case when REMRM_DELETED_IND = 1 then isnull(REMRM_LST_UPD_BY,'') end as checker2
					, case when REMRM_DELETED_IND = 1 then CASE WHEN isnull(convert(varchar(11),REMRM_LST_UPD_DT,109),'') ='jan 01 1900' THEN '' ELSE REMRM_LST_UPD_DT END else '' end checker2_dt
--isnull(convert(varchar(11),REMRM_LST_UPD_DT,103),'') end as checker2_dt	
					, '' slip_reco
					, '' image_scan
					, '' scan_dt
					, isnull(remrm_rmks,'') remrm_rmks
					, '' backoffice_code
					, '' reason
					, '' recon_datetime
					, remrm_batch_no
, '' RejectionDate
					, '' courier
					, '' podno
					, '' dispdate
					
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),1,'|*~|') as Rate
					, citrus_usr.FN_SPLITVAL_BY(citrus_usr.fn_find_ISIN_rate_valuation(REMRM_EXECUTION_DT,REMRM_ISIN,REMRM_QTY),2,'|*~|') as Valuation
					from remat_request_mstr with (nolock)
					where REMRM_request_dt >= @pa_from_dt and REMRM_request_dt <= @pa_to_dt
					and  Remrm_deleted_ind in (0,1,-1)
                    and @pa_trastm_cd like  case when isnull(@pa_trastm_cd,'')= '' then  '1' else 'RMAT' end
					AND REMRM_SLIP_SERIAL_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					) tmpview left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= isnull(eff_to,'DEc 31 2100')
					--ORDER BY 18,17			
					order by slipno,inst_id

			end

  --
end
   --
  end 
end

GO
