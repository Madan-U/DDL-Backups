-- Object: FUNCTION citrus_usr.fn_addr_value_chkyn
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_addr_value_chkyn](@pa_crn_no   numeric      
                             ,@pa_cd       varchar(25)      
                             ,@pa_chk_yn int 
                             )      
RETURNS VARCHAR(1000)       
AS      
--      
BEGIN      
--      
  DECLARE @l_addr_value  varchar(250)      
  --      
  if @pa_chk_yn = 0
  SELECT @l_addr_value = ISNULL(adr_1,'')+'|*~|'+ISNULL(adr_2,'')+'|*~|'+ISNULL(adr_3,'')+'|*~|'+ISNULL(adr_city,'')+'|*~|'+ISNULL(adr_state,'')+'|*~|'+ISNULL(adr_country,'')+'|*~|'+ISNULL(adr_zip,'')+'|*~|'      
  FROM   addresses         addr        
        ,entity_adr_conc   entac        
  WHERE  entac.entac_adr_conc_id = addr.adr_id        
  AND    entac_ent_id            = @pa_crn_no        
  AND    entac_concm_cd          = @pa_cd       
  --      

  if @pa_chk_yn = 1
  SELECT @l_addr_value = ISNULL(adr_1,'')+'|*~|'+ISNULL(adr_2,'')+'|*~|'+ISNULL(adr_3,'')+'|*~|'+ISNULL(adr_city,'')+'|*~|'+ISNULL(adr_state,'')+'|*~|'+ISNULL(adr_country,'')+'|*~|'+ISNULL(adr_zip,'')+'|*~|'      
  FROM   addresses_mak         addr        
  WHERE  ADR_ENT_ID            = @pa_crn_no        
  AND    ADR_CONCM_CD          = @pa_cd       


  RETURN @l_addr_value      
--        
END

GO
