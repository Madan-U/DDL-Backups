-- Object: PROCEDURE citrus_usr.pr_import_property_acct_new1
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--BEGIN tran  
--exec [pr_import_property_acct_new1] 'BBO_CODE'  
--select max(accp_id) from account_properties --select 15480577+58  --15480635
--select max(accp_id) from accp_mak --752962  
--select 1276+9316--10592  
--rollback
--COMMIT  
--SELECT * FROM ACCOUNT_PROPERTIES WHERE  ACCP_CREATED_DT >= '2016-03-28 17:47:33.253' ORDER BY 1 DESC  
--select DISTINCT accp_clisba_id from account_properties where accp_id > 22016  
--select * into account_properties_baknov082011 from account_properties where accp_id < 21998  
--select * from account_properties where ACCP_ACCPM_PROP_CD = 'bbo_code' order by 9 desc  --select 40103 + 66
--select count(*) from ACCOUNT_properties WITH(NOLOCK) where ACCP_ACCPM_PROP_CD = 'bbo_code' order by 9 desc--SELECT 40103 + 67 --SELECT 40170
  
CREATE  PROCEDURE [citrus_usr].[pr_import_property_acct_new1](@pa_cd VARCHAR(100))  
AS  
BEGIN  
   
declare @c_client_summary1  cursor  
,@c_ben_acct_no1  varchar(20)  
,@L_ACCP_VALUE VARCHAR(8000)  
,@L_dpam_id numeric   
,@L_crn_no numeric   
 
set @c_client_summary1  = CURSOR fast_forward FOR 

--select DISTINCT CONVERT(VARCHAR,CONVERT(NUMERIC,[F2]))     
--from [BBO_CODE] ,  
--     dp_Acct_mstr, account_properties   
--WHERE dpam_sba_no = CONVERT(VARCHAR,CONVERT(NUMERIC,[F2]))   
--and accp_clisba_id = dpam_id   
--AND accp_accpm_prop_Cd = 'BBO_CODE' 
                  
select DISTINCT CONVERT(VARCHAR,CONVERT(NUMERIC,CLIENT_CODE))     from ytemp03022016   
--where NOT EXISTS (select accp_value   
--                  from dp_Acct_mstr, account_properties   
--                  WHERE dpam_sba_no = CONVERT(VARCHAR,CONVERT(NUMERIC,[F2]))   
--                  and accp_clisba_id = dpam_id   
--                  AND accp_accpm_prop_Cd = 'BBO_CODE'
--                  )		and isnull(f2,'')<>''

open @c_client_summary1  
  
fetch next from @c_client_summary1 into @c_ben_acct_no1   
  
  
  
WHILE @@fetch_status = 0                                                                                                          
BEGIN --#cursor                                                                                                          
--  
  PRINT @c_ben_acct_no1
SET @L_ACCP_VALUE       = ''  
  
SELECT DISTINCT @L_ACCP_VALUE = CONVERT(VARCHAR,accpm_PROP_ID) + '|*~|' + CONVERT(VARCHAR(100),TMPCLI_TRADING_ID) + '|*~|*|~*'   
FROM ytemp03022016 ,account_PROPERTY_MSTR    
WHERE CLIENT_CODE  = @c_ben_acct_no1   
AND accpm_prop_CD   = @pa_cd  
  
PRINT @L_ACCP_VALUE   
SET @L_dpam_id = 0   
  
SELECT @L_dpam_id = dpam_id , @L_crn_no = dpam_crn_no FROM dp_acct_mSTR WHERE dpam_sba_no =  @c_ben_acct_no1   
  
    
PRINT @L_crn_no
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
