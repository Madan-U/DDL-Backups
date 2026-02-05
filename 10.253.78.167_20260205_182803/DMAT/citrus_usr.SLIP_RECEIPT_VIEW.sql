-- Object: VIEW citrus_usr.SLIP_RECEIPT_VIEW
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create view SLIP_RECEIPT_VIEW			
as
select 'T' [CODE]
,convert(numeric,mak.dptdc_id ) [RECEIPT_CODE]
,'0' [BRANCH_CODE]
,'MOD' [TRXN_TYPE]
,convert(datetime,convert(varchar(11),mak.DPTDC_CREATED_DT,103) ,103)	[TRXN_DATE]
, CONVERT(VARCHAR(8), mak.DPTDC_CREATED_DT, 108) [TRXN_TIME]
,convert(datetime,convert(varchar(11),mak.dptdc_lst_upd_dt,103) ,103) [LAST_UPDATE_DATE]
,CONVERT(VARCHAR(8), mak.dptdc_lst_upd_dt, 108) [LAST_UPDATE_TIME]
,convert(varchar(100),mak.dptdc_slip_no ) [SLIP_NO]
,convert(datetime,convert(varchar(11),mak.DPTDC_REQUEST_DT ,103) ,103) [SLIP_DATE]
,right(dpam_sba_no ,8) [BENEF_ACCNO]
,dpam_sba_no [CLIENT_CODE]
,convert(varchar(1),'' )  [STAGE]
,convert(varchar(1),case when ISNULL(mstr.DPTDC_DELETED_IND ,'')='1'  then   'ACCEPTED'      
when ISNULL(mak.dptdc_res_cd ,'')<>''  then   'REJECTED' else ''  end )  [STATUS]
,convert(varchar(10),isnull(mak.dptdc_res_cd  ,'')) [REJECT_CODE]
,convert(varchar(200),isnull(mak.dptdc_res_desc ,'') )  [REJECT_REASON]
,'N' [LATE_RECP]
,'N' [LATE_FEE]
,mak.dptdc_created_by [RECEIPT_USER]
,mak.dptdc_created_by [USER1]
,mak.dptdc_lst_upd_by [USER2]
,null [USER1_REC]
,null [USER2_REC]
,'Y' [DATA_ENTRY]
,null [REPLY_TAG]
,null [REPLY_DATE]
,null [BY_FAX]
,null [ENTRY_TYPE]
,null [FORM_KIT_NO]
,null [CONTROL_NO]
,null [NO_REC]
,convert(datetime,convert(varchar(11),mak.DPTDC_execution_DT ,103) ,103) [EXEC_DATE]
from dptdc_mak mak      
left outer join dp_trx_dtls_cdsl mstr      
on mstr.DPTDC_ID =  mak.DPTDC_ID       
and mstr.DPTDC_SLIP_NO = mak.DPTDC_SLIP_NO       
and mstr.DPTDC_DELETED_IND = 1       
,dp_acct_mstr       
,ISIN_MSTR       
where mak.DPTDC_DELETED_IND in (1,3)      
and mak.dptdc_dpam_id = DPAM_ID       
and mak.dptdc_isin = ISIN_CD

GO
