-- Object: VIEW dbo.TBL_CLIENT_VIEW
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE VIEW TBL_CLIENT_VIEW
AS 
select  CM_CD AS CLIENT_CODE, CM_BLSAVINGCD AS NISE_PARTY_CODE,STATUS =(CASE WHEN  CM_ACTIVE =1 THEN 'ACTIVE' ELSE 'CLOSED' END)
 FROM DMAT.citrus_usr.Synergy_Client_Master  WITH(NOLOCK)

GO
