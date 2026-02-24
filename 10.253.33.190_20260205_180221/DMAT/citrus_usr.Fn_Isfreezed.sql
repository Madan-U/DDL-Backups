-- Object: FUNCTION citrus_usr.Fn_Isfreezed
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[Fn_Isfreezed](@pa_depository char(4),@dpmid bigint,@pa_acct_id varchar(16),@pa_isin varchar(12)) returns varchar(100)
as
begin
	declare @@COLDEL CHAR(4),
	@@retval varchar(100)
	SET @@COLDEL = '|~*|'

	IF @pa_isin <> ''
	BEGIN
		--CHECK IF ISIN IS NOT BLOCKED
		select top 1 @@retval = 'B' + @@COLDEL from freeze_unfreeze_dtls where fre_exec_date <=Getdate() and fre_isin_code = @pa_isin and fre_action = 'F' and fre_status = 'A' and fre_level = 'I' and fre_deleted_ind =1 
	END
	IF @pa_acct_id <> '' and isnull(@@retval,'') = ''
	BEGIN
		--CHECK IF ACCOUNT IS NOT BLOCKED
		select top 1 @@retval = 'B' + @@COLDEL from freeze_unfreeze_dtls,dp_acct_mstr where fre_exec_date <=Getdate() and isnull(fre_isin_code,'') = '' and fre_dpam_id = dpam_id and dpam_sba_no = @pa_acct_id  and fre_action = 'F' and fre_status = 'A' and fre_level = 'A' and fre_deleted_ind =1 
	END
	IF (@pa_acct_id <> '' and @pa_isin <> '' and isnull(@@retval,'') = '')
	BEGIN
		--CHECK IF ACCOUNT & ISIN COMBINATION IS NOT BLOCKED
		select top 1 @@retval = 'B' + @@COLDEL + CASE WHEN fre_qty= 0 THEN '' ELSE '' END from freeze_unfreeze_dtls,dp_acct_mstr where  fre_exec_date <=Getdate() and fre_isin_code = @pa_isin and fre_dpam_id = dpam_id and dpam_sba_no = @pa_acct_id and fre_action = 'F' and fre_level = 'A' and fre_status = 'A' and fre_deleted_ind =1 

		--select top 1 @@retval = 'B' + @@COLDEL + CASE WHEN fre_qty= 0 THEN '' ELSE fn_IsinProvisionalHolding(@pa_depository,@dpmid,dpam_id,@pa_isin)-fre_qty END from freeze_unfreeze_dtls,dp_acct_mstr where fre_dpam_id = dpam_id and dpam_sba_no = @pa_acct_id and fre_isin_code = @pa_isin and fre_action = 'F' and fre_level = 'A' and fre_status = 'A' and fre_exec_date <=Getdate() and fre_deleted_ind =1 
	END



	RETURN @@retval



end

GO
