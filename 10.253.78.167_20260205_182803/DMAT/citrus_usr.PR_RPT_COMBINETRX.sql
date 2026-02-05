-- Object: PROCEDURE citrus_usr.PR_RPT_COMBINETRX
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*

PR_RPT_COMBINETRX	3,'Jul  1 2009','Jul 30 2009','','',3,1,'BASIS POINT|*~|',''		

PR_RPT_COMBINETRX	3,'Jul  1 2009','Jul 30 2009','','',345,1,'BASIS POINT|*~|',''	
PR_RPT_COMBINETRX	3,'Jul  1 2009','Jul 30 2009','','',5,1,'BASIS POINT|*~|',''		
	


*/

CREATE PROCEDURE [citrus_usr].[PR_RPT_COMBINETRX]
(
@PA_EXCSMID bigint,
@PA_FROMDT datetime,
@PA_TODT datetime,
@pa_fromaccid varchar(16),
@pa_toaccid varchar(16),
@pa_trans_type int, --0 --ALL,1 - Interdep, 2 - offmarket, 345 - payin,6 - demat, 7 - remat
@pa_login_pr_entm_id bigint,
@pa_login_entm_cd_chain varchar(1000),
@PA_OUT VARCHAR(8000) OUT
)
AS
BEGIN
set nocount on    
set transaction isolation level read uncommitted  
set @PA_TODT  = Convert(Datetime,Convert(Varchar(11),@PA_TODT,109) + ' 23:59:59')        

IF @pa_fromaccid = ''                    
BEGIN                    
	SET @pa_fromaccid = '0'                    
	SET @pa_toaccid = '99999999999999999'                    
END                    
IF @pa_toaccid = ''                    
BEGIN                
	SET @pa_toaccid = @pa_fromaccid                    
END                    


declare @@dpmid bigint,
@@l_child_entm_id bigint

select @@dpmid= dpm_id from dp_mstr where default_dp = @PA_EXCSMID and dpm_deleted_ind =1              
select @@l_child_entm_id =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                      
CREATE TABLE #ACLIST(dpam_crn_no BIGINT,dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
INSERT INTO #ACLIST(dpam_crn_no,dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to) SELECT dpam_crn_no, DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		


-- trn_type = 1 - Interdep, 2 - offmarket, 3 - Early payin, 4 - normal payin , 5 - Autopayin ,6 - demat, 7 - remat

Create table #tmpreport(trn_type int,dpam_id bigint,isin_cd varchar(12),isin_name varchar(200),trn_no varchar(20),ctr_client_id varchar(200),Qty numeric(18,3),slip_no varchar(20),Buy_Sell varchar(3),int_ref_no varchar(20),trn_dt datetime,trn_exec_dt datetime,sett_dtls varchar(40),trn_status varchar(100),Error_msg varchar(200))

if (@pa_trans_type = 0 or @pa_trans_type = 1)
begin


	insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,ctr_client_id,Qty,Buy_Sell,int_ref_no,trn_dt,trn_exec_dt,sett_dtls,trn_status,Error_msg)
	SELECT 1,IDS_DPAM_ID,IDS_ISIN_ALPHA,IDS_ISIN_SHORT_NM,IDS_SENDER_TRX_REFNO,ctr_client_id = CASE WHEN LTRIM(RTRIM(ISNULL(IDS_NSDL_CLTID,''))) = '' THEN  LTRIM(RTRIM(IDS_NSDL_CMBP_DPID)) ELSE LTRIM(RTRIM(IDS_NSDL_CMBP_DPID)) + LTRIM(RTRIM(IDS_NSDL_CLTID)) END 
	,IDS_QTY,LEFT(LTRIM(RTRIM(IDS_BS_FLG)),1),IDS_INT_REF_NO,IDS_TRX_DT,IDS_EXEC_DT,IDS_NSDL_SETT_ID,ISNULL(S.DESCP,IDS_TRX_STAT_CD),IDS_ERR_DESC1
	FROM INTERDP_STATUS_MSTR LEFT OUTER JOIN [citrus_usr].[FN_GETSUBTRANSDTLS]('RES_STAT_CD_CDSL') S ON IDS_TRX_STAT_CD=CD
	WHERE IDS_TRX_DT BETWEEN @PA_FROMDT AND  @PA_TODT AND ids_BS_FLG = 'SELL' AND IDS_DPM_ID = @@dpmid

    UPDATE t SET slip_no = DPTDC_SLIP_NO
	FROM #tmpreport t, dp_trx_dtls_cdsl
	where trn_no = DPTDC_TRANS_NO
	and dpam_id = dptdc_dpam_id 
	and dptdc_internal_trastm = 'ID'
	and dptdc_deleted_ind = 1

