-- Object: FUNCTION citrus_usr.fn_acct_conc_value
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_acct_conc_value](@pa_clisba_id numeric, @pa_cd varchar(50))    
returns varchar(150)    
as    
begin    
declare @l_temp varchar(150)    
      
select @l_temp  = conc_value from account_adr_conc     
, contact_channels     
, conc_code_mstr     
where accac_concm_id = concm_id     
and accac_adr_conc_id = conc_id     
and accac_clisba_id = @pa_clisba_id    
and concm_cd = @pa_cd    
and concm_deleted_ind = 1    
and conc_deleted_ind = 1    
and accac_deleted_ind = 1    
    
    
return @l_temp    
end

GO
