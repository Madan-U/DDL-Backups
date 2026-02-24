-- Object: PROCEDURE citrus_usr.PR_Transfer_Previous_Log_bak_05112016
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create Procedure PR_Transfer_Previous_Log 
(
@pa_boid varchar(16),
@pa_date varchar(25),
@pa_mrkt varchar(10)
)

as
begin
 SELECT OTP_BOID,LEFT(OTP_BOID,8) DPID,DPNAME=(SELECT TOP 1 DPM_NAME FROM DP_MSTR WHERE DPM_DPID=LEFT(OTP_BOID,8)),DPTDC_EXECUTION_DT,case when DPTDC_INTERNAL_TRASTM='BOBO' then 'OFF MKT' else 'ONMKT' end MARKET FROM OTP_MSTR, DPTDC_MAK WHERE DPTDC_SLIP_NO=OTP_INTREFNO and DPTDC_EXECUTION_DT = @pa_date 


end

GO
