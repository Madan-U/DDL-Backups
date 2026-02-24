-- Object: PROCEDURE citrus_usr.pr_getclientemail
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_getclientemail](    
    @pa_acc_no varchar(20),    
    @pa_for varchar(10),
    @pa_rptname varchar(15)
        )    
as    
begin 
if @pa_for ='HO'
BEGIN
  --
	SELECT DISTINCT ltrim(rtrim(Lower(CONC.CONC_VALUE)))
	FROM  CONTACT_CHANNELS     CONC
	,  ENTITY_ADR_CONC      ENTAC
	,  ENTITY_MSTR          ENTM
	,  CONC_CODE_MSTR       CONCM  
	WHERE ENTM_ENTTM_CD  = 'HO'
	AND   ENTAC_CONCM_CD = 'EMAIL1'
	AND   ENTAC_ENT_ID   =  ENTM_ID 
	AND   ENTAC_ADR_CONC_ID   =  CONC_ID 
  --
 END
ELSE
BEGIN
  --	   
	Select distinct ltrim(rtrim(Lower(conc_value)))     
	from entity_adr_conc    
	, contact_channels    
	, client_mstr    
	, dp_acct_mstr    
	, conc_code_mstr     
	where not exists(select dpam_id from blk_client_email_dtls where dpam_id = blcked_dpam_id and blkced_rptname = @pa_rptname)
	and entac_concm_cd = 'email1'     
	and entac_adr_conc_id = conc_id     
	and clim_crn_no = entac_ent_id     
	and clim_crn_no = dpam_crn_no     
	and entac_concm_id = concm_id     
	and entac_deleted_ind = 1     
	and conc_deleted_ind = 1     
	and clim_deleted_ind = 1     
	and dpam_deleted_ind = 1     
	and concm_deleted_ind = 1     
	and dpam_sba_no = @pa_acc_no    
  --
END
END

GO
