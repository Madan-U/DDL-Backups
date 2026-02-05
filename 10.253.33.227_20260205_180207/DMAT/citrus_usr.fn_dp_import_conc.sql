-- Object: FUNCTION citrus_usr.fn_dp_import_conc
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_dp_import_conc](@pa_crn_no   numeric  
                             ,@pa_cd       varchar(25)  
                             )  
RETURNS VARCHAR(1000)   
AS  
--  
BEGIN  
--  
  DECLARE @l_conc_value  VARCHAR(1000)  
         ,@l_email_list  VARCHAR(1000)  
         ,@l_list        VARCHAR(1000)  
   
 
      SELECT @l_conc_value           = conc.conc_value    
      FROM   contact_channels          conc    
            ,entity_adr_conc           entac    
      WHERE  entac.entac_adr_conc_id = conc.conc_id    
      AND    entac_ent_id            = @pa_crn_no  
      AND    entac_concm_cd          = @pa_cd  
      AND    conc.conc_deleted_ind   = 1   
      AND    entac.entac_deleted_ind = 1  
   
    
  
  RETURN @l_conc_value    
--    
END

GO