end
 


if (@pa_trans_type = 0 or @pa_trans_type = 2)
begin
	insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,ctr_client_id,Qty,Buy_Sell,int_ref_no,trn_dt,trn_exec_dt,sett_dtls,trn_status,Error_msg)
	SELECT 2,OFFSM_DPAM_ID,OFFSM_ISIN,OFFSM_ISIN_NM,OFFSM_SELLER_TXNID,OFFSM_CTR_BO_ID
	,OFFSM_QTY,LEFT(LTRIM(RTRIM(OFFSM_BS_FLG)),1),OFFSM_SELLER_INT_REFNO,OFFSM_TXN_DT,OFFSM_SETTL_DT,OFFSM_SETTL_ID,ISNULL(S.DESCP,OFFSM_STAT),OFFSM_ERR_DESC
	FROM OFFMKT_STATUS_MSTR LEFT OUTER JOIN [citrus_usr].[FN_GETSUBTRANSDTLS]('RES_STAT_CD_CDSL') S ON CONVERT(VARCHAR,OFFSM_STAT)=CD
	WHERE OFFSM_TXN_DT BETWEEN @PA_FROMDT AND  @PA_TODT AND LEFT(LTRIM(RTRIM(OFFSM_BS_FLG)),1) = 'S' AND OFFSM_DPID = @@dpmid

	UPDATE t SET slip_no = DPTDC_SLIP_NO
	FROM #tmpreport t, dp_trx_dtls_cdsl
	where trn_type = 2
	and trn_no = DPTDC_TRANS_NO
	and dpam_id = dptdc_dpam_id 
	and dptdc_internal_trastm not in ('ID','EP','NP')
	and dptdc_deleted_ind = 1
end

if (@pa_trans_type = 0 or @pa_trans_type = 345)--EP
begin
insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,ctr_client_id,Qty,Buy_Sell,int_ref_no,trn_dt,trn_exec_dt,sett_dtls,trn_status,Error_msg)
select trn_type=case when Dp89_Txn_Type_Flag = 'N' then 4 WHEN Dp89_Txn_Type_Flag = 'A' then 5 WHEN Dp89_Txn_Type_Flag = 'E' then 3 ELSE 4 END,
dp89_dpam_id,dp89_isin,isin_name,Dp89_Txn_Id,[citrus_usr].[fn_splitstrin_byspace](isnull(Dp89_CM_Nm,'') + '/' + Dp89_CM_Id + ' / Exch: ' + isnull(Excm_desc,excm_id) ,'32','',1)
,Dp89_Trx_Qty,'S',Dp89_Int_RefNo,dp89_earmark_datetime,dp89_settl_datetime,sett_no =  isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id
,'CLOSED & SETTLED',''
  from transaction_dp89 with(nolock)  
  left outer join settlement_type_mstr on Dp89_Settl_type = settm_id,  
  isin_mstr  
  ,exchange_mstr   
  where Dp89_Settl_DateTime between @pa_fromdt and @pa_todt  
  and dp89_ISIN = isin_cd  
  AND Dp89_Trn_Status = 'C'

  AND Dp89_Ex_Id = excm_id  
  and Dp89_dpm_id = @@dpmid



	UPDATE t SET slip_no = DPTDC_SLIP_NO
	FROM #tmpreport t, dp_trx_dtls_cdsl
	where trn_no = DPTDC_TRANS_NO
	and dpam_id = dptdc_dpam_id 
	and trn_type in(3)
	and dptdc_internal_trastm in ('EP','NP')
	and dptdc_deleted_ind = 1

end

