-- Object: PROCEDURE citrus_usr.PR_Transfer_Previous_Log
-- Server: 10.253.33.227 | DB: DMAT
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
print 'here'
SELECT distinct OTP_BOID,LEFT(OTP_BOID,8) DPID,
DPNAME=(SELECT TOP 1 DPM_NAME FROM DP_MSTR WHERE DPM_DPID=LEFT(OTP_BOID,8)),DPTDC_EXECUTION_DT 
,case when DPTDC_INTERNAL_TRASTM='BOBO' then 'OFF MKT' else 'ONMKT' end MARKET
,OTP_INTREFNO ,OTP_NO,Onip_Ip_address  + ' - STATUS : ' + case when dptdc_deleted_ind=0 then 'PENDING' when dptdc_deleted_ind='3' then
'REJECTED' WHEN DPTDC_DELETED_IND='1' THEN 'APPROVED' ELSE '' END  IP , OTP_LST_UPD_DT MSGLG
,dptdc_id
FROM OTP_MSTR, DPTDC_MAK,Onlinetbl_IP_Mstr onl WHERE DPTDC_SLIP_NO=convert(varchar,OTP_INTREFNO)
and onl.Onip_slip_no = convert(varchar,OTP_INTREFNO)
and DPTDC_EXECUTION_DT  between @pa_date and @to_date and case when DPTDC_INTERNAL_TRASTM in ('BOBO') then 'OFF MKT'
when DPTDC_INTERNAL_TRASTM not in ('BOBO') then 'ONMKT' else  DPTDC_INTERNAL_TRASTM end  =@pa_mrkt

union all 
SELECT distinct DPAM_SBA_NO OTP_BOID,LEFT(DPAM_SBA_NO,8) DPID,
DPNAME=(SELECT TOP 1 DPM_NAME FROM DP_MSTR WHERE DPM_DPID=LEFT(DPAM_SBA_NO,8)),DPTDC_EXECUTION_DT 
,case when DPTDC_INTERNAL_TRASTM='BOBO' then 'OFF MKT' else 'ONMKT' end MARKET
--,isnull(OTP_INTREFNO,'0') OTP_INTREFNO 
,isnull(DPTDC_SLIP_NO ,'0') OTP_INTREFNO 
,isnull(OTP_NO,'0') OTP_NO,isnull(Onip_Ip_address,'0')  + ' - STATUS : ' + case when (dptdc_deleted_ind=0 and ISNULL(dptdc_trans_no,'0')='0') 
then 'PENDING' when dptdc_deleted_ind='3' then
'REJECTED' WHEN (DPTDC_DELETED_IND='0' and ISNULL(dptdc_trans_no,'0')<>'0') THEN 'APPROVED' ELSE '' END  IP , OTP_LST_UPD_DT MSGLG
,dptdc_id
FROM  EDIS_PRE_DPTDC_MAK E
--,Onlinetbl_IP_Mstr onl 
 left outer join OTP_MSTR on DPTDC_SLIP_NO=convert(varchar,OTP_INTREFNO)
left outer join Onlinetbl_IP_Mstr onl on onl.Onip_slip_no = DPTDC_SLIP_NO --OTP_INTREFNO
,dp_acct_mstr
WHERE DPTDC_EXECUTION_DT  between @pa_date and @to_date and case when DPTDC_INTERNAL_TRASTM in ('BOBO') then 'OFF MKT'
when DPTDC_INTERNAL_TRASTM not in ('BOBO') then 'ONMKT' else  DPTDC_INTERNAL_TRASTM end  =@pa_mrkt
and DPAM_ID=DPTDC_DPAM_ID and DPAM_DELETED_IND=1
and ISNULL(dptdc_trans_no,'0')<>'0'
order by DPTDC_EXECUTION_DT


--and OTP_BOID = @pa_boid
end

else if len(isnull(@pa_boid,''))<>'ALL'
begin

Select distinct DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY*-1 DPTDC_QTY,isnull(DPTDC_TRANS_NO,'0') DPTDC_TRANS_NO
,DPTDC_COUNTER_DP_ID,
DPTDC_COUNTER_DEMAT_ACCT_NO,DPTDC_COUNTER_CMBP_ID
,dptdc_id
 from dp_trx_dtls_cdsl,dp_acct_mstr where 
   dpam_id=dptdc_dpam_id and dpam_deleted_ind=1
 and DPTDC_DELETED_IND=1 and DPTDC_SLIP_NO = @pa_boid 
 
end

end 
else
begin

