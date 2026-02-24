-- Object: VIEW citrus_usr.Beneficiary_Category
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create view [citrus_usr].[Beneficiary_Category]
as
select distinct substring(enttm_cd,1,2) bc_code ,ENTTM_DESC from ENTITY_TYPE_MSTR

GO
