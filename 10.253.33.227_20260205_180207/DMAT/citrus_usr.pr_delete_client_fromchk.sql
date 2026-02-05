-- Object: PROCEDURE citrus_usr.pr_delete_client_fromchk
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_delete_client_fromchk  '8800302' (need to put form number)
create  proc [citrus_usr].[pr_delete_client_fromchk] (@pa_acct_no varchar(100))
as
begin 
declare @l_crn_no   numeric
declare @l_dpam_id   numeric

select @l_crn_no  = dpam_Crn_no,@l_dpam_id= dpam_id from dp_Acct_mstr where dpam_acct_no = @pa_acct_no  

delete  from ENTITY_PROPERTY_DTLS where ENTPD_ENTP_ID 
in (select entp_id from entity_properties  where ENTP_ENT_ID = @l_crn_no)

delete from entity_relationship where ENTR_CRN_NO = @l_crn_no
delete from client_list where clim_crn_no = @l_crn_no
delete from dp_holder_dtls where DPHD_DPAM_ID = @l_dpam_id
delete from client_list where CLIM_CRN_NO = @l_crn_no 
delete from client_bank_accts where CLIBA_clisba_id = @l_dpam_id
delete from dp_poa_dtls where DPPD_DPAM_ID = @l_dpam_id

delete from entity_properties where entp_ent_id = @l_crn_no

delete from client_mstr where CLIM_CRN_NO = @l_crn_no
delete from dp_acct_mstr where DPAM_ACCT_NO = @pa_acct_no

end

GO
