-- Object: PROCEDURE citrus_usr.pr_valid_hldg
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--- CDSL 1234567890123456 INE268A01031 2     
--exec pr_valid_hldg  'CDSL','1234567890123456','C000012087', 1 ,''      
--exec pr_valid_hldg 'CDSL','1234567890123456','INE268A01031','700',''      
--select * from dp_acct_mstr where dpam_id = 61171      
--select * from bitmap_ref_mstr    
--insert into bitmap_ref_mstr     
--select 377, 'HLDG_WARN','HLDG_WARN','0','Y','','HO',getdate(),'HO',getdate(),1      
CREATE proc [citrus_usr].[pr_valid_hldg](@pa_cd varchar(10),@pa_boid varchar(20),@pa_isin varchar(20),@pa_qty numeric(18,3),@pa_out varchar(25) output)      
as      
begin      
      
  declare @l_avail_qty numeric(18,3)      
  declare @l_unapprove_qty  numeric(18,3)      
  declare @l_approve_qty  numeric(18,3)      
  declare @l_hldg_qty  numeric(18,3)      
      
  set @l_avail_qty = 0      
  set @l_unapprove_qty = 0      
  set @l_approve_qty = 0       
  set @l_hldg_qty = 0       
if exists(select bitrm_id from bitmap_ref_mstr where bitrm_parent_cd  = 'HLDG_WARN' and bitrm_values = 'Y' and bitrm_deleted_ind = 1)    
begin       
 if @pa_cd = 'CDSL'      
 begin       
   select @l_hldg_qty = DPHMCd_FREE_QTY from holdingallforview  , dp_acct_mstr       
   where dpam_id = DPHMCd_DPAM_ID       
   and dpam_sba_no = @pa_boid       
   and DPHMCd_ISIN = @pa_isin      
   and dpam_deleted_ind = 1

--
--  
--print @l_hldg_qty 
--     
--   select @l_unapprove_qty = DPTDC_QTY * -1 from dptdc_mak , dp_acct_mstr       
--   where dpam_id = dptdc_dpam_id       
--   and dpam_sba_no = @pa_boid       
--   and dptdc_isin = @pa_isin      
--   and dpam_deleted_ind = 1       
--   and isnull(DPTDC_BROKERBATCH_NO,'') = ''      
--   and dptdc_deleted_ind in (0,-1)    
--   and isnull(dptdc_res_cd,'') = ''  
--
--print @l_unapprove_qty    
--       
--       
--   select @l_approve_qty = DPTDC_QTY * - 1 from dp_trx_dtls_cdsl , dp_acct_mstr       
--   where dpam_id = dptdc_dpam_id       
--   and dpam_sba_no = @pa_boid       
--   and dptdc_isin = @pa_isin      
--   and dpam_deleted_ind = 1       
--   and isnull(DPTDC_BROKERBATCH_NO,'') = ''      
--   and dptdc_deleted_ind = 1      
--   and isnull(DPTDC_TRANS_NO,'') <> ''      
--   and isnull(DPTDC_BATCH_NO,'') <> '' 
--
--print @l_approve_qty  
  


     
       
 end       
   
   set @l_avail_qty =   ABS(isnull(@l_hldg_qty ,0)) - (ABS(isnull(@l_unapprove_qty ,0)) + ABS(isnull(@l_approve_qty ,0)))   
       
print 'd'
   print @l_avail_qty
print @pa_qty

   if @l_avail_qty < @pa_qty      
   begin       
  set @pa_out = 'N'      
   end      
   else       
   begin       
  set @pa_out = 'Y'         
   end       
         
  
end    
else     
begin     
set @pa_out = 'Y'     
end     
      
        
      
       
end

GO
