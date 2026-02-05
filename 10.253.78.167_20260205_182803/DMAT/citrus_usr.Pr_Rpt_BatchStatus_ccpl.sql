-- Object: PROCEDURE citrus_usr.Pr_Rpt_BatchStatus_ccpl
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*    
    
exec Pr_Rpt_BatchStatus 'nsdl',4,'5/7/2008 12:00:00 AM','5/7/2009 12:00:00 AM','',''    

exec Pr_Rpt_BatchStatus  'CDSL',3,'5/7/2008 12:00:00 AM','5/7/2009 12:00:00 AM','',''    
    
*/    
      
create PROC [citrus_usr].[Pr_Rpt_BatchStatus_ccpl]            
@pa_dptype varchar(4),            
@pa_excsmid int,            
@pa_fromdate datetime,            
@pa_todate datetime,       
@pa_type char(1),           
@pa_output varchar(8000) output             
as            
begin            
 declare @@dpmid int            
             
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1            
            
 set @pa_todate = convert(datetime,convert(varchar(11),@pa_todate,109) + ' 23:59:59')      
 ---------------------------------------------------------------- ------------------------------------------------------   
    
IF @pa_dptype ='CDSL'       
 IF @pa_type ='C'      
    
 BEGIN     
        SELECT batchc_trans_type ,  batch_cr_dt=BATCHC_FILEGEN_DT            
  ,batch_cr_user=batchc_created_by            
  ,batch_no = batchc_no,Tot_Records=batchc_records        
   ,For_trans = 'ACCOUNT REGISTRATION'       
  ,batch_status=CASE WHEN batchc_deleted_ind = 9 then 'Batch Cancelled'       
       else       
       case when batchc_status = 'P' then 'Batch Request Generated'             
        WHEN batchc_status = 'A' THEN 'DPM Response Imported'            
        else '' end            
       end      
  ,batch_resp_dt=batchc_lst_upd_dt            
  ,batch_resp_user=batchc_lst_upd_by     
  FROM    BATCHNO_CDSL_MSTR            
  WHERE   batchc_dpm_id = @@dpmid            
-- and batchc_created_dt between @pa_fromdate and @pa_todate            
  and batchc_deleted_ind =1         
    and batchc_type = 'C'    order by batch_no,For_trans          

 
 END     
 --  
 --Added by Jitesh on 12-Oct-2010
 ELSE IF @pa_type ='AC'        
 BEGIN      

    SELECT distinct batchc_trans_type   
		, batch_cr_dt=BATCHC_FILEGEN_DT              
		, batch_cr_user=batchc_created_by              
		, batch_no = batchc_no,Tot_Records=batchc_records          
		, For_trans = 'ACCOUNT CLOUSER'         
		, batch_status=CASE WHEN batchc_deleted_ind = 9 THEN 'Batch Cancelled'         
						ELSE CASE WHEN batchc_status = 'P' THEN 'Batch Request Generated'               
								  WHEN batchc_status = 'A' THEN 'DPM Response Imported'              
							 ELSE '' END END        
		, batch_resp_dt=batchc_lst_upd_dt              
		, batch_resp_user=batchc_lst_upd_by
		,CLSR_BATCH_NO
		,BATCHC_NO   
		,dpam.dpam_id,CLSR_DPAM_ID    
	FROM  BATCHNO_CDSL_MSTR
		, DP_ACCT_MSTR DPAM
		, #ACLIST account
		, closure_acct_cdsl             
	WHERE batchc_dpm_id = @@dpmid 
	AND	batchc_dpm_id = CLSR_DPM_ID 
	and dpam.dpam_id = CLSR_DPAM_ID 
	AND DPAM.DPAM_SBA_NO = ACCOUNT.DPAM_SBA_NO  
	AND CLSR_BATCH_NO = BATCHC_NO 
	and batchc_created_dt between @pa_fromdate and @pa_todate              
	and batchc_deleted_ind =1           
	and batchc_type = 'AC'      
	order by batch_no,For_trans            
 END 
--End by Jitesh on 12-Oct-2010
 --        
 ELSE --when @pa_type <> 'C'       
 --   
 BEGIN       
         
  SELECT BATCHC_TRANS_TYPE,  batch_cr_dt=replace(convert(varchar(10),BATCHC_FILEGEN_DT ,103),'-','/' )            
  ,batch_cr_user=batchc_created_by            
  ,batch_no = batchc_no,Tot_Records=batchc_records        
  ,For_trans= Replace(Replace(Replace(Replace(Replace(batchc_trans_type,'EP','EARLY PAYIN'),'NP',' NORMAL PAYIN'),'ID','INTER DEPOSITORY'),'DMAT','DEMAT'),'OFFM','OFF MARKET')            
  ,batch_status=CASE WHEN batchc_deleted_ind = 9 then 'Batch Cancelled'      
       else case when batchc_status = 'P' then 'Batch Request Generated'             
        WHEN batchc_status = 'I' THEN 'DPM Response imported'            
        else '' end            
       end       
  ,batch_resp_dt=batchc_lst_upd_dt            
  ,batch_resp_user=batchc_lst_upd_by          
        ,batchc_trans_type   batch_trans_type      
  FROM    BATCHNO_CDSL_MSTR            
  WHERE   batchc_dpm_id = @@dpmid            
  and batchc_created_dt between @pa_fromdate and @pa_todate            
  and batchc_deleted_ind =1         
        and batchc_type = 'T'    order by batch_no,For_trans          
 END      
