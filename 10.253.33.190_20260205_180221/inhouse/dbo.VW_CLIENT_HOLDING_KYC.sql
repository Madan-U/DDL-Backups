-- Object: VIEW dbo.VW_CLIENT_HOLDING_KYC
-- Server: 10.253.33.190 | DB: inhouse
--------------------------------------------------

/*
Created By : Paras Sankdecha
Created On : Sep  6 2011
Purpose    : Requested by Aarvind Shenoy - KYC Team (Request given by mail)
*/
CREATE VIEW [dbo].[VW_CLIENT_HOLDING_KYC]
As
SELECT PARTY_CODE = ISNULL(NISE_PARTY_CODE, ''),
CLIENT_DPID = C.CLIENT_CODE, HOLDING_QTY = HLD_AC_POS
FROM TBL_CLIENT_MASTER C WITH (NOLOCK), 
(SELECT HLD_AC_CODE, HLD_AC_POS = SUM(CONVERT(MONEY, ISNULL(HLD_AC_POS, 0))) FROM HOLDING WITH (NOLOCK)
GROUP BY HLD_AC_CODE) H
WHERE C.CLIENT_CODE = H.HLD_AC_CODE

GO
