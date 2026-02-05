-- Object: FUNCTION citrus_usr.fn_acct_list_vishal
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select * from citrus_usr.fn_acct_list_test(2,1,0)  --4 sec 
--select * from citrus_usr.fn_acct_list(2,1,0)  --5sec
CREATE function [citrus_usr].[fn_acct_list_vishal](@pa_dpm_id int ,@pa_ent_id int,@pa_child_id int) returns TABLE --@temp   (dpam_id INT,dpam_crn_no NUMERiC,dpam_sba_no varchar(16),dpam_sba_name varchar(100),eff_from datetime,eff_to datetime,acct_type char(1),child_id int,dpam_stam_cd varchar(4))           
as       
   
--      
 
  

 return SELECT dpam.dpam_id ,dpam_crn_no,dpam_sba_no,isnull(dpam_sba_name ,dpam_sba_no)  dpam_sba_name   
     , entr.entr_from_dt eff_from      
     , isnull(entr.entr_to_dt ,'01/01/2900') eff_to   
     , 'P' acct_type      
     , @pa_child_id  child_id
  ,dpam_stam_cd    
  FROM dp_acct_mstr dpam       
  , entity_relationship entr       
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and entr_ar  = case when @pa_child_id <> 0 then  @pa_child_id else entr_ar end

GO