----------------------------------  -------------------------------------------------------------------------  
          
 IF @pa_dptype ='NSDL'       
    
 IF @pa_type ='C'    
      
 BEGIN       
         SELECT  batchn_trans_type batchc_trans_type, batch_cr_dt=BATCHN_FILEGEN_DT            
  ,batch_cr_user=batchn_created_by            
  ,batch_no = batchn_no,Tot_Records=batchn_records        
  ,For_trans='ACCOUNT REGISTRATION'      
  ,batch_status= CASE WHEN batchn_deleted_ind = 9 then 'Batch Cancelled'       
        else      
       case when batchn_status = 'P' then 'Batch Request Generated'             
         WHEN batchn_status = 'A' THEN 'DPM Response Imported'          
       else '' end            
      end      
  ,batch_resp_dt=batchn_lst_upd_dt            
  ,batch_resp_user=batchn_lst_upd_by            
  FROM    BATCHNO_NSDL_MSTR            
  WHERE   batchn_dpm_id = @@dpmid            
  and batchn_created_dt between @pa_fromdate and dateadd(hh,24,@pa_todate)            
  and batchn_deleted_ind =1      
     and batchn_type = 'C'   order by batch_no,For_trans           
 END            
  --Added by Jitesh on 12-Oct-2010
	 ELSE IF @pa_type ='AC'      
	 BEGIN 
       
	  SELECT  batchn_trans_type batchc_trans_type, batch_cr_dt=BATCHN_FILEGEN_DT              
		  , batch_cr_user=batchn_created_by              
		  , batch_no = batchn_no,Tot_Records=batchn_records          
		  , For_trans='ACCOUNT CLOUSER'        
		  , batch_status= CASE WHEN batchn_deleted_ind = 9 then 'Batch Cancelled'         
							else case when batchn_status = 'P' then 'Batch Request Generated'               
									WHEN batchn_status = 'A' THEN 'DPM Response Imported'            
								else '' end end        
		  , batch_resp_dt=batchn_lst_upd_dt              
		  , batch_resp_user=batchn_lst_upd_by              
	  FROM BATCHNO_NSDL_MSTR
		, DP_ACCT_MSTR DPAM
		, #ACLIST account
		, closure_acct_cdsl              
	  WHERE batchn_dpm_id = @@dpmid     
	  AND batchn_dpm_id = CLSR_DPM_ID
	  and dpam.dpam_id = CLSR_DPAM_ID 
	  AND DPAM.DPAM_SBA_NO = ACCOUNT.DPAM_SBA_NO  
	  AND CLSR_BATCH_NO = BATCHN_NO           
	  and batchn_created_dt between @pa_fromdate and dateadd(hh,24,@pa_todate)              
	  and batchn_deleted_ind =1        
	  and batchn_type = 'AC'   
	  order by batch_no,For_trans             
	 END 
	 --End by Jitesh on 12-Oct-2010           
 ELSE           

 BEGIN   
        
 SELECT    batch_cr_dt= replace(convert(varchar(10),BATCHN_FILEGEN_DT ,103),'-','/' ) --convert(varchar(11),batchn_created_dt,103)            
  ,batch_cr_user=batchn_created_by            
  ,batch_no = batchn_no,Tot_Records=batchn_records        
  ,For_trans = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(batchn_trans_type,'IDD','INTER DEPOSITORY'),'ATO','INTER SETTLEMENT'),'ID0','IREVERSIBLE DELIVERY OUT'),'DO','REVERSIBLE DO'),'C2C','OFF MARKET'),'P2C','ONMARKET 	PAYOUT'),'C2P','ONMARKET PAYIN'),'DMT','DEMAT'),'RMT','REMAT'),'P2P','ONMARKET - POOL TO POOL'),              
  batch_status=CASE WHEN batchn_deleted_ind = 9 then  'Batch Cancelled'       
       else      
       case when batchn_status = 'P' then 'Batch Request Generated'             
       WHEN batchn_status = 'A' THEN 'Successful Verification Release'            
       WHEN batchn_status = 'R' then 'Failure during Verification Release'            
       WHEN batchn_status = 'VRA' THEN 'Successful Verification Release'            
       WHEN batchn_status = 'VRR' then 'Failure during Verification Release'            
       else '' end            
       end      
  ,batch_resp_dt=batchn_lst_upd_dt            
  ,batch_resp_user=batchn_lst_upd_by         
  ,batchn_trans_type    batchc_trans_type      
  FROM    BATCHNO_NSDL_MSTR            
  WHERE   batchn_dpm_id = @@dpmid            
  and batchn_created_dt between @pa_fromdate and dateadd(hh,24,@pa_todate)            
  and batchn_deleted_ind =1      
     and batchn_type = 'T'  order by batch_no,For_trans          
 END            
            
            
            
end

GO
