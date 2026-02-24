-- Object: PROCEDURE citrus_usr.pr_ins_upd_OffMktPay_Details_CDSL
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



create  PROCEDURE  [citrus_usr].[pr_ins_upd_OffMktPay_Details_CDSL]( 
									@PA_ID  VARCHAR(800)                          
                                   ,@PA_ACTION         VARCHAR(100)                          
                                   ,@PA_LOGIN_NAME     VARCHAR(20)         
								   ,@pa_cd VARCHAR(20)  
								   ,@pa_desc                 VARCHAR(20)  
                                   ,@PA_CONSAMT             VARCHAR(25)                          
                                   ,@PA_PAYMODE           VARCHAR(250)                          
                                   ,@PA_DOI           VARCHAR(11)                          
                                   ,@PA_BANKNO         VARCHAR(800)                         
                                   ,@PA_BANKNAME          VARCHAR(800) 
								   ,@PA_BANKBRNAME        VARCHAR(800)
								   ,@PA_BUYERNAME          VARCHAR(800)                        
                                   ,@PA_INSTRUMENTNO      VARCHAR(800)           
                                   ,@ROWDELIMITER      CHAR(20)                          
                                   ,@COLDELIMITER      CHAR(20)                          
                                   ,@PA_REF_CUR        VARCHAR(8000) OUT                          
                                  )                          
AS                        
/*                        
*********************************************************************************                        
 SYSTEM         : DP                        
 MODULE NAME    : PR_SELECT_MSTR                        
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE SELECT SAVE QUERIES FOR NSDL PAY DETAILS TABLES                        
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES                         
 VERSION HISTORY: 1.0                        
 VERS.  AUTHOR            DATE          REASON                        
 -----  -------------     ------------  --------------------------------------------------                        
 1.0    LATESH P WANI            03-OCT-2018   VERSION.                        
-----------------------------------------------------------------------------------*/                        
BEGIN                        
--     


DECLARE @BOID VARCHAR(16)
SELECT @BOID = DPAM_SBA_NO from dptdc_mak,DP_ACCT_MSTR with(nolock) where (dptdc_id=@pa_id or dptdc_dtls_id=@pa_id) and DPTDC_DELETED_IND in (-1,0,4,6) AND DPAM_ID=DPTDC_DPAM_ID

DECLARE @L_AMT TABLE(AMT VARCHAR(1000))



DECLARE @L_SDRATE VARCHAR(10),@L_SDCALC VARCHAR(20)

,@L_OS VARCHAR,@L_TRATM_ID NUMERIC,@L_FIN_ID NUMERIC,@L_LEDGERTBL VARCHAR(100),@L_SQL VARCHAR(800)





SELECT @L_FIN_ID = FIN_ID FROM FINANCIAL_YR_MSTR WHERE  GETDATE() BETWEEN FIN_START_DT AND FIN_END_DT     

AND FIN_DELETED_IND = 1     

      

    

SET @L_LEDGERTBL = 'LEDGER'+CONVERT(VARCHAR,@L_FIN_ID )    

    

SET @L_SQL = ' SELECT SUM(LDG_AMOUNT)  '

