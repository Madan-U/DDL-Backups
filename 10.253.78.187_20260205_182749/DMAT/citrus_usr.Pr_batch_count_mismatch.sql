-- Object: PROCEDURE citrus_usr.Pr_batch_count_mismatch
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec [citrus_usr].[Pr_batch_count_mismatch] 'May 11 2020', 'May 11 2020'  , 'HO'
CREATE    proc [citrus_usr].[Pr_batch_count_mismatch] (@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    )
 as 
begin
declare @pa_errmsg varchar (8000)

select  dptdc_batch_no ,  COUNT (DPTDC_ID ) count1  into #temp1   from DP_TRX_DTLS_CDSL  with (nolock) where dptdc_request_dt =@pa_from_dt
and dptdc_deleted_ind in ( 1)
and DPTDC_SLIP_NO like 'E%'
and DPTDC_BATCH_NO  is not null 
group by dptdc_batch_no
 
 
 
 select BATCHC_NO , BATCHC_RECORDS into #temp2    from BATCHNO_CDSL_MSTR  where BATCHC_TRANS_TYPE  = 'ALL'  
 and BATCHC_CREATED_DT  > @pa_from_dt
 
 --declare @count varchar (103)
 
 --select @count = DPTDC_BATCH_NO   from #temp1 , #temp2
 --where DPTDC_BATCH_NO = BATCHC_NO
 --and count1 <> BATCHC_RECORDS
 
 if not  exists (select 1  from #temp1 , #temp2
 where DPTDC_BATCH_NO = BATCHC_NO
 and count1 <> BATCHC_RECORDS )
 begin 
 SET @pa_errmsg =  'NO MISMATCH FOUND'
   select @pa_errmsg       
  RETURN    
 end 
 if exists (select 1  from #temp1 , #temp2
 where DPTDC_BATCH_NO = BATCHC_NO
 and count1 <> BATCHC_RECORDS )
 begin 
 SET @pa_errmsg =  'MIMSATCH FOUND , PLEASE CONTACT ADMINISTRATOR'
   select @pa_errmsg       
  RETURN    
  
  
  end 
  end

GO
