-- Object: FUNCTION citrus_usr.fn_addr_value_vendorfilgn
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create function [citrus_usr].[fn_addr_value_vendorfilgn](@pa_crn_no   numeric        
                             ,@pa_cd       varchar(25)        
                             )        
RETURNS VARCHAR(8000)         
AS        
--        
BEGIN        
--        
  DECLARE @l_addr_value  varchar(8000)        
  --        
  set @l_addr_value = ''  
  --SELECT @l_addr_value = IsNull(adr_1,'')+'|*~|'+IsNull(adr_2,'')+'|*~|'+IsNull(adr_3,'')+'-'+IsNull(adr_city,'')+'-'+IsNull(adr_zip,'')+'|*~|'+'|*~|'+IsNull(adr_state,'')+'-'+IsNull(adr_country,'')+'|*~|'   --IsNull(adr_1,'') + ',' + IsNull(adr_2,'')+','+IsNull(adr_3,'')+'|*~|'+IsNull(adr_city,'')+' '+IsNull(adr_state,'')+' '+IsNull(adr_country,'')+' '+IsNull(adr_zip,'')+'|*~|'        
  SELECT @l_addr_value = IsNull(adr_1,'')+'|*~|'+IsNull(adr_2,'')+'|*~|'+IsNull(adr_3,'')+'|*~|'+IsNull(adr_city,'')+'|*~|'+IsNull(adr_state,'')+'|*~|'+IsNull(adr_country,'')+'|*~|'+IsNull(adr_zip,'')   --IsNull(adr_1,'') + ',' + IsNull(adr_2,'')+','+IsNull(adr_3,'')+'|*~|'+IsNull(adr_city,'')+' '+IsNull(adr_state,'')+' '+IsNull(adr_country,'')+' '+IsNull(adr_zip,'')+'|*~|'        
  FROM   addresses         addr          
        ,entity_adr_conc   entac          
  WHERE  entac.entac_adr_conc_id = addr.adr_id          
  AND    entac_ent_id            = @pa_crn_no          
  AND    entac_concm_cd          = @pa_cd   
  and    IsNull(adr_1,'')        <> ''      
  --        
  return @l_addr_value        
--          
END

GO