if (@pa_trans_type = 0 or @pa_trans_type = 3)--EP
begin
insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,ctr_client_id,Qty,Buy_Sell,int_ref_no,trn_dt,trn_exec_dt,sett_dtls,trn_status,Error_msg)
select trn_type=case when Dp89_Txn_Type_Flag = 'N' then 4 WHEN Dp89_Txn_Type_Flag = 'A' then 5 WHEN Dp89_Txn_Type_Flag = 'E' then 3 ELSE 4 END,
dp89_dpam_id,dp89_isin,isin_name,Dp89_Txn_Id,[citrus_usr].[fn_splitstrin_byspace](isnull(Dp89_CM_Nm,'') + '/' + Dp89_CM_Id + ' / Exch: ' + isnull(Excm_desc,excm_id) ,'32','',1)
,Dp89_Trx_Qty,'S',Dp89_Int_RefNo,dp89_earmark_datetime,dp89_settl_datetime,sett_no =  isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id
,'CLOSED & SETTLED',''
  from transaction_dp89 with(nolock)  
  left outer join settlement_type_mstr on Dp89_Settl_type = settm_id,  
  isin_mstr  
  ,exchange_mstr   
  where Dp89_Settl_DateTime between @pa_fromdt and @pa_todt  
  and dp89_ISIN = isin_cd  
  AND Dp89_Trn_Status = 'C'
  and Dp89_Txn_Type_Flag = 'E' 
  AND Dp89_Ex_Id = excm_id  
  and Dp89_dpm_id = @@dpmid



	UPDATE t SET slip_no = DPTDC_SLIP_NO
	FROM #tmpreport t, dp_trx_dtls_cdsl
	where trn_no = DPTDC_TRANS_NO
	and dpam_id = dptdc_dpam_id 
	and trn_type in(3)
	and dptdc_internal_trastm in ('EP')
	and dptdc_deleted_ind = 1

end
if (@pa_trans_type = 0 or @pa_trans_type = 4)--NP
begin
insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,ctr_client_id,Qty,Buy_Sell,int_ref_no,trn_dt,trn_exec_dt,sett_dtls,trn_status,Error_msg)
select trn_type=case when Dp89_Txn_Type_Flag = 'N' then 4 WHEN Dp89_Txn_Type_Flag = 'A' then 5 WHEN Dp89_Txn_Type_Flag = 'E' then 3 ELSE 4 END,
dp89_dpam_id,dp89_isin,isin_name,Dp89_Txn_Id,[citrus_usr].[fn_splitstrin_byspace](isnull(Dp89_CM_Nm,'') + '/' + Dp89_CM_Id + ' / Exch: ' + isnull(Excm_desc,excm_id) ,'32','',1)
,Dp89_Trx_Qty,'S',Dp89_Int_RefNo,dp89_earmark_datetime,dp89_settl_datetime,sett_no =  isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id
,'CLOSED & SETTLED',''
  from transaction_dp89 with(nolock)  
  left outer join settlement_type_mstr on Dp89_Settl_type = settm_id,  
  isin_mstr  
  ,exchange_mstr   
  where Dp89_Settl_DateTime between @pa_fromdt and @pa_todt  
  and dp89_ISIN = isin_cd  
  AND Dp89_Trn_Status = 'C'
  and Dp89_Txn_Type_Flag = 'N' 
  AND Dp89_Ex_Id = excm_id  
  and Dp89_dpm_id = @@dpmid



	UPDATE t SET slip_no = DPTDC_SLIP_NO
	FROM #tmpreport t, dp_trx_dtls_cdsl
	where trn_no = DPTDC_TRANS_NO
	and dpam_id = dptdc_dpam_id 
	and trn_type in(3,4,5)
	and dptdc_internal_trastm in ('EP','NP')
	and dptdc_deleted_ind = 1

end
if (@pa_trans_type = 0 or @pa_trans_type = 5)--AP
begin
insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,ctr_client_id,Qty,Buy_Sell,int_ref_no,trn_dt,trn_exec_dt,sett_dtls,trn_status,Error_msg)
select trn_type=case when Dp89_Txn_Type_Flag = 'N' then 4 WHEN Dp89_Txn_Type_Flag = 'A' then 5 WHEN Dp89_Txn_Type_Flag = 'E' then 3 ELSE 4 END,
dp89_dpam_id,dp89_isin,isin_name,Dp89_Txn_Id,[citrus_usr].[fn_splitstrin_byspace](isnull(Dp89_CM_Nm,'') + '/' + Dp89_CM_Id + ' / Exch: ' + isnull(Excm_desc,excm_id) ,'32','',1)
,Dp89_Trx_Qty,'S',Dp89_Int_RefNo,dp89_earmark_datetime,dp89_settl_datetime,sett_no =  isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id
,'CLOSED & SETTLED',''
  from transaction_dp89 with(nolock)  
  left outer join settlement_type_mstr on Dp89_Settl_type = settm_id,  
  isin_mstr  
  ,exchange_mstr   
  where Dp89_Settl_DateTime between @pa_fromdt and @pa_todt  
  and dp89_ISIN = isin_cd  
  AND Dp89_Trn_Status = 'C'
  and Dp89_Txn_Type_Flag = 'A' 
  AND Dp89_Ex_Id = excm_id  
  and Dp89_dpm_id = @@dpmid



	UPDATE t SET slip_no = DPTDC_SLIP_NO
	FROM #tmpreport t, dp_trx_dtls_cdsl
	where trn_no = DPTDC_TRANS_NO
	and dpam_id = dptdc_dpam_id 
	and trn_type in(3,4,5)
	and dptdc_internal_trastm in ('EP','NP')
	and dptdc_deleted_ind = 1

