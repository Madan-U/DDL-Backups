-- Object: PROCEDURE citrus_usr.pr_rpt_img_binary
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_rpt_img_binary]
(
	@pa_boid varchar(16)
)
as
begin
	declare @l_dpam_id as numeric
	select @l_dpam_id = dpam_id from dp_acct_mstr
	where dpam_sba_no = @pa_boid
	
	select top 1 ACCD_BINARY_IMAGE from account_documents
	where ACCD_CLISBA_ID = @l_dpam_id
	and ACCD_DELETED_IND = '1'
	order by ACCD_LST_UPD_DT desc
end

GO
