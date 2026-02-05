-- Object: PROCEDURE citrus_usr.pr_bulk_mod
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_bulk_mod]
as
begin 



declare @c_client_summary cursor 
declare @c_ben_acct_no varchar(16)


declare @L_ADR  varchar(1000)
declare @L_CONC  varchar(1000)
declare @l_crn_no numeric
  
set @c_client_summary  = CURSOR fast_forward FOR                
SELECT DP_ID    FROM ang_modi 
		
		
		
		
		 open @c_client_summary  
          
        fetch next from @c_client_summary into @c_ben_acct_no   
          
          
          
WHILE @@fetch_status = 0                                                                                                          
BEGIN --#cursor                                                                                                          
--  
    select @l_crn_no = dpam_crn_no from dp_acct_mstr where DPAM_SBA_NO = @C_BEN_ACCT_NO
    
    
    update clim
    set clim_dob = CONVERT(datetime,APP_DOB_INCORP,103)
    ,CLIM_LST_UPD_DT = GETDATE()
    ,CLIM_LST_UPD_BY = 'MIG'
    from client_mstr clim , DP_ACCT_MSTR ,ang_modi
    where DPAM_CRN_NO = CLIM_CRN_NO  and dp_id = DPAM_SBA_NO 
    and dp_id = @C_BEN_ACCT_NO
    
    
		
	SET @L_ADR ='' 
	SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_ADD1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_ADD2)),'')
	+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_ADD3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_CITY)),'')+'|*~|'+ISNULL(APP_PER_STATE,'')+ '|*~|'
	+ISNULL(country,'')+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_PINCD)),'')+'|*~|*|~*' 
	FROM   ang_modi WHERE DP_ID = @C_BEN_ACCT_NO 

print @c_ben_acct_no
	print @L_ADR
	EXEC PR_INS_UPD_ADDR @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|','' 
	
	set @l_adr=''

	SELECT @L_CONC =  'MOBILE1|*~|'+ISNULL(LTRIM(RTRIM(APP_MOB_NO)),'')+'*|~*'  
	FROM   ang_modi WHERE DP_ID = @C_BEN_ACCT_NO  

	print @L_CONC
	EXEC PR_INS_UPD_CONC @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  
	set @L_CONC =''


  fetch next from @c_client_summary into @c_ben_acct_no   

end 
close @c_client_summary
deallocate @c_client_summary

end

GO
