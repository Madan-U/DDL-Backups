-- Object: PROCEDURE citrus_usr.pr_import_property_Disflag
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--BEGIN tran  
--exec [pr_import_property_entity] 'pan_gir_no'
--exec [pr_import_property_entity] 'CERTVALIDFROMDT'
--exec [pr_import_property_entity] 'CERTVALIDTODT'
--exec [pr_import_property_entity] 'OWNER'
--exec [pr_import_property_Disflag] 'DIS_REQ'
--rollback
--COMMIT  
--select * from entity_properties where ENTP_ENTPM_CD='DIS_REQ' order by 1 desc --select 52082 + 427 -- 52509
--select * from ACCOUNT_properties WITH(NOLOCK) where ACCP_ACCPM_PROP_CD = 'CMBPEXCH' --SELECT 25 + 8 --SELECT 38926

CREATE PROCEDURE [citrus_usr].[pr_import_property_Disflag](@pa_cd VARCHAR(100))  
AS  
BEGIN  
   
declare @c_client_summary1  cursor  
,@c_ben_acct_no1  varchar(20) ,@c_ben_acct_no2 varchar(20) 
,@L_ACCP_VALUE VARCHAR(8000)  
,@L_dpam_id numeric   
,@L_crn_no numeric   
 
set @c_client_summary1  = CURSOR fast_forward FOR

Select dpam_sba_no from TEMPMISSING_DISFLAG
--select  [BO code as per DP class], isnull(add1,'') + '|*~|' +isnull(add2,'') + '|*~|' + isnull(add3,'') + '|*~|' + isnull(city,'') + '|*~|'+ '|*~|'+ isnull(pin,'') +  '|*~|' + '*|~*' 
-- from tmp_entbr_mstr where [BO code as per DP class] in (
--select entm_short_name from entity_mstr where entm_short_name=[BO code as per DP class]
--AND ENTM_ENTTM_CD= 'BR'
--) and isnull([BR code as per DP],'')<>''
--and [BO code as per DP class]<>'Mapping to be done'
--and isnull(add1,'')<>''
--

--and accp_clisba_id = dpam_id   
--AND accp_accpm_prop_Cd = 'CMBPEXCH'
                  
/*select DISTINCT CONVERT(VARCHAR,CONVERT(NUMERIC,[F2]))     from [BBO_CODE]   
where NOT EXISTS (select accp_value   
                  from dp_Acct_mstr, account_properties   
                  WHERE dpam_sba_no = CONVERT(VARCHAR,CONVERT(NUMERIC,[F2]))   
                  and accp_clisba_id = dpam_id   
                  AND accp_accpm_prop_Cd = 'BBO_CODE' 
                  ) */ 

open @c_client_summary1  
  
fetch next from @c_client_summary1 into @c_ben_acct_no1 -- ,@c_ben_acct_no2 
  
  
  
WHILE @@fetch_status = 0                                                                                                          
BEGIN --#cursor                                                                                                          
--  
    PRINT @c_ben_acct_no1
	SET @L_ACCP_VALUE       = ''  
  
	SELECT DISTINCT @L_ACCP_VALUE = CONVERT(VARCHAR,entpm_PROP_ID) + '|*~|' 
	+ ltrim(rtrim(disflag))
	+ '|*~|*|~*'   
	FROM TEMPMISSING_DISFLAG ,entity_PROPERTY_MSTR    
	WHERE dpam_sba_no  = @c_ben_acct_no1   
	AND ENTPM_cd   = @pa_cd  
	  
PRINT @L_ACCP_VALUE   
SET @L_dpam_id = 0   
  
SELECT @L_dpam_id = dpam_crn_no   FROM dp_acct_mstr WHERE dpam_sba_no  =  @c_ben_acct_no1   
  
    
PRINT @L_crn_no
print @L_dpam_id  

EXEC pr_ins_upd_entp '1','EDT','MIG',@L_dpam_id,'',@L_ACCP_VALUE,'',0,'*|~*','|*~|',''  
  
--EXEC pr_ins_upd_accp @l_crn_no ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no1,'DP',@L_ACCP_value,'' ,0,'*|~*','|*~|',''  
  
  
fetch next from @c_client_summary1 into @c_ben_acct_no1  --,@c_ben_acct_no2  
  
--  
end  
  
close @c_client_summary1    
deallocate  @c_client_summary1    
  
END

GO
