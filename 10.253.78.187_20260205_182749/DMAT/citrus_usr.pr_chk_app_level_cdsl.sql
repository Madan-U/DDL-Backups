-- Object: PROCEDURE citrus_usr.pr_chk_app_level_cdsl
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_chk_app_lmt_nsdl 3,530,'AMOLP','Dec 09 2011',''        
create procedure [citrus_usr].[pr_chk_app_level_cdsl]        
(@pa_id numeric,         
 @pa_dtls_id  numeric ,        
 @pa_loginname varchar (50),        
 @pa_req_dt datetime,        
 @pa_output  varchar(8000) output )        
as         
begin         
    
     
if exists(select dptdc_created_by from dptdc_mak where dptdc_dtls_id = @pa_dtls_id    
and dptdc_deleted_ind in (0,-1) and isnull(dptdc_mid_chk,'') = '')     
and exists(select logn_name from login_names where logn_name = @pa_loginname and isnull(logn_level,'') = 1)    
begin     
    
select @pa_output = 'Y' -- n    
    
end     
else if exists(select dptdc_created_by from dptdc_mak where dptdc_dtls_id = @pa_dtls_id    
and dptdc_deleted_ind = 0 and isnull(dptdc_mid_chk,'') <> '')     
and exists(select logn_name from login_names where logn_name = @pa_loginname and isnull(logn_level,'') = 2)    
or   
exists(select dptdc_created_by from dptdc_mak where dptdc_dtls_id = @pa_dtls_id    
and dptdc_deleted_ind IN (0,-1) and isnull(dptdc_mid_chk,'') = ''
GROUP BY  dptdc_created_by
HAVING  SUM(dptdc_deleted_ind) = 0   ) 
and exists(select logn_name from login_names where logn_name = @pa_loginname and isnull(logn_level,'') = 2)    
begin     
    
select @pa_output =  'Y' -- n    
    
end     
else     
begin     
    
select @pa_output = 'N'  -- y    
    
end     
    
    
    
    
    
    
end     
    
--alter table login_names add logn_level numeric

GO
