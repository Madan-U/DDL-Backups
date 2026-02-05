-- Object: PROCEDURE citrus_usr.pr_import_property_acct_new_EmailStFlag
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--begin tran
--exec pr_import_property_acct_new_EmailStFlag 'SMS_FLAG',''

--SELECT dpam_sba_no  FROM TMP_SEP2815 T,DP_ACCT_MSTR C WHERE T.DPAM_CRN_NO=C.DPAM_CRN_NO AND  NOT EXISTS 
--(SELECT ACCP_ACCT_NO FROM ACCOUNT_PROPERTIES WHERE ACCP_ACCPM_PROP_CD='SMS_FLAG' AND C.DPAM_ID=ACCP_CLISBA_ID AND ACCP_VALUE=1)
--commit
  
CREATE   PROCEDURE [citrus_usr].[pr_import_property_acct_new_EmailStFlag]
(
	@pa_cd VARCHAR(100),
	@pa_errmsg VARCHAR(8000) output
)  
AS  
BEGIN  
   
declare @c_client_summary1  cursor  
,@c_ben_acct_no1  varchar(20)  
,@L_ACCP_VALUE VARCHAR(8000)  
,@L_dpam_id numeric   
,@L_crn_no numeric   
,@l_error BIGINT
,@t_errorstr VARCHAR(8000)
 
set @c_client_summary1  = CURSOR fast_forward FOR 

--select DISTINCT CONVERT(VARCHAR,CONVERT(NUMERIC,[TMP_BOID])) from [BBO_CODE]   
--select boid  from tmp_emailstatflag_Sep182015

select dpam_sba_no from tmp_sep2815_smsflag

open @c_client_summary1  
  
fetch next from @c_client_summary1 into @c_ben_acct_no1   
  
WHILE @@fetch_status = 0                                                                                                          
BEGIN --#cursor                                                                                                          
--  
	SET @L_ACCP_VALUE = ''  
  --print 'pp'
	SELECT DISTINCT @L_ACCP_VALUE = CONVERT(VARCHAR,'42') + '|*~|' + CONVERT(VARCHAR(1),'1') + '|*~|*|~*'   
	FROM tmp_sep2815_smsflag     
	WHERE dpam_sba_no  = @c_ben_acct_no1   
	
	  
	SET @L_dpam_id = 0   
	  
	SELECT @L_dpam_id = dpam_id , @L_crn_no = dpam_crn_no FROM dp_acct_mSTR WHERE dpam_sba_no =  @c_ben_acct_no1   
	  
	--EXEC pr_ins_upd_entp '1','EDT','MIG',@L_dpam_id,'',@L_ACCP_VALUE,'',0,'*|~*','|*~|',''    
	EXEC pr_ins_upd_accp @l_crn_no ,'EDT','MIG',@L_DPAM_ID,@c_ben_acct_no1,'DP',@L_ACCP_value,'' ,0,'*|~*','|*~|',''  
  
	fetch next from @c_client_summary1 into @c_ben_acct_no1   
--  
end  
--  print 'pp1'
close @c_client_summary1    
deallocate  @c_client_summary1    

	SET @l_error = @@error        
		  IF @l_error <> 0        
		  BEGIN        
		  --        
			  SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'        
			RETURN        
		  --        
		  END
		  ELSE
		  BEGIN
			SELECT @t_errorstr = 'UPLOADED SUCCESSFULLY'
		  END
	SET @pa_errmsg = @t_errorstr
END

GO
