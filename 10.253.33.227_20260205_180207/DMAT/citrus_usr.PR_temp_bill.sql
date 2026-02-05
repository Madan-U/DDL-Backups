-- Object: PROCEDURE citrus_usr.PR_temp_bill
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create    procedure [citrus_usr].[PR_temp_bill]
(
-- exec pR_temp_bill 'Jun 01 2018' , 'Jun 30 2018' , 'Ho'
@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_login_name varchar(100)
)
AS
BEGIN
select ''''+convert(varchar, Actual_Trans_dt,103) Actual_Trans_dt, ''''+dpam_sba_no dpam_sba_no,charge_name,
abs(charge_val) abs,''''+convert(varchar, Bill_charge_dt,103) Bill_charge_dt,
Flg
 from Temp_Bill where Actual_Trans_dt between @pa_from_dt and @pa_to_dt
and Flg = '0'
end

GO