end
  --order by Dp89_Earmark_DateTime,dpam_sba_no,Dp89_Txn_Type_Flag,excm_id,isnull(SETTM_DESC,'') + '/' + Dp89_Settl_Id,Dp89_ISIN  


if (@pa_trans_type = 0 or @pa_trans_type = 6)
begin
	insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,Qty,int_ref_no,trn_dt,trn_exec_dt,trn_status,Error_msg)
	SELECT 6,DMTS_DPAM_ID,DMTS_ISIN,DMTS_ISIN_SHRT_NM,DMTS_DMT_REQ_NO,DMTS_DMT_REQ_QTY,DMTS_DMT_REQ_FRM_NOS,DMTS_DRN_SETUP_DT,DMTS_DRN_SETUP_DT,DESCP,DMTS_REJ_REASON
	FROM DMT_STATUS_MSTR,[citrus_usr].[FN_GETSUBTRANSDTLS]('RES_STAT_CD_CDSL') R
	WHERE  DMTS_DRN_STATUS=CD  
	AND DMTS_DRN_SETUP_DT BETWEEN @PA_FROMDT AND  @PA_TODT
	and DMTS_DPM_ID = @@dpmid
end

if (@pa_trans_type = 0 or @pa_trans_type = 7)
begin
	insert into #tmpreport(trn_type,dpam_id,isin_cd,isin_name,trn_no,Qty,int_ref_no,trn_dt,trn_exec_dt,trn_status,Error_msg)
	SELECT 7,RMTS_DPAM_ID,RMTS_ISIN_ALPHA_CD,RMTS_ISIN_SHRT_NM,RMTS_RMT_REQ_NO,RMTS_QTY_REQ_FOR_RMT_NOS,RMTS_RMT_REF_NO,RMTS_SETUP_DT,RMTS_CONF_DT,RMTS_STAT_DESC,''
	FROM RMT_STATUS_MSTR
	WHERE RMTS_SETUP_DT BETWEEN @PA_FROMDT AND  @PA_TODT
	and RMTS_DPM_ID = @@dpmid
end
--trn_type = 1 - Interdep, 2 - offmarket, 3 - Early payin, 4 - normal payin , 5 - Autopayin ,6 - demat, 7 - remat

print @pa_fromaccid
print @pa_toaccid
select dpam_sba_name,dpam_sba_no,
trans_type=case when trn_type = 1 then 'INTER DEPOSITORY'
				WHEN trn_type = 2 then 'OFF MARKET'
				WHEN trn_type = 3 then 'EARLY PAYIN'
				WHEN trn_type = 4 then 'NORMAL PAYIN'
				WHEN trn_type = 5 then 'AUTO PAYIN'
				WHEN trn_type = 6 then 'DEMAT'
				WHEN trn_type = 7 then 'REMAT'
				else '' end
,isin_cd,isin_name,trn_no,ctr_client_id,Qty,slip_no,Buy_Sell,int_ref_no,convert(varchar,trn_dt,103) trn_dt,convert(varchar,trn_exec_dt,103) trn_exec_dt,sett_dtls,trn_status,Error_msg
from #tmpreport t ,#ACLIST a
where t.dpam_id = a.dpam_id
and  isnumeric(DPAM_SBA_NO) = 1
AND (DPAM_SBA_NO BETWEEN CONVERT(NUMERIC(20,0),@pa_fromaccid) and CONVERT(NUMERIC(20,0),@pa_toaccid))  
AND (trn_dt between EFF_FROM and EFF_TO)                            
order by trn_exec_dt,slip_no desc,trn_type,1,dpam_sba_no


truncate table #tmpreport
drop table #tmpreport
truncate table #ACLIST
drop table #ACLIST

END

GO
