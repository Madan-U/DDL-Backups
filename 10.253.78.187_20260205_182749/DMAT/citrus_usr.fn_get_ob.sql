-- Object: FUNCTION citrus_usr.fn_get_ob
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE  function [citrus_usr].[fn_get_ob](@pa_dpam_id numeric)    
returns numeric(18,3)    
as    
begin     
    
return ((select SUM(ldg_amount) from ledger5 where LDG_ACCOUNT_ID = @pa_dpam_id and LDG_DELETED_IND = 1 and LDG_ACCOUNT_TYPE ='P' group by LDG_ACCOUNT_ID ))    
    
end

GO
