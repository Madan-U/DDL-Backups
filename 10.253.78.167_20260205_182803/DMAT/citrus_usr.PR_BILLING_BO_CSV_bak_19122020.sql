-- Object: PROCEDURE citrus_usr.PR_BILLING_BO_CSV_bak_19122020
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



--1489--
--select * from dp_mstr
--[PR_BILLING_BO_CSV] 'sep 04 2012','sep 05 2012','12010900','Y','Y','P','B','comm'  

create   PROCEDURE [citrus_usr].[PR_BILLING_BO_CSV_bak_19122020]  
(@PA_BILLING_FROM_DT DATETIME  
,@PA_BILLING_TO_DT   DATETIME  
,@PA_DP_ID          VARCHAR(16)  
,@PA_BILLING_STATUS  CHAR(1)  
,@PA_POSTED_FLG      CHAR(1)  
,@PA_BILL_POST_SHW_BILL   CHAR(1)  
,@PA_B2B_OUTSTANDING_FLG CHAR(1)
,@PA_LOGIN_NAME   VARCHAR(20)  
)  
AS  
BEGIN  
--  


	
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
  DECLARE  @DPPOSTACCOUNT NUMERIC(10,0)  
         , @L_FIN_ID      INT  
         , @L_REF_NO      VARCHAR(16)  
         , @L_SQL         VARCHAR(8000)  
         , @L_DPM_ID      INT  
         , @L_VOUCHER_NO  INT  
         , @BROKERGL_ACC_CD VARCHAR(20)  
         , @DP_NAME VARCHAR(10)   
  		 , @@l_posting_dt datetime    
		 , @@l_totalamt numeric(18,2)     


         SELECT @BROKERGL_ACC_CD = BITRM_VALUES FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='BROKER_GL_ACCNO' 
		CREATE TABLE  #MAIN_BILL  
		(FROMDT     DATETIME  
		,TODT       DATETIME              
		,CLTCODE varchar(100)
		, fina_acc_code   VARCHAR(100)  
		,DRCR       CHAR(1)  
		,AMOUNT     numeric(18,2)    ,dpam_sba_no varchar(20)
		,charge_name varchar(800)
		,ordby char(1)
		)   

create table #exceptionclient(entm_id numeric,entm_enttm_cd varchar(100),sba varchar(100))



if convert(varchar(11),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@pa_billing_from_dt)+1,0)),109) <> @pa_billing_from_dt
begin
insert into #exceptionclient
select entm_id ,entm_enttm_cd,entr_sba   from entity_mstr with(nolock)
, exceptionclientforpost with(nolock)
, entity_relationship    with(nolock)
where entm_enttm_cd in ('br','ba') and replace(replace(entm_short_name ,'_br',''),'_ba','') = brcode
and (entr_br = entm_id  or entr_sb= entm_id ) 
and getdate() between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')
end 
else 
begin

insert into #exceptionclient
select entm_id ,entm_enttm_cd,entr_sba   from entity_mstr with(nolock)
, exceptionclientforpost with(nolock)
, entity_relationship    with(nolock)
where entm_enttm_cd in ('br','ba') and replace(replace(entm_short_name ,'_br',''),'_ba','') = brcode
and brcode ='RNASIK'
and (entr_br = entm_id  or entr_sb= entm_id ) 
and getdate() between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2900')


end 

   
	if @PA_LOGIN_NAME='EQ'
						begin

--						SELECT 						
--						@@l_totalamt=abs(SUM(CLIC_CHARGE_AMT)) +  abs(SUM(CLIC_CHARGE_AMT*0.1800))
--						FROM   CLIENT_CHARGES_CDSL LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
--						AND ACCP_DELETED_IND = 1 ,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR

--						WHERE CLIC_DPAM_ID = DPAM_ID 
--						AND DPM_ID = DPAM_DPM_ID 
--						and clidb_deleted_ind = '1' 
--						AND BROM_ID = CLIDB_BROM_ID 
--						AND CLIDB_DPAM_ID = DPAM_ID 
--						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
--						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
----						AND CLIC_CHARGE_NAME IN (
----						'DEMAT COURIER CHARGE',
----						'DEMAT REJECTION CHARGE',
----						'TRANSACTION CHARGES'--,'SERVICE TAX'
----						,'ONE TIME CHARGE cor'
----						,'ONE TIME CHARGE'
----						,'NORMAL_AMC PRO RATA'
----						,'CORPORATE_AMC'
----						,'INDIVIDUAL NEW_INDIV'
----						,'ESOP_INDIVIDUAL_ESOP'
----,'INDIVIDUAL_INDIVIDUA'
----,'IPO_INDIVIDUAL_IPO_I'
----,'IPO_NON_INDIVIDUAL_I'
----,'NON INDIVIDUAL_NON I'
----,'BFL_BFL'
----						)

