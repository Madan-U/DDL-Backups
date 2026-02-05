-- Object: PROCEDURE citrus_usr.Pr_ValidateAccount_BAK_28072015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--Pr_ValidateAccount  '3','1203330004587963',1,'12033300',''      
--Pr_ValidateAccount '3','57',1,'',''    
  
CREATE Proc [citrus_usr].[Pr_ValidateAccount_BAK_28072015]            
@pa_excsmid int,            
@pa_acct_no varchar(50),            
@pa_login_pr_entm_id numeric,         
@pa_dpm_dpid varchar(8),         
@pa_ref_cur varchar(8000) output          
          
as               
begin            
 declare @@dpmid int            
        ,@l_exch_cd varchar(10)        
  ,@@sbano varchar(8000)  
        ,@count  varchar(20)   
  
set @@sbano =''   
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1        
 select @l_exch_cd =  excsm_exch_cd from exch_seg_mstr where excsm_id = @pa_excsmid and excsm_deleted_ind =1                                                  
--  
if len(@pa_acct_no) in (2,3,4,5)  
begin  
    if exists(select dpam_sba_no from dp_acct_mstr  
    where case when len(@pa_acct_no) = 3 then right(dpam_sba_no,3)  
when len(@pa_acct_no) = 2 then right(dpam_sba_no,2)  
when len(@pa_acct_no) = 4 then right(dpam_sba_no,4)  
when len(@pa_acct_no) = 5 then right(dpam_sba_no,5)end = @pa_acct_no   
 and dpam_stam_cd = 'active'   
 and dpam_excsm_id = @pa_excsmid  
 and dpam_deleted_ind = 1)  
 begin  
  select @@sbano = @@sbano + dpam_sba_no + '|' from dp_acct_mstr  
     where case when len(@pa_acct_no) = 3 then right(dpam_sba_no,3)  
when len(@pa_acct_no) = 2 then right(dpam_sba_no,2)  
when len(@pa_acct_no) = 4 then right(dpam_sba_no,4)  
when len(@pa_acct_no) = 5 then right(dpam_sba_no,5)end  = @pa_acct_no   
  and dpam_stam_cd = 'active'   
  and dpam_excsm_id = @pa_excsmid  
  and dpam_deleted_ind = 1  
  
        select @count = count(dpam_sba_no) from dp_acct_mstr  
     where case when len(@pa_acct_no) = 3 then right(dpam_sba_no,3)  
when len(@pa_acct_no) = 2 then right(dpam_sba_no,2)  
when len(@pa_acct_no) = 4 then right(dpam_sba_no,4)  
when len(@pa_acct_no) = 5 then right(dpam_sba_no,5)end = @pa_acct_no   
  and dpam_stam_cd = 'active'   
  and dpam_excsm_id = @pa_excsmid  
  and dpam_deleted_ind = 1  
          
  print @@sbano  
         
  select isnull(@count + '|' + @@sbano,'') Msg    
 end  
 else  
    begin  
   select  'Account Does Not Exist' Msg     
       end  
end   
--  
else  
begin  

     
  
--if @l_exch_cd  = 'CDSL'        
--     set @pa_acct_no = @pa_dpm_dpid + @pa_acct_no                        
                               
  if exists(select top 1 dpam_id from dp_acct_mstr where dpam_sba_no = @pa_acct_no  and dpam_dpm_id = @@dpmid and dpam_deleted_ind = 1)            
  begin            
    if @pa_login_pr_entm_id <> 1 
	begin         
     if not exists(SELECT top 1 dpam_sba_no FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,0))            
     begin            
     Select 'Account does not fall under your access heirarchy level' Msg            
     end    
	end         
  end            
  else            
  begin            
  Select 'Invalid Account - Account does not exist'  Msg          
  end            
end    
end

GO
