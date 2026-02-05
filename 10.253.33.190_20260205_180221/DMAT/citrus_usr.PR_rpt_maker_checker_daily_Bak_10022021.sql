-- Object: PROCEDURE citrus_usr.PR_rpt_maker_checker_daily_Bak_10022021
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create   PROC [citrus_usr].[PR_rpt_maker_checker_daily_Bak_10022021](@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    
)          
AS          
BEGIN  

--exec [PR_rpt_maker_checker_daily] 'Apr 29 2020', 'Apr 29 2020', 'ho'
declare @pa_slip_no varchar (50)

select dptdc_dpam_id id into #tempid from (select dptdc_dpam_id from dptdc_mak with (nolock) where dptdc_dpam_id is not null
 and dptdc_request_dt >= case when convert(varchar(11),@pa_from_dt,109) = 'Jan  1 1900' then 'Jan  1 1900' else @pa_from_dt+' 00:00:00' end  
 and dptdc_request_dt <= case when convert(varchar(11),@pa_to_dt,109) = 'Jan  1 1900' then 'Jan  1 2100' else @pa_to_dt+' 23:59:59' end
											
											) a 
--select * from #tempid where id =1508143
--return 
create clustered index ix_1 on #tempid(id)

CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
INSERT INTO #ACLIST 
SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,isnull(EFF_TO,'DEC 31 2100') 
FROM citrus_usr.fn_acct_list(3 ,1,0) 
where  exists(select 1 from #tempid with (nolock) where id = dpam_id )

create clustered index ix_1 on #ACLIST(dpam_id )


SELECT MAX(CDSHM_CDAS_SUB_TRAS_TYPE) SUBTYPECDAS,DPTDC_SLIP_NO 
INTO #TMPOTP
 FROM DP_TRX_DTLS_CDSL,CDSL_HOLDING_DTLS WHERE 
DPTDC_SLIP_NO like @pa_slip_no + '%'  AND 
DPTDC_DPAM_ID=CDSHM_DPAM_ID AND DPTDC_ISIN=CDSHM_ISIN
AND DPTDC_TRANS_NO=CDSHM_TRANS_NO
AND DPTDC_QTY=CDSHM_QTY
AND ISNULL(DPTDC_BATCH_NO,'0')<>'0'
AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('542','543','544','545','546','328','329','330','331','332') 
AND CDSHM_TRAS_DT>='OCT 31 2020'
AND DPTDC_INTERNAL_TRASTM IN ('BOBO','ID')
GROUP BY DPTDC_SLIP_NO

Create table #BALANCES(
		dpam_id bigint,
		outstand_amt numeric(18,2)
		)
		
declare @@finId varchar (3), 
@@ssql varchar(8000)

		select @@finId = isnull(fin_id,0) from financial_yr_mstr where  FIN_DPM_ID   = '3' AND @PA_TO_DT between fin_start_dt and fin_end_dt and fin_deleted_ind = 1
		set @@ssql ='insert into #BALANCES(dpam_id,outstand_amt)
		select LDG_ACCOUNT_ID,sum(isnull(ldg_amount,0)) * -1
		from Ledger' + convert(varchar,@@finId) + ' with (nolock) where ldg_account_type = ''P'' and ldg_voucher_dt < ''' + convert(varchar(11),@pa_to_dt,109) + ''' and ldg_deleted_ind = 1
		group by LDG_ACCOUNT_ID'
		exec(@@ssql)

			select	distinct inst_id 
					,REQUESTDATE 
					,EXECUTIONDATE
					,trans_descp     
					,''''+SLIPNO 
					,''''+dpam_sba_no   ACCOUNTNO
					,dpam_sba_name ACCOUNTNAME
					,QUANTITY
					,[DUAL CHECKER]
					,''''+mkr  mkr
					,convert(varchar(11),mkr_dt ,103)  + ' ' + convert(varchar(8),mkr_dt ,108)   mkr_dt 
					,ORDBY
					,ISIN_NAME
					,ISIN
					,dptdc_request_dt
					,'0' Amt_charged --= isnull(inwsr_ufcharge_collected,0),outstand_amt=isnull(outstand_amt,0)
                    ,mkt_type 
                    ,other_mkt_type 
                    ,[settlementno] 
                    ,[othersettmno]
                    ,[cmbp] 
                    ,''''+counter_account counter_account
                    ,counter_dpid
					,[Status1]
					,ISNULL([auth_rmks],'') [auth_rmks]
					,''''+ISNULL([checker1],'') [checker1]
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
					,--case when exists (select 1 from #TMPOTP  OTP where otp.DPTDC_SLIP_NO=DPTDC_SLIP_NO and SUBTYPECDAS='545') then 'NON AUTHENTICATED OTP TRANSACTION CANCELLED'
case when exists (select 1 from #TMPOTP  OTP where otp.DPTDC_SLIP_NO=DPTDC_SLIP_NO and SUBTYPECDAS IN ('543','330')) then 'REJECTED OTP AUTHENTICATED TRANSACTION'

--when exists (select 1 from #TMPOTP  OTP where otp.DPTDC_SLIP_NO=DPTDC_SLIP_NO and SUBTYPECDAS IN ('328','542')) then 'PENDING OTP AUTHENTICATED TRANSACTION'
when exists (select 1 from #TMPOTP  OTP where otp.DPTDC_SLIP_NO=DPTDC_SLIP_NO and SUBTYPECDAS='332') then 'PENDING OTP AUTHENTICATION TRANSACTION CANCELLED IN EOD'
 
					 when citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(convert(varchar,dptd1.dptdc_dpam_id),'0'))<> '' then citrus_usr.gettranstype(ISNULL(dptd1.dptdc_trans_no,''),ISNULL(convert(varchar,dptd1.dptdc_dpam_id),'0'))
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
					 dptd.dptdc_request_dt >= @pa_from_dt+' 00:00:00' and dptd.dptdc_request_dt <= @pa_to_dt+' 23:59:59'
					-- dptd.dptdc_request_dt >= @pa_from_dt+' 00:00:00.000' and dptd.dptdc_request_dt <= @pa_to_dt+' 23:21:00.000'
					--and dptd1.dptdc_trastm_cd   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					--and case when dptd.dptdc_trastm_cd='CMBO' then 'BOCM' else dptd.dptdc_trastm_cd end   like case when isnull(@pa_trastm_cd,'')= '' then  '%' else   @pa_trastm_cd end
					--AND dptd1.dptdc_deleted_ind = 1 
					--AND dptd.dptdc_deleted_ind in(0,1)
                    --AND dptd.DPTDC_SLIP_NO like case when @pa_slip_no = '' then '%' else @pa_slip_no end
					AND dptd.dptdc_deleted_ind not in(2,4,6)
					)
					tmpview --left outer join INWARD_SLIP_REG on tmpview.dpam_id = INWSR_DPAM_ID and tmpview.SLIPNO = INWSR_SLIP_NO and tmpview.dptdc_request_dt = INWSR_RECD_DT
					,#ACLIST a left outer join #BALANCES b on a.dpam_id = b.dpam_id
					,isin_mstr
					where tmpview.dpam_id = a.dpam_id
					and tmpview.isin = isin_cd
					--and dptdc_request_dt >=eff_from and dptdc_request_dt <= isnull(eff_to,'DEc 31 2100')
					--ORDER BY 18,17			
					order by ''''+SLIPNO ,inst_id
					
					end

GO
