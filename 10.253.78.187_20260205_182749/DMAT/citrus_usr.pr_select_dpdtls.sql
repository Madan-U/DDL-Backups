-- Object: PROCEDURE citrus_usr.pr_select_dpdtls
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_select_dpdtls '1203270000114478','1203270000114478','Nov 10 2009','jan 13 2010'

CREATE Proc [citrus_usr].[pr_select_dpdtls] 
(
	 @pa_from_acct_no varchar(20)
	,@pa_to_acct_no varchar(20)
	,@pa_from_dt varchar(11)
	,@pa_to_dt varchar(11) 
)
as
begin

 IF @pa_from_acct_no = ''                      
 BEGIN                      
  SET @pa_from_acct_no = '0'                      
  SET @pa_to_acct_no = '99999999999999999'                      
 END                      
 IF @pa_to_acct_no = ''                      
 BEGIN                  
   SET @pa_to_acct_no = @pa_from_acct_no                      
 END   

SELECT  DISTINCT DPAM_SBA_NAME [NAME]
   ,'' SOURCE
   ,'' RELATIONSHIP
   ,'' CONTACTTYPE
	,CLICM_DESC [CATEGORY]	
	,LOWER(ISNULL(CITRUS_USR.FN_DP_IMPORT_CONC(CLIM_CRN_NO,'EMAIL1'),'')) [EMAIL]
	,'' [SALUTATIONS]	
    ,CITRUS_USR.INSIDE_TRIM(LTRIM(RTRIM(DPAM_SBA_NAME)),'1') [FIRSTNAME]
	,CITRUS_USR.INSIDE_TRIM(LTRIM(RTRIM(DPAM_SBA_NAME)),'2') [MIDDLENAME]
	,CITRUS_USR.INSIDE_TRIM(LTRIM(RTRIM(DPAM_SBA_NAME)),'3') [LASTNAME]
    ,'' COMPANY
    ,'' DEPARTMENT
    ,'' DESIGNATION
	,CITRUS_USR.FN_SPLITVAL(ISNULL(CITRUS_USR.FN_ADDR_VALUE(CLIM_CRN_NO,'COR_ADR1'),''),1) [ADDRESS1]	
	,CITRUS_USR.FN_SPLITVAL(ISNULL(CITRUS_USR.FN_ADDR_VALUE(CLIM_CRN_NO,'COR_ADR1'),''),2) [ADDRESS2]	
	,CITRUS_USR.FN_SPLITVAL(ISNULL(CITRUS_USR.FN_ADDR_VALUE(CLIM_CRN_NO,'COR_ADR1'),''),3) [ADDRESS3]	
	,CITRUS_USR.FN_SPLITVAL(ISNULL(CITRUS_USR.FN_ADDR_VALUE(CLIM_CRN_NO,'COR_ADR1'),''),6) [COUNTRY]	
	,CITRUS_USR.FN_SPLITVAL(ISNULL(CITRUS_USR.FN_ADDR_VALUE(CLIM_CRN_NO,'COR_ADR1'),''),5) [STATE]
	,CITRUS_USR.FN_SPLITVAL(ISNULL(CITRUS_USR.FN_ADDR_VALUE(CLIM_CRN_NO,'COR_ADR1'),''),4) [CITY]
	,'' [CITYZONE]
    ,CITRUS_USR.FN_SPLITVAL(ISNULL(CITRUS_USR.FN_ADDR_VALUE(CLIM_CRN_NO,'COR_ADR1'),''),7) [PINCODE]
    ,ISNULL(CITRUS_USR.FN_DP_IMPORT_CONC(CLIM_CRN_NO,'FAX'),'') [FAX]	
    ,ISNULL(CITRUS_USR.FN_DP_IMPORT_CONC(CLIM_CRN_NO,'MOBILE1'),'') [MOBILE]
    ,'' [MOBILE2]	
    ,'' WEBSITE
    ,ISNULL(CITRUS_USR.FN_UCC_ENTP(CLIM_CRN_NO,'PAN_GIR_NO',''),'') [PAN]
    ,CONVERT(VARCHAR,CLIM_DOB,103) [DATEOFBIRTH]
    ,'' ANNIVERSARYDATE
    ,'' SEETAPORTFOLIOCUSTOMER
    ,'' SEETACOMMODITIESCUSTOMER
    ,'' [SEETACLIENTCODE]
    ,ISNULL(CITRUS_USR.[FN_FIND_RELATIONS_NM](CLIM_CRN_NO,'ENTR_AR'),'') [BRANCHCODE]
    ,'' FAMILYKEYCONTACT
    ,'' SALESOWNERCODE
    ,ISNULL(CITRUS_USR.FN_UCC_ENTP(CLIM_CRN_NO,'BBO_CODE',''),'') [TRADINGID]
    ,DPM_DPID [DPID]
    ,'' [EQUITYVALUATIONS]
    ,'' [DATEOFEQUITYVALUATIONS]
    ,ISNULL(CITRUS_USR.FN_DP_IMPORT_CONC(CLIM_CRN_NO,'RES_PH1'),'') [PHONE1]
    ,ISNULL(CITRUS_USR.FN_DP_IMPORT_CONC(CLIM_CRN_NO,'RES_PH2'),'') [PHONE2]

--,dpam_sba_no [DEMAT ACCOUNT]
--,isnull(brom_desc,'') [PROFILE]	
--,'' [DEMAT HOLDING VALUATION]
--,'' [DT. OF DEMAT HOLDING VALUATION]

from dp_Acct_mstr 
left outer join client_dp_brkg on clidb_dpam_id = dpam_id  and clidb_deleted_ind = 1 and getdate() between clidb_eff_from_dt and clidb_eff_to_dt
left outer join brokerage_mstr on brom_id = clidb_brom_id 
, client_mstr , dp_mstr , client_ctgry_mstr 
where dpam_crn_no  = clim_crn_no and dpam_dpm_id = dpm_id 
and clicm_cd = dpam_clicm_cd
and dpam_sba_no between  @pa_from_acct_no and @pa_to_acct_no   --'1203270000114478'
AND DPAM_LST_UPD_DT BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59'   
and  dpam_deleted_ind = 1
and  clim_deleted_ind = 1 
end

GO
