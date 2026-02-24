-- Object: VIEW citrus_usr.Narration
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE VIEW [citrus_usr].[Narration]
AS
SELECT TRASTM_CD nr_code
,TRASTM_DESC nr_description
,'' nr_cdsl
FROM TRANSACTION_SUB_TYPE_MSTR
WHERE TRASTM_TRATM_ID = 75

GO