SET @L_SQL = @L_SQL + ' FROM ' + @L_LEDGERTBL   + ',DP_ACCT_MSTR WHERE LDG_ACCOUNT_ID=DPAM_ID AND DPAM_SBA_NO =''' +  @BOID  + ''''

INSERT INTO @L_AMT

--PRINT @L_SQL

EXEC (@L_SQL)



declare @l_dptdc_dtls_id numeric
Select @l_dptdc_dtls_id=dptdc_dtls_id from dptdc_mak with(nolock) 
where (dptdc_id=@pa_id or dptdc_dtls_id=@pa_id) and DPTDC_DELETED_IND in (-1,0,4,6)
print @l_dptdc_dtls_id
IF @PA_ACTION='CDSL_PAY_DETAILS_SELECT'
BEGIN
if @pa_desc='A'
begin
SELECT distinct DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_ISIN,DPTDC_ID,DPTDC_DTLS_ID,ISIN_NAME
, DPTDC_LINE_NO	 DPTDC_CONSIDERATION,  DPTDC_PAYMODE	, DPTDC_BANKACNO	,	DPTDC_BANKACNAME ,DPTDC_BANKBRNAME
,	DPTDC_TRANSFEREENAME,	DPTDC_DOI, DPTDC_CHQ_REFNO 
,case when ISIN_SEC_TYPE  in  ('1','15','3','9') then citrus_usr.FN_TOGETTSTM('EQUITY') WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') then citrus_usr.FN_TOGETTSTM('DEBENTURES') else '0' end stampdutyrate
--,CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3') THEN convert(numeric(18,2),0.00015*convert(numeric,DPTDC_LINE_NO)) WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') THEN convert(numeric(18,2),0.000001*convert(numeric,DPTDC_LINE_NO)) ELSE 0*DPTDC_LINE_NO END STAMPDUTYCHARGED
,case when DPTDC_LINE_NO ='' then '0' else CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN convert(numeric(18,2),0.00015*convert(numeric,isnull(DPTDC_LINE_NO,0))) 
WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') 
THEN convert(numeric(18,2),0.000001*convert(numeric,isnull(DPTDC_LINE_NO,0))) ELSE 0*isnull(DPTDC_LINE_NO,0) END
end STAMPDUTYCHARGED
,isnull(DPTDC_REASON_CD,'0') DPTDC_REASON_CD
,OS=(SELECT TOP 1 ISNULL ((SELECT ISNULL(AMT,'0') FROM @L_AMT) ,0))
FROM DPTDC_MAK,ISIN_MSTR WHERE DPTDC_DTLS_ID=@l_dptdc_dtls_id AND DPTDC_DELETED_IND IN (0,4,6,-1,1) AND DPTDC_ISIN=ISIN_CD AND ISIN_DELETED_IND=1
--and isnull(DPTD_PAYMODE,'')<>''
UNION 
SELECT distinct DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_ISIN,DPTDC_ID,DPTDC_DTLS_ID,ISIN_NAME
,DPTDCOD_CONSIDERATION	AS DPTDC_CONSIDERATION,DPTDCOD_PAYMODE AS DPTD_PAYMODE	,DPTDCOD_BANKACNO DPTD_BANKACNO	,DPTDCOD_BANKACNAME	DPTD_BANKACNAME ,DPTDC_BANKBRNAME
,DPTDCOD_TRANSFEREENAME	DPTD_TRANSFEREENAME,convert(varchar(10),DPTDCOD_DOI,103)	DPTD_DOI,DPTDCOD_CHQ_REFNO DPTD_CHQ_REFNO
,case when ISIN_SEC_TYPE  in  ('1','15','3','9') then citrus_usr.FN_TOGETTSTM('EQUITY') WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') then citrus_usr.FN_TOGETTSTM('DEBENTURES') else '0' end stampdutyrate
--,CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3') THEN convert(numeric(18,2),0.00015)*convert(numeric,DPTDC_LINE_NO) WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') THEN convert(numeric(18,2),0.000001)*convert(numeric,DPTDC_LINE_NO) ELSE 0*DPTDC_LINE_NO END STAMPDUTYCHARGED
,case when DPTDC_LINE_NO ='' then '0' else CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN convert(numeric(18,2),0.00015*convert(numeric,isnull(DPTDC_LINE_NO,0))) 
WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') 
THEN convert(numeric(18,2),0.000001*convert(numeric,isnull(DPTDC_LINE_NO,0))) ELSE 0*isnull(DPTDC_LINE_NO,0) END
end STAMPDUTYCHARGED
,isnull(DPTDC_REASON_CD,'0') DPTDC_REASON_CD
,OS=(SELECT TOP 1 ISNULL ((SELECT ISNULL(AMT,'0') FROM @L_AMT) ,0))
FROM DPTDC_MAK,ISIN_MSTR,DPTDC_OFFPAY_DETAILS WHERE DPTDC_DTLS_ID=@l_dptdc_dtls_id AND DPTDC_DELETED_IND IN (0,4,6,-1,1) AND DPTDC_ISIN=ISIN_CD AND ISIN_DELETED_IND=1
AND DPTDCOD_DTLS_ID=DPTDC_DTLS_ID and DPTDC_ID=DPTDCOD_DPTD_ID
end
ELSE
begin
print @l_dptdc_dtls_id

SELECT distinct DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_ISIN,DPTDC_ID,DPTDC_DTLS_ID,ISIN_NAME
, case when isnull(DPTDC_LINE_NO,'0')='0' then '0' when DPTDC_LINE_NO='' then '0' else DPTDC_LINE_NO end 	 DPTDC_CONSIDERATION,  DPTDC_PAYMODE	, DPTDC_BANKACNO	,	DPTDC_BANKACNAME ,DPTDC_BANKBRNAME
,	DPTDC_TRANSFEREENAME,	DPTDC_DOI, DPTDC_CHQ_REFNO 
,case when ISIN_SEC_TYPE  in  ('1','15','3','9') then citrus_usr.FN_TOGETTSTM('EQUITY') WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') then citrus_usr.FN_TOGETTSTM('DEBENTURES') else '0' end stampdutyrate
,case when DPTDC_LINE_NO ='' then '0' else CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN convert(numeric(18,2),0.00015*convert(numeric(18,2),isnull(DPTDC_LINE_NO,0))) 
WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') 
THEN convert(numeric(18,2),0.000001*convert(numeric(18,2),isnull(DPTDC_LINE_NO,0))) ELSE 0*convert(numeric(18,2),isnull(DPTDC_LINE_NO,0))END
end STAMPDUTYCHARGED
,isnull(DPTDC_REASON_CD,'0') DPTDC_REASON_CD
,OS=(SELECT TOP 1 ISNULL ((SELECT ISNULL(AMT,'0') FROM @L_AMT) ,0))
FROM DPTDC_MAK,ISIN_MSTR WHERE DPTDC_DTLS_ID=@l_dptdc_dtls_id AND DPTDC_DELETED_IND IN (0,4,6,-1,1) AND DPTDC_ISIN=ISIN_CD AND ISIN_DELETED_IND=1
--and isnull(DPTDC_PAYMODE,'')<>''
UNION 
SELECT distinct DPTDC_SLIP_NO,DPTDC_REQUEST_DT,DPTDC_ISIN,DPTDC_ID,DPTDC_DTLS_ID,ISIN_NAME
, case when isnull(DPTDCOD_CONSIDERATION,'0')='0' then '0' when DPTDCOD_CONSIDERATION='' then '0' else DPTDCOD_CONSIDERATION end 	AS DPTDC_CONSIDERATION,DPTDCOD_PAYMODE AS DPTD_PAYMODE	,DPTDCOD_BANKACNO DPTD_BANKACNO	,DPTDCOD_BANKACNAME	DPTD_BANKACNAME ,DPTDC_BANKBRNAME
,DPTDCOD_TRANSFEREENAME	DPTD_TRANSFEREENAME,	DPTDC_DOI,DPTDCOD_CHQ_REFNO DPTD_CHQ_REFNO
,case when ISIN_SEC_TYPE  in  ('1','15','3','9') then citrus_usr.FN_TOGETTSTM('EQUITY') WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') then citrus_usr.FN_TOGETTSTM('DEBENTURES') else '0' end stampdutyrate
,case when DPTDC_LINE_NO= '' then '0' else CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN convert(numeric(18,2),0.00015*convert(numeric(18,2),DPTDC_LINE_NO)) WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') THEN convert(numeric(18,2),0.000001*convert(numeric (18,2),DPTDC_LINE_NO)) ELSE 0*convert(numeric (18,2),DPTDC_LINE_NO) 
END END STAMPDUTYCHARGED
,isnull(DPTDC_REASON_CD,'0') DPTDC_REASON_CD
,OS=(SELECT TOP 1 ISNULL ((SELECT ISNULL(AMT,'0') FROM @L_AMT) ,0))
FROM DPTDC_MAK,ISIN_MSTR,DPTDC_OFFPAY_DETAILS WHERE DPTDC_DTLS_ID=@l_dptdc_dtls_id AND DPTDC_DELETED_IND IN (0,4,6,-1,1) AND DPTDC_ISIN=ISIN_CD AND ISIN_DELETED_IND=1
AND DPTDCOD_DTLS_ID=DPTDC_DTLS_ID and DPTDC_ID=DPTDCOD_DPTD_ID
end
END

 IF @PA_ACTION='CDSL_PAY_DETAILS_EDIT'
 BEGIN

insert into DPTDC_OFFPAY_DETAILS
select DPTDC_SLIP_NO
,DPTDC_ID
,DPTDC_DTLS_ID
,@PA_CONSAMT
,@PA_PAYMODE
,@PA_BANKNO
,@PA_BANKNAME
,@PA_BANKBRNAME
,@PA_BUYERNAME
,convert(datetime,@PA_DOI,103)
,@PA_INSTRUMENTNO
,''
,'1' from dptdC_mak where DPTDC_ID=@PA_CD and not exists(select 1 from DPTDC_OFFPAY_DETAILS where DPTDCOD_DPTD_ID=@PA_CD)


UPDATE T SET 
	 DPTDC_PAYMODE=@PA_PAYMODE
	,DPTDC_BANKACNO=@PA_BANKNO
	,DPTDC_BANKACNAME=@PA_BANKNAME
	,DPTDC_BANKBRNAME=@PA_BANKBRNAME
	,DPTDC_TRANSFEREENAME=@PA_BUYERNAME
	,DPTDC_DOI=convert(datetime,@PA_DOI,103)
	,DPTDC_LINE_NO=@PA_CONSAMT
	,DPTDC_CHQ_REFNO=  @PA_INSTRUMENTNO
FROM DPTDC_MAK T 
WHERE DPTDC_ID=@pa_cd 

update T set 
 DPTDCOD_PAYMODE=@PA_PAYMODE
	,DPTDCOD_BANKACNO=@PA_BANKNO
	,DPTDCOD_BANKACNAME=@PA_BANKNAME
	,DPTDCOD_BANKBRNAME=@PA_BANKBRNAME
	,DPTDCOD_TRANSFEREENAME=@PA_BUYERNAME
	,DPTDCOD_DOI=convert(datetime,@PA_DOI,103)
	,DPTDCOD_CONSIDERATION=@PA_CONSAMT
	,DPTDCOD_CHQ_REFNO=  @PA_INSTRUMENTNO
From DPTDC_OFFPAY_DETAILS T
WHERE DPTDCOD_DPTD_ID=@pa_cd 
----need to update this also with personal table

END
                         
IF @PA_ACTION='CDSL_PAY_DETAILS_OFFMKTSALE'
BEGIN
if @PA_ID='0' 
begin
select DISTINCT DPTDC_ISIN [ISIN CODE], DPTDC_LINE_NO CONSIDERATION 
  ,DPTDC_PAYMODE PAYMODE
  ,DPTDC_BANKACNO BANKACNO
  ,DPTDC_BANKACNAME BANKACNAME
  ,DPTDC_BANKBRNAME BANKBRNAME
  ,DPTDC_TRANSFEREENAME TRANSFEREENAME
  ,convert(varchar(10),DPTDC_DOI,103) DOI
  ,DPTDC_CHQ_REFNO [CHEQUE REFNO] 
  ,CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN CITRUS_USR.FN_TOGETTSTM('EQUITY') WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') THEN CITRUS_USR.FN_TOGETTSTM('DEBENTURES') ELSE '0' END STAMPDUTYRATE
  ,CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN 0.015*convert(numeric,DPTDC_LINE_NO) WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') THEN 0.015*convert(numeric,DPTDC_LINE_NO) ELSE 0*DPTDC_LINE_NO END STAMPDUTYCHARGED
  from dptdC_mak,isin_mstr where DPTDC_REQUEST_DT=convert(datetime,@PA_cD,103) and DPTDC_DELETED_IND in (0,-1,4,6,1) and DPTDC_REASON_CD='1'
  and isin_cd=DPTDC_ISIN
end
else
begin
select DISTINCT DPTDC_ISIN [ISIN CODE], DPTDC_LINE_NO CONSIDERATION 
  ,DPTDC_PAYMODE PAYMODE
  ,DPTDC_BANKACNO BANKACNO
  ,DPTDC_BANKACNAME BANKACNAME
  ,DPTDC_BANKBRNAME BANKBRNAME
  ,DPTDC_TRANSFEREENAME TRANSFEREENAME
  ,convert(varchar(10),DPTDC_DOI,103) DOI
  ,DPTDC_CHQ_REFNO [CHEQUE REFNO] 
    ,CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN CITRUS_USR.FN_TOGETTSTM('EQUITY') WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') THEN CITRUS_USR.FN_TOGETTSTM('DEBENTURES') ELSE '0' END STAMPDUTYRATE
  ,CASE WHEN ISIN_SEC_TYPE  in  ('1','15','3','9') THEN 0.015*convert(numeric,DPTDC_LINE_NO) WHEN ISIN_SEC_TYPE  in  ('12','4' ,'19') THEN 0.015*convert(numeric,DPTDC_LINE_NO) ELSE 0*DPTDC_LINE_NO END STAMPDUTYCHARGED

  from dptdc_mak,isin_mstr where DPTDC_DTLS_ID=@PA_ID and DPTDC_DELETED_IND in (0,-1,4,6,1) and DPTDC_REASON_CD='1'
  and isin_cd=DPTDC_ISIN
 end
END                      
--
 END

GO
