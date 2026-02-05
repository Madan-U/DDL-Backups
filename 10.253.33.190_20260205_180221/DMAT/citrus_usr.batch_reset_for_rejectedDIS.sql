-- Object: PROCEDURE citrus_usr.batch_reset_for_rejectedDIS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  proc [citrus_usr].[batch_reset_for_rejectedDIS]
(@slip_no varchar (16))

--begin tran
--exec batch_reset_fot_slip '501565967'

--rollback
as 
begin 
declare @pa_errmsg varchar (8000)
declare @l_batch_no varchar (10)
declare @l_count numeric (10)
select @l_batch_no = dptdc_batch_no from dp_trx_dtls_cdsl where dptdc_slip_no = @slip_no and dptdc_deleted_ind = '1'

exec dis_backup @slip_no

select @l_count = count(1)   from dp_Trx_Dtls_Cdsl where dptdc_slip_no = @slip_no and dptdc_deleted_ind = '1'



				IF NOT exists (select 1 from  BATCHNO_CDSL_MSTR  WHERE BATCHC_NO = @l_batch_no AND BATCHC_TRANS_TYPE = 'ALL'
				 AND BATCHC_TYPE = 'T')    
				BEGIN  
			       
				SET @pa_errmsg =  'BATCH NUMBER IS NOT PRESENT IN BATCHNO_CDSL_MSTR TABLE, PLEASE CHECK IN DETAIL'
				select @pa_errmsg       
				RETURN          
				END 
				
				IF EXISTS (SELECT 1 FROM dp_trx_Dtls_cdsl  where DPTDC_BATCH_NO = @l_batch_no-- AND DPTDc_REQUEST_DT = @PA_REQU_DT
				 AND DPTDC_STATUS = 'S' AND  DPTDC_ERRMSG = '')

				BEGIN  			      
				SET @pa_errmsg =  'SUCCESSFULL RESPONSE IMPORTED, CAN NOT RESET BATCH'
				select @pa_errmsg       
				RETURN          
				END 
				
				
				begin 
				update  dp_Trx_dtls_cdsl set dptdc_batch_no = NULL, 
				DPTDC_TRANS_NO = '0', DPTDC_STATUS = 'P',DPTDC_ERRMSG = ''
				where dptdc_slip_no = @slip_no and dptdc_deleted_ind = '1' and  DPTDC_ERRMSG <> '' and DPTDC_STATUS <> 'P'
				update  batchno_cdsl_mstr set batchc_records = batchc_records-@l_count where batchc_no =  @l_batch_no
				end


end

GO
