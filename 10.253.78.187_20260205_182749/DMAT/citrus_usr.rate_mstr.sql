-- Object: VIEW citrus_usr.rate_mstr
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[rate_mstr]
as
select clopm_isin_cd rm_isin_code ,CLOPM_DT rm_trx_date ,CLOPM_CDSL_RT rm_rate from closing_price_mstr_cdsl

GO
