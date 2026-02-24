-- Object: PROCEDURE citrus_usr.pr_rpt_dispatch_confirm
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_rpt_dispatch_confirm 4,'NSDL','BILLNSDL','28/04/2008','29/04/2008','post',2,''    
--pr_rpt_dispatch_confirm  4,'NSDL','BILLNSDL','14/03/2009','14/03/2009','courier','1',1,''   
-- pr_rpt_dispatch_confirm	3,'CDSL','BILL_CDSL','may 14 2010','may 15 2010','COURIER','3',1,'HO|*~|',''	  

--select * from dispatch_report_nsdl  
  
CREATE PROCEDURE [citrus_usr].[pr_rpt_dispatch_confirm]    
(    
    @pa_excsmid   int    
   ,@pa_dptype    varchar(10)    
   ,@pa_Rpt_Type  varchar(20)    
   ,@pa_fromdt   datetime    
   ,@pa_todt    datetime  
   ,@pa_dispatch_mode varchar(20)    
   ,@pa_confirm_recd  char(1)    
   ,@pa_login_pr_entm_id numeric                            
   ,@pa_login_entm_cd_chain  varchar(8000)                        
   ,@pa_ref_cur   varchar(8000) output    
)    
    
As    
    
BEGIN     
--    
  DECLARE @@dpmid int   
  SELECT @@dpmid = dpm_id FROM dp_mstr WHERE default_dp = @pa_excsmid and default_dp  =  dpm_excsm_id and  dpm_deleted_ind = 1      
  
  IF @pa_dptype = 'CDSL'    
  BEGIN    
  --    
     IF @pa_confirm_recd = '3'     
      BEGIN     
   --    
     SELECT dpac.dpam_id   DPAMID     
      ,dpam_sba_no    ACCOUNTNO    
      ,Report_name REPORTNAME    
      ,Dispatch_dt DISPATCHDATE    
      ,Cof_recv  CONFIRMATION    
      ,dispatch_mode DISPATCH_MODE              
     FROM   dispatch_report_cdsl  dprc      
        ,dp_acct_mstr  dpac        
        --,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT           
     WHERE report_name = @pa_Rpt_Type    
     AND  dpac.dpam_dpm_id = @@dpmid
     AND  dprc.dpam_id = dpac.dpam_id     
	 and convert(datetime,Dispatch_dt,103) >= convert(datetime,@pa_fromdt,103) + ' 00:00:00' and convert(datetime,Dispatch_dt,103) <= convert(datetime,@pa_todt,103) + ' 23:59:59'        
    -- AND  dispatch_dt between @pa_fromdt and @pa_todt   
   --  
   END    
   ELSE    
   BEGIN    
   --    
      SELECT dpac.dpam_id   DPAMID     
      ,dpam_sba_no    ACCOUNTNO    
      ,Report_name REPORTNAME    
      ,Dispatch_dt DISPATCHDATE    
      ,Cof_recv  CONFIRMATION    
      ,dispatch_mode DISPATCH_MODE              
     FROM  dispatch_report_cdsl dprc    
          ,dp_acct_mstr  dpac       
      --,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT           
     WHERE report_name = @pa_Rpt_Type    
     AND  dpac.dpam_dpm_id = @@dpmid
     AND   dprc.dpam_id = dpac.dpam_id         
     AND   dispatch_mode = @pa_dispatch_mode    
     AND   cof_recv = @pa_confirm_recd    
	 and convert(datetime,Dispatch_dt,103) >= convert(datetime,@pa_fromdt,103) + ' 00:00:00' and convert(datetime,Dispatch_dt,103) <= convert(datetime,@pa_todt,103) + ' 23:59:59'        
     --AND   dispatch_dt between @pa_fromdt and @pa_todt   
   --    
   END    
  --    
  END    
  ELSE    
  BEGIN    
  --    
      IF @pa_confirm_recd = '3'     
    BEGIN     
    --    
    SELECT dpac.dpam_id DPAMID     
     ,dpam_sba_no    ACCOUNTNO    
     ,Report_name REPORTNAME    
--     ,Dispatch_dt DISPATCHDATE    
--     ,Cof_recv  CONFIRMATION  
     ,Dispatch_dt DISPATCHDATE      
     ,Cof_recv    CONFIRMATION    
     ,dispatch_mode DISPATCH_MODE              
    FROM  dispatch_report_nsdl dprn    
         ,dp_acct_mstr  dpac       
     --,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT           
    WHERE report_name = @pa_Rpt_Type    
    AND  dpac.dpam_dpm_id = @@dpmid
    AND   dprn.dpam_id = dpac.dpam_id         
	 and convert(datetime,Dispatch_dt,103) >= convert(datetime,@pa_fromdt,103) + ' 00:00:00' and convert(datetime,Dispatch_dt,103) <= convert(datetime,@pa_todt,103) + ' 23:59:59'            
--AND   dispatch_dt between @pa_fromdt and @pa_todt   
    --    
    END    
     ELSE    
   BEGIN    
   --   
    SELECT dpac.dpam_id   DPAMID     
     ,dpam_sba_no    ACCOUNTNO    
     ,Report_name REPORTNAME    
--     ,Dispatch_dt DISPATCHDATE    
--     ,Cof_recv  CONFIRMATION    
     ,Dispatch_dt   DISPATCHDATE
     ,Cof_recv      CONFIRMATION 

     ,dispatch_mode DISPATCH_MODE              
    FROM  dispatch_report_nsdl dprn    
         ,dp_acct_mstr  dpac       
      --,citrus_usr.FN_ACCT_LIST(@@dpmid ,@pa_login_pr_entm_id,0) ACCOUNT           
    WHERE report_name = @pa_Rpt_Type    
    AND  dpac.dpam_dpm_id = @@dpmid
    AND   dprn.dpam_id = dpac.dpam_id       
    AND   dispatch_mode = @pa_dispatch_mode    
    AND   cof_recv = @pa_confirm_recd    
    and convert(datetime,Dispatch_dt,103) >= convert(datetime,@pa_fromdt,103) + ' 00:00:00' and convert(datetime,Dispatch_dt,103) <= convert(datetime,@pa_todt,103) + ' 23:59:59'          
--AND   dispatch_dt between @pa_fromdt and @pa_todt   
   --    
   END    
  --    
  END     
--    
END

GO
