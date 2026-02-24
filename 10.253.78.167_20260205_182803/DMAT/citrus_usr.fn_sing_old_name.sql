-- Object: FUNCTION citrus_usr.fn_sing_old_name
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

cREATE function [citrus_usr].[fn_sing_old_name]
(@pa_dpam_sba_no     varchar(16))    

RETURNS VARCHAR(50)    

AS    
BEGIN    
  
  DECLARE  @l_accp_value           VARCHAR(135)    
 
  SELECT  @l_accp_value            = signame     
  FROM   OLD_SIGN_NAME          
  WHERE  boid       = @pa_dpam_sba_no    
 
  
 RETURN ISNULL(CONVERT(VARCHAR(50), @l_accp_value),'')      

END

GO
