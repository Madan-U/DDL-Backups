-- Object: VIEW dbo.Beneficiary_Category
-- Server: 10.253.33.227 | DB: inhouse
--------------------------------------------------

Create View Beneficiary_Category
as
 select bc_code,bc_description=ENTTM_DESC from dmat.citrus_usr.Beneficiary_Category

GO
