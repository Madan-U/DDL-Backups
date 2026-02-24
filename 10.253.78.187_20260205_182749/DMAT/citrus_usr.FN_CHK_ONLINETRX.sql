-- Object: FUNCTION citrus_usr.FN_CHK_ONLINETRX
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE FUNCTION FN_CHK_ONLINETRX
(@pa_slip_no varchar(20))
returns varchar(20)
as
begin
declare @pa_val varchar(20)
if exists (SELECT otp_no FROM OTP_MSTR WHERE OTP_INTREFNO=@PA_SLIP_NO AND OTP_DELETED_IND=1)
begin
set @pa_val='Y'
end 
else
begin 
set @pa_val='N'
end
return @pa_val

end

GO
