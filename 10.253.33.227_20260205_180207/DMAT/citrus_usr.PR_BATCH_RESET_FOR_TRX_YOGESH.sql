-- Object: PROCEDURE citrus_usr.PR_BATCH_RESET_FOR_TRX_YOGESH
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--BEGIN TRAN

--EXEC  [PR_BATCH_RESET_FOR_TRX_YOGESH]  '3484' ,'mAR 15 2018'
--ROLLBACK

CREATE PROC [citrus_usr].[PR_BATCH_RESET_FOR_TRX_YOGESH] 
(@PA_BATCH_NO VARCHAR(10),@PA_REQU_DT DATETIME )

AS 
BEGIN

DECLARE @l_BATCHNO_CDSL_MSTR_COUNT VARCHAR (10)
declare @pa_errmsg varchar (8000)
SELECT @l_BATCHNO_CDSL_MSTR_COUNT = BATCHC_RECORDS  FROM BATCHNO_CDSL_MSTR  WHERE BATCHC_NO = @PA_BATCH_NO 
AND BATCHC_TRANS_TYPE = 'ALL' AND BATCHC_TYPE = 'T'

select  COUNT(1) DISCOUNT INTO  #TEMPDIS from dp_trx_Dtls_cdsl  
where DPTDC_BATCH_NO = @PA_BATCH_NO AND DPTDc_REQUEST_DT = @PA_REQU_DT
UPDATE A SET DIS = DISCOUNT FROM COUNT_FOR_RESET A , #TEMPDIS

select  COUNT(1) DRFCOUNT INTO  #TEMPDRF from demat_Request_mstr  
where demrm_BATCH_NO  = @PA_BATCH_NO AND DEMRM_REQUEST_DT = @PA_REQU_DT
UPDATE A SET DRF = DRFCOUNT FROM COUNT_FOR_RESET A , #TEMPDRF

select  COUNT(1) PLDGCOUNT INTO  #TEMPPLDG from cdsl_pledge_Dtls  
where PLDTC_BATCH_NO = @PA_BATCH_NO AND PLDTC_REQUEST_DT = @PA_REQU_DT
UPDATE A SET PLEDGE = PLDGCOUNT FROM COUNT_FOR_RESET A , #TEMPPLDG

select  COUNT(1) REMATCOUNT INTO  #TEMPREMAT from remat_Request_mstr  
where REMRM_BATCH_NO = @PA_BATCH_NO AND remrm_request_dt = @PA_REQU_DT
UPDATE A SET REMAT = REMATCOUNT FROM COUNT_FOR_RESET A , #TEMPREMAT

