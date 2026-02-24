-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls_rrem
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin tran      
--[pr_bulk_ins_dtls_rrem]      
--select * from entity_mstr  where entm_enttm_cd='rem'--257 --select 1498 + 122 -- 1620      
--select * from entity_adr_conc --8959  --9926       
--select * from addresses --1554 --1598 --1612      
--select * from contact_channels --3627       
--select * from entity_adr_conc where entac_ent_id = 141573       
--SELECT * FROM CONC_CODE_MSTR      
--select * from client_ctgry_mstr      
--rollback      
--COMMIT      

      
CREATE PROC [citrus_usr].[pr_bulk_ins_dtls_rrem]      
AS      
BEGIN      
--      
Declare @l_member_no varchar(50),      
  @l_member_name varchar(100),      
  @l_sebi_registration_no varchar(50),      
  @l_entm_id  int, @l_entm_parentid  int,      
  @l_error  int      
        
      
declare cur1 cursor fast_forward for      
    
--select distinct replace(sub_broker,'_onw','') + '_REM',name from [mosl_onword and remissor],mosl_branch where replace(branch_code,'_br','')=replace(code,'_br','')--rm-      
      
--select distinct sub_broker,name  from moslnew_rem where right(sub_broker,4)='_rem'    
-- select distinct [code],      
--   [ description ]--,      
--   --SEBI_REGISTRATION_NO      
-- from mosl_ba --,entity_mstr      
--select distinct Sub_Broker,name,entm_id  from moslnew_rem , entity_mstr where right(branch_code,3)='_br'  
--and branch_code = entm_short_name  
--union  
--select distinct Sub_Broker,name,entm_id from moslnew_rem  a, entity_mstr , moslnew_region c  where right(a.branch_code,3)<>'_BR'  
--and regioncode  = entm_short_name and Reg_subbroker  = a.branch_code       

select a.Sub_Broker + '_REM' a ,name,entm_id from mosl_rem_may032012 a ,entity_mstr,mosl_branch_May032012 b where ltrim(rtrim(Sub_Broker)) + '_REM' 
not in (select ltrim(rtrim(entm_short_name)) from entity_mstr where entm_enttm_cd='REM')
and entm_short_name=ltrim(rtrim(b.branch_code))  + '_br'
and ltrim(rtrim(b.branch_Code)) + '_br' =ltrim(rtrim(a.branch_Code))   + '_br'

       
 open cur1      
 fetch next from cur1 into       
 @l_member_no,@l_member_name ,@l_entm_parentid--,@l_sebi_registration_no      
      
 while @@fetch_status = 0       
 begin      
      
  BEGIN TRANSACTION      
      
  /*SELECT @l_entm_id = MAX(ENTM_ID) + 1 FROM ENTITY_MSTR*/      
--print @l_member_no      
      
   SELECT @l_entm_id         = bitrm_bit_location          
      FROM   bitmap_ref_mstr    WITH(NOLOCK)          
      WHERE  bitrm_parent_cd    = 'ENTITY_ID'          
      AND    bitrm_child_cd     = 'ENTITY_ID'          
      --          
      UPDATE bitmap_ref_mstr    WITH(ROWLOCK)          
      SET    bitrm_bit_location = bitrm_bit_location+1          
      WHERE  bitrm_parent_cd    = 'ENTITY_ID'          
      AND    bitrm_child_cd     = 'ENTITY_ID'         
      
  INSERT INTO ENTITY_MSTR      
  (      
   ENTM_ID,      
   ENTM_NAME1,      
   ENTM_NAME2,      
   ENTM_NAME3,      
   ENTM_SHORT_NAME,      
   ENTM_ENTTM_CD,      
   ENTM_CLICM_CD,      
   ENTM_PARENT_ID,      
   ENTM_RMKS,      
   ENTM_CREATED_BY,      
   ENTM_CREATED_DT,      
   ENTM_LST_UPD_BY,      
   ENTM_LST_UPD_DT,      
   ENTM_DELETED_IND      
   --entm_stam_cd      
  )      
  VALUES      
  (      
   @l_entm_id,      
   @l_member_name,      
   '',      
   '',      
   @l_member_no,      
   'REM',  --'BRK',      
   'NRM', --'PARTNERSHIP',       
   @l_entm_parentid,      
   '', --@l_sebi_registration_no,      
   'MIG',      
   GETDATE(),      
   'MIG',      
   GETDATE(),      
   1      
   --'ACTIVE' --case when isnull(@l_sebi_registration_no,'') <> '' then 'ACTIVE' else 'CI' end      
  )      
      
      
  SET @L_ERROR = @@ERROR      
  IF @L_ERROR <> 0      
  BEGIN       
   SELECT 'Error : Can not Insert the Record'      
      
   ROLLBACK TRANSACTION      
  END      
      
  ELSE      
  BEGIN      
   COMMIT TRANSACTION      
  END      
      
      
  fetch next from cur1 into       
  @l_member_no,@l_member_name ,@l_entm_parentid --,@l_sebi_registration_no      
      
  end      
      
  close cur1      
  deallocate cur1      
      
END

GO
