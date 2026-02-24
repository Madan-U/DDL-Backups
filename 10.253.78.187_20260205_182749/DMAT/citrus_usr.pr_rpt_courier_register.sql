-- Object: PROCEDURE citrus_usr.pr_rpt_courier_register
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_rpt_courier_register 4,'DEMAT','06/01/2008','06/01/2009','','','','','','','DHL',''  
--select * from DMAT_DISPATCH
  
CREATE procedure [citrus_usr].[pr_rpt_courier_register]  
(   
 @pa_excsmid int,                  
    @pa_instype varchar(10),  
 @pa_dispdtfr varchar(11),    
 @pa_dispdtto varchar(11),    
 @pa_isincd varchar(20),  
    @pa_acctnofr varchar(20),  
 @pa_acctnoto varchar(20),   
 @pa_dispnofr varchar(20),    
 @pa_dispnoto varchar(20),    
 @pa_regcd varchar(20),   
 @pa_courier varchar(100),     
 @pa_output varchar(8000) output     
)  
  
As   
Begin  
 declare @@dpmid int ,@@dptype varchar(20)     
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind = 1           
 select @@dptype = excsm_exch_cd from exch_seg_mstr where excsm_id = @pa_excsmid and excsm_deleted_ind = 1  
  
 if @pa_acctnofr = ''                    
 begin                    
 set @pa_acctnofr = '0'                    
 set @pa_acctnoto = '99999999999999999'                    
 end                      
 if @pa_acctnoto = ''                    
 begin                    
 set @pa_acctnoto = @pa_acctnofr                    
 end                   
                        
IF @pa_acctnoto =''                          
BEGIN                          
SET @pa_acctnoto= @pa_acctnofr               
END   

-- if @pa_dispnofr = ''                    
-- begin                    
-- set @pa_dispnofr = '0'                    
-- set @pa_dispnoto = '99999999999999999'                    
-- end                      
-- if @pa_dispnofr = ''                    
-- begin                    
-- set @pa_dispnoto = @pa_dispnofr                    
-- end   
  
 IF(@pa_instype = 'DEMAT')  
    BEGIN  
  --  
     SELECT DEMRM_ID ID  
    ,DEMRM_ISIN ISIN  
     ,ISIN_NAME                                                           
    ,ENTM_NAME1 RTA_NAME              
    ,ISIN_REG_CD RTA_CD   
    , DISP_DOC_ID disp_dis_no                                
    ,disp_dt  
    ,disp_name   
    ,DISP_DOC_ID 
    ,isnull(isin_contactperson,'') contact_person
    ,isnull(isin_adrcity,'') city 
    ,demrm_rmks Remarks, disp_cons_no
  FROM DEMAT_REQUEST_MSTR 
       LEFT OUTER JOIN 
       DP_ACCT_MSTR ON DEMRM_DPAM_ID =  DPAM_ID   
   ,ISIN_MSTR    
   ,ENTITY_MSTR   
   ,DMAT_DISPATCH                                            
  WHERE DEMRM_ID = DISP_DEMRM_ID                
  AND ISIN_CD = DEMRM_ISIN                   
  AND ISIN_REG_CD = case when @@dptype = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end              
  and entm_enttm_cd = case when  @@dptype = 'nsdl' then 'SR' else 'RTA' end               
  AND CASE WHEN @pa_isincd <> '' THEN @pa_isincd ELSE '' END = CASE WHEN @pa_isincd <> '' THEN ISIN_CD ELSE '' END     
  AND ISIN_REG_CD like @pa_regcd + '%'  
  AND disp_dt BETWEEN CONVERT(DATETIME,@pa_dispdtfr+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@pa_dispdtto+ ' 23:59:59:999',103)                                                        
  --AND disp_cons_no between @pa_dispnofr and @pa_dispnoto
  AND DISP_DOC_ID like @pa_dispnofr + '%'
  AND disp_name like @pa_courier + '%'  
  AND convert(numeric,dpam_sba_no) between convert(numeric,@pa_acctnofr) and convert(numeric,@pa_acctnoto)  
        --AND disp_conf_recd in ('D','R')  
  AND Disp_to = 'R'     
  AND  ISNULL(DEMRM_TRANSACTION_NO,'')<>''   
  ORDER BY disp_name, disp_dt  
 --
 END  
 ELSE   
    BEGIN  
 --  
  SELECT REMRM_ID ID  
    ,REMRM_ISIN ISIN  
     ,ISIN_NAME                                                           
    ,ENTM_NAME1 RTA_NAME              
    ,ISIN_REG_CD RTA_CD   
    ,DISPR_DOC_ID  disp_dis_no                               
    ,dispr_dt    disp_dt
    ,dispr_name  disp_name  
    ,DISPR_DOC_ID    
    ,isnull(isin_contactperson,'') contact_person
    ,isnull(isin_adrcity,'') city 
    ,remrm_rmks Remarks    ,dispr_cons_no
  FROM REMAT_REQUEST_MSTR LEFT OUTER JOIN DP_ACCT_MSTR ON REMRM_DPAM_ID =  DPAM_ID   
   ,ISIN_MSTR    
   ,ENTITY_MSTR   
   ,DMAT_DISPATCH_REMAT                                            
  WHERE REMRM_ID = DISPR_REMRM_ID                
  AND ISIN_CD = REMRM_ISIN                   
  AND ISIN_REG_CD = case when @@dptype = 'nsdl' then ltrim(rtrim(entm_short_name))  else  replace(ltrim(rtrim(entm_short_name)),'RTA_','') end              
  and entm_enttm_cd = case when  @@dptype = 'nsdl' then 'SR' else 'RTA' end               
  AND CASE WHEN @pa_isincd <> '' THEN @pa_isincd ELSE '' END = CASE WHEN @pa_isincd <> '' THEN ISIN_CD ELSE '' END     
  AND ISIN_REG_CD like @pa_regcd + '%'  
  AND dispr_dt BETWEEN CONVERT(DATETIME,@pa_dispdtfr+ ' 00:00:00:000',103) AND CONVERT(DATETIME,@pa_dispdtto+ ' 23:59:59:999',103)                                                        
  AND DISPR_DOC_ID  between @pa_dispnofr and @pa_dispnoto 
  AND dispr_name like @pa_courier + '%'  
  AND convert(numeric,dpam_sba_no) between convert(numeric,@pa_acctnofr) and convert(numeric,@pa_acctnoto)  
        --AND dispr_conf_recd in ('D','R')  
  AND Dispr_to = 'R'     
  AND  ISNULL(REMRM_TRANSACTION_NO,'')<>''   
  ORDER BY dispr_name,dispr_dt  
 --  
 END  
End

GO
