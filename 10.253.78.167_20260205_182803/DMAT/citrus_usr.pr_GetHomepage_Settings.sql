-- Object: PROCEDURE citrus_usr.pr_GetHomepage_Settings
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[pr_GetHomepage_Settings]
@pa_login_name    VARCHAR(20)              
,@pa_ent_id        VARCHAR(20)              
,@pa_rol_ids       VARCHAR(200)           
,@pa_ver_no        VARCHAR(20)         
,@rowdelimiter     CHAR(4) = '*|~*'        
,@coldelimiter     CHAR(4) = '|*~|'        
,@pa_ref_cur       VARCHAR(8000) OUTPUT    
as
begin
select top 1 menu_top,menu_left,msgbar_top,msgbar_left,topsection_display 
from Homepage_settings 
where logn_name = @pa_login_name
end

GO
