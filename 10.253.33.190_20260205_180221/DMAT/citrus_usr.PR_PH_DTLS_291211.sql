-- Object: PROCEDURE citrus_usr.PR_PH_DTLS_291211
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--PR_PH_DTLS 0,0
CREATE PROCEDURE [citrus_usr].[PR_PH_DTLS_291211]
(
	@PA_BO_ID	VARCHAR(20),
	@PA_EXCSM_ID NUMERIC(10,0)	
)
as
begin

	select isnull(citrus_usr.[fn_conc_value](dpam_crn_no,'OFF_PH1'),'') [office ph]
	,isnull(citrus_usr.[fn_conc_value](dpam_crn_no,'MOBILE1'),'') [mobile]
	,isnull(citrus_usr.[fn_conc_value](dpam_crn_no,'RES_PH1'),'') [res ph]
	from dp_acct_mstr 
	where dpam_SBA_NO = @PA_BO_ID
	and DPAM_EXCSM_ID = @PA_EXCSM_ID
	and dpam_deleted_ind =1  

end

GO
