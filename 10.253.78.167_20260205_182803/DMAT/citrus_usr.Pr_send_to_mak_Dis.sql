-- Object: PROCEDURE citrus_usr.Pr_send_to_mak_Dis
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  PROCEDURE [citrus_usr].[Pr_send_to_mak_Dis] 
( @pa_dpm_id  varchar (1),  @pa_slip_no varchar(20),@pa_out varchar (8000))

as 

begin 
EXEC DIS_BACKUP @PA_SLIP_NO, 'BRING BACK TO MAKER'

--SELECT * FROM DPTDC_MAK  WHERE DPTDC_SLIP_NO = @pa_slip_no
--SELECT * FROM dp_trx_dtls_cdsl WHERE DPTDC_SLIP_NO =@pa_slip_no

Declare @pa_errmsg varchar (8000)
SET @PA_ERRMSG ='ACTION SUCCESSFULLY DONE' 
DECLARE @L_DELETED_IND VARCHAR(2) 
SELECT @L_DELETED_IND = DPTDC_DELETED_IND FROM DPTDC_MAK WHERE DPTDC_SLIP_NO = @pa_slip_no and dptdc_deleted_ind not in ( '2')
DECLARE @L_mid_chk VARCHAR(15) 
SELECT @L_mid_chk = DPTDC_MID_CHK FROM DPTDC_MAK WHERE DPTDC_SLIP_NO = @pa_slip_no and dptdc_deleted_ind  not in ( '2')


print @L_DELETED_IND
print @L_mid_chk

IF not exists (select 1 from dptdc_mak  where dptdc_slip_no = @pa_slip_no  )    
 BEGIN  
       
  SET @pa_errmsg =  'DIS NOT FOUND'
   select @pa_errmsg     msg  
  RETURN          
 END 


 IF exists (select 1 from dptdc_mak   where dptdc_slip_no = @pa_slip_no AND Isnull(dptdc_res_desc,'') <> '' 
 and isnull(dptdc_res_cd,'') <> '' and DPTDC_DELETED_IND = '0')    
 BEGIN  
       
  SET @pa_errmsg =  'DIS is rejected, Can not process'
   select @pa_errmsg        msg
  RETURN          
 END 

IF exists (select 1 from DPTDC_MAK  where dptdc_slip_no = @pa_slip_no AND DPTDC_DELETED_IND in ( '-1') )    
 BEGIN  
       
  SET @pa_errmsg =  'CHECKER NOT YET DONE'
   select @pa_errmsg    msg    
  RETURN          
 END 
 
 
 IF exists (select 1 from dp_trx_Dtls_Cdsl  where dptdc_slip_no = @pa_slip_no AND DPTDC_batch_no is not null and isnull(DPTDC_ERRMSG,'') = '')    
 BEGIN  
       
  SET @pa_errmsg =  'BATCH FOR THIS DIS IS ALREADY EXPORTED '
   select @pa_errmsg      msg  
  RETURN          
 END 
 
 
 
		IF @L_DELETED_IND = '1'  and @L_mid_chk is not null 
		begin 
		print 'here'

		UPDATE  DPTDC_MAK 
		SET DPTDC_LST_UPD_BY = DPTDC_CREATED_BY ,DPTDC_LST_UPD_DT = DPTDC_CREATED_DT ,DPTDC_DELETED_IND = '-1',dptdc_mid_chk = NULL
		WHERE DPTDC_SLIP_NO = @pa_slip_no and DPTDC_DELETED_IND = 1 
		DELETE FROM DP_TRX_DTLS_CDSL  WHERE DPTDC_SLIP_NO = @pa_slip_no

		end 


		IF @L_DELETED_IND = '1'  and @L_mid_chk is null 
		begin 

		UPDATE  DPTDC_MAK 
		SET DPTDC_LST_UPD_BY = DPTDC_CREATED_BY ,DPTDC_LST_UPD_DT = DPTDC_CREATED_DT ,DPTDC_DELETED_IND = '0'--,dptdc_mid_chk = ''
		WHERE DPTDC_SLIP_NO = @pa_slip_no and DPTDC_DELETED_IND = 1 
		DELETE FROM DP_TRX_DTLS_CDSL  WHERE DPTDC_SLIP_NO = @pa_slip_no

		end 


		IF @L_DELETED_IND = '0'  and @L_mid_chk is not null 
		begin 

		UPDATE  DPTDC_MAK 
		SET DPTDC_LST_UPD_BY = DPTDC_CREATED_BY ,DPTDC_LST_UPD_DT = DPTDC_CREATED_DT ,DPTDC_DELETED_IND = '-1',dptdc_mid_chk = NULL 
		WHERE DPTDC_SLIP_NO = @pa_slip_no and DPTDC_DELETED_IND = 0 
		--DELETE FROM DP_TRX_DTLS_CDSL  WHERE DPTDC_SLIP_NO = @pa_slip_no

		end 

		--SELECT * FROM DPTDC_MAK  WHERE DPTDC_SLIP_NO = @pa_slip_no
		--SELECT * FROM dp_trx_dtls_cdsl WHERE DPTDC_SLIP_NO =@pa_slip_no

		select @pa_errmsg  msg

end

GO
