-- Object: PROCEDURE citrus_usr.pr_select_poa_dtls
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



CREATE procedure [citrus_usr].[pr_select_poa_dtls]
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

--CREATE FUNCTION CITRUS_USR.FN_POATYPE(@pA_BOID VARCHAR(16),@PA_MASTER VARCHAR(16))
--RETURNS VARCHAR(100) 
--AS
--BEGIN 
--RETURN(
--SELECT TOP 1 DPPD_POA_TYPE FROM DP_POA_DTLS , DP_ACCT_MSTR WHERE DPPD_DPAM_ID = DPAM_ID AND DPAM_SBA_NO = @pA_BOID
--AND dppd_master_id  = @PA_MASTER)

--END 

	select distinct DPAM_SBA_NAME DPPD_FNAME    
	, '' DPPD_MNAME      
	, '' DPPD_LNAME        
	, '' DPPD_DOB        
	, '' DPPD_PAN_NO      
	, POARegNum  dppd_poa_id      
	, DPAM_SBA_NO dppd_master_id    
	, citrus_usr.[FN_POATYPE_new](BOID,DPAM_SBA_NO)  dppd_poa_type     
	, left(SetupDate,2)+'/'+SUBSTRING (SetupDate,3,2)+'/'+RIGHT (SetupDate,4) dppd_setup --SetupDate dppd_setup 
	, left(EffFormDate,2)+'/'+SUBSTRING (EffFormDate,3,2)+'/'+RIGHT (EffFormDate,4)  dppd_eff_fr_dt-- EffFormDate dppd_eff_fr_dt      
	, left(EffToDate,2)+'/'+SUBSTRING (EffToDate,3,2)+'/'+RIGHT (EffToDate,4)    dppd_eff_to_dt      -- EffToDate dppd_eff_to_dt      
	, 'ACTIVE' POA_STATUS 
	, HolderNum DPPD_HLD      --0
	, (select top 1 case when upper(isnull(mSTRPOAFLG,'')) = 'C' then 'FOR CM POA' when  upper(isnull(mSTRPOAFLG,'')) = 'R' then 'OTHER THEN CM POA' ELSE '' END from dps8_pc1 where boid = MasterPOAId ) master_poa_type
	from  dps8_pc5, dp_acct_mstr
	where boid =@PA_FROM_ACCTNO 
	and TypeOfTrans in ('','1','2')
	and dpam_sba_no = MasterPOAId 
	and dpam_deleted_ind = '1'
	order by HolderNum
	
	
end

GO
