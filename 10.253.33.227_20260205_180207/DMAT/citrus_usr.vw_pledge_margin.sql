-- Object: VIEW citrus_usr.vw_pledge_margin
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE view citrus_usr.vw_pledge_margin
as
select CDSHM_BEN_ACCT_NO
,CDSHM_TRATM_DESC
,CDSHM_TRATM_CD
,CDSHM_TRAS_DT
,CDSHM_ISIN
,CDSHM_QTY
,CDSHM_TRANS_NO
,CDSHM_COUNTER_BOID
,CDSHM_COUNTER_DPID
,CDSHM_COUNTER_CMBPID
,CDSHM_EXCM_ID
,CDSHM_TRADE_NO
,citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,12,'~')	[	Original PSN	]
,citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,13,'~')	[	UCC	]
,citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,14,'~')	[	Segment ID	]
,citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,45,'~')	[	EXCHANGE ID	]
,citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,46,'~')	[	CM ID	]
,citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,47,'~')	[	TM ID / CP ID	]
,citrus_usr.FN_SPLITVAL_BY (cdshm_trans_cdas_code,48,'~')	[	ENTITY IDENTIFIER	]
 from cdsl_holding_dtls where CDSHM_CDAS_TRAS_TYPE in ('8','9','10','11')

GO
