-- Object: VIEW dbo.Beneficiary_Type
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

Create View Beneficiary_Type
as
 select bt_code=subcm_cd,bt_description=subcm_desc from dmat.citrus_usr.Beneficiary_Type

GO
