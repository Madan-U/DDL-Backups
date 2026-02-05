-- Object: FUNCTION citrus_usr.fn_get_ledger
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_get_ledger](@pa_dpam_id varchar(16))
returns  varchar(1000)
as 
begin 

 declare @l_ledger varchar(1000)
 declare @l_fin_yr numeric

select @l_fin_yr = FIN_ID from financial_yr_mstr where getdate() between FIN_START_DT and FIN_END_DT

declare @l_sql varchar(8000)
set @l_sql  = ''
set @l_sql  = 'select sum(ldg_amount) from ledger'+convert(varchar,@l_fin_yr)
set @l_sql  = @l_sql  + ' dp_acct_mstr where ldg_deleted_ind = 1 ldg_account_id = dpam_id and dpam_id = ' + @pa_dpam_id 

--exec (@l_sql) 

set @l_ledger = @l_sql
return @l_ledger  



end

GO
