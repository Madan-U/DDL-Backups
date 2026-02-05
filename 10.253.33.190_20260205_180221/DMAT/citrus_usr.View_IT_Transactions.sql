-- Object: VIEW citrus_usr.View_IT_Transactions
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

Create View [citrus_usr].[View_IT_Transactions]
As
Select CDSHM_DPM_ID,CDSHM_BEN_ACCT_NO,CDSHM_DPAM_ID,CDSHM_TRATM_CD,CDSHM_TRATM_DESC,CDSHM_TRAS_DT,CDSHM_ISIN,CDSHM_QTY,CDSHM_INT_REF_NO,CDSHM_TRANS_NO,CDSHM_SETT_TYPE,CDSHM_SETT_NO,CDSHM_COUNTER_BOID,CDSHM_COUNTER_DPID,CDSHM_COUNTER_CMBPID,CDSHM_EXCM_ID,CDSHM_TRADE_NO,CDSHM_CREATED_BY,CDSHM_CREATED_DT,CDSHM_LST_UPD_BY,CDSHM_LST_UPD_DT,CDSHM_DELETED_IND,cdshm_slip_no,cdshm_tratm_type_desc,cdshm_internal_trastm,CDSHM_BAL_TYPE,cdshm_id,cdshm_opn_bal,cdshm_charge,CDSHM_DP_CHARGE,CDSHM_TRG_SETTM_NO,WAIVE_FLAG
From dmat.citrus_usr.cdsl_holding_dtls 
Where cdshm_tratm_cd in('2246','2277','2201','2205','2220','3102','2252','2270','2280','2262','2251','3202','2202','2212')
And CDSHM_TRAS_DT >= '2011-08-01'
And Left(cdshm_ben_acct_no,6) = '120109'
and 
(
case when cdshm_tratm_cd ='2251' then 
case when right((dmat.citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,1,'~')),1)='D'
then dmat.citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,7,'~')
else  dmat.citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,8,'~')
end else '0' end in ('607','609','0') 
)
and 
(
case when cdshm_tratm_cd ='2212' then 
case when right((citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,1,'~')),1)='D'
then citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,7,'~')
else  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,8,'~')
end else '0' end in ('2204','0')
)
and 
(
case when cdshm_tratm_cd ='2255' then 
case when right((citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,1,'~')),1)='D'
then citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,7,'~')
else  citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,8,'~')
end else '0' end in ('709','0')
)

GO
