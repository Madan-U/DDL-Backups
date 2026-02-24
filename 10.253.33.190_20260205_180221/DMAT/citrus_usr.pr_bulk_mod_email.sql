-- Object: PROCEDURE citrus_usr.pr_bulk_mod_email
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_bulk_mod_email]
as
begin 



declare @c_client_summary cursor 
declare @c_ben_acct_no varchar(16)


declare @L_ADR  varchar(1000)
declare @L_CONC  varchar(1000)
declare @l_crn_no numeric
  
set @c_client_summary  = CURSOR fast_forward FOR                
--SELECT [bo id]    FROM email_17042015 where   [dsa]='permanent'
SELECT client_code FROM TMP_SMSMOB_SEP2415 where CLIENT_CODE 
not IN (SELECT ACCP_ACCT_NO FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD='SMS_FLAG') -- 37
and not exists 
(
select dpam_sba_no from DP_ACCT_MSTR,ENTITY_ADR_CONC,contact_channels,CONC_CODE_MSTR WHERE
DPAM_CRN_NO=ENTAC_ENT_ID and ENTAC_ADR_CONC_ID=CONC_ID and ENTAC_CONCM_id=CONCM_id
and CONCM_CD='MOBSMS' and CLIENT_CODE=DPAM_SBA_NO
)		
		
		
		
		 open @c_client_summary  
          
        fetch next from @c_client_summary into @c_ben_acct_no   
          
          
          
WHILE @@fetch_status = 0                                                                                                          
BEGIN --#cursor                                                                                                          
--  
    select @l_crn_no = dpam_crn_no from dp_acct_mstr where DPAM_SBA_NO = @C_BEN_ACCT_NO
    
    
    --update clim
    --set CLIM_LST_UPD_DT = GETDATE()
    --,CLIM_LST_UPD_BY = 'MIG'
    --from client_mstr clim , DP_ACCT_MSTR ,email_17042015
    --where DPAM_CRN_NO = CLIM_CRN_NO  and [bo id] = DPAM_SBA_NO 
    --and [bo id] = @C_BEN_ACCT_NO
    
    
    update clim
    set CLIM_LST_UPD_DT = GETDATE()
    ,CLIM_LST_UPD_BY = 'MIG'
    from client_mstr clim , DP_ACCT_MSTR ,TMP_SMSMOB_SEP2415
    where DPAM_CRN_NO = CLIM_CRN_NO  and CLIENT_CODE = DPAM_SBA_NO 
    and CLIENT_CODE = @C_BEN_ACCT_NO
    
    
		
--	SET @L_ADR ='' 
--	SELECT @L_ADR = 'PER_ADR1|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_ADD1)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_ADD2)),'')
--	+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_ADD3)),'')+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_CITY)),'')+'|*~|'+ISNULL(APP_PER_STATE,'')+ '|*~|'
--	+ISNULL(country,'')+'|*~|'+ISNULL(LTRIM(RTRIM(APP_PER_PINCD)),'')+'|*~|*|~*' 
--	FROM   ang_modi WHERE DP_ID = @C_BEN_ACCT_NO 

--print @c_ben_acct_no
--	print @L_ADR
--	EXEC PR_INS_UPD_ADDR @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_ADR,0,'*|~*','|*~|','' 
	
	set @l_adr=''

	--SELECT @L_CONC =  'EMAIL1|*~|'+ISNULL(LTRIM(RTRIM([CVL Email])),'')+'*|~*'  
	--FROM   email_17042015 WHERE [bo id] = @C_BEN_ACCT_NO  
	

	--SELECT @L_CONC =  'MOBSMS|*~|'+ISNULL(LTRIM(RTRIM([CVL Email])),'')+'*|~*'  
	--FROM   email_17042015 WHERE [bo id] = @C_BEN_ACCT_NO  
	
	SELECT @L_CONC =  'MOBSMS|*~|'+ISNULL(LTRIM(RTRIM([FIRST_HOLD_MOBILE])),'')+'*|~*'  
	FROM   TMP_SMSMOB_SEP2415 WHERE CLIENT_CODE = @C_BEN_ACCT_NO 	

	print @L_CONC
	print @L_CRN_NO
	EXEC PR_INS_UPD_CONC @L_CRN_NO,'EDT','MIG',@L_CRN_NO,'',@L_CONC,0,'*|~*','|*~|',''  
	set @L_CONC =''


  fetch next from @c_client_summary into @c_ben_acct_no   

end 
close @c_client_summary
deallocate @c_client_summary

end

GO
