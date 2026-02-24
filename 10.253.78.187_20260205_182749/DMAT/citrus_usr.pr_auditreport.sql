-- Object: PROCEDURE citrus_usr.pr_auditreport
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_auditreport '','1','17/12/2001','12/07/2010'

CREATE procedure [citrus_usr].[pr_auditreport](@PA_EXCH_CD VARCHAR(100),@pa_audit_report_no numeric,@pa_from_dt varchar(30), @pa_to_dt varchar(30))
as
begin

set dateformat dmy
set @pa_to_dt = @pa_to_dt + ' 23:59:59'
select convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties 
from account_properties 
where accp_accpm_prop_cd = 'BILL_START_DT' 

if @pa_audit_report_no = '0'
begin
select id, report from auditreport
end 
if @pa_audit_report_no = '1'
begin
--client Type, category and Sub category
select  identity(bigint,1,1) id , enttm_desc CATEGORY ,clicm_desc TYPES ,subcm_desc [SUB CATEGORY] ,count(distinct dpam_sba_no) count   into #temp1 
from dp_acct_mstr , #account_properties ,entity_type_mstr , client_ctgry_mstr , sub_ctgry_mstr
where dpam_enttm_cd = enttm_cd and dpam_clicm_cd = clicm_cd  and dpam_subcm_cd = subcm_cd
and accp_clisba_id = dpam_id and accp_value between @pa_from_dt and @pa_to_dt
group by clicm_desc,enttm_desc,subcm_desc 
--client Type, category and Sub category
select id [Sr no],CATEGORY,TYPES,[SUB CATEGORY],count [No of] from #temp1
end 

if @pa_audit_report_no = '2'
begin
--During particular period how many accounts activated/ closed/ to be closed with client Type, category and Sub category. 

select  identity(bigint,1,1) id ,stam_desc STATUS , enttm_desc CATEGORY ,clicm_desc TYPES,subcm_desc [SUB CATEGORY] ,count(distinct dpam_sba_no) count   into #temp2 
from dp_acct_mstr , #account_properties ,entity_type_mstr , client_ctgry_mstr , sub_ctgry_mstr,status_mstr
where dpam_enttm_cd = enttm_cd and dpam_clicm_cd = clicm_cd  and dpam_subcm_cd = subcm_cd and stam_Cd = dpam_stam_cd
and accp_clisba_id = dpam_id and accp_value between @pa_from_dt and @pa_to_dt
group by stam_desc,clicm_desc,enttm_desc,subcm_desc 
--During particular period how many accounts activated/ closed/ to be closed with client Type, category and Sub category. 

select id [Sr no],status,CATEGORY,TYPES,[SUB CATEGORY],count [No of] from #temp2
end 
if @pa_audit_report_no = '3'
begin
--During particular period how many accounts activated/ closed/ to be closed with client Type, category and Sub category. 

select  identity(bigint,1,1) id ,stam_desc,count(dpam_sba_no) [Initiated by BO’s],''  [Initiated by DP]   into #temp4 
from dp_acct_mstr , #account_properties ,entity_type_mstr , client_ctgry_mstr , sub_ctgry_mstr,status_mstr
where dpam_enttm_cd = enttm_cd and dpam_clicm_cd = clicm_cd  and dpam_subcm_cd = subcm_cd and stam_Cd = dpam_stam_cd
and accp_clisba_id = dpam_id and accp_value between @pa_from_dt and @pa_to_dt AND DPAM_STAM_CD = '05'
group by stam_desc,clicm_desc,enttm_desc,subcm_desc 

--During particular period how many accounts activated/ closed/ to be closed with client Type, category and Sub category. 

select id [Sr no],[Initiated by BO’s],[Initiated by DP]  from #temp4
end 

if @pa_audit_report_no = '4'
begin

CREATE TABLE  #TEMP3(TRA_TYPE VARCHAR(1500),NO_COUNT NUMERIC)

