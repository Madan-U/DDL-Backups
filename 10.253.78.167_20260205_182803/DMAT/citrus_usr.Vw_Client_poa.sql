-- Object: VIEW citrus_usr.Vw_Client_poa
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE View Vw_Client_poa
As
Select NISE_PARTY_CODE as Party_COde,Client_COde as DP,
(Case when isnull(POa_ver,'')='' Then 'N' Else 'Y' End) as POA_Status from TBL_CLIENT_MASTER (NOlock)

GO
