-- Object: PROCEDURE citrus_usr.pr_import_property_acct
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--select * from account_properties where accp_accpm_prop_cd='SMS_FLAG'
--BEGIN tran      
--exec [pr_import_property_acct] 'ECN_FLAG'     
--select top 100 * from account_properties order by 1 desc 
--rollback
CREATE PROCEDURE [citrus_usr].[pr_import_property_acct](@pa_cd VARCHAR(100))      
AS      
BEGIN      
       
declare @c_client_summary1  cursor      
,@c_ben_acct_no1  varchar(20)      
,@L_ACCP_VALUE VARCHAR(8000)      
,@L_dpam_id numeric       
,@L_crn_no numeric       
      
set @c_client_summary1  = CURSOR fast_forward FOR                    
select   CLIENT_CODE  from ecn_data_11062016 


open @c_client_summary1      
      
fetch next from @c_client_summary1 into @c_ben_acct_no1       
      
      
      
WHILE @@fetch_status = 0                                                                                                              
BEGIN --#cursor                                                                                                              
--      
      
SET @L_ACCP_VALUE       = ''      
      
SELECT DISTINCT @L_ACCP_VALUE = CONVERT(VARCHAR,'62') + '|*~|' 
+ ltrim(rtrim(case when [ECN Flag as per BO] ='ecn' then 'YES' else 'NO' end )) + '|*~|*|~*'       
FROM  ecn_data_11062016 -- ,account_PROPERTY_MSTR
where  client_code   = @c_ben_acct_no1       
--AND accpm_prop_CD   = @pa_cd  
    
      
SET @L_dpam_id = 0       
      
SELECT @L_dpam_id = dpam_id , @L_crn_no = dpam_crn_no FROM dp_acct_mSTR WHERE dpam_sba_no =  @c_ben_acct_no1       
      
        
PRINT @L_ACCP_VALUE       
print @L_dpam_id      
--EXEC pr_ins_upd_entp '1','EDT','MIG',@L_dpam_id,'',@L_ACCP_VALUE,'',0,'*|~*','|*~|',''        
EXEC pr_ins_upd_accp @l_crn_no ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no1,'DP',@L_ACCP_value,'' ,0,'*|~*','|*~|',''      
      
      
fetch next from @c_client_summary1 into @c_ben_acct_no1       
      
      
--      
end      
      
close @c_client_summary1        
deallocate  @c_client_summary1        
      
END

GO
