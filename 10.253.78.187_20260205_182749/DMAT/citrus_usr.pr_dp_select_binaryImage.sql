-- Object: PROCEDURE citrus_usr.pr_dp_select_binaryImage
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



create  procedure [citrus_usr].[pr_dp_select_binaryImage]
(
	@pa_dpam_id numeric,
	@pa_action varchar(100),
	@pa_account_no varchar(100),
    @pa_output VARCHAR(8000) OUTPUT
)
as
begin
print '13'
	if @pa_action = 'FetchImageBinary' 
	begin
	print '12'
print @pa_dpam_id
print @pa_account_no
		select ACCD_BINARY_IMAGE, ACCD_DOC_PATH,accd_accdocm_doc_id
		from account_documents, dp_acct_mstr
		where ACCD_CLISBA_ID = @pa_dpam_id
		and dpam_id = ACCD_CLISBA_ID
		and dpam_acct_no  = @pa_account_no
		and ACCD_DELETED_IND =1
		and dpam_deleted_ind = 1
		and accd_accdocm_doc_id in (12)
		--and accd_accdocm_doc_id in (12,13)
	end
end

GO
