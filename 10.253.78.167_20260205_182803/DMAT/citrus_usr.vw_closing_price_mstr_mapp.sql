-- Object: VIEW citrus_usr.vw_closing_price_mstr_mapp
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[vw_closing_price_mstr_mapp]
as
(
select CLOPM_ISIN_CD
,CLOPM_DT
,CLOPM_CDSL_RT from closing_price_mstr_cdsl
)

GO
