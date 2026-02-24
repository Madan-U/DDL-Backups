-- Object: PROCEDURE citrus_usr.pr_valid_hldg_nsdl
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

---	CDSL	1234567890123456	INE268A01031	2	
--exec pr_valid_hldg 	'CDSL','1234567890123456','C000012087',	1 ,''		
--exec pr_valid_hldg 'CDSL','1234567890123456','INE268A01031','700',''  
--select * from dp_acct_mstr where dpam_id = 61171  
--select * from bitmap_ref_mstr
--insert into bitmap_ref_mstr 
--select 377, 'HLDG_WARN','HLDG_WARN','0','Y','','HO',getdate(),'HO',getdate(),1  
CREATE proc [citrus_usr].[pr_valid_hldg_nsdl](@pa_cd varchar(10),@pa_boid varchar(20),@pa_isin varchar(20),@pa_qty numeric(18,3),@pa_out varchar(25) output)  
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
	if @pa_cd = 'NSDL'  
   if left(@pa_boid,2) = 'IN'
   begin 
    select @l_hldg_qty = DPDHM_QTY from DP_HLDG_MSTR_NSDL  , dp_acct_mstr  ,account_properties 
	  where dpam_id = DPDHM_DPAM_ID   
      and dpam_id = ACCP_CLISBA_ID	  
      and accp_value  = @pa_boid   
	  and DPDHM_ISIN  = @pa_isin        
	  and dpam_deleted_ind = 1  

   End
   else
   
	begin   
	  select @l_hldg_qty = DPDHM_QTY from DP_HLDG_MSTR_NSDL  , dp_acct_mstr   
	  where dpam_id = DPDHM_DPAM_ID   
	  and dpam_sba_no = @pa_boid   
	  and DPDHM_ISIN = @pa_isin  
	  and dpam_deleted_ind = 1   
	  
	  select @l_unapprove_qty = DPTD_QTY*-1 from dptd_mak , dp_acct_mstr   
	  where dpam_id = dptd_dpam_id   
	  and dpam_sba_no = @pa_boid   
	  and dptd_isin = @pa_isin  
	  and dpam_deleted_ind = 1   
	  and isnull(DPTD_BROKERBATCH_NO,'') = ''  
	  and dptd_deleted_ind in (0,-1)  
	  
	  
	  select @l_approve_qty = DPTD_QTY* - 1 from dp_trx_dtls , dp_acct_mstr   
	  where dpam_id = dptd_dpam_id   
	  and dpam_sba_no = @pa_boid   
	  and dptd_isin = @pa_isin  
	  and dpam_deleted_ind = 1   
	  and isnull(DPTD_BROKERBATCH_NO,'') = ''  
	  and dptd_deleted_ind = 1  
	  and isnull(DPTD_TRANS_NO,'') <> ''  
	  and isnull(DPTD_BATCH_NO,'') <> ''  
	  
	end   
	  
	  set @l_avail_qty =   isnull(@l_hldg_qty ,0)  
	  
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
	    
	 print @pa_out  
end
else 
begin 
set @pa_out = 'Y' 
end 
  
    
  
   
end

GO
