-- Object: FUNCTION citrus_usr.fn_get_poa_name
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



create function [citrus_usr].[fn_get_poa_name] (@pa_sba_no varchar(100))  
returns varchar(1000)  
as  
begin   
  
DECLARE @L_PODID VARCHAR(8000)  
SET @L_PODID =''  
SELECT  @L_PODID  = @L_PODID  + dpam_sba_name +'/' 
from (select distinct MasterPOAId FROM DPS8_PC5 
WHERE BOID =@pa_sba_no and TypeOfTrans<>'3'
)  a  ,poam 
where MasterPOAId = poam_master_id
  
  
return @L_PODID   
  
end

GO
