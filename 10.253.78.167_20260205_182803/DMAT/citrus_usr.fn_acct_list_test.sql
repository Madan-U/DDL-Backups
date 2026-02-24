-- Object: FUNCTION citrus_usr.fn_acct_list_test
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--select * from citrus_usr.fn_acct_list_test(2,1,0)  --4 sec 
--select * from citrus_usr.fn_acct_list(2,1,0)  --5sec
CREATE function [citrus_usr].[fn_acct_list_test](@pa_dpm_id int ,@pa_ent_id int,@pa_child_id int) returns @temp  TABLE (dpam_id INT,dpam_crn_no NUMERiC,dpam_sba_no varchar(16),dpam_sba_name varchar(100),eff_from datetime,eff_to datetime,acct_type char(1),child_id int,dpam_stam_cd varchar(20))           
as       
begin      
--      
declare @l_entem_col_name varchar(25)      
       ,@l_string         varchar(8000),@l_col_name       VARCHAR(250),@pa_child_name    varchar(250), @l_child_col_name varchar(25)      
      
--declare @temp table (dpam_id INT,dpam_crn_no NUMERIC,dpam_sba_no varchar(16),dpam_sba_name varchar(100),eff_from datetime,eff_to datetime,acct_type char(1),child_id int)       
  
if @pa_child_id =0  
begin  
--  
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,dpam_stam_cd)      
  SELECT dpam.dpam_id ,dpam_crn_no,dpam_sba_no,isnull(dpam_sba_name ,dpam_sba_no)     
     , entr.entr_from_dt       
     , isnull(entr.entr_to_dt ,'01/01/2900')    
     , 'P'      
     , 0  
  ,dpam_stam_cd    
  FROM dp_acct_mstr dpam       
  , entity_relationship entr       
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and dpam.dpam_dpm_id   = 2
  and entr.entr_ho  = 1
   
--  
end  
else   
begin  
--  
  insert into @temp(dpam_id,dpam_crn_no,dpam_sba_no,dpam_sba_name,eff_from,eff_to,acct_type ,child_id,dpam_stam_cd)      
  SELECT dpam.dpam_id ,dpam_crn_no,dpam_sba_no,isnull(dpam_sba_name ,dpam_sba_no)     
     , entr.entr_from_dt       
     , isnull(entr.entr_to_dt ,'01/01/2900')    
     , 'P'      
     , @pa_child_id  
  ,dpam_stam_cd    
  FROM dp_acct_mstr dpam       
  , entity_relationship entr       
  WHERE  entr.entr_sba =  dpam.dpam_sba_no     
  and dpam.dpam_dpm_id   = @pa_dpm_id  
  and entr.entr_ho  = @pa_ent_id      
  and entr.entr_ar  = @pa_child_id   
   
--  
end       
      
 return      
       
end

GO
