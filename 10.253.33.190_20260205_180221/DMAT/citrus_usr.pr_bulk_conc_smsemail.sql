-- Object: PROCEDURE citrus_usr.pr_bulk_conc_smsemail
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  proc [citrus_usr].[pr_bulk_conc_smsemail]
as
begin
declare @c_client_summary1  cursor
,@c_ben_acct_no1  varchar(20)
declare @L_CONC varchar(1000)
,@l_crn_no numeric

set @c_client_summary1  = CURSOR fast_forward FOR              
select boid ,dpam_crn_no    from dps8_pc16 with(nolock),dp_acct_mstr with(nolock) where boid= dpam_sba_no
and MobileNum <> ''
open @c_client_summary1

fetch next from @c_client_summary1 into @c_ben_acct_no1 ,@l_crn_no



WHILE @@fetch_status = 0                                                                                                        
BEGIN --#cursor                                                                                                        
--


SELECT @L_CONC = @L_CONC  +'MOBSMS|*~|'+ISNULL(ltrim(rtrim(MobileNum)),'')+'*|~*' 
FROM   dps8_pc16 with(nolock) WHERE boid = @C_BEN_ACCT_NO1  
and MobileNum <> ''


SELECT @L_CONC = @L_CONC  +'SMSEMAIL|*~|'+ISNULL(ltrim(rtrim(EmailId)),'')+'*|~*' 
FROM   dps8_pc16 with(nolock) WHERE boid = @C_BEN_ACCT_NO1  
and EmailId <> ''


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
