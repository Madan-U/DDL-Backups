-- Object: PROCEDURE citrus_usr.PR_CHARGE_MSTR_DTLS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--execute PR_CHARGE_MSTR_DTLS 4,'C','fixed',''              
--select * from account_adr_conc              
--SELECT * FROM fin_account_mstr               
--cham_post_toacc              
--select * from charge_mstr              
--sp_help charge_mstr              
CREATE PROCEDURE [citrus_usr].[PR_CHARGE_MSTR_DTLS]                             
(                        
   @pa_id      int       --excsm_id        
  ,@pa_cd      char(1)       
  ,@pa_desc    varchar(500) --profile name(from brokerage)/charge slab name      
  ,@pa_ref_cur varchar(8000) out              
)                        
                        
AS                        
                        
BEGIN -- MAIN                        
                  
 CREATE TABLE #TMP(cd varchar(16),descp varchar(100))                          
 INSERT INTO  #tmp SELECT ltrim(rtrim(cd)),descp FROM citrus_usr.fn_getsubtransdtls('INT_TRANS_TYPE_NSDL')                          
 INSERT INTO #tmp VALUES('O','ONE TIME CHARGE')                          
 INSERT INTO #tmp VALUES('F','FIXED CHARGE')                          
 INSERT INTO #tmp VALUES('A','ACCOUNT CLOSURE')                        
 INSERT INTO #tmp VALUES('H','HOLDING CHARGES')                        
 INSERT INTO #tmp VALUES('AMT','BASED ON CHARGE AMOUNT')                        
                           
IF @pa_cd = 'P'    
BEGIN     
--                        
select distinct cham.cham_slab_no   cham_slab_no     
,brom.brom_desc      brom_desc                  
,cham.cham_slab_name    cham_slab_name                
,cham_charge_type = t.descp                           
,cham_bill_period  = CASE WHEN  isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval = 1 THEN 'MONTHLY'   
  WHEN  isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval <> 1 THEN 'MONTH(S)'  
  WHEN  isnull(cham_bill_period,'') = 'D' THEN 'DAY(S)'  
  WHEN  isnull(cham_bill_period,'') = 'Q' THEN 'QUARTLY'   
  WHEN  isnull(cham_bill_period,'') = 'H' THEN 'HALF YAERLY'  
  WHEN  isnull(cham_bill_period,'') = 'Y' THEN 'YAERLY'  ELSE isnull(cham_bill_period,'') END                
                              
,cham_bill_interval = CASE WHEN isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval = 1 THEN 'N/A'  
       WHEN isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval <> 1 THEN cham_bill_interval   
       WHEN isnull(cham_bill_period,'') = 'D' THEN cham_bill_interval  
       WHEN isnull(cham_bill_period,'') = 'Q' THEN 'N/A'   
       WHEN isnull(cham_bill_period,'') = 'H' THEN 'N/A'  
       WHEN isnull(cham_bill_period,'') = 'Y' THEN 'N/A'  ELSE isnull(cham_bill_period,'') END                                     
,cham_charge_baseon = CASE WHEN cham_charge_baseon ='TQ' then 'Transaction Quantity'                          
         WHEN cham_charge_baseon ='TV' then 'Transaction Value'                          
         WHEN cham_charge_baseon ='INST' then 'No.Of Instruction Slip'                          
         WHEN cham_charge_baseon ='TRANSPERSLIP' then 'Per Transaction Slip Wise'        
       else '' end                       
,cham_val_pers = CASE WHEN cham_val_pers = 'V' then 'Value'                          
             WHEN cham_val_pers = 'P' then 'Percent'                          
                 else '' end                         
,cham.cham_from_factor         cham_from_factor                
,cham.cham_to_factor           cham_to_factor                
,cham.cham_charge_value        cham_charge_value                
,cham.CHAM_CHARGE_MINVAL       CHAM_CHARGE_MINVAL                
,cham.cham_remarks             cham_remarks                
,cham.cham_post_toacct         cham_post_toacct              
,faccm.fina_acc_name     fina_acc_name                   
from  charge_mstr      cham                     
   LEFT OUTER JOIN fin_account_mstr faccm ON cham.cham_post_toacct = faccm.fina_acc_id                 
  ,#TMP       t                                  
  ,brokerage_mstr    brom                
  ,profile_charges    profc                
  ,transaction_sub_type_mstr trastm                
  ,transaction_type_mstr  tratm                
  ,exchange_mstr    excm                
  ,exch_seg_mstr    excsm                    
