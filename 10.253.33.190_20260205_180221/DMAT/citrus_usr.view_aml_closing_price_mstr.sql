-- Object: VIEW citrus_usr.view_aml_closing_price_mstr
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[view_aml_closing_price_mstr]
as
select * from closing_price_mstr_cdsl

GO
