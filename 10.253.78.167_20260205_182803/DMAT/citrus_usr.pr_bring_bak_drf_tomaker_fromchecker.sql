-- Object: PROCEDURE citrus_usr.pr_bring_bak_drf_tomaker_fromchecker
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  proc [citrus_usr].[pr_bring_bak_drf_tomaker_fromchecker] (@pa_slip_no varchar (50))
 as 
begin
exec drf_backup @pa_slip_no 

declare @pa_errmsg varchar (8000)

IF not exists (select 1 from demrm_mak  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no  )    
 BEGIN  
 
  SET @pa_errmsg =  'MAKER NOT DONE'
   select @pa_errmsg       
  RETURN          
 END  
 
 
 
IF   exists (select 1 from demrm_mak  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no  and DEMRM_DELETED_IND = 0  
AND( DEMRM_INTERNAL_REJ = '' or demrm_res_desc_intobj = '') )    
 BEGIN  
 
  SET @pa_errmsg =  'CHECKER NOT DONE'
   select @pa_errmsg       
  RETURN          
 END  

IF exists (select 1 from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no AND demrm_batch_no is not null and isnull(DEMRM_TRANSACTION_NO ,'') = '')    
 BEGIN  
 print 'yogesh'        
  SET @pa_errmsg =  'BATCH FOR THIS DRF IS ALREADY EXPORTED'
   select @pa_errmsg  msg
   
  RETURN          
 END     

IF exists (select 1 from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no AND demrm_batch_no is not null and isnull(DEMRM_TRANSACTION_NO ,'') <> '' and isnull(DEMRM_ERRMSG,'') = '' )    
 BEGIN  
 print 'yogesh'        
  SET @pa_errmsg =  'BATCH FOR THIS DRF IS ALREADY EXPORTED AND RESPONSE UPLOADED'
   select @pa_errmsg  msg
   
  RETURN          
 END     
  
 
 
 IF exists (select 1 from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no AND isnull(DEMRM_TRANSACTION_NO,'0')<> '' and DEMRM_BATCH_NO is not null )    
 BEGIN       
    
  SET @pa_errmsg =  'DRN ALREADY GENERATED ' 
     
   select @pa_errmsg
  RETURN          
 END  
 
  IF exists (select 1 from demrm_mak  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no AND( DEMRM_INTERNAL_REJ <> '' or demrm_res_desc_intobj <> ''))    
 BEGIN       
    
  SET @pa_errmsg =  'DRF IS ALREADY REJECTED' 
     
   select @pa_errmsg
  RETURN          
 END   



 update  demat_Request_mstr set  DEMRM_BATCH_NO = NULL , DEMRM_INTERNAL_REJ = ''
, DEMRM_ERRMSG = '', DEMRM_STATUS = 'P', DEMRM_TRANSACTION_NO = ''
 where DEMRM_SLIP_SERIAL_NO  = @pa_slip_no
 

update  demrm_mak set DEMRM_LST_UPD_BY=DEMRM_CREATED_BY,
DEMRM_LST_UPD_DT=DEMRM_CREATED_DT,DEMRM_DELETED_IND='0' 
where DEMRM_SLIP_SERIAL_NO = @pa_slip_no and DEMRM_DELETED_IND = '1'

update  demrd_mak set DEMRD_LST_UPD_BY=DEMRD_CREATED_BY,DEMRD_LST_UPD_DT=DEMRD_CREATED_DT,
DEMRD_DELETED_IND='0' where DEMRD_DEMRM_ID in(select demrm_id from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
and DEMRD_DELETED_IND = '1'

update  DEMAT_TRAN_TRANM_DTLS_mak set DEMTTD_LST_UPD_BY = DEMTTD_CREATED_BY,
DEMTTD_LST_UPD_DT =DEMTTD_CREATED_DT ,DEMTTD_DELETED_IND='0' 
 where DEMTTD_DEMRM_ID in(select demrm_id from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
 and DEMTTD_DELETED_IND = '1'





delete from DEMAT_TRAN_TRANM_DTLS where DEMTTD_DEMRM_ID in (select demrm_id from DEMAT_REQUEST_MSTR where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
delete from DEMAT_REQUEST_DTLS  where DEMRD_DEMRM_ID in (select demrm_id from DEMAT_REQUEST_MSTR where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
delete from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no


print 'demrm_mak data'
select * from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no
print 'demrd_mak data'
select * from demrd_mak where DEMRD_DEMRM_ID in 
(select demrm_id from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
print 'DEMAT_TRAN_TRANM_DTLS_mak data'
select * from DEMAT_TRAN_TRANM_DTLS_mak where DEMTTD_DEMRM_ID 
in (select demrm_id from demrm_mak where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)

print 'DEMAT_REQUEST_MSTR data'
select * from DEMAT_REQUEST_MSTR  where DEMRM_SLIP_SERIAL_NO = @pa_slip_no
print 'DEMAT_REQUEST_DTLS data'
select * from DEMAT_REQUEST_DTLS  where DEMRD_DEMRM_ID in 
(select demrm_id from DEMAT_REQUEST_MSTR where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)
print 'DEMAT_TRAN_TRANM_DTLS data'
select * from DEMAT_TRAN_TRANM_DTLS where DEMTTD_DEMRM_ID in 
(select demrm_id from DEMAT_REQUEST_MSTR where DEMRM_SLIP_SERIAL_NO = @pa_slip_no)


end

GO
