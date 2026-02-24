-- Object: PROCEDURE citrus_usr.pr_check_EmailMobMOD
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

---pr_check_EmailMobMOD 4,'DORMANT','IN504316',''
CREATE procedure [citrus_usr].[pr_check_EmailMobMOD](@pa_id numeric,@pa_action varchar(100), @pa_dtls_id VARCHAR(20),@pa_output varchar(8000) output)
as
begin
--print @pa_dtls_id
--print convert(datetime,getdate(),103)
declare @l_me char(1)
if exists(select 1 from ABVSCITRUS.Crmdb_A.dbo.MOBILE_EMAIL_MODI,dp_acct_mstr with(nolock) where  
DPAM_SBA_NO= '' + @pa_dtls_id + '' and DPAM_DELETED_IND=1 and DPAM_BBO_CODE=BO_PARTYCODE
union
select 1 from client_list_modified where clic_mod_action in ('FIRST EMAILID','FIRST MOBILENO','MOBILE SMS')
and clic_mod_deleted_ind=1 and clic_mod_DPAM_SBA_NO= '' + @pa_dtls_id + '' 
and convert (varchar(11),clic_mod_created_dt,103) between convert(varchar(11),getdate(),103)
 and convert(varchar(11),dateadd(month,-6,getdate()),103)
)
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