if len(isnull(@pa_boid,''))='16'
begin
if (@pa_boid='1203320006685107')
begin
print 'boid '
 SELECT distinct OTP_BOID,LEFT(OTP_BOID,8) DPID,
DPNAME=(SELECT TOP 1 DPM_NAME FROM DP_MSTR WHERE DPM_DPID=LEFT(OTP_BOID,8)),DPTDC_EXECUTION_DT 
,case when DPTDC_INTERNAL_TRASTM='BOBO' then 'OFF MKT' else 'ONMKT' end MARKET
,OTP_INTREFNO,OTP_NO,case when Onip_Ip_address='182.77.105.130' then '117.196.42.154' else  Onip_Ip_address end+ ' - STATUS : ' + case when dptdc_deleted_ind=0 then 'PENDING' when dptdc_deleted_ind='3' then
'REJECTED' WHEN DPTDC_DELETED_IND='1' THEN 'APPROVED' ELSE '' END IP , OTP_LST_UPD_DT MSGLG
,dptdc_id
FROM OTP_MSTR, DPTDC_MAK,Onlinetbl_IP_Mstr onl WHERE DPTDC_SLIP_NO=OTP_INTREFNO and onl.Onip_slip_no = OTP_INTREFNO
and DPTDC_EXECUTION_DT  between @pa_date and @to_date
and OTP_BOID = @pa_boid and dptdc_id<>'697555'
end
else
begin
print 'boidl'
 SELECT distinct dpam_sba_no OTP_BOID,LEFT(dpam_sba_no,8) DPID,
DPNAME=(SELECT TOP 1 DPM_NAME FROM DP_MSTR WHERE DPM_DPID=LEFT(dpam_sba_no,8)),DPTDC_EXECUTION_DT 
,case when DPTDC_INTERNAL_TRASTM in ('BOBO', 'ID') then 'OFF MKT' else 'ONMKT' end MARKET
,dptdc_DTLS_id OTP_INTREFNO,'NA' OTP_NO,'NA' IP 
, Case when isnull(dptdc_trans_no,'0')<>'0' then 'Accepted At CDSL For PreEDIS' when isnull(dptdc_trans_no,'0')='0' then 'Rejected'  
when isnull((Select 'Batch Generated' from DP_TRX_DTLS_CDSL M where M.DPTDC_SLIP_NO=E.DPTDC_SLIP_NO and isnull(dptdc_batch_no,'0')<>'0' and isnull(dptdc_trans_no,'0')='0'),'')='Batch Generated' then 'Batch Generated'
when isnull((Select 'Response Updated' from DP_TRX_DTLS_CDSL M where M.DPTDC_SLIP_NO=E.DPTDC_SLIP_NO and isnull(dptdc_batch_no,'0')<>'0' and isnull(dptdc_trans_no,'0')<>'0'),'')='Response Updated' then 'Response Updated'
else
''
end MSGLG
,dptdc_id
FROM 
dp_acct_mstr,
EDIS_PRE_DPTDC_MAK  E left outer join OTP_MSTR on DPTDC_SLIP_NO=OTP_INTREFNO
left outer join Onlinetbl_IP_Mstr onl on onl.Onip_slip_no = OTP_INTREFNO
where  DPTDC_EXECUTION_DT  between @pa_date and @to_date and dpam_id=DPTDC_DPAM_ID and DPAM_DELETED_IND=1
--and OTP_BOID = @pa_boid
and DPAM_SBA_NO=@pa_boid
and @pa_mrkt=case when DPTDC_INTERNAL_TRASTM in ('BOBO', 'ID') then 'OFF MKT' else 'ONMKT' end
end 
end

if len(isnull(@pa_boid,''))<>'16'
begin
print '<>16'
  Select distinct DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_EXECUTION_DT,DPTDC_ISIN,DPTDC_QTY*-1 DPTDC_QTY,isnull(DPTDC_TRANS_NO,'0') DPTDC_TRANS_NO
,DPTDC_COUNTER_DP_ID,
DPTDC_COUNTER_DEMAT_ACCT_NO,DPTDC_COUNTER_CMBP_ID
,dptdc_id
 from 
 --dp_trx_dtls_cdsl
 EDIS_PRE_DPTDC_MAK
 ,dp_acct_mstr where 
 dpam_id=dptdc_dpam_id and dpam_deleted_ind=1
 --and DPTDC_DELETED_IND IN (0,-1)
  and DPTDC_SLIP_NO =@pa_boid --DPTDC_SLIP_NO = @pa_boid 
  
 end 
 
 
 
end
end

--end

GO
