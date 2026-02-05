-- Object: VIEW citrus_usr.VW_CLIENTPOA
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

/*

Created By : Siva Kumar

Created On : OCT 31 2015

Purpose    : Requested by Amit Singh - KYC Team (Request given by mail)

*/

CREATE VIEW VW_CLIENTPOA  
AS  

SELECT PARTY_CODE = NISE_PARTY_CODE,   
CLIENT_DPID = C.CLIENT_CODE, POA_STATUS = (CASE WHEN POA_STATUS = 'D' THEN 'N' ELSE 'Y' END), POA_DATE_FROM  
FROM TBL_CLIENT_MASTER C WITH (NOLOCK), TBL_CLIENT_POA P WITH (NOLOCK)  
WHERE C.CLIENT_CODE = P.CLIENT_CODE

GO
