-- Object: PROCEDURE citrus_usr.PR_DEMAT_BATCH_RESET
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  PROC [citrus_usr].[PR_DEMAT_BATCH_RESET] 
@PA_BATCH_NO VARCHAR (10)
AS
BEGIN 

declare @pa_errmsg varchar (8000)

	IF not exists (select 1 from DEMAT_REQUEST_MSTR  where DEMRM_batch_no = @PA_BATCH_NO  )    
	 BEGIN  
	 
	  SET @pa_errmsg =  'BATCH NOT FOUND'
	   select @pa_errmsg       
	  RETURN          
	 END  
	 
	 
	 IF exists (select 1 from DEMAT_REQUEST_MSTR  where DEMRM_batch_no = @PA_BATCH_NO AND isnull (DEMRM_TRANSACTION_NO,'')<>'')    
	 BEGIN       
	    
	  SET @pa_errmsg =  'DRN ALREADY GENERATED ' 
	     
	   select @pa_errmsg
	  RETURN          
	 END  
 

	IF  EXISTS(SELECT DEMRM_ID FROM DEMAT_REQUEST_MSTR WHERE DEMRM_batch_no = @PA_BATCH_NO 
	 AND  isnull(DEMRM_status, '') <> 'P' AND DEMRM_deleted_ind = 1)  
			BEGIN 
			UPDATE DEMAT_REQUEST_MSTR SET  DEMRM_BATCH_NO = NULL , DEMRM_STATUS = 'P'
			WHERE DEMRM_BATCH_NO = @PA_BATCH_NO

			UPDATE BATCHNO_CDSL_MSTR SET  BATCHC_STATUS ='C',BATCHC_DELETED_IND = '9' 
			WHERE  BATCHC_NO = @PA_BATCH_NO
			and BATCHC_TRANS_TYPE='ALL'
			END
		

END

GO
