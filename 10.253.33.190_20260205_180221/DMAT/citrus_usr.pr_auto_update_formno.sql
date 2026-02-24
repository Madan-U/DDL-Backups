-- Object: PROCEDURE citrus_usr.pr_auto_update_formno
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*select * from dp_acct_mstr where dpam_id = 64163 
select * from entity_relationship where entr_crn_no = 357223
select * from account_properties where accp_clisba_id = 64163
select * from account_documents  where accd_clisba_id = 64163
*/
CREATE procedure [citrus_usr].[pr_auto_update_formno](@pa_id numeric, @pa_client_id varchar(25), @pa_new_form_no varchar(25),@pa_login_name varchar(25),@PA_OUT CHAR(1) OUTPUT)
as
begin
   DECLARE @L_COUNTER NUMERIC
          ,@L_COUNTER_EXISTS_FR NUMERIC
         , @L_COUNTER_EXISTS NUMERIC
   SET @L_COUNTER = 0
   SET @L_COUNTER_EXISTS_FR = 0
   SELECT @L_COUNTER = COUNT(*) FROM DP_ACCT_MSTR WHERE DPAM_SBA_NO = LTRIM(RTRIM(@pa_client_id)) AND DPAM_DELETED_IND = 1 --AND ISNULL(DPAM_BATCH_NO,'1')= '1'

   SELECT @L_COUNTER_EXISTS_FR = COUNT(DPAM_ACCT_NO) FROM DP_ACCT_MSTR WHERE DPAM_ACCT_NO =   @pa_new_form_no AND DPAM_DELETED_IND = 1 
   IF @L_COUNTER_EXISTS_FR = 0
   SELECT @L_COUNTER_EXISTS_FR = COUNT(DPAM_ACCT_NO) FROM DP_ACCT_MSTR_MAK WHERE DPAM_ACCT_NO =   @pa_new_form_no AND DPAM_DELETED_IND = 0
 

   IF @L_COUNTER_EXISTS_FR >=1
   BEGIN
   SET @PA_OUT = 'N'
   RETURN
   END 

   IF @L_COUNTER = 1 
   BEGIN

      UPDATE DP_ACCT_MSTR SET DPAM_ACCT_NO = LTRIM(RTRIM(@pa_new_form_no)) 
      WHERE DPAM_SBA_NO = LTRIM(RTRIM(@pa_client_id)) 
      AND DPAM_DELETED_IND = 1
      
      UPDATE ENTR SET ENTR_ACCT_NO = LTRIM(RTRIM(@pa_new_form_no)) 
      FROM ENTITY_RELATIONSHIP ENTR
         , DP_aCCT_MSTR 
      WHERE DPAM_CRN_NO = ENTR_CRN_NO 
      AND DPAM_SBA_NO = ENTR_SBA 
      AND DPAM_SBA_NO = LTRIM(RTRIM(@pa_client_id)) 
      AND ENTR_DELETED_IND = 1 
      AND DPAM_DELETED_IND = 1

      UPDATE ACCP SET ACCP_ACCT_NO = LTRIM(RTRIM(@pa_new_form_no)) 
      FROM account_properties ACCP
         , DP_aCCT_MSTR 
      WHERE ACCP_CLISBA_ID   = DPAM_ID 
      AND   DPAM_SBA_NO      =  LTRIM(RTRIM(@pa_client_id)) 
      AND   ACCP_DELETED_IND = 1
      AND   DPAM_DELETED_IND = 1
   
      UPDATE ACCD SET ACCD_ACCT_NO = LTRIM(RTRIM(@pa_new_form_no)) 
      FROM ACCOUNT_DOCUMENTS ACCD
         , DP_aCCT_MSTR 
      WHERE ACCD_CLISBA_ID   = DPAM_ID 
      AND   DPAM_SBA_NO      =  LTRIM(RTRIM(@pa_client_id)) 
      AND   ACCD_DELETED_IND = 1
      AND   DPAM_DELETED_IND = 1

     
      
   END 

   SET @PA_OUT = 'Y'
   
end

GO
