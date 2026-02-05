-- Object: PROCEDURE citrus_usr.pr_check_dormant_bakMar92021
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

---pr_check_dormant 4,'DORMANT','IN504316',''
CReate procedure [citrus_usr].[pr_check_dormant_bakMar92021](@pa_id numeric,@pa_action varchar(100), @pa_dtls_id VARCHAR(20),@pa_output varchar(8000) output)
as
begin
print @pa_dtls_id
print convert(datetime,getdate(),103)
if @pa_action = 'DORMANT'
set @pa_output = citrus_usr.fn_get_high_val('',0,'DORMANT',@pa_dtls_id,convert(datetime,getdate(),103))
PRINT @pa_output
end

GO
