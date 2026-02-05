-- Object: FUNCTION citrus_usr.fn_chk_app_level_cdsl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



--select citrus_usr.fn_chk_app_level_cdsl (0,2509,'PRASADD','JUN  8 2012')
  
--select [fn_chk_app_level_cdsl] 3,1087,'NARESHG','May 15 2012',''          
CREATE function [citrus_usr].[fn_chk_app_level_cdsl]          
(@pa_id numeric,           
 @pa_dtls_id  numeric ,          
 @pa_loginname varchar (50),          
 @pa_req_dt datetime          
  )          
      
returns varchar(10)    
as 
begin           

declare @pa_output  varchar(10) 
if exists(select dptdc_created_by from dptdc_mak where dptdc_dtls_id = @pa_dtls_id      
and dptdc_deleted_ind in(0,-1) and isnull(dptdc_mid_chk,'') = '')       
and exists(select logn_name from login_names where logn_name = @pa_loginname and isnull(logn_level,'') = 1)      
begin       
      
select @pa_output =  'Y' -- n      
      
end       
      
else if exists(select dptdc_created_by from dptdc_mak where dptdc_dtls_id = @pa_dtls_id      
and dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') <> '')       
and exists(select logn_name from login_names where logn_name = @pa_loginname and isnull(logn_level,'') = 2)      
begin       
      
select @pa_output =  'Y' -- n      
      
end       
else       
begin       
      
select @pa_output = 'N'  -- y      
      
end       
      
      
      
  return @pa_output    
      
      
end       
      
--alter table login_names add logn_level numeric

GO
