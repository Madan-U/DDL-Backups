-- Object: PROCEDURE citrus_usr.tusharbill
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*bill reco */

CREATE proc [citrus_usr].[tusharbill]
as
begin
--pr_get_client_charge_info '12010919','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010926','B-DETAILS',6,2012,'ALL'
--pr_get_client_charge_info '12010909','B-all',6,2012,'1201090004699199'
--pr_get_client_charge_info '12010919','B-DETAILS',6,2012,'1201091900161077'
--pr_get_client_charge_info '12010900','C-DETAILS',6,2012,'1201090000932520'
--pr_get_client_charge_info '12010909','T-DETAILS',6,2012,'1201090900002976'
--pr_get_client_charge_info '12010900','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010904','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010907','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010909','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010910','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010919','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010924','B-all',6,2012,'ALL'
--pr_get_client_charge_info '12010926','B-all',6,2012,'ALL'


select * from dp_acct_mstr where dpam_sba_no ='1201090700201456'
select * from account_properties where accp_clisba_id = 1084403

select * from cdsl_holding_dtls where cdshm_trans_no = '155202' and 	
cdshm_isin = 'INF397L01091'
 


end 

/*bill reco */

GO
