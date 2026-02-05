-- Object: PROCEDURE citrus_usr.pr_upd_demrm_rej_dt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--
--exec pr_upd_demrm_rej_dt '','1|*~|16/12/2001|*~|100.00*|~*2|*~|01/12/2001|*~|15.000*|~*3|*~|15/12/2001*|~*',''
CREATE proc [citrus_usr].[pr_upd_demrm_rej_dt](@pa_id varchar, @pa_values varchar(8000) ,@pa_loginname varchar(100), @pa_dpid varchar(10) , @pa_output varchar(8000) out)
as
begin 

set dateformat dmy 

create table #demrm_details
(tmpdemrm_id numeric,rejdate varchar(11))

declare @l_counter numeric
,@l_count numeric
,@l_value varchar(100)
,@l_error bigint


declare @l_sba_no varchar(8000)
,@l_rej_dt varchar(11)
,@l_amount numeric(10,2)

SET @l_error     = 0
set @l_counter =1
set @l_count =citrus_usr.ufn_countstring(@pa_values,'*|~*')

while @l_counter <= @l_count
begin 
set @l_value = citrus_usr.fn_splitval_by(@pa_values,@l_counter,'*|~*')

insert into #demrm_details
select citrus_usr.fn_splitval(@l_value,1),citrus_usr.fn_splitval(@l_value,2)





select @l_sba_no  = dpam_sba_no from dp_acct_mstr , demat_request_mstr 
where demrm_dpam_id = dpam_id and demrm_id = citrus_usr.fn_splitval(@l_value,1) 
set @l_rej_dt = citrus_usr.fn_splitval(@l_value,2)
set @l_amount = citrus_usr.fn_splitval(@l_value,3)*-1

exec pr_ins_upd_manualcharge_app '0','INS',@pa_loginname,@pa_dpid,'C',@l_sba_no,'2',@l_rej_dt,'REJECTION CHARGES',@l_amount,'NSDL',0,'*|~*','|*~|',''

set @l_value= ''

set @l_counter = @l_counter  + 1 

end 

BEGIN TRANSACTION

update demrm set  DEMRM_RESPONSE_DT = rejdate from demat_request_mstr demrm , #demrm_details
where demrm_id = tmpdemrm_id





SET @l_error = @@error
                    
    IF @l_error > 0
    BEGIN
    --
      SELECT 'Error:Cannot not be update'
      --
      ROLLBACK TRANSACTION
    --
    END
    ELSE
    BEGIN
	--
    SELECT '1'
     commit transaction
	END



end

GO
