-- Object: VIEW citrus_usr.dmat_tbl_Sproc_DP_Ledger_q
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE view  [citrus_usr].[dmat_tbl_Sproc_DP_Ledger_q]
as
select dpcode
,convert(varchar(11),CONVERT(datetime, date, 112),103) date
,Particular
,debit
,credit
,balance
,holdingdate from quaterlyledgerdata

GO
