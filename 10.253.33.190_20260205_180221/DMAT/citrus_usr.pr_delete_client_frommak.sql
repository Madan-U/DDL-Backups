-- Object: PROCEDURE citrus_usr.pr_delete_client_frommak
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--exec pr_delete_client_frommak  '8800302' (need to put form number)
create    proc [citrus_usr].[pr_delete_client_frommak] (@pa_acct_no varchar(100))
as
begin 
declare @l_crn_no   numeric
declare @l_dpam_id   numeric

select @l_crn_no  = dpam_Crn_no,@l_dpam_id= dpam_id from dp_Acct_mstr_mak where dpam_acct_no = @pa_acct_no  

delete from entity_relationship_mak where ENTR_CRN_NO = @l_crn_no
delete from client_list where clim_crn_no = @l_crn_no
delete from dp_holder_dtls_mak where DPHD_DPAM_ID = @l_dpam_id
delete from client_list where CLIM_CRN_NO = @l_crn_no 
delete from client_bank_accts_mak where CLIBA_clisba_id = @l_dpam_id
delete from accp_mak where ACCP_CLISBA_ID = @l_dpam_id  ---1116937  NA
delete from ADDR_ACCT_MAK where ADR_CLISBA_ID = @l_dpam_id  
delete from ACCD_MAK where ACCD_CLISBA_ID = @l_dpam_id ---NA 
delete from clib_mak where  CLIDB_DPAM_ID = @l_dpam_id -- NA 
delete from entity_properties_mak where entp_ent_id = @l_crn_no

delete from dp_acct_mstr_mak where DPAM_ACCT_NO = @pa_acct_no
delete from client_mstr_mak where CLIM_CRN_NO = @l_crn_no
end

GO
