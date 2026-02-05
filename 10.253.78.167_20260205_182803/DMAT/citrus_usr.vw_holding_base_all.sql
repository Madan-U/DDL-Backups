-- Object: VIEW citrus_usr.vw_holding_base_all
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create view [citrus_usr].[vw_holding_base_all]
as
select * from DP_DAILY_HLDG_CDSL
union all 
select * from dp_daily_hldg_cdsl_last_base

GO
