-- Object: PROCEDURE citrus_usr.pr_get_holding
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--exec pr_get_holding 3,'mar 31 2015','1203320000000066','1203320000000070'

--exec pr_get_holding 3,'mar 31 2015','0','9999999999999999'
--select * from holdingall_dumpforaudit
CREATE proc [citrus_usr].[pr_get_holding](@pa_dpm_id numeric,@pa_dt datetime,@pa_from_acct_no varchar(16),@pa_to_acct_no varchar(16))
as
begin 

--return 0
drop table holdingall_dumpforaudit
select top 0 * into holdingall_dumpforaudit from holdingall_structure

insert into holdingall_dumpforaudit
exec [pr_get_holding_fix_latest_asondate] @pa_dpm_id,@pa_dt,@pa_dt,@pa_from_acct_no,@pa_to_acct_no,''    

--select dpam_sba_no ,holding.DPHMCD_ISIN isin , holding.DPHMCD_CURR_QTY  qty from holdingall_dumpforaudit holding , dp_acct_mstr with(nolock)
--where DPHMCD_DPAM_ID = DPAM_ID  
 


end

GO
