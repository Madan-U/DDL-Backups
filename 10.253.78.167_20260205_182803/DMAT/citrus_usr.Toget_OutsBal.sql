-- Object: FUNCTION citrus_usr.Toget_OutsBal
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  function [citrus_usr].[Toget_OutsBal]
(
@pa_boid varchar(16)
)
returns varchar(800)
as
begin
declare @l_rt_val money

--select @l_rt_val= utl_BalanceAmount from utlUploadCSV_temp where utl_BOID=@pa_boid

SELECT @l_rt_val=  SUM(LDG_AMOUNT) 
FROM LEDGER10,DP_ACCT_MSTR WHERE LDG_ACCOUNT_ID=DPAM_ID AND LDG_DELETED_IND=1 AND DPAM_DELETED_IND=1
AND DPAM_SBA_NO=@PA_BOID
 
return @l_rt_val
end

GO