DECLARE @l_TOTALCOUNT NUMERIC(10)
SELECT @l_TOTALCOUNT = DIS+DRF+PLEDGE+REMAT FROM COUNT_FOR_RESET

				IF NOT exists (select 1 from  BATCHNO_CDSL_MSTR  WHERE BATCHC_NO = @PA_BATCH_NO AND BATCHC_TRANS_TYPE = 'ALL'
				 AND BATCHC_TYPE = 'T')    
				BEGIN  
			       
				SET @pa_errmsg =  'BATCH NUMBER IS NOT PRESENT IN BATCHNO_CDSL_MSTR TABLE, PLEASE CHECK IN DETAIL'
				select @pa_errmsg       
				RETURN          
				END 
				
				IF EXISTS (SELECT 1 FROM dp_trx_Dtls_cdsl  where DPTDC_BATCH_NO = @PA_BATCH_NO AND DPTDc_REQUEST_DT = @PA_REQU_DT
				 AND (DPTDC_STATUS <> 'P' OR ISNULL(DPTDC_TRANS_NO,'0') <> '0' ))

				BEGIN  			      
				SET @pa_errmsg =  'RESPONSE FILE ALREADY IMPORTED, CAN NOT RESET BATCH'
				select @pa_errmsg       
				RETURN          
				END 
				
				
				IF EXISTS (SELECT 1 FROM BATCHNO_CDSL_MSTR  where BATCHC_NO = @PA_BATCH_NO AND BATCHC_STATUS <> 'P' )

				BEGIN  			       
				SET @pa_errmsg =  'RESPONSE FILE ALREADY IMPORTED, CAN NOT RESET BATCH'
				select @pa_errmsg       
				RETURN          
				END 

				

				IF @l_BATCHNO_CDSL_MSTR_COUNT <> 	@l_TOTALCOUNT	
					BEGIN  
			       
					SET @pa_errmsg =  'BATCH RECORDS ARE NOT MATCHING'
					select @pa_errmsg       
					RETURN          
					END 
			  --IF NOT exists (select 1 from  DP_TRX_DTLS_CDSL WHERE DPTDC_BATCH_NO = @PA_BATCH_NO AND DPTDC_REQUEST_DT = @PA_REQU_DT )    
			  --BEGIN  
			       
			  --SET @pa_errmsg =  'BATCH NUMBER IS NOT PRESENT IN DP_TRX_DTLS_CDSL TABLE, PLEASE CHECK IN DETAIL'
			  -- select @pa_errmsg       
			  --RETURN          
			  --END 
			  
			  --IF NOT exists (select 1 from  DEMAT_REQUEST_MSTR WHERE DEMRM_BATCH_NO = @PA_BATCH_NO AND DEMRM_REQUEST_DT = @PA_REQU_DT )    
			  --BEGIN  
			       
			  --SET @pa_errmsg =  'BATCH NUMBER IS NOT PRESENT IN DEMAT_REQUEST_MSTR TABLE, PLEASE CHECK IN DETAIL'
			  -- select @pa_errmsg       
			  --RETURN          
			  --END 
			  
			  --IF NOT exists (select 1 from  CDSL_PLEDGE_DTLS WHERE PLDTC_BATCH_NO = @PA_BATCH_NO AND PLDTC_REQUEST_DT = @PA_REQU_DT )    
			  --BEGIN  
			       
			  --SET @pa_errmsg =  'BATCH NUMBER IS NOT PRESENT IN CDSL_PLEDGE_DTLS TABLE, PLEASE CHECK IN DETAIL'
			  -- select @pa_errmsg       
			  --RETURN          
			  --END 

			  --IF NOT exists (select 1 from  REMAT_REQUEST_MSTR WHERE REMRM_BATCH_NO = @PA_BATCH_NO AND REMRM_REQUEST_DT = @PA_REQU_DT )    
			  --BEGIN  
			       
			  --SET @pa_errmsg =  'BATCH NUMBER IS NOT PRESENT IN REMAT_REQUEST_MSTR TABLE, PLEASE CHECK IN DETAIL'
			  -- select @pa_errmsg       
			  --RETURN          
			  --END 
				BEGIN 
				UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS = 'C', BATCHC_DELETED_IND = '9' WHERE BATCHC_NO = @PA_BATCH_NO
				AND BATCHC_TRANS_TYPE = 'ALL' AND BATCHC_TYPE = 'T'
			  
				update  dp_trx_Dtls_cdsl   set dptdc_status = 'P', dptdc_batch_no = NULL , dptdc_trans_no = '0'  
				where DPTDC_BATCH_NO = @PA_BATCH_NO AND DPTDc_REQUEST_DT = @PA_REQU_DT
				update  demat_Request_mstr set demrm_status = 'P', demrm_batch_no = NULL , demrm_transaction_no = '0' 
				where demrm_BATCH_NO  = @PA_BATCH_NO AND DEMRM_REQUEST_DT = @PA_REQU_DT
				update  cdsl_pledge_Dtls set pldtc_status = 'P', pldtc_batch_no = NULL , pldtc_trans_no = '0' 
				 where PLDTC_BATCH_NO = @PA_BATCH_NO AND PLDTC_REQUEST_DT = @PA_REQU_DT
				update remat_Request_mstr set remrm_status = 'P', remrm_batch_no = NULL , remrm_transaction_no = '0' 
				where REMRM_BATCH_NO = @PA_BATCH_NO AND remrm_request_dt = @PA_REQU_DT

			  
				SET @pa_errmsg =  'BATCH NUMBER HAS BEEN RESET FOR' +' - ' +CONVERT(VARCHAR,@l_TOTALCOUNT)+'  ' +'RECORDS'
				select @pa_errmsg 
				END 
	
		  
END

GO
