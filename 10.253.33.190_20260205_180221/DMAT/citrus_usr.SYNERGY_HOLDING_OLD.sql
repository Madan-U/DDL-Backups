-- Object: VIEW citrus_usr.SYNERGY_HOLDING_OLD
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create view SYNERGY_HOLDING
as
select dphmcd_holding_dt HLD_HOLD_DATE
,	DPAM_SBA_NO   HLD_AC_CODE
,	'' HLD_CAT
,	dphmcd_isin HLD_ISIN_CODE
,	'' HLD_AC_TYPE
,	DPHMCD_CURR_QTY  HLD_AC_POS
,	'' HLD_CCID
,	'' HLD_MARKET_TYPE
,	'' HLD_SETTLEMENT
,	'' HLD_BLF
,	'' HLD_BLC
,	'' HLD_LRD
,	'' HLD_PENDINGDT
from holdingallforview  with(nolock), dp_acct_mstr with(nolock)
where DPAM_ID = DPHMCD_DPAM_ID

GO