where cham.cham_charge_type     = t.cd                   
and cham.cham_chargebitfor     = @pa_id            
and brom.brom_desc like      '%' + @pa_desc + '%'                  
and profc.proc_profile_id     = brom.brom_id                     
AND profc.proc_slab_no      = cham.cham_slab_no                   
AND trastm.trastm_tratm_id         = tratm.trantm_id                   
AND tratm.trantm_excm_id           = excm.excm_id                    
AND tratm.trantm_code              = case when excsm.excsm_exch_cd = 'CDSL' then 'INT_TRANS_TYPE_CDSL'                               
                                          when excsm.excsm_exch_cd = 'NSDL' then 'INT_TRANS_TYPE_NSDL' end                   
AND excm.excm_cd                = excsm.excsm_exch_cd              
AND brom.brom_deleted_ind          = 1                             
AND profc.proc_deleted_ind         = 1                             
AND cham.cham_deleted_ind          = 1                   
AND excsm.excsm_id                 = cham.cham_chargebitfor                         
AND tratm.trantm_deleted_ind       = 1                     
ORDER BY brom.brom_desc               
--    
END     
ELSE IF @pa_cd = 'S'     
--    
select distinct cham.cham_slab_no   cham_slab_no     
--,brom.brom_desc      brom_desc                  
,cham.cham_slab_name    cham_slab_name                
,cham_charge_type = t.descp                           
,cham_bill_period  = CASE WHEN  isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval = 1 THEN 'MONTHLY'   
  WHEN  isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval <> 1 THEN 'MONTH(S)'  
  WHEN  isnull(cham_bill_period,'') = 'D' THEN 'DAY(S)'  
  WHEN  isnull(cham_bill_period,'') = 'Q' THEN 'QUARTLY'   
  WHEN  isnull(cham_bill_period,'') = 'H' THEN 'HALF YAERLY'  
  WHEN  isnull(cham_bill_period,'') = 'Y' THEN 'YAERLY'  ELSE isnull(cham_bill_period,'') END                
                              
,cham_bill_interval = CASE WHEN isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval = 1 THEN 'N/A'  
       WHEN isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval <> 1 THEN cham_bill_interval   
       WHEN isnull(cham_bill_period,'') = 'D' THEN cham_bill_interval  
       WHEN isnull(cham_bill_period,'') = 'Q' THEN 'N/A'   
       WHEN isnull(cham_bill_period,'') = 'H' THEN 'N/A'  
       WHEN isnull(cham_bill_period,'') = 'Y' THEN 'N/A'  ELSE isnull(cham_bill_period,'') END                                
,cham_charge_baseon = CASE WHEN cham_charge_baseon ='TQ' then 'Transaction Quantity'                          
         WHEN cham_charge_baseon ='TV' then 'Transaction Value'                          
         WHEN cham_charge_baseon ='INST' then 'No.Of Instruction Slip'                          
         WHEN cham_charge_baseon ='TRANSPERSLIP' then 'Per Transaction Slip Wise'        
       else '' end                       
,cham_val_pers = CASE WHEN cham_val_pers = 'V' then 'Value'                          
             WHEN cham_val_pers = 'P' then 'Percent'                          
                 else '' end                         
,cham.cham_from_factor         cham_from_factor                
,cham.cham_to_factor           cham_to_factor                
,cham.cham_charge_value        cham_charge_value                
,cham.CHAM_CHARGE_MINVAL       CHAM_CHARGE_MINVAL                
,cham.cham_remarks             cham_remarks                
,cham.cham_post_toacct         cham_post_toacct              
,faccm.fina_acc_name     fina_acc_name                   
from  charge_mstr      cham                     
   LEFT OUTER JOIN fin_account_mstr faccm ON cham.cham_post_toacct = faccm.fina_acc_id                 
  ,#TMP       t                                      
  ,transaction_sub_type_mstr trastm                
  ,transaction_type_mstr  tratm                
  ,exchange_mstr    excm               
  ,exch_seg_mstr    excsm                    
where cham.cham_charge_type     = t.cd                   
and cham.cham_chargebitfor     = @pa_id          
and cham.cham_slab_name like  '%' + @pa_desc + '%'          
AND trastm.trastm_tratm_id         = tratm.trantm_id                   
AND tratm.trantm_excm_id           = excm.excm_id                    
AND tratm.trantm_code              = case when excsm.excsm_exch_cd = 'CDSL' then 'INT_TRANS_TYPE_CDSL'                               
                                          when excsm.excsm_exch_cd = 'NSDL' then 'INT_TRANS_TYPE_NSDL' end                   
