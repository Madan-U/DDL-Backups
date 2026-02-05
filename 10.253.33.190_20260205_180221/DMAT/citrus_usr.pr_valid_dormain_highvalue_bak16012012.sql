-- Object: PROCEDURE citrus_usr.pr_valid_dormain_highvalue_bak16012012
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

---pr_valid_dormain_highvalue '4','DORMENT',640,'Formno'
create procedure [citrus_usr].[pr_valid_dormain_highvalue_bak16012012](@pa_id numeric,@pa_action varchar(100), @pa_dtls_id numeric,@pa_output varchar(8000) output)
as
begin

declare @l_dpam_acct_no varchar(25)
, @l_req_dt datetime
, @l_excsm_id numeric
, @l_excsm_cd  varchar(80)
, @l_dpm_id numeric
, @l_isin   varchar(50)
, @l_qty    numeric(18,3)
select @l_excsm_id = dpm_excsm_id , @l_dpm_id = dpm_id from dp_mstr where dpm_excsm_id = default_dp and dpm_excsm_id = @pa_id and dpm_deleted_ind = 1
select @l_excsm_cd = excsm_exch_cd from exch_seg_mstr where excsm_id = @l_excsm_id and excsm_deleted_ind = 1


if @l_excsm_cd = 'CDSL'
begin 
 select @l_dpam_acct_no  =  dpam_sba_no 
       ,@l_req_dt        =  dptdc_request_dt
 from dp_acct_mstr 
    , dp_trx_dtls_cdsl 
 where dptdc_dpam_id = dpam_id 
 and dptdc_dtls_id = @pa_dtls_id 
-- and dpam_sba_no = @pa_dtls_id 
 and dpam_dpm_id = @l_dpm_id 
 and dptdc_deleted_ind = 1 
 and dpam_deleted_ind = 1

end 

if @l_excsm_cd = 'NSDL'
begin 
 select @l_dpam_acct_no  =  dpam_sba_no 
       ,@l_req_dt        =  dptd_request_dt
 from dp_acct_mstr 
    , dp_trx_dtls
 where dptd_dpam_id = dpam_id 
 and dptd_dtls_id = @pa_dtls_id 
 and dpam_dpm_id = @l_dpm_id 
 and dptd_deleted_ind = 1 
 and dpam_deleted_ind = 1

end 
print @l_dpam_acct_no
print @l_req_dt
if @pa_action = 'DORMENT'
print @l_dpam_acct_no
print @l_req_dt

select @pa_output = citrus_usr.fn_get_high_val('',0,'DORMANT',@pa_dtls_id,getdate())

if @pa_action = 'HIGH' and @l_excsm_cd = 'NSDL' 
begin 
	if exists(select dptd_dtls_id from dp_trx_dtls where citrus_usr.fn_get_high_val(dptd_isin,abs(dptd_qty),'HIGH_VALUE','','') = 'Y' and dptd_dtls_id = @pa_dtls_id and dptd_deleted_ind = 1)
	begin
	set @pa_output = 'Y'
	end 
	else
	begin 
	set @pa_output = 'N'
	end 
end
if @pa_action = 'HIGH' and @l_excsm_cd = 'CDSL' 
begin 
print @pa_dtls_id
--	if exists(select dptdc_dtls_id from dp_trx_dtls_cdsl where citrus_usr.fn_get_high_val(dptdc_isin,abs(dptdc_qty),'HIGH_VALUE','','') = 'Y' and dptdc_dtls_id = @pa_dtls_id and dptdc_deleted_ind = 1)
if exists(select dptdc_dtls_id from dptdc_mak where citrus_usr.fn_get_high_val(dptdc_isin,abs(dptdc_qty),'HIGH_VALUE','','') = 'Y' and dptdc_dtls_id = @pa_dtls_id and dptdc_deleted_ind = -1)
	begin
	set @pa_output = 'Y'
	end 
	else
	begin 
	set @pa_output = 'N'
	end 
end

print @pa_output 


end

GO
