-- Object: FUNCTION citrus_usr.FN_POATYPE_new
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



Create FUNCTION [citrus_usr].[FN_POATYPE_new](@pA_BOID VARCHAR(16),@PA_MASTER VARCHAR(16))
RETURNS VARCHAR(100) 
AS
BEGIN 




declare @l_poa_type varchar(100)
set @l_poa_type =''
select @l_poa_type = @l_poa_type  + GPABPAFlg  +'/'  from (select distinct GPABPAFlg FROM dps8_pc5  , DP_ACCT_MSTR 
WHERE boid = DPAM_SBA_NO  AND DPAM_SBA_NO = @pA_BOID
AND MasterPOAId   = @PA_MASTER ) a 

RETURN(@l_poa_type)


END

GO
