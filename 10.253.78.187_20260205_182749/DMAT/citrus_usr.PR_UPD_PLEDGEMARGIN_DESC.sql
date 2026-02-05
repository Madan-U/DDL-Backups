-- Object: PROCEDURE citrus_usr.PR_UPD_PLEDGEMARGIN_DESC
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[PR_UPD_PLEDGEMARGIN_DESC]
AS
BEGIN 
--SELECT CDSHM_TRATM_DESC , 
--CASE 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='829' THEN  'MP Setp:' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PSB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='831' THEN 'MP Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='832' THEN 'MP Acpt: '+ ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' DR PSB SG FO EX '+   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='833' THEN 'MP Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PEB SG FO EX '+ ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='837' THEN 'MRP Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR RPB SG FO EX '  + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='838' THEN 'MRP Acpt: '+ ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PEB SG FO EX '  + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--ELSE CDSHM_TRATM_DESC END NEWDESCR
--FROM CDSL_HOLDING_DTLS WHERE CDSHM_CDAS_TRAS_TYPE ='8' AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('829','831','832','833','837','838')
declare @l_last_trx datetime
select @l_last_trx   =  max(CDSHM_TRAS_DT) from cdsl_holding_dtls
UPDATE CDSHM 
SET CDSHM_TRATM_DESC = 
CASE 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='829' THEN  'MP Setp:' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PSB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='831' THEN 'MP Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='832' THEN 'MP Acpt: '+ ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' DR PSB SG FO EX '+   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='833' THEN 'MP Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PEB SG FO EX '+ ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='837' THEN 'MRP Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR RPB SG FO EX '  + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='838' THEN 'MRP Acpt: '+ ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' CTRBO ' + ISNULL(CDSHM_COUNTER_BOID  ,'')+ ' CR PEB SG FO EX '  + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
ELSE CDSHM_TRATM_DESC END 
, CDSHM_Qty = 
CASE 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='829' THEN  ABS(CDSHM_Qty)
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='831' THEN ABS(CDSHM_Qty)
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='832' THEN ABS(CDSHM_Qty)*-1
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='833' THEN ABS(CDSHM_Qty)
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='837' THEN ABS(CDSHM_Qty)
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='838' THEN ABS(CDSHM_Qty)
ELSE CDSHM_Qty END 
FROM CDSL_HOLDING_DTLS CDSHM (NOLOCK) WHERE CDSHM_CDAS_TRAS_TYPE ='8' AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('829','831','832','833','837','838')
AND CDSHM_TRATM_DESC IS NULL 
--added on Dec 14 2020
AND CDSHM_TRAS_DT BETWEEN DATEADD(D,-2,@l_last_trx) AND GETDATE()
 



--SELECT CDSHM_TRATM_DESC , 
--CASE 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='917' THEN  'MRP Unpledge Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' Cntr:0001 DR RPB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='918' THEN 'MRP Unpledge Acpt:  ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + '  Cntr:0001 DR PEB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='924' THEN 'MP Unpledge Acpt:  ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' Cntr:0001 DR PB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='925' THEN 'MP Unpledge Acpt:  ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' Cntr:0001 DR PEB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
--ELSE CDSHM_TRATM_DESC END NEWDESCR
--FROM CDSL_HOLDING_DTLS WHERE CDSHM_CDAS_TRAS_TYPE ='9' AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('917','918','924','925')

UPDATE CDSHM SET CDSHM_TRATM_DESC = 
CASE 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='917' THEN  'MRP Unpledge Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' Cntr:0001 DR RPB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='918' THEN 'MRP Unpledge Acpt:  ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + '  Cntr:0001 DR PEB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='924' THEN 'MP Unpledge Acpt:  ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' Cntr:0001 DR PB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='925' THEN 'MP Unpledge Acpt:  ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' Cntr:0001 DR PEB SG FO EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 
ELSE CDSHM_TRATM_DESC END 
, CDSHM_Qty = 
CASE 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='917' THEN  ABS(CDSHM_Qty)*-1
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='918' THEN ABS(CDSHM_Qty)*-1
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='924' THEN ABS(CDSHM_Qty)*-1
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='925' THEN ABS(CDSHM_Qty)*-1
ELSE CDSHM_Qty END 
FROM CDSL_HOLDING_DTLS CDSHM  (NOLOCK) WHERE CDSHM_CDAS_TRAS_TYPE ='9' AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('917','918','924','925')
AND CDSHM_TRATM_DESC IS NULL 
AND CDSHM_TRAS_DT BETWEEN DATEADD(D,-2,@l_last_trx) AND GETDATE()


UPDATE CDSHM SET CDSHM_TRATM_DESC = 
CASE 
WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='1012' THEN  'MP Unpledge Acpt: ' + ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~'),'') + ' Cntr:0001 DR PB SG AL EX ' +   ISNULL(citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~'),'') 

ELSE CDSHM_TRATM_DESC END 
--, CDSHM_Qty = 
--CASE 
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='917' THEN  ABS(CDSHM_Qty)*-1
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='918' THEN ABS(CDSHM_Qty)*-1
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='924' THEN ABS(CDSHM_Qty)*-1
--WHEN CDSHM_CDAS_SUB_TRAS_TYPE ='925' THEN ABS(CDSHM_Qty)*-1
--ELSE CDSHM_Qty END 
FROM CDSL_HOLDING_DTLS CDSHM  (NOLOCK) WHERE CDSHM_CDAS_TRAS_TYPE ='10' AND CDSHM_CDAS_SUB_TRAS_TYPE IN ('1012')
AND CDSHM_TRATM_DESC IS NULL 

AND CDSHM_TRAS_DT BETWEEN DATEADD(D,-2,@l_last_trx) AND GETDATE()


END

GO
