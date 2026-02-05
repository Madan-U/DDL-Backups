-- Object: VIEW citrus_usr.SYNERGY_LEDGER_OLD
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



CREATE view [citrus_usr].[SYNERGY_LEDGER_OLD]
as
select 	case when ldg_account_type ='P' then dpam_sba_no else FINA_ACC_CODE end LD_CLIENTCD
,LDG_VOUCHER_DT 	LD_DT
,LDG_AMOUNT 	LD_AMOUNT
,LDG_NARRATION 	LD_PARTICULAR
,LDG_INSTRUMENT_NO 	LD_CHEQUENO
,case when LDG_AMOUNT < 0 then 'D' else 'C' end  	LD_DEBITFLAG
,''	LD_DOCUMENTTYPE
,''	LD_DOCUMENTNO
,''	LD_ENTRYNO
,''	LD_COSTCENTER
,LDG_CREATED_BY 	MKRID
,LDG_LST_UPD_DT 	MKRDT
,YEAR(ldg_voucher_dt)	LD_ACCYEAR
,LEFT(DPAM_SBA_NO,8)	LD_DPID
,''	LD_COMMONDT
,''	LD_COMMON
from LEDGER2 
left outer join  dp_acct_mstr on case when LDG_ACCOUNT_TYPE ='P' then  LDG_ACCOUNT_ID else 0 end = case when LDG_ACCOUNT_TYPE ='P' then  dpam_id else 1 end 
left outer join  FIN_ACCOUNT_MSTR on case when LDG_ACCOUNT_TYPE <>'P' then  LDG_ACCOUNT_ID else 0 end = case when LDG_ACCOUNT_TYPE ='P' then  FINA_ACC_ID else 1 end

GO