--						and CLIC_CHARGE_NAME not like '%stamp%'
--						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
--								and dpam_subcm_cd not in ('392144'
--								,'022545'
--								,'413046'
--								,'392179'
--								,'392180') and ISNULL(ACCP_VALUE ,'')<>''
----AND NOT EXISTS(SELECT SBA FROM #exceptionclient WHERE SBA = DPAM_SBA_NO )


						

						insert into #MAIN_BILL
						SELECT 						
						@PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
						ISNULL(DPAM_BBO_CODE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'D' DRCR
 ,abs(SUM(CLIC_CHARGE_AMT))+abs(SUM(CLIC_CHARGE_AMT))*0.18
--abs(isnull((select sum(clic_charge_amt) from client_charges_cdsl b where a.clic_dpam_id = b.clic_dpam_id   
--and b.CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and b.CLIC_CHARGE_NAME like '%gst%'),'0')) 
AMOUNT 
,DPAM_SBA_NO,'Demat Monthly Maintenance Charges' + ' for BOID : ' +  DPAM_SBA_NO + ' Dt : ' +  convert(varchar(11),MAX(CLIC_TRANS_DT ),109)   FINA_ACC_NAME ,'1'						
						FROM   CLIENT_CHARGES_CDSL a 
						--LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
						--AND ACCP_DELETED_IND = 1 
						,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
						,FIN_ACCOUNT_MSTR
						WHERE CLIC_DPAM_ID = DPAM_ID AND FINA_ACC_ID=CLIC_POST_TOACCT
						AND DPM_ID = DPAM_DPM_ID 
						and clidb_deleted_ind = '1' 
						AND BROM_ID = CLIDB_BROM_ID 
						AND CLIDB_DPAM_ID = DPAM_ID 
						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
						and (CLIC_CHARGE_NAME not like '%Gst%')
						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
						and ISNULL(DPAM_BBO_CODE ,'')<>''
						AND FINA_ACC_NAME IN (
						'AMC CHARGES  LIFE SCHEME 1250'
						,'ANNUAL MAINTENANCE CHARGES'
						,'CM FIXED CHARGES')
						and not exists (select 1 from ledger7 where LDG_ACCOUNT_TYPE ='p' 
						and LDG_DELETED_IND = 1 and LDG_VOUCHER_DT 
						between   @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and LDG_ACCOUNT_ID = CLIC_DPAM_ID 
						and LDG_NARRATION like  'Demat Monthly Maintenance Charges%')
				

						GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(DPAM_BBO_CODE ,'')  ORDER BY 1,2 
---for transaction
						insert into #MAIN_BILL
						SELECT 						
						@PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
						ISNULL(DPAM_BBO_CODE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'D' DRCR
 ,abs(SUM(CLIC_CHARGE_AMT))+abs(SUM(CLIC_CHARGE_AMT))*0.18
-- abs(isnull((select sum(clic_charge_amt) from client_charges_cdsl b where a.clic_dpam_id = b.clic_dpam_id   
--and b.CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and b.CLIC_CHARGE_NAME like '%gst%'),'0')) 
AMOUNT 
,DPAM_SBA_NO,'Charges for On-MKT/ Off-MKT Transaction' + ' for BOID : ' +  DPAM_SBA_NO + ' Dt : ' + + convert(varchar(11),MAX(CLIC_TRANS_DT ),109) FINA_ACC_NAME ,'2'						
						FROM   CLIENT_CHARGES_CDSL a 
						--LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
						--AND ACCP_DELETED_IND = 1 
						,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
						,FIN_ACCOUNT_MSTR
						WHERE CLIC_DPAM_ID = DPAM_ID AND FINA_ACC_ID=CLIC_POST_TOACCT
						AND DPM_ID = DPAM_DPM_ID 
						and clidb_deleted_ind = '1' 
						AND BROM_ID = CLIDB_BROM_ID 
						AND CLIDB_DPAM_ID = DPAM_ID 
						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
						and (CLIC_CHARGE_NAME not like '%Gst%')
						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
						and ISNULL(DPAM_BBO_CODE ,'')<>''
						and exists (select 1 from ledger7 where LDG_ACCOUNT_TYPE ='p' 
						and LDG_DELETED_IND = 1 and LDG_VOUCHER_DT 
						between   @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and LDG_ACCOUNT_ID = CLIC_DPAM_ID 
					and   LDG_NARRATION   like 'Charges for On-MKT/ Off-MKT Transaction%'
						and CLIC_TRANS_DT > ltrim(rtrim(replace(citrus_usr.fn_splitval_by(LDG_NARRATION,2,'dt'),':',''))) )
						AND FINA_ACC_NAME IN ('DEMAT/REMAT CHARGES','DIS ISSUANCE CHARGES','OFF MARKET TXN CHARGES','ON MARKET TXN CHARGES')
						GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(DPAM_BBO_CODE ,'')  ORDER BY 1,2 

--for pledge
						insert into #MAIN_BILL
						SELECT 						
						@PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
						ISNULL(DPAM_BBO_CODE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'D' DRCR
 ,abs(SUM(CLIC_CHARGE_AMT))+abs(SUM(CLIC_CHARGE_AMT))*0.18
 --abs(isnull((select sum(clic_charge_amt) from client_charges_cdsl b where a.clic_dpam_id = b.clic_dpam_id   
--and b.CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and b.CLIC_CHARGE_NAME like '%gst%'),'0')) 
AMOUNT 
,DPAM_SBA_NO,'Charges for Pledge/Unpledge of Securities' + ' for BOID : ' +  DPAM_SBA_NO + ' Dt : ' + convert(varchar(11),MAX(CLIC_TRANS_DT ),109)  FINA_ACC_NAME	,'3'					
						FROM   CLIENT_CHARGES_CDSL a 
						--LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
						--AND ACCP_DELETED_IND = 1 
						,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
						,FIN_ACCOUNT_MSTR
						WHERE CLIC_DPAM_ID = DPAM_ID AND FINA_ACC_ID=CLIC_POST_TOACCT
						AND DPM_ID = DPAM_DPM_ID 
						and clidb_deleted_ind = '1' 
						AND BROM_ID = CLIDB_BROM_ID 
						AND CLIDB_DPAM_ID = DPAM_ID 
						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
						and (CLIC_CHARGE_NAME not like '%Gst%')
						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
						and ISNULL(DPAM_BBO_CODE ,'')<>''
						and exists (select 1 from ledger7 where LDG_ACCOUNT_TYPE ='p' 
						and LDG_DELETED_IND = 1 and LDG_VOUCHER_DT 
						between   @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and LDG_ACCOUNT_ID = CLIC_DPAM_ID 
						and  LDG_NARRATION  like 'Charges for Pledge/Unpledge of Securities%'
						--and CLIC_TRANS_DT > 'dec 12 2020')
						and CLIC_TRANS_DT > ltrim(rtrim(replace(citrus_usr.fn_splitval_by(LDG_NARRATION,2,'dt'),':',''))) )
						AND FINA_ACC_NAME IN (
						'PLEDGE CHARGES','UNPLEDGE CHARGES')
						GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(DPAM_BBO_CODE ,'')  ORDER BY 1,2 
-----ledger entry

Select @@l_posting_dt= isnull(billc_posting_dt,@pa_billing_to_dt) from bill_cycle where   
 @pa_billing_to_dt between  BILLC_FROM_DT and billc_to_dt --and billc_dpm_id = @l_dpm_id
--print @@l_posting_dt
SELECT @l_fin_id = fin_id from financial_yr_mstr where 
--fin_dpm_id = @l_dpm_id and 
@@l_posting_dt between fin_start_dt and fin_end_dt


Set  @L_SQL = ' INSERT INTO  #MAIN_BILL
SELECT ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' , ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' ,  ISNULL(DPAM_BBO_CODE,'''') ,LDG_ACCOUNT_ID ,CASE WHEN SUM(LDG_AMOUNT)< 0 THEN ''D'' ELSE ''C'' END ,ABS(SUM(LDG_AMOUNT))  , dpam_sba_no,''DP Transaction charges till  '+ convert(varchar(11),@PA_BILLING_FROM_DT -1,109) +''' FINA_ACC_NAME,''4''
FROM DP_ACCT_MSTR ,
LEDGER' + convert(varchar,@l_fin_id) + ' t

WHERE  LDG_ACCOUNT_ID = DPAM_ID  
--AND LDG_VOUCHER_DT >= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_FROM_DT) + '''
AND LDG_VOUCHER_DT <= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + '''

AND LDG_DELETED_IND = 1 
AND LDG_ACCOUNT_TYPE = ''P''
--AND LDG_VOUCHER_TYPE in (''1'',''2'')
--AND ISNULL(CITRUS_USR.FN_UCC_AccP(DPAM_id,''BBO_CODE'',''''),'''')<>''''  
AND ISNULL(DPAM_BBO_CODE,'''')<>''''
and exists (select clic_dpam_id from client_charges_cdsl where CLIC_DPAM_ID=LDG_ACCOUNT_ID and CLIC_TRANS_DT between ''' +  CONVERT(VARCHAR(11),@PA_BILLING_FROM_DT) + ''' and ''' +  CONVERT(VARCHAR(11),@PA_BILLING_to_DT) + ''')
GROUP BY LDG_ACCOUNT_ID,DPAM_id,dpam_sba_no,DPAM_BBO_CODE --, LDG_INSTRUMENT_NO
HAVING SUM(LDG_AMOUNT) < 0 '

print (@L_SQL)
Execute(@L_SQL)

-----ledger entry

delete from #MAIN_BILL where CLTCODE='MINOR'

IF EXISTS(SELECT isnull(DPAM_SBA_NO,'') FROM #MAIN_BILL)
BEGIN
--INSERT INTO #MAIN_BILL
--SELECT @PA_BILLING_FROM_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
--ISNULL(@BROKERGL_ACC_CD ,'') CLTCODE , FINA_ACC_CODE=@BROKERGL_ACC_CD ,
-- 'C' DRCR ,@@L_TOTALAMT AMOUNT ,@BROKERGL_ACC_CD DPAM_SBA_NO 

INSERT INTO #MAIN_BILL
SELECT @PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
ISNULL(@BROKERGL_ACC_CD ,'') CLTCODE , FINA_ACC_CODE=@BROKERGL_ACC_CD ,
 'C' DRCR ,( SELECT SUM(AMOUNT) FROM #MAIN_BILL ) AMOUNT ,@BROKERGL_ACC_CD DPAM_SBA_NO ,'' charge_name ,'5'




END 

select 
--CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) FROMDT 
--,CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) TODT ,
convert(varchar(10),GETDATE(),103) FROMDT,
convert(varchar(10),GETDATE(),103) TODT,
CLTCODE,fina_acc_code,drcr,AMOUNT,DPAM_SBA_NO,charge_name 
from #MAIN_BILL --,[192.168.100.100].msajag.dbo.Vw_to_getactiveClt_Class--where cltcode=cl_code
--where drcr='C'
where (CLTCODE not like 'ZR%' and CLTCODE not like '98%' )
order by CLTCODE,ordby

--select sum(AMOUNT) amont
--from #MAIN_BILL --,[192.168.100.100].msajag.dbo.Vw_to_getactiveClt_Class--where cltcode=cl_code
--where drcr='D'


end
if @PA_LOGIN_NAME='EQCR'
						begin

				

						insert into #MAIN_BILL
						SELECT 						
						@PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
						ISNULL(DPAM_BBO_CODE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'C' DRCR 
						,abs(SUM(CLIC_CHARGE_AMT)) + abs(SUM(CLIC_CHARGE_AMT))*0.18
						--abs(isnull((select sum(clic_charge_amt) from client_charges_cdsl b where a.clic_dpam_id = b.clic_dpam_id   
						--and b.CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and b.CLIC_CHARGE_NAME like '%gst%'),'0')) 
						AMOUNT ,DPAM_SBA_NO
						,'Demat Monthly Maintenance Charges' + ' for BOID : ' +  DPAM_SBA_NO + ' Dt : ' +  convert(varchar(11),MAX(CLIC_TRANS_DT ),109)  FINA_ACC_NAME ,'1'
						FROM   CLIENT_CHARGES_CDSL a 
						--LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
						--AND ACCP_DELETED_IND = 1 
						,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
						,FIN_ACCOUNT_MSTR
						WHERE CLIC_DPAM_ID = DPAM_ID and FINA_ACC_ID=CLIC_POST_TOACCT and FINA_DELETED_IND=1
						AND DPM_ID = DPAM_DPM_ID 
						and clidb_deleted_ind = '1' 
						AND BROM_ID = CLIDB_BROM_ID 
						AND CLIDB_DPAM_ID = DPAM_ID 
						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
						and CLIC_CHARGE_NAME not like '%GST%'
						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
and ISNULL(DPAM_BBO_CODE ,'')<>''
						AND FINA_ACC_NAME IN (
						'AMC CHARGES  LIFE SCHEME 1250'
						,'ANNUAL MAINTENANCE CHARGES'
						,'CM FIXED CHARGES')
						and not exists (select 1 from ledger7 where LDG_ACCOUNT_TYPE ='p' 
						and LDG_DELETED_IND = 1 and LDG_VOUCHER_DT 
						between   @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and LDG_ACCOUNT_ID = CLIC_DPAM_ID 
						and LDG_NARRATION like  'Demat Monthly Maintenance Charges%')
						GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(DPAM_BBO_CODE ,'')  ORDER BY 1,2 

-----for transaction

						insert into #MAIN_BILL
						SELECT 						
						@PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
						ISNULL(DPAM_BBO_CODE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'C' DRCR 
						,abs(SUM(CLIC_CHARGE_AMT)) + abs(SUM(CLIC_CHARGE_AMT))*0.18
						--abs(isnull((select sum(clic_charge_amt) from client_charges_cdsl b where a.clic_dpam_id = b.clic_dpam_id   
						--and b.CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and b.CLIC_CHARGE_NAME like '%gst%'),'0')) AMOUNT 
						,DPAM_SBA_NO
						,'Charges for On-MKT/ Off-MKT Transaction' + ' for BOID : ' +  DPAM_SBA_NO + ' Dt : ' +  convert(varchar(11),MAX(CLIC_TRANS_DT ),109) FINA_ACC_NAME,'2'
						FROM   CLIENT_CHARGES_CDSL a 
						--LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
						--AND ACCP_DELETED_IND = 1 
						,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
						,FIN_ACCOUNT_MSTR
						WHERE CLIC_DPAM_ID = DPAM_ID and FINA_ACC_ID=CLIC_POST_TOACCT and FINA_DELETED_IND=1
						AND DPM_ID = DPAM_DPM_ID 
						and clidb_deleted_ind = '1' 
						AND BROM_ID = CLIDB_BROM_ID 
						AND CLIDB_DPAM_ID = DPAM_ID 
						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
						and CLIC_CHARGE_NAME not like '%GST%'
						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
and ISNULL(DPAM_BBO_CODE ,'')<>''
and exists (select 1 from ledger7 where LDG_ACCOUNT_TYPE ='p' 
						and LDG_DELETED_IND = 1 and LDG_VOUCHER_DT 
						between   @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and LDG_ACCOUNT_ID = CLIC_DPAM_ID 
					and   LDG_NARRATION   like 'Charges for On-MKT/ Off-MKT Transaction%'
						and CLIC_TRANS_DT > ltrim(rtrim(replace(citrus_usr.fn_splitval_by(LDG_NARRATION,2,'dt'),':',''))) )
						AND FINA_ACC_NAME IN ('DIS ISSUANCE CHARGES','OFF MARKET TXN CHARGES','ON MARKET TXN CHARGES','DEMAT/REMAT CHARGES')
						GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(DPAM_BBO_CODE ,'')  ORDER BY 1,2 

----for pledge


						insert into #MAIN_BILL
						SELECT 						
						@PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
						ISNULL(DPAM_BBO_CODE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'C' DRCR 
						,abs(SUM(CLIC_CHARGE_AMT)) +abs(SUM(CLIC_CHARGE_AMT))*0.18
						--abs(isnull((select sum(clic_charge_amt) from client_charges_cdsl b where a.clic_dpam_id = b.clic_dpam_id   
						--and b.CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and b.CLIC_CHARGE_NAME like '%gst%'),'0')) AMOUNT 
						,DPAM_SBA_NO
						,'Charges for Pledge/Unpledge of Securities' + ' for BOID : ' +  DPAM_SBA_NO + ' Dt : ' + convert(varchar(11),MAX(CLIC_TRANS_DT ),109)  FINA_ACC_NAME,'3'
						FROM   CLIENT_CHARGES_CDSL a 
						--LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
						--AND ACCP_DELETED_IND = 1 
						,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
						,FIN_ACCOUNT_MSTR
						WHERE CLIC_DPAM_ID = DPAM_ID and FINA_ACC_ID=CLIC_POST_TOACCT and FINA_DELETED_IND=1
						AND DPM_ID = DPAM_DPM_ID 
						and clidb_deleted_ind = '1' 
						AND BROM_ID = CLIDB_BROM_ID 
						AND CLIDB_DPAM_ID = DPAM_ID 
						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
						and CLIC_CHARGE_NAME not like '%GST%'
						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
and ISNULL(DPAM_BBO_CODE ,'')<>''
and exists (select 1 from ledger7 where LDG_ACCOUNT_TYPE ='p' 
						and LDG_DELETED_IND = 1 and LDG_VOUCHER_DT 
						between   @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and LDG_ACCOUNT_ID = CLIC_DPAM_ID 
						and  LDG_NARRATION  like 'Charges for Pledge/Unpledge of Securities%'
						--and CLIC_TRANS_DT > 'dec 12 2020')
						and CLIC_TRANS_DT > ltrim(rtrim(replace(citrus_usr.fn_splitval_by(LDG_NARRATION,2,'dt'),':',''))) )
						AND FINA_ACC_NAME IN ('PLEDGE CHARGES','UNPLEDGE CHARGES')
						GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(DPAM_BBO_CODE ,'')  ORDER BY 1,2 


-----ledger entry

Select @@l_posting_dt= isnull(billc_posting_dt,@pa_billing_to_dt) from bill_cycle where   
 @pa_billing_to_dt between  BILLC_FROM_DT and billc_to_dt --and billc_dpm_id = @l_dpm_id
--print @@l_posting_dt
SELECT @l_fin_id = fin_id from financial_yr_mstr where 
--fin_dpm_id = @l_dpm_id and 
@@l_posting_dt between fin_start_dt and fin_end_dt


Set  @L_SQL = ' INSERT INTO  #MAIN_BILL
SELECT ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' , ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + ''' ,  ISNULL(DPAM_BBO_CODE,'''') ,LDG_ACCOUNT_ID ,CASE WHEN SUM(LDG_AMOUNT)< 0 THEN ''C'' ELSE ''D'' END ,ABS(SUM(LDG_AMOUNT))  , dpam_sba_no,''DP Transaction charges till '+ convert(varchar(11),@PA_BILLING_FROM_DT -1,109) +'''  FINA_ACC_NAME,''4''
FROM DP_ACCT_MSTR ,
LEDGER' + convert(varchar,@l_fin_id) + ' t

WHERE  LDG_ACCOUNT_ID = DPAM_ID  
--AND LDG_VOUCHER_DT >= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_FROM_DT) + '''
AND LDG_VOUCHER_DT <= ''' +  CONVERT(VARCHAR(11),@PA_BILLING_TO_DT) + '''

AND LDG_DELETED_IND = 1 
AND LDG_ACCOUNT_TYPE = ''P''
--AND LDG_VOUCHER_TYPE in (''1'',''2'')
--AND ISNULL(CITRUS_USR.FN_UCC_AccP(DPAM_id,''BBO_CODE'',''''),'''')<>''''  
AND ISNULL(DPAM_BBO_CODE,'''')<>''''
and exists (select clic_dpam_id from client_charges_cdsl where CLIC_DPAM_ID=LDG_ACCOUNT_ID and CLIC_TRANS_DT between ''' +  CONVERT(VARCHAR(11),@PA_BILLING_FROM_DT) + ''' and ''' +  CONVERT(VARCHAR(11),@PA_BILLING_to_DT) + ''')
GROUP BY LDG_ACCOUNT_ID,DPAM_id,dpam_sba_no,DPAM_BBO_CODE --, LDG_INSTRUMENT_NO
HAVING SUM(LDG_AMOUNT) < 0 '

print (@L_SQL)
Execute(@L_SQL)

delete from #MAIN_BILL where CLTCODE='MINOR'
 
--select CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) FROMDT ,CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) TODT ,
--CLTCODE,fina_acc_code,drcr,AMOUNT,DPAM_SBA_NO
-- from #MAIN_BILL 

 INSERT INTO  #MAIN_BILL  
SELECT @PA_BILLING_TO_DT,@PA_BILLING_TO_DT,@BROKERGL_ACC_CD, fina_acc_code=@BROKERGL_ACC_CD,
'D' drcr ,  ( SELECT SUM(AMOUNT) FROM #MAIN_BILL ) AMOUNT ,@BROKERGL_ACC_CD,'' fina_acc_name ,'5'


select 

--CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) FROMDT 
--,CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) TODT ,
convert(varchar(10),GETDATE(),103) FROMDT,
convert(varchar(10),GETDATE(),103) TODT,

CLTCODE,fina_acc_code,drcr,AMOUNT,DPAM_SBA_NO,charge_name 
 from #MAIN_BILL 
 where (CLTCODE not like 'ZR%' and CLTCODE not like '98%' )
 order by cltcode,ordby
--,[192.168.100.100].msajag.dbo.Vw_to_getactiveClt_Class
--where cltcode=cl_code


end
	if @PA_LOGIN_NAME='COMM'
						begin


					    SELECT 						
						@@l_totalamt=abs(SUM(CLIC_CHARGE_AMT))  +abs(SUM(CLIC_CHARGE_AMT*0.1800))
						
						FROM   CLIENT_CHARGES_CDSL a LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
						AND ACCP_DELETED_IND = 1 ,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR

						WHERE CLIC_DPAM_ID = DPAM_ID 
						AND DPM_ID = DPAM_DPM_ID 
						and clidb_deleted_ind = '1' 
						AND BROM_ID = CLIDB_BROM_ID 
						AND CLIDB_DPAM_ID = DPAM_ID 
						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
						AND CLIC_CHARGE_NAME IN (
						'DEMAT COURIER CHARGE',
						'DEMAT REJECTION CHARGE',
						'TRANSACTION CHARGES'--,'SERVICE TAX'
						,'ONE TIME CHARGE cor'
						,'ONE TIME CHARGE'
						,'NORMAL_AMC PRO RATA'
						,'CORPORATE_AMC'
						,'CORPORATE_CORPORATE'
						,'INDIVIDUAL NEW_INDIV'
								,'ESOP_INDIVIDUAL_ESOP'
,'INDIVIDUAL_INDIVIDUA'
,'IPO_INDIVIDUAL_IPO_I'
,'IPO_NON_INDIVIDUAL_I'
,'NON INDIVIDUAL_NON I'
,'BFL_BFL'
						)
							and CLIC_CHARGE_NAME not like '%stamp%'
						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
								and dpam_subcm_cd  in ('392144'
								,'022545'
								,'413046'
								,'392179'
								,'392180') and ISNULL(ACCP_VALUE ,'')<>''
AND NOT EXISTS(SELECT SBA FROM #exceptionclient WHERE SBA = DPAM_SBA_NO )
						

						insert into #MAIN_BILL

								SELECT 
								
								@PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
								ISNULL(ACCP_VALUE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'D' DRCR 
,abs(SUM(CLIC_CHARGE_AMT)) ++abs((select sum(clic_charge_amt) from client_charges_cdsl b where a.clic_dpam_id = b.clic_dpam_id   
and b.CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT and b.CLIC_CHARGE_NAME like '%gst%')) AMOUNT ,DPAM_SBA_NO
								--DPM_DPID,DPAM_SBA_NO , ISNULL(ACCP_VALUE ,'') [BBOCODE],BROM_DESC SCHEME, SUM(CLIC_CHARGE_AMT) AMOUNT
								--,CONVERT(NUMERIC(18,2),SUM(CLIC_CHARGE_AMT)*0.1236) ST  
								--,CASE WHEN [CITRUS_USR].[FN_FIND_RELATIONS_ACCTLVL_BILL](CLIC_DPAM_ID , 'BR') <>'' 
								--		THEN REPLACE([CITRUS_USR].[FN_FIND_RELATIONS_ACCTLVL_BILL](CLIC_DPAM_ID , 'BR') ,'_BR','')
								--		ELSE REPLACE([CITRUS_USR].[FN_FIND_RELATIONS_ACCTLVL_BILL](CLIC_DPAM_ID , 'BA'),'_BA','') END 
								FROM   CLIENT_CHARGES_CDSL a LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
								AND ACCP_DELETED_IND = 1 ,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR

								WHERE CLIC_DPAM_ID = DPAM_ID 
								AND DPM_ID = DPAM_DPM_ID 
								and clidb_deleted_ind = '1' 
								AND BROM_ID = CLIDB_BROM_ID 
								AND CLIDB_DPAM_ID = DPAM_ID 
								AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
								AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
								AND CLIC_CHARGE_NAME IN (
								'DEMAT COURIER CHARGE',
						'DEMAT REJECTION CHARGE',
						'TRANSACTION CHARGES'--,'SERVICE TAX'
						,'ONE TIME CHARGE cor'
						,'ONE TIME CHARGE'
						,'NORMAL_AMC PRO RATA'
						,'CORPORATE_AMC'
						,'CORPORATE_CORPORATE'
						,'INDIVIDUAL NEW_INDIV'
								,'ESOP_INDIVIDUAL_ESOP'
,'INDIVIDUAL_INDIVIDUA'
,'IPO_INDIVIDUAL_IPO_I'
,'IPO_NON_INDIVIDUAL_I'
,'NON INDIVIDUAL_NON I'
,'BFL_BFL'
								)
									and CLIC_CHARGE_NAME not like '%stamp%'
								AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
								and dpam_subcm_cd in ('392144'
								,'022545'
								,'413046'
								,'392179'
								,'392180') and ISNULL(ACCP_VALUE ,'')<>''
AND NOT EXISTS(SELECT SBA FROM #exceptionclient WHERE SBA = DPAM_SBA_NO )
								GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(ACCP_VALUE ,'')  ORDER BY 1,2 						
						
IF EXISTS(SELECT isnull(DPAM_SBA_NO,'') FROM #MAIN_BILL)
BEGIN
--insert into #MAIN_BILL
--select @PA_BILLING_FROM_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
--						ISNULL(@BROKERGL_ACC_CD ,'') CLTCODE , fina_acc_code=@BROKERGL_ACC_CD ,
--'C' DRCR ,@@l_totalamt AMOUNT ,@BROKERGL_ACC_CD DPAM_SBA_NO 
--CHANGE BY TUSHAR TO MATCH TOTAL AMONUNT 

insert into #MAIN_BILL
select @PA_BILLING_TO_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
						ISNULL(@BROKERGL_ACC_CD ,'') CLTCODE , fina_acc_code=@BROKERGL_ACC_CD ,
'C' DRCR ,( SELECT SUM(AMOUNT) FROM #MAIN_BILL )AMOUNT ,@BROKERGL_ACC_CD DPAM_SBA_NO 

end

select CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) FROMDT ,CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) TODT ,
CLTCODE,fina_acc_code,drcr,AMOUNT,DPAM_SBA_NO from #MAIN_BILL 
--,[192.168.100.100].msajag.dbo.Vw_to_getactiveClt_Class
where cltcode=cl_code

end

--	if @PA_LOGIN_NAME='COMMCR'
--						begin
--
--
--					    SELECT 						
--						@@l_totalamt=abs(SUM(CLIC_CHARGE_AMT)) +abs(SUM(CLIC_CHARGE_AMT*0.1236)) 
--						
--						FROM   CLIENT_CHARGES_CDSL LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
--						AND ACCP_DELETED_IND = 1 ,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
--
--						WHERE CLIC_DPAM_ID = DPAM_ID 
--						AND DPM_ID = DPAM_DPM_ID 
--						AND BROM_ID = CLIDB_BROM_ID 
--						AND CLIDB_DPAM_ID = DPAM_ID 
--						AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
--						AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
--						AND CLIC_CHARGE_NAME IN (
--						'DEMAT COURIER CHARGE',
--						'DEMAT REJECTION CHARGE',
--						'TRANSACTION CHARGES'--,'SERVICE TAX'
--						)
--						AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
--								and dpam_subcm_cd  in ('392144'
--								,'022545'
--								,'413046'
--								,'392179'
--								,'392180') and ISNULL(ACCP_VALUE ,'')<>''
--						
--
--						insert into #MAIN_BILL
--
--								SELECT 
--								
--								@PA_BILLING_FROM_DT FROMDT ,@PA_BILLING_TO_DT TODT ,
--								ISNULL(ACCP_VALUE ,'') CLTCODE , fina_acc_code=CLIC_DPAM_ID , 'C' DRCR 
--,abs(SUM(CLIC_CHARGE_AMT))+abs(SUM(CLIC_CHARGE_AMT*0.1236)) AMOUNT ,DPAM_SBA_NO
--								--DPM_DPID,DPAM_SBA_NO , ISNULL(ACCP_VALUE ,'') [BBOCODE],BROM_DESC SCHEME, SUM(CLIC_CHARGE_AMT) AMOUNT
--								--,CONVERT(NUMERIC(18,2),SUM(CLIC_CHARGE_AMT)*0.1236) ST  
--								--,CASE WHEN [CITRUS_USR].[FN_FIND_RELATIONS_ACCTLVL_BILL](CLIC_DPAM_ID , 'BR') <>'' 
--								--		THEN REPLACE([CITRUS_USR].[FN_FIND_RELATIONS_ACCTLVL_BILL](CLIC_DPAM_ID , 'BR') ,'_BR','')
--								--		ELSE REPLACE([CITRUS_USR].[FN_FIND_RELATIONS_ACCTLVL_BILL](CLIC_DPAM_ID , 'BA'),'_BA','') END 
--								FROM   CLIENT_CHARGES_CDSL LEFT OUTER JOIN ACCOUNT_PROPERTIES ON ACCP_CLISBA_ID = CLIC_DPAM_ID AND ACCP_ACCPM_PROP_CD = 'BBO_CODE' 
--								AND ACCP_DELETED_IND = 1 ,DP_ACCT_MSTR, DP_MSTR , CLIENT_DP_BRKG , BROKERAGE_MSTR
--
--								WHERE CLIC_DPAM_ID = DPAM_ID 
--								AND DPM_ID = DPAM_DPM_ID 
--								AND BROM_ID = CLIDB_BROM_ID 
--								AND CLIDB_DPAM_ID = DPAM_ID 
--								AND CLIC_TRANS_DT BETWEEN CLIDB_EFF_FROM_DT
--								AND ISNULL(CLIDB_EFF_TO_DT,'DEC 31 2100')
--								AND CLIC_CHARGE_NAME IN (
--								'DEMAT COURIER CHARGE',
--								'DEMAT REJECTION CHARGE',
--								'TRANSACTION CHARGES'--,'SERVICE TAX'
--								)
--								AND  CLIC_TRANS_DT BETWEEN @PA_BILLING_FROM_DT AND @PA_BILLING_TO_DT
--								and dpam_subcm_cd in ('392144'
--								,'022545'
--								,'413046'
--								,'392179'
--								,'392180') and ISNULL(ACCP_VALUE ,'')<>''
--								GROUP BY CLIC_DPAM_ID , DPM_DPID,DPAM_SBA_NO,BROM_DESC,ISNULL(ACCP_VALUE ,'')  ORDER BY 1,2 						
--						
--
--
--
--select CONVERT(VARCHAR(11),@PA_BILLING_FROM_DT,103) FROMDT ,CONVERT(VARCHAR(11),@PA_BILLING_TO_DT,103) TODT ,
--CLTCODE,fina_acc_code,drcr,AMOUNT,DPAM_SBA_NO from #MAIN_BILL 
--
--end
TRUNCATE TABLE #exceptionclient
drop table #exceptionclient

--  
END

GO
