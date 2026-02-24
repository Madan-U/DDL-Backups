-- Object: VIEW dbo.AADHAR_CLIENT_INFO_DP
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



CREATE VIEW [dbo].[AADHAR_CLIENT_INFO_DP]
AS
select PARTYCODE,FIRST_HOLD_NAME,CLIENT_CODE,EMAIL_ADD,AadhaarNo 
from ABVSKYCMIS.Kyc_Ci.dbo.Vi_GetAadhaarRepositoryDetails  s with(nolock),tbl_Client_master t(nolock)
wHERE PARTYCODE=NISE_PARTY_CODE
AND STATUS ='ACTIVE'

GO
