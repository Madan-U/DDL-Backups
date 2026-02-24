-- Object: PROCEDURE citrus_usr.Pr_rpt_Highvalue_BAK22072015FINAL
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE Proc [citrus_usr].[Pr_rpt_Highvalue_BAK22072015FINAL]              
@pa_dptype varchar(4),              
@pa_excsmid int,              
@pa_fromdate datetime,              
@pa_todate datetime,              
@pa_fromaccid varchar(16),              
@pa_toaccid varchar(16),              
@pa_isincd varchar(12),              
@pa_login_pr_entm_id numeric,                
@pa_login_entm_cd_chain  varchar(8000),                
@pa_output varchar(8000) output                
AS              
BEGIN              
 declare @@dpmid int,        
 @@highvalue numeric(18,5)              
           
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1              
 declare @@l_child_entm_id      numeric                
 select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                
               
 IF @pa_fromaccid = ''              
 BEGIN              
  SET @pa_fromaccid = '0'              
  SET @pa_toaccid = '99999999999999999'              
 END              
 IF @pa_toaccid = ''              
 BEGIN          
   SET @pa_toaccid = @pa_fromaccid              
 END              
               

  CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)

  INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		

 IF @pa_dptype = 'NSDL'              
 BEGIN              
   
 select @@highvalue = bitrm_bit_location         
 from bitmap_ref_mstr         
 where bitrm_parent_cd = 'HIGH_VAL_NSDL'         
 and bitrm_deleted_ind = 1        
        
        
   select         
   request_dt= convert(varchar(11),dptd_request_dt,109),              
   exec_dt   = convert(varchar(11),dptd_execution_dt,109),         
   dpam_sba_name,dpam_sba_no,        
   trans_cd=dptd_trastm_cd,              
   trans_desc=ttypes.descp,         
   slip_no = dptd_slip_no,             
   isin_cd = dptd_isin,             
   Isin_name,         
   qty = convert(numeric(18,3),abs(dptd_qty)),        
   rate = CONVERT(NUMERIC(18,3),isnull(clopm_nsdl_rt,0)),        
   value = convert(numeric(18,3),abs(dptd_qty*isnull(clopm_nsdl_rt,0)))  
   FROM          
   CLOSING_LAST_NSDL right outer join dp_trx_dtls on  clopm_isin_cd = dptd_isin        
   left outer join isin_mstr on dptd_isin = isin_cd,              
   #ACLIST account,        
   citrus_usr.FN_GETSUBTRANSDTLS('TRANS_TYPE_NSDL') ttypes                     
   where    
   dptd_dpam_id = account.dpam_id     
   and (DPTD_REQUEST_DT between eff_from and eff_to)    
   and dptd_trastm_cd = ttypes.CD          
   and DPTD_REQUEST_DT >=@pa_fromdate AND DPTD_REQUEST_DT <=@pa_todate           
   and abs(dptd_qty)*isnull(clopm_nsdl_rt,0) >= @@highvalue           
   and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)               
   and dptd_isin like @pa_isincd + '%'              
   order by ttypes.descp,dptd_isin,DPTD_REQUEST_DT,Isin_name,dpam_sba_name              
   END              
   ELSE              
   BEGIN              
        
		 select @@highvalue = bitrm_bit_location         
		 from bitmap_ref_mstr         
		 where bitrm_parent_cd = 'HIGH_VAL_CDSL'         
		 and bitrm_deleted_ind = 1        
        
		   select         
		   request_dt=dptdc_request_dt,              
		   exec_dt   =dptdc_execution_dt,         
		   dpam_sba_name,dpam_sba_no,        
		   trans_cd=dptdc_trastm_cd,              
		   trans_desc=case when dptdc_trastm_cd = 'BOBO' then 'OFF MARKET - BO TO BO'            
					when dptdc_trastm_cd = 'BOCM' then 'ON MARKET PAYIN - BO TO CM'            
					when dptdc_trastm_cd = 'CMBO' then 'ON MARKET PAYOUT - CM TO BO'            
					when dptdc_trastm_cd = 'CMCM' then 'ON MARKET PAYOUT - CM TO CM'            
					when dptdc_trastm_cd = 'ID' then 'INTER DEPOSITORY - IDD'            
					when dptdc_trastm_cd = 'EP' then 'EARLY PAYIN - EP'            
					when dptdc_trastm_cd = 'NP' then 'NORMAL PAYIN - NP'            
								  else 'COMMON SLIP' end,         
		   slip_no = dptdc_slip_no,             
		   isin_cd = dptdc_isin,             
		   Isin_name,         
		   qty = convert(numeric(18,3),abs(dptdc_qty)),        
		   rate = convert(numeric(18,3),isnull(clopm_cdsl_rt,0)),        
		   value = convert(numeric(18,3),abs(dptdc_qty*isnull(clopm_cdsl_rt,0)))        
		   FROM          
		   CLOSING_LAST_CDSL right outer join dp_trx_dtls_cdsl on  clopm_isin_cd = dptdc_isin        
		   left outer join isin_mstr on dptdc_isin = isin_cd,              
		   #ACLIST account        
		   where               
		   DPTDC_REQUEST_DT >=@pa_fromdate AND DPTDC_REQUEST_DT <=@pa_todate              
		   --and sum(abs(dptdc_qty)*isnull(clopm_cdsl_rt,0)) >= @@highvalue        
		   and convert(numeric,dpam_sba_no) between convert(numeric,@pa_fromaccid) and convert(numeric,@pa_toaccid)               
		   and dptdc_isin like @pa_isincd + '%'              
		   and dptdc_dpam_id = account.dpam_id                
		   and (DPTDC_REQUEST_DT between eff_from and eff_to)
     and citrus_usr.fn_get_DIS_high('RPT',dptdc_slip_no,'')  > @@highvalue  
    
		   order by dptdc_trastm_cd,dptdc_isin,DPTDC_REQUEST_DT,Isin_name,dpam_sba_name   
    
        
        
  END         

      TRUNCATE TABLE #ACLIST
	  DROP TABLE #ACLIST       
              
END

GO
