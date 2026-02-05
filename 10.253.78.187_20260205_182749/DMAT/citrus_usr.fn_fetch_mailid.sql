-- Object: FUNCTION citrus_usr.fn_fetch_mailid
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

Create function [citrus_usr].[fn_fetch_mailid](@pa_crn_no numeric,@pa_cd varchar(100))
returns varchar(8000) 
as
begin
declare @l_val varchar(8000)

SELECT @l_val = conc.conc_value
      FROM   contact_channels          conc    
            ,entity_adr_conc           entac    
      WHERE  entac.entac_adr_conc_id = conc.conc_id    
      AND    entac_concm_cd          = @pa_cd  
      AND    entac_ent_id            = @pa_crn_no
      AND    conc.conc_deleted_ind   = 1   
      AND    entac.entac_deleted_ind = 1  
return @l_val
end

GO
