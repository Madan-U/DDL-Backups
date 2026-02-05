-- Object: PROCEDURE citrus_usr.pr_select_coum
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_select_coum](@pa_coum_no varchar(50),@pa_action varchar(50),@pa_ref_cur varchar(8000)out)    
as    
begin    
if @pa_action='Search'  
select coum_id    
,coum_no    
from courier_mstr    
where coum_deleted_ind = 1   
end  
  
begin  
if @pa_action='Select'  
select coum_id    
,coum_no    
,Isnull(coum_adr1,'')  coum_adr1    
,Isnull(coum_adr2,'')  coum_adr2  
,Isnull(coum_adr3,'')  coum_adr3    
,Isnull(coum_adr3,'')  coum_adr_city    
,Isnull(coum_adr_state,'')  coum_adr_state    
,Isnull(coum_adr_country,'')  coum_adr_country    
,Isnull(coum_adr_zip,'')  coum_adr_zip    
,Isnull(coum_cont_per,'')  coum_cont_per    
,Isnull(coum_off_ph1,'')  coum_off_ph1    
,Isnull(coum_off_ph2,'')  coum_off_ph2    
,Isnull(coum_off_fax1,'')  coum_off_fax1    
,Isnull(coum_off_fax2,'')  coum_off_fax2    
,Isnull(coum_res_ph1,'')  coum_res_ph1    
,Isnull(coum_res_ph2,'')  coum_res_ph2    
,Isnull(coum_mobile,'')  coum_mobile    
,Isnull(coum_email,'')  coum_email    
,Isnull(coum_rmks,'')  coum_rmks from courier_mstr    
where coum_deleted_ind = 1    
and   coum_no = @pa_coum_no  
end

GO
