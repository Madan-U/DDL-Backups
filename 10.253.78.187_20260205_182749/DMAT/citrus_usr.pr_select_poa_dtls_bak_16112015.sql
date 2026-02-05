-- Object: PROCEDURE citrus_usr.pr_select_poa_dtls_bak_16112015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create procedure [citrus_usr].[pr_select_poa_dtls_bak_16112015]
(
	@PA_FROM_ACCTNO varchar(16)
)
as
begin
--SELECT ISNULL(DPPD_FNAME,'')DPPD_FNAME,
--ISNULL(DPPD_MNAME,'')DPPD_MNAME,
--ISNULL(DPPD_LNAME,'')DPPD_LNAME,
--ISNULL(DPPD_DOB,'')DPPD_DOB,
--ISNULL(DPPD_PAN_NO,'')DPPD_PAN_NO,
--ISNULL(dppd_poa_id,'')dppd_poa_id,
--ISNULL(dppd_master_id,'')dppd_master_id,
--ISNULL(dppd_poa_type,'')dppd_poa_type,
--ISNULL(dppd_setup,'')dppd_setup,
--ISNULL(dppd_eff_fr_dt,'')dppd_eff_fr_dt,
--ISNULL(dppd_eff_to_dt,'')dppd_eff_to_dt,
--ISNULL(POA_STATUS,'') POA_STATUS,
--ISNULL(DPPD_HLD,'') DPPD_HLD FROM TEMPPOADATE
--RETURN

	select distinct DPPD_FNAME    
	, DPPD_MNAME      
	, DPPD_LNAME        
	, DPPD_DOB        
	, DPPD_PAN_NO      
	, dppd_poa_id      
	, dppd_master_id    
	, dppd_poa_type     
	, dppd_setup 
	, dppd_eff_fr_dt      
	, dppd_eff_to_dt      
	, 'ACTIVE' POA_STATUS 
	, DPPD_HLD      --0
	from dp_poa_dtls, dps8_pc5, dp_acct_mstr
	where boid =@PA_FROM_ACCTNO 
	and TypeOfTrans in ('','1','2')
	and dpam_id = DPPD_DPAM_ID
	and dpam_sba_no = boid
	and dpam_deleted_ind = '1'
	and DPPD_DELETED_IND = '1'
	order by DPPD_HLD
end

GO
