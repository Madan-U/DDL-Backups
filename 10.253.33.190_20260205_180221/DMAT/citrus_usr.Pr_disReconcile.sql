-- Object: PROCEDURE citrus_usr.Pr_disReconcile
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--SELECT * FROM SLIP_ISSUE_MSTR ORDER BY 1 DESC
--SELECT * FROM TRANSACTION_SUB_TYPE_MSTR WHERE TRASTM_ID = 454
--[Pr_disReconcile] 3,'SEP 23 2014','y',''            
CREATE  proc [citrus_usr].[Pr_disReconcile]              
@pa_excsmid int,                                    
@pa_reconcile_dt datetime,    
@pa_mismatchonly char(1),    
@pa_account varchar(8)             
as              
begin              
  declare @l_dpm_id numeric
  select @l_dpm_id = dpm_id from dp_mstr where dpm_Excsm_id = @pa_excsmid and dpm_excsm_id = default_dp and dpm_deleted_ind = 1 
  PRINT @l_dpm_id
  SELECT * INTO #ASONDISDATA FROM (
  select 'DIS ISSUE' [TYPE],SLIIM_ID ,  SLIIM_DPAM_ACCT_NO
  ,TRASTM_DESC
  ,SLIIM_SERIES_TYPE
  ,SLIIM_SLIP_NO_FR
  ,SLIIM_SLIP_NO_TO 
  ,CONVERT(DATETIME,CONVERT(VARCHAR(11),sliim_dt ,109),109) sliim_dt
  ,SLIIM_SUCCESS_FLAG
  ,SLIIM_ERROR_CODE
  FROM SLIP_ISSUE_MSTR, TRANSACTION_SUB_TYPE_MSTR  WHERE   sliim_dt  IS NOT NULL AND CONVERT(DATETIME,CONVERT(VARCHAR(11),sliim_dt ,109),109) = @pa_reconcile_dt AND SLIIM_DELETED_IND = 1
  AND TRASTM_ID = SLIIM_TRATM_ID
  AND SLIIM_DPM_ID = @l_dpm_id
  UNION ALL 
  select 'DIS ISSUE' [TYPE],SLIIM_ID,SLIIM_DPAM_ACCT_NO
  ,TRASTM_DESC
  ,SLIIM_SERIES_TYPE
  ,SLIIM_SLIP_NO_FR
  ,SLIIM_SLIP_NO_TO 
  ,CONVERT(DATETIME,CONVERT(VARCHAR(11),sliim_dt ,109),109) sliim_dt
  ,SLIIM_SUCCESS_FLAG
  ,SLIIM_ERROR_CODE
  FROM SLIP_ISSUE_MSTR_POA, TRANSACTION_SUB_TYPE_MSTR  WHERE sliim_dt  IS NOT NULL AND CONVERT(DATETIME,CONVERT(VARCHAR(11),sliim_dt ,109),109) = @pa_reconcile_dt AND SLIIM_DELETED_IND = 1
  AND TRASTM_ID = SLIIM_TRATM_ID
  AND SLIIM_DPM_ID = @l_dpm_id
  UNION ALL 
  select 'DIS CANCEL' [TYPE],USES_ID,USES_DPAM_ACCT_NO
  ,TRASTM_DESC
  ,USES_SERIES_TYPE
  ,USES_SLIP_NO
  ,USES_SLIP_NO_to 
  , CONVERT(DATETIME,CONVERT(VARCHAR(11),USES_CANCELLATION_DT ,109),109)  USES_CANCELLATION_DT
  ,USES_SUCCESS_FLAG
  ,USES_ERROR_CODE
  FROM USED_SLIP_BLOCK, TRANSACTION_SUB_TYPE_MSTR  WHERE  CONVERT(DATETIME,CONVERT(VARCHAR(11),USES_CANCELLATION_DT ,109),109)  IS NOT NULL AND USES_CANCELLATION_DT = @pa_reconcile_dt 
  AND USES_DELETED_IND  = 1
  AND TRASTM_ID = USES_TRANTM_ID
  AND USES_DPM_ID = @l_dpm_id )  A 
  
  
  SELECT [TYPE]
  ,SLIIM_DPAM_ACCT_NO ACCT_NO
  ,TRASTM_DESC SLIP_TYPE 
  ,SLIIM_SERIES_TYPE SERIES 
  ,SLIIM_SLIP_NO_FR [FROM]
  ,SLIIM_SLIP_NO_TO [TO]
  ,sliim_dt [ISSUE/CANCEL DATE]
  ,ISNULL(SLIIM_SUCCESS_FLAG ,'') [CDSL STATUS]
  ,ISNULL(SLIIM_ERROR_CODE ,'') [ERROR CODE]
  ,ISNULL(CASE WHEN ISNULL(slibd_batch_no,'') = '' THEN 'N' ELSE 'Y' END ,'') BATCH_GENERATED 
  ,ISNULL(CASE WHEN ISNULL(SLIIM_SUCCESS_FLAG,'') = '' THEN 'N' ELSE 'Y' END ,'') RESPONSE_UPDATED 
  INTO #ALLDATA 
  FROM #ASONDISDATA A 
  LEFT OUTER JOIN sliim_batch_dtls ON slibd_sliim_id = SLIIM_ID 
  
  
  if @pa_mismatchonly = 'M'
  begin 
	SELECT * FROM #ALLDATA  WHERE BATCH_GENERATED ='N' OR RESPONSE_UPDATED ='N'
  end 
  else 
  begin
	SELECT * FROM #ALLDATA  
  end 
  
           
              
end

GO
