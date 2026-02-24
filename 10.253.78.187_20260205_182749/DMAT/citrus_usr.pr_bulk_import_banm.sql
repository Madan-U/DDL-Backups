-- Object: PROCEDURE citrus_usr.pr_bulk_import_banm
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--BEGIN tran
--[pr_bulk_import_banm]
--rollback
CREATE PROCEDURE [citrus_usr].[pr_bulk_import_banm]
AS
BEGIN
	
declare @c_client_summary1  cursor
,@c_bank_name  varchar(200)
,@c_branch_name  varchar(200)
,@c_ifcs_code  varchar(20)
,@c_banm_micr  varchar(12)

set @c_client_summary1  = CURSOR fast_forward FOR  
select bank_name, branch_name, ifcs_code, banm_micr  from bank_mstr_temp            
open @c_client_summary1
fetch next from @c_client_summary1 into @c_bank_name, @c_branch_name, @c_ifcs_code, @c_banm_micr

WHILE @@fetch_status = 0                                                                                                        
BEGIN --#cursor                                                                                                        
--
exec [pr_mak_banm]  0,'INS','MIG',@c_bank_name,@c_branch_name,@c_banm_micr,@c_ifcs_code,'','',0,0,'',0,'','*|~*','|*~|',''     

fetch next from @c_client_summary1 into @c_bank_name, @c_branch_name, @c_ifcs_code, @c_banm_micr 
--
end

close @c_client_summary1  
deallocate  @c_client_summary1  

END

GO
