-- Object: FUNCTION citrus_usr.Fn_Toget_Midchk
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create function Fn_Toget_Midchk(@pa_slip_no varchar(16),@pa_dptdc_id int)
returns varchar(20)
as
begin
DECLARE @l_mid_chk  varchar(30)    
select @l_mid_chk =dptdc_mid_chk from dptdc_mak where dptdc_deleted_ind=1 and dptdc_id=@pa_dptdc_id and dptdc_slip_no=@pa_slip_no
return @l_mid_chk
end

GO