INSERT INTO #TEMP3
select  case when DPTDC_INTERNAL_TRASTM = 'EP' then 'EARLY PAYIN'
when DPTDC_INTERNAL_TRASTM = 'NP' then 'NORMAL PAYIN'
when DPTDC_INTERNAL_TRASTM = 'BOBO' then 'OFF MARKET BO - BO'
when DPTDC_INTERNAL_TRASTM = 'ID' then 'INTER DEPOSITORY'
when DPTDC_INTERNAL_TRASTM = 'CMBO' then 'OFF MARKET CM - BO'
when DPTDC_INTERNAL_TRASTM = 'BOCM' then 'OFF MARKET Bo - CM'
else  DPTDC_INTERNAL_TRASTM  end [TRANSACTION TYPE], count( dptdc_isin) [NO OF TRANSACTION EXECUTED] 
from cdsl_holding_dtls,dp_trx_dtls_cdsl where  CDSHM_TRANS_NO = DPTDC_TRANS_NO
and CDSHM_TRAS_DT between @pa_from_dt and @pa_to_dt and CDSHM_TRATM_CD in('2246','2277')
and CDSHM_TRANS_NO <>''
and CDSHM_QTY  < 0
group by DPTDC_INTERNAL_TRASTM 




INSERT INTO #TEMP3
SELECT citrus_usr.FN_GET_TRAN_TYPE(CDSHM_TRATM_DESC,'') ,COUNT( CDSHM_ISIN) FROM CDSL_HOLDING_DTLS WHERE NOT EXISTS(SELECT DPTDC_TRANS_NO FROM DP_TRX_DTLS_CDSL 
                                                 WHERE DPTDC_TRANS_NO = CDSHM_TRANS_NO 
                                                 --AND   DPTDC_EXECUTION_DT BETWEEN @pa_from_dt and @pa_to_dt
                                                 )
AND   CDSHM_TRAS_DT BETWEEN @pa_from_dt and @pa_to_dt
AND  CDSHM_TRATM_CD in('2246','2277')
and  CDSHM_QTY  < 0 and CDSHM_TRANS_NO <>''
and  CDSHM_TRATM_DESC not like 'CA%'
and  CDSHM_TRATM_DESC not like 'A TRANSFER%'
group by citrus_usr.FN_GET_TRAN_TYPE(CDSHM_TRATM_DESC,'')





SELECT identity(bigint,1,1) id , UPPER(TRA_TYPE) [TRANSACTION TYPE] , sum(NO_COUNT)  [NO OF TRANSACTION EXECUTED]  into #temp5 FROM #TEMP3
group by TRA_TYPE

select id [Sr no], [TRANSACTION TYPE]  , [NO OF TRANSACTION EXECUTED]  from #temp5



end 

if @pa_audit_report_no = '5'
begin
select  identity(bigint,1,1) id ,   case when DPTDC_INTERNAL_TRASTM = 'EP' then 'EARLY PAYIN'
when DPTDC_INTERNAL_TRASTM = 'NP' then 'NORMAL PAYIN'
when DPTDC_INTERNAL_TRASTM = 'BOBO' then 'OFF MARKET BO - BO'
when DPTDC_INTERNAL_TRASTM = 'ID' then 'INTER DEPOSITORY'
when DPTDC_INTERNAL_TRASTM = 'CMBO' then 'OFF MARKET CM - BO'
when DPTDC_INTERNAL_TRASTM = 'BOCM' then 'OFF MARKET Bo - CM'
else  DPTDC_INTERNAL_TRASTM  end [TRANSACTION TYPE], count(distinct  dptdc_slip_no)  [NO OF SLIP PROCESSED] into #temp6 from dp_trx_dtls_cdsl where  DPTDC_REQUEST_DT between @pa_from_dt and @pa_to_dt
group by DPTDC_INTERNAL_TRASTM 

select id [Sr no], [TRANSACTION TYPE] , [NO OF SLIP PROCESSED] from #temp6

end 

 




end

GO
