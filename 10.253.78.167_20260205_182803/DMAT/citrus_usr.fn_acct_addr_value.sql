-- Object: FUNCTION citrus_usr.fn_acct_addr_value
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_acct_addr_value](@pa_clisba_id  numeric      
                             ,@pa_cd       varchar(25)      
                             )      
RETURNS VARCHAR(8000)       
AS      
--      
BEGIN      
--      
  DECLARE @l_addr_value  varchar(8000)      
  --    
  set  @l_addr_value = ''    
  SELECT @l_addr_value =  IsNull(ltrim(rtrim(adr_1)),'')+'|*~|'+IsNull(ltrim(rtrim(adr_2)),'')+'|*~|'+IsNull(ltrim(rtrim(adr_3)),'')+'|*~|'+IsNull(ltrim(rtrim(adr_city)),'')+'|*~|'+IsNull(ltrim(rtrim(adr_state)),'')+'|*~|'+IsNull(ltrim(rtrim(adr_country)),'')+'|*~|'+IsNull(ltrim(rtrim(adr_zip)),'')+'|*~|'      
  FROM   addresses         addr        
        ,account_adr_conc   accac    
        , conc_code_mstr         
  WHERE  accac.accac_adr_conc_id = addr.adr_id        
  AND    accac_clisba_id         = @pa_clisba_id        
  AND    accac_concm_id          = concm_id     
  AND    concm_cd                = @pa_cd 
  and    adr_1                   <> ''      -- and convert(varchar(11),ADR_lst_upd_DT,109)='apr  1 2015'
  --      
  return @l_addr_value      
--        
END      
    
--select * from account_adr_conc

GO
