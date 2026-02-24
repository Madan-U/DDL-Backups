-- Object: VIEW citrus_usr.Beneficiary_status
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE view [citrus_usr].[Beneficiary_status]
as
select distinct convert(varchar(2),STAM_CD) bs_code, STAM_DESC from STATUS_MSTR

GO
