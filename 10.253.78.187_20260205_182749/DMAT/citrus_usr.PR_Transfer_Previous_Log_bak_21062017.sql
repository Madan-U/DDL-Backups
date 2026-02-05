-- Object: PROCEDURE citrus_usr.PR_Transfer_Previous_Log_bak_21062017
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------





CREATE Procedure [citrus_usr].[PR_Transfer_Previous_Log] 
(
@pa_boid varchar(16),
@pa_date varchar(25),
@to_date varchar(25),
@pa_mrkt varchar(10)
)

as
begin
if isnull(@pa_boid,'')='ALL'
begin
if isnull(@pa_boid,'')='ALL'
begin

SELECT distinct OTP_BOID,LEFT(OTP_BOID,8) DPID,
DPNAME=(SELECT TOP 1 DPM_NAME FROM DP_MSTR WHERE DPM_DPID=LEFT(OTP_BOID,8)),DPTDC_EXECUTION_DT 
,case when DPTDC_INTERNAL_TRASTM='BOBO' then 'OFF MKT' else 'ONMKT' end MARKET
,OTP_INTREFNO ,OTP_NO,Onip_Ip_address  + ' - STATUS : ' + case when dptdc_deleted_ind=0 then 'PENDING' when dptdc_deleted_ind='3' then
'REJECTED' WHEN DPTDC_DELETED_IND='1' THEN 'APPROVED' ELSE '' END  IP , OTP_LST_UPD_DT MSGLG
FROM OTP_MSTR, DPTDC_MAK,Onlinetbl_IP_Mstr onl WHERE DPTDC_SLIP_NO=convert(varchar,OTP_INTREFNO)
and onl.Onip_slip_no = convert(varchar,OTP_INTREFNO)
and DPTDC_EXECUTION_DT  between @pa_date and @to_date and case when DPTDC_INTERNAL_TRASTM in ('BOBO') then 'OFF MKT'
when DPTDC_INTERNAL_TRASTM not in ('BOBO') then 'ONMKT' else  DPTDC_INTERNAL_TRASTM end  =@pa_mrkt
--and OTP_BOID = @pa_boid
end

else if len(isnull(@pa_boid,''))<>'ALL'
begin

Select DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY*-1 DPTDC_QTY,isnull(DPTDC_TRANS_NO,'0') DPTDC_TRANS_NO
,DPTDC_COUNTER_DP_ID,
DPTDC_COUNTER_DEMAT_ACCT_NO,DPTDC_COUNTER_CMBP_ID
 from dp_trx_dtls_cdsl,dp_acct_mstr where 
   dpam_id=dptdc_dpam_id and dpam_deleted_ind=1
 and DPTDC_DELETED_IND=1 and DPTDC_SLIP_NO = @pa_boid 
end

end 
else
begin

if len(isnull(@pa_boid,''))='16'
begin
 SELECT distinct OTP_BOID,LEFT(OTP_BOID,8) DPID,
DPNAME=(SELECT TOP 1 DPM_NAME FROM DP_MSTR WHERE DPM_DPID=LEFT(OTP_BOID,8)),DPTDC_EXECUTION_DT 
,case when DPTDC_INTERNAL_TRASTM='BOBO' then 'OFF MKT' else 'ONMKT' end MARKET
,OTP_INTREFNO,OTP_NO,Onip_Ip_address + ' - STATUS : ' + case when dptdc_deleted_ind=0 then 'PENDING' when dptdc_deleted_ind='3' then
'REJECTED' WHEN DPTDC_DELETED_IND='1' THEN 'APPROVED' ELSE '' END IP , OTP_LST_UPD_DT MSGLG
FROM OTP_MSTR, DPTDC_MAK,Onlinetbl_IP_Mstr onl WHERE DPTDC_SLIP_NO=OTP_INTREFNO and onl.Onip_slip_no = OTP_INTREFNO
and DPTDC_EXECUTION_DT  between @pa_date and @to_date
and OTP_BOID = @pa_boid
end

if len(isnull(@pa_boid,''))<>'16'
begin
Select DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY*-1 DPTDC_QTY,isnull(DPTDC_TRANS_NO,'0') DPTDC_TRANS_NO
,DPTDC_COUNTER_DP_ID,
DPTDC_COUNTER_DEMAT_ACCT_NO,DPTDC_COUNTER_CMBP_ID
 from dp_trx_dtls_cdsl,dp_acct_mstr where 
   dpam_id=dptdc_dpam_id and dpam_deleted_ind=1
 and DPTDC_DELETED_IND=1 and DPTDC_SLIP_NO = @pa_boid 
end
end

end

GO
