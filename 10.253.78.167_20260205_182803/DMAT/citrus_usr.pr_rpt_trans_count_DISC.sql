-- Object: PROCEDURE citrus_usr.pr_rpt_trans_count_DISC
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

   
CREATE procedure [citrus_usr].[pr_rpt_trans_count_DISC](  
 @pa_excsm_id int  
,@pa_tab varchar(10)  
,@pa_request_dt varchar(11)  
,@pa_request_todt varchar(11)  
,@pa_exchange varchar(10)  
,@pa_type char(20)  
)    
as    
begin    
--    
  declare @dpm_id numeric    
    
  select @dpm_id = dpm_id from dp_mstr where default_dp = @pa_excsm_id and dpm_deleted_ind = 1    
    create table #tmp (dis_cnt varchar(50),dic_cnt varchar(50))    
   if citrus_usr.FN_SPLITVAL_BY(@pa_type,2,'|')   ='I'   
    begin   
      
       
   insert into #tmp  
   Select COUNT(sliim_id),'0' from slip_issue_mstr where SLIIM_DELETED_IND=1  
   and sliim_dt> =@pa_request_dt and sliim_dt<=@pa_request_todt  
   and SLIIM_ID not in (select slibd_sliim_id from sliim_batch_dtls where slibd_deleted_ind=1   
   and slibd_DIS_type=citrus_usr.FN_SPLITVAL_BY(@pa_type,2,'|')  
   and slibd_entity_type=citrus_usr.FN_SPLITVAL_BY(@pa_type,3,'|'))  
     
   select * from #tmp  
       
    end   
   if citrus_usr.FN_SPLITVAL_BY(@pa_type,2,'|')='C'   
    begin   
      
        
   insert into #tmp  
   Select '0',COUNT(uses_id) from used_slip_block where USES_DELETED_IND =1  
   and USES_CANCELLATION_DT> =@pa_request_dt and USES_CANCELLATION_DT<=@pa_request_todt  
   and uses_id not in (select slibd_sliim_id from sliim_batch_dtls where slibd_deleted_ind=1   
   and slibd_DIS_type=citrus_usr.FN_SPLITVAL_BY(@pa_type,2,'|')  
   and slibd_entity_type=citrus_usr.FN_SPLITVAL_BY(@pa_type,3,'|'))  
     
   select * from #tmp  
       
    end      
--    
end

GO
