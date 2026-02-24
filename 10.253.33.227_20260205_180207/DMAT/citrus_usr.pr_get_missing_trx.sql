-- Object: PROCEDURE citrus_usr.pr_get_missing_trx
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_get_missing_trx](@pa_id numeric , @pa_from_dt datetime, @pa_to_dt datetime ,@pa_out varchar(8000) out)
as
begin
  declare @l_exch varchar(10)
  select @l_exch = excsm_exch_cd from exch_seg_mstr where excsm_id = @pa_id and excsm_deleted_ind = 1 

  if @l_exch = 'NSDL'
  begin
     select * from dptd_mak dptdm where dptd_deleted_ind = 1 
     and not exists(select dptd_id from dp_trx_dtls dptd where dptdm.dptd_id = dptd.dptd_id and dptd_deleted_ind = 1)
     and   dptd_request_dt between @pa_from_dt and @pa_to_dt
  end 
  else 
  begin
      select * from dptdc_mak dptdcm where dptdc_deleted_ind = 1 
      and not exists(select dptdc_id from dp_trx_dtls_cdsl dptdc where dptdcm.dptdc_id = dptdc.dptdc_id and dptdc_deleted_ind = 1)
     and   dptdc_request_dt between @pa_from_dt and @pa_to_dt
  end 
end

GO
