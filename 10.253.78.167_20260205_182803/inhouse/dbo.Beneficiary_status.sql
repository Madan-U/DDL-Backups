-- Object: VIEW dbo.Beneficiary_status
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

Create View Beneficiary_status
as
 select bs_code,bs_description=STAM_DESC from dmat.citrus_usr.Beneficiary_status

GO
