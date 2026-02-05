-- Object: VIEW citrus_usr.Beneficiary_Type
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[Beneficiary_Type]
as
select distinct subcm_cd , subcm_desc from SUB_CTGRY_MSTR

GO
