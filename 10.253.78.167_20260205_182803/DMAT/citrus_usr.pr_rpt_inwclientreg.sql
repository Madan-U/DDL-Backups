-- Object: PROCEDURE citrus_usr.pr_rpt_inwclientreg
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_rpt_inwclientreg]    
(    
 @pa_excsm_id numeric,    
 @pa_recvd_dt datetime,    
 @pa_frmno    varchar(15),    
 @pa_ref_cur  varchar(8000)  output                            
)    
as    
BEGIN    
--    
 declare @l_dpmid numeric    
  ,@l_compname varchar(250)    
     
 select  @l_dpmid = dpm_id from dp_mstr where default_dp = @pa_excsm_id and dpm_deleted_ind =1    
     
 select @l_compname = compm_name1 from company_mstr,exch_seg_mstr        
   where compm_id = excsm_compm_id        
   and excsm_id =@pa_excsm_id        
   and compm_deleted_ind = 1        
   and excsm_deleted_ind =1      
     
 select inwcr_id   receiptno    
    ,convert(varchar(11),inwcr_recvd_dt,103) receiptdt    
  ,inwcr_frmno    clientid    
  ,inwcr_name name    
  ,inwcr_charge_collected amt    
  ,inwcr_pay_mode   paymode    
  ,inwcr_cheque_no  chequeno    
  ,inwcr_rmks  narrations    
  ,@l_compname     companyname    
 from  inw_client_reg    
 where inwcr_dmpdpid = @l_dpmid
 and inwcr_recvd_dt = @pa_recvd_dt    
 and   inwcr_frmno LIKE CASE WHEN LTRIM(RTRIM(@pa_frmno))     = '' THEN '%' ELSE @pa_frmno  END     
 and   inwcr_deleted_ind =1              
     
--    
END

GO
