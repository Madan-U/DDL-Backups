-- Object: PROCEDURE citrus_usr.pr_check_EmailMobMOD_bak_28062018
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

---pr_check_EmailMobMOD 4,'DORMANT','IN504316',''
create procedure [citrus_usr].[pr_check_EmailMobMOD_bak_28062018](@pa_id numeric,@pa_action varchar(100), @pa_dtls_id VARCHAR(20),@pa_output varchar(8000) output)
as
begin
--print @pa_dtls_id
--print convert(datetime,getdate(),103)
declare @l_me char(1)
if exists(select * from [172.31.16.57].Crmdb_A.dbo.MOBILE_EMAIL_MODI,dp_acct_mstr with(nolock) 
where  DPAM_SBA_NO= '' + @pa_dtls_id + '' and DPAM_DELETED_IND=1)
begin
set @l_me ='M'
end
else
begin
set @l_me =''
end
set @pa_output = @l_me
PRINT @pa_output
end

GO
