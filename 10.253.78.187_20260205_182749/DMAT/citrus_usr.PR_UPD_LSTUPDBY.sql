-- Object: PROCEDURE citrus_usr.PR_UPD_LSTUPDBY
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--- EXEC PR_UPD_LSTUPDBY '503076446', 'E19709'

CREATE   PROCEDURE [citrus_usr].[PR_UPD_LSTUPDBY]
(@pa_slip_no varchar (50), @PA_LSTUPDBY varchar (50))
AS
BEGIN 

DECLARE @L_DELETED_IND VARCHAR(2) 
SELECT @L_DELETED_IND = DPTDC_DELETED_IND FROM DPTDC_MAK WHERE DPTDC_SLIP_NO = @pa_slip_no
PRINT @L_DELETED_IND

declare @pa_errmsg varchar (8000)


  IF NOT exists (select 1 from LOGIN_NAMES  where LOGN_NAME = @PA_LSTUPDBY )    
 BEGIN  
       
  SET @pa_errmsg =  'LOGIN ID NOT EXISTS'
   select @pa_errmsg       
  RETURN          
 END 

IF exists (select 1 from DPTDC_MAK  where dptdc_slip_no = @pa_slip_no AND DPTDC_DELETED_IND = '-1')    
 BEGIN  
       
  SET @pa_errmsg =  'CHECKER NOT YET DONE'
   select @pa_errmsg       
  RETURN          
 END 

IF exists (select 1 from dp_trx_Dtls_Cdsl  where dptdc_slip_no = @pa_slip_no AND DPTDC_batch_no is not null)    
 BEGIN  
       
  SET @pa_errmsg =  'BATCH FOR THIS DIS IS ALREADY EXPORTED '
   select @pa_errmsg       
  RETURN          
 END 
 
 
 IF exists (select 1 from dptdc_mak  where dptdc_slip_no = @pa_slip_no
  AND dptdc_deleted_ind in (0) AND DPTDC_MID_CHK <> '')    
 BEGIN  
       
  SET @pa_errmsg =  'VERIFIER IS ALREADY UPDATED'
   select @pa_errmsg       
  RETURN          
 END 
 
  
	IF @L_DELETED_IND = '1' 
	BEGIN 
	update  dptdc_mak set dptdc_lst_upd_by = @PA_LSTUPDBY where dptdc_slip_no = @pa_slip_no
	AND dptdc_lst_upd_by = '' AND DPTDC_DELETED_IND = '1' 
	update  dp_trx_Dtls_Cdsl set dptdc_lst_upd_by = @PA_LSTUPDBY  where dptdc_slip_no = @pa_slip_no
	AND dptdc_lst_upd_by = '' AND DPTDC_DELETED_IND = '1' 

	END

	IF @L_DELETED_IND = '0' 
	BEGIN 
	update  dptdc_mak set dptdc_lst_upd_by = @PA_LSTUPDBY , DPTDC_MID_CHK = @PA_LSTUPDBY where dptdc_slip_no = @pa_slip_no
	AND dptdc_lst_upd_by = '' AND DPTDC_DELETED_IND = '0' AND  DPTDC_MID_CHK = ''
	 
	END
	
	
	SELECT * FROM DPTDC_MAK  WHERE DPTDC_SLIP_NO = @pa_slip_no
SELECT * FROM dp_trx_dtls_cdsl WHERE DPTDC_SLIP_NO =@pa_slip_no

 
 END

GO
