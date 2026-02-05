-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls_ba
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran      
--pr_bulk_ins_dtls_ba      
--select * from entity_mstr where entm_enttm_cd='ba'--257 --989      
--select * from entity_adr_conc --8959  --9926       
--select * from addresses --1554 --1598 --1612      
--select * from contact_channels --3627       
--select * from entity_adr_conc where entac_ent_id = 141573       
--SELECT * FROM CONC_CODE_MSTR      
--select * from client_ctgry_mstr      
--rollback      
--COMMIT      
      
CREATE PROC [citrus_usr].[pr_bulk_ins_dtls_ba]      
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
    
-- select distinct [code],      
--   [ description ]    
-- from mosl_ba     
    
 --select distinct branch_code,branch  from moslnew_ba     
--select distinct b.branch_code,b.branch,entm_id from moslnew_AREA  a, moslnew_ba b , 
--entity_mstr C where b.branch_Code=a.Branch_code  
--and entm_short_name=a.Areacode  
       
select distinct b.branch_code + '_BA',a.branch,entm_id from mosl_ba_May032012 a,mosl_area_May032012 b, entity_mstr c
where ltrim(rtrim(a.branch_Code)) + '_BA' not in (
select  ltrim(rtrim(Code))   from mosl_BA)
and ltrim(rtrim(b.branch_Code)) + '_BA' =ltrim(rtrim(a.Branch_code))   + '_BA'
and entm_short_name=ltrim(rtrim(b.Areacode))  + '_AR'
and ltrim(rtrim(a.branch_code)) + '_BA' not in (select ltrim(rtrim(entm_short_name)) from entity_mstr where entm_enttm_cd='BA')
       
 open cur1      
 fetch next from cur1 into       
 @l_member_no,@l_member_name ,@l_entm_parentid      --,@l_sebi_registration_no      
      
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
   'BA',  --'BRK',      
   'NRM', --'PARTNERSHIP',       
   @l_entm_parentid ,      
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
  @l_member_no,@l_member_name,@l_entm_parentid   --,@l_sebi_registration_no      
      
  end      
      
  close cur1      
  deallocate cur1      
      
END

GO
