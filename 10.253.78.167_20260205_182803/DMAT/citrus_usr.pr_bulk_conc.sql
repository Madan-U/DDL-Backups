-- Object: PROCEDURE citrus_usr.pr_bulk_conc
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  proc [citrus_usr].[pr_bulk_conc]
as
begin
declare @c_client_summary1  cursor
,@c_ben_acct_no1  varchar(20)
declare @L_CONC varchar(1000)
,@l_crn_no numeric

set @c_client_summary1  = CURSOR fast_forward FOR              
select a ,dpam_crn_no    from tmpsms_formig ,dp_acct_mstr where a= dpam_sba_no
and b <> ''
open @c_client_summary1

fetch next from @c_client_summary1 into @c_ben_acct_no1 ,@l_crn_no



WHILE @@fetch_status = 0                                                                                                        
BEGIN --#cursor                                                                                                        
--


SELECT @L_CONC = @L_CONC  +'MOBSMS|*~|'+ISNULL(ltrim(rtrim(b)),'')+'*|~*' 
FROM   tmpsms_formig WHERE a = @C_BEN_ACCT_NO1  
and b <> ''


print @L_CONC

EXEC PR_INS_UPD_CONC @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  
set @L_CONC =''
set @L_CRN_NO ='0'


fetch next from @c_client_summary1 into @c_ben_acct_no1 ,@l_crn_no


--
end

close @c_client_summary1  
deallocate  @c_client_summary1  


end 

--create index ix_1 on tmpsms_formig(a)

GO
