-- Object: VIEW citrus_usr.vw_holding_base_all_ARCHTEST
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



create view [citrus_usr].[vw_holding_base_all_ARCHTEST]
as
select * from DP_DAILY_HLDG_CDSL
union all 
select *,NULL from dp_hldg_mstr_cdsl_FORARCH

GO
