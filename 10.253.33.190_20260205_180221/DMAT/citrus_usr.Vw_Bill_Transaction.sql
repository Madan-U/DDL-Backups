-- Object: VIEW citrus_usr.Vw_Bill_Transaction
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE view Vw_Bill_Transaction  
as  
select convert(numeric,'0') BILL_TRXN_ID  
,convert(varchar(16),dpam_sba_no ) CLIENT_CODE  
,convert(varchar(8),right(dpam_sba_no,8) ) BENEF_ACCNO  
,convert(varchar(10),clic_charge_name  ) TRXN_TYPE  
,convert(varchar(200),clic_charge_name   ) NARRATION  
,convert(money,sum(clic_charge_amt*-1))  AMOUNT  
,convert(numeric,'0' ) BILL_NO  
,clic_trans_dt BILL_DATE  
,convert(varchar(200),'' ) REMARKS  
,convert(money,0 ) DPM_CHARGES  
,convert(money,0) SERV_TAX  
from client_charges_cdsl,dp_acct_mstr  where CLIC_TRANS_DT>='jul 01 2015'
and DPAM_ID = CLIC_DPAM_ID   
group by clic_charge_name ,dpam_sba_no,clic_trans_dt

GO
