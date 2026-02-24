-- Object: VIEW citrus_usr.Slip_Detail
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE view citrus_usr.Slip_Detail       
as    
select convert(varchar(20),mak.dptdc_slip_no ) [SLIP_NO]    
,mak.dptdc_request_dt [SLIP_DATE]    
,convert(numeric,mak.dptdc_id ) [RECEIPT_CODE]    
,convert(varchar(16),dpam_sba_no)  [CLIENT_CODE]    
,convert(varchar(12),mak.dptdc_isin ) [ISIN]    
,convert(varchar(20),isin_name ) [ISIN_NAME]    
,convert(money,mak.dptdc_qty*-1 ) [QTY]    
,mak.dptdc_execution_dt [EXEC_DATE]    
,convert(varchar(1),'' ) [STAGE]    
,convert(varchar(1),case when ISNULL(mstr.DPTDC_DELETED_IND ,'')='1'  then   'ACCEPTED'    
when ISNULL(mak.dptdc_res_cd ,'')<>''  then   'REJECTED' else ''  end ) [STATUS]    
,convert(varchar(10),isnull(dptdc_res_cd  ,'')) [REJECT_CODE]    
,convert(varchar(200),isnull(dptdc_res_desc ,'') ) [REJECT_REASON]    
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
