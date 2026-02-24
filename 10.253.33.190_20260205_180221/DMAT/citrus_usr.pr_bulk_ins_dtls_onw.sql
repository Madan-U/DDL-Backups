-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls_onw
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--begin tran      
--[pr_bulk_ins_dtls_onw]      
--select * from entity_mstr where entm_enttm_cd='onw' --select 609 + 1011 --10329      


--select * from entity_adr_conc --8959  --9926       
--select * from addresses --1554 --1598 --1612      
--select * from contact_channels --3627       
--select * from entity_adr_conc where entac_ent_id = 141573       
--SELECT * FROM CONC_CODE_MSTR      
--select * from entity_type_mstr where enttm_cli_yn = 1      
--select * from enttm_entr_mapping       
--rollback      
--COMMIT      
      
CREATE PROC [citrus_usr].[pr_bulk_ins_dtls_onw]      
AS      
BEGIN      
--      
Declare @l_member_no varchar(50),      
  @l_member_name varchar(100),      
  @l_sebi_registration_no varchar(50),      
  @l_entm_id  int,      
@l_entm_parentid  int,      
  @l_error  int      
        
      
 declare cur1 cursor fast_forward for      
    
 --Select distinct sub_broker,Name from moslnew_fr where right(sub_broker,4)='_onw'    

--select distinct Sub_Broker,name,entm_id  from moslnew_fr , entity_mstr where right(branch_code,3)='_ba'  
--and branch_code = entm_short_name  
--union  
--select distinct Sub_Broker,name,entm_id from moslnew_fr  a, entity_mstr , moslnew_region c  where right(a.branch_code,3)<>'_Ba'  
--and regioncode  = entm_short_name and Reg_subbroker  = a.branch_code  

SELECT A.SUB_BROKER + '_ONW' A ,NAME,ENTM_ID FROM MOSL_ONW_MAY032012 A ,ENTITY_MSTR,MOSL_Ba_MAY032012 B 
WHERE LTRIM(RTRIM(SUB_BROKER)) + '_ONW' 
NOT IN (SELECT LTRIM(RTRIM(ENTM_SHORT_NAME)) FROM ENTITY_MSTR WHERE ENTM_ENTTM_CD='ONW')
AND ENTM_SHORT_NAME=LTRIM(RTRIM(B.BRANCH_CODE))  + '_BA'
AND LTRIM(RTRIM(B.BRANCH_CODE)) + '_BA' =LTRIM(RTRIM(A.BRANCH_CODE))   + '_BA'
    
 open cur1      
 fetch next from cur1 into       
 @l_member_no,@l_member_name ,@l_entm_parentid--,@l_sebi_registration_no      
      
 while @@fetch_status = 0       
 begin      
      
  BEGIN TRANSACTION      
      
  /*SELECT @l_entm_id = MAX(ENTM_ID) + 1 FROM ENTITY_MSTR*/      
print @l_member_no      
      
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
   'ONW',  --'BRK',      
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
  @l_member_no,@l_member_name,@l_entm_parentid --,@l_sebi_registration_no      
      
  end      
      
  close cur1      
  deallocate cur1      
      
END

GO
