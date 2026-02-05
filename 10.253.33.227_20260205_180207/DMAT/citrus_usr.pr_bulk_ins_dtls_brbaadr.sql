-- Object: PROCEDURE citrus_usr.pr_bulk_ins_dtls_brbaadr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin tran  
--[pr_bulk_ins_dtls_brbaadr]  
--select * from entity_mstr order by entm_created_dt desc--957 --977  
--select * from entity_adr_conc where  --5523  --5587  
--select * from addresses order by adr_created_dt desc --1191 --3175288  
--select * from contact_channels
--commit  
--select top 100 * from contact_channels order by conc_created_dt desc --2533 --2596   
--rollback  
  
CREATE PROC [citrus_usr].[pr_bulk_ins_dtls_brbaadr]  
AS  
BEGIN  
--  
Declare @l_member_no varchar(50),  
  @l_member_name varchar(100),  
  @l_trade_name varchar(100),  
  @l_sebi_registration_no  varchar(50),  
  @l_address_1 varchar(50),  
  @l_address_2 varchar(50),  
  @l_address_3 varchar(50),  
  @l_city   varchar(50),  
  @l_pincode  varchar(50),  
  @l_state  varchar(50),  
  @l_e_mail  varchar(50),  
  @l_telephone varchar(100),  
  @l_fax   varchar(100),  
  @l_telephone1 varchar(100),  
  @l_e_mail1  varchar(100),  
  @l_fax1   varchar(100),  
  @l_entm_id  int,  
  @l_adr_value varchar(8000),  
  @l_conc_value1 varchar(8000),  
  @l_conc_value2 varchar(8000),  
  @l_conc_value3 varchar(8000),  
  @l_conc_value4 varchar(8000),  
  @l_conc_value5 varchar(8000),   
  @l_conc_value6 varchar(8000),  
  @l_error  int  ,@l_ent_id int
    
  
 set @l_adr_value = ''  
 set @l_conc_value1 = ''   
 set @l_conc_value2 = ''  
 set @l_conc_value3 = ''  
 set @l_conc_value4 = ''  
 set @l_conc_value5 = ''  
 set @l_conc_value6 = ''  
   
  
declare cur1 cursor fast_forward for  

select  branch_Code,[branch],isnull(Address1,'') add1,isnull(Address2,'') add2,isnull(City,'') city
,isnull(state,'') state
,isnull(Zip,'') zip,
isnull(Phone1,'') ph1,isnull(Email,'') email ,entm_id
from moslnew_ba,entity_mstr
where branch_Code = entm_short_name 
  
 open cur1  
 fetch next from cur1 into   
 @l_member_no,@l_member_name,@l_address_1,@l_address_2,@l_city,@l_state,@l_pincode,@l_telephone,@l_e_mail,@l_ent_id  
  
 while @@fetch_status = 0   
 begin  
  
  set @l_adr_value = ''  
 -- set @l_value = @l_value + @l_member_name + '' + '' + @l_member_no + 'BRK' + 'HO' + 'PARTNERSHIP' + @l_sebi_registration_no +    
 -- exec pr_ins_upd_entm '0','INS','MIG',@l_value,1,'*|~*','|*~|','',''  
  
  BEGIN TRANSACTION  
  

if  isnull(@l_address_1,'') <> ''  

SET @l_adr_value = 'COR_ADR1' + '|*~|' + @l_address_1 + '|*~|' + @l_address_2 + '|*~|' + ' ' + '|*~|' + @l_city + '|*~|' + @l_state + '|*~|' + 'INDIA' + '|*~|' + @l_pincode + '*|~*'   

print @l_ent_id  

print @l_adr_value  
  
  EXEC pr_ins_upd_addr @l_ent_id,'EDT','MIG',@l_ent_id,'',@l_adr_value,0,'*|~*','|*~|',''   
  --  
--         
--  select top 1 @l_conc_value1 = case when isnull(ltrim(rtrim(@l_e_mail)),'') <> ''   
--           then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_e_mail)),'')+'|*~|*|~*'   
--            else '' end from conc_code_mstr    
--  where concm_cd= 'EMAIL1'   
--
--  print @l_conc_value1
--
--  exec pr_ins_upd_conc @l_ent_id,'EDT','MIG',@l_ent_id,'',@l_conc_value1,0,'*|~*','|*~|',''   
--  --  
  
--  select top 1 @l_conc_value2 = case when isnull(ltrim(rtrim(@l_telephone)),'') <> ''   
--           then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_telephone)),'')+'|*~|*|~*'   
--            else '' end from conc_code_mstr    
--  where concm_cd= 'OFF_PH1'       
--
--print @l_conc_value2
--
--  exec pr_ins_upd_conc @l_ent_id,'EDT','MIG',@l_ent_id,'',@l_conc_value2,0,'*|~*','|*~|',''  
  --  
  
--  select top 1 @l_conc_value3 = case when isnull(ltrim(rtrim(@l_fax)),'') <> ''   
--           then convert(varchar,concm_cd)+'|*~|'+isnull(ltrim(rtrim(@l_fax)),'')+'|*~|*|~*'   
--            else '' end from conc_code_mstr    
--  where concm_cd= 'FAX1'       
--  exec pr_ins_upd_conc @l_ent_id,'EDT','MIG',@l_ent_id,'',@l_conc_value3,0,'*|~*','|*~|',''  
  --  
  
  set @l_error = @@error  
  if @l_error <> 0  
  begin   
   select 'Error : Can not Insert the Record'  
  
   ROLLBACK TRANSACTION  
  end  
  
  else  
  begin  
   COMMIT TRANSACTION  
  end  
    
  fetch next from cur1 into   
   @l_member_no,@l_member_name,@l_address_1,@l_address_2,@l_city,@l_state,@l_pincode,@l_telephone,@l_e_mail ,@l_ent_id 
  
     
  end  
  
  close cur1  
  deallocate cur1  
  
END

GO