AND excm.excm_cd                = excsm.excsm_exch_cd              
AND cham.cham_deleted_ind          = 1                   
AND excsm.excsm_id                 = cham.cham_chargebitfor                         
AND tratm.trantm_deleted_ind       = 1                     
ORDER BY cham.cham_slab_name     
--    
ELSE IF @pa_cd = 'C'    
--  
select distinct cham.cham_slab_no   cham_slab_no     
,cham.cham_slab_name    cham_slab_name                
,cham_charge_type = t.descp                           
,cham_bill_period  = CASE WHEN  isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval = 1 THEN 'MONTHLY'   
  WHEN  isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval <> 1 THEN 'MONTH(S)'  
  WHEN  isnull(cham_bill_period,'') = 'D' THEN 'DAY(S)'  
  WHEN  isnull(cham_bill_period,'') = 'Q' THEN 'QUARTLY'   
  WHEN  isnull(cham_bill_period,'') = 'H' THEN 'HALF YAERLY'  
  WHEN  isnull(cham_bill_period,'') = 'Y' THEN 'YAERLY'  ELSE isnull(cham_bill_period,'') END                
                              
,cham_bill_interval = CASE WHEN isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval = 1 THEN 'N/A'  
       WHEN isnull(cham_bill_period,'') = 'M' AND  cham_bill_interval <> 1 THEN cham_bill_interval   
       WHEN isnull(cham_bill_period,'') = 'D' THEN cham_bill_interval  
       WHEN isnull(cham_bill_period,'') = 'Q' THEN 'N/A'   
       WHEN isnull(cham_bill_period,'') = 'H' THEN 'N/A'  
       WHEN isnull(cham_bill_period,'') = 'Y' THEN 'N/A'  ELSE isnull(cham_bill_period,'') END                                
,cham_charge_baseon = CASE WHEN cham_charge_baseon ='TQ' then 'Transaction Quantity'                          
         WHEN cham_charge_baseon ='TV' then 'Transaction Value'                          
         WHEN cham_charge_baseon ='INST' then 'No.Of Instruction Slip'                          
         WHEN cham_charge_baseon ='TRANSPERSLIP' then 'Per Transaction Slip Wise'        
       else '' end                       
,cham_val_pers = CASE WHEN cham_val_pers = 'V' then 'Value'                          
             WHEN cham_val_pers = 'P' then 'Percent'                          
                 else '' end                         
,cham.cham_from_factor         cham_from_factor                
,cham.cham_to_factor           cham_to_factor                
,cham.cham_charge_value        cham_charge_value                
,cham.CHAM_CHARGE_MINVAL       CHAM_CHARGE_MINVAL                
,cham.cham_remarks             cham_remarks                
,cham.cham_post_toacct         cham_post_toacct              
,faccm.fina_acc_name     fina_acc_name                   
from  charge_mstr      cham                     
   LEFT OUTER JOIN fin_account_mstr faccm ON cham.cham_post_toacct = faccm.fina_acc_id                 
  ,#TMP       t                                      
  ,transaction_sub_type_mstr trastm                
  ,transaction_type_mstr  tratm                
  ,exchange_mstr    excm                
  ,exch_seg_mstr    excsm                    
where cham.cham_charge_type     = t.cd                   
and cham.cham_chargebitfor     = @pa_id          
and cham.cham_charge_type like  '%' + @pa_desc + '%'          
AND trastm.trastm_tratm_id         = tratm.trantm_id                   
AND tratm.trantm_excm_id           = excm.excm_id                    
AND tratm.trantm_code              = case when excsm.excsm_exch_cd = 'CDSL' then 'INT_TRANS_TYPE_CDSL'                               
                                          when excsm.excsm_exch_cd = 'NSDL' then 'INT_TRANS_TYPE_NSDL' end                   
AND excm.excm_cd                = excsm.excsm_exch_cd              
AND cham.cham_deleted_ind          = 1                   
AND excsm.excsm_id                 = cham.cham_chargebitfor                         
AND tratm.trantm_deleted_ind       = 1                     
ORDER BY cham.cham_charge_type     
--  
END -- MAIN

GO
