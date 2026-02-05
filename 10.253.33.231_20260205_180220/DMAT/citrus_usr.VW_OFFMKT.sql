-- Object: VIEW citrus_usr.VW_OFFMKT
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------



 --ALTER THIS VIEW UNDER SRE-34226

CREATE View  [citrus_usr].[VW_OFFMKT]
AS
SELECT * FROM AGMUBODPL3.DMAT.Citrus_usr.VW_OFFMKT
union all
SELECT * FROM AGMUBODPL3.DMAT.Citrus_usr.VW_OFFMKT
union all
SELECT * FROM ANGELDP202.DMAT.Citrus_usr.VW_OFFMKT
union all
SELECT * FROM ABVSDP203.DMAT.Citrus_usr.VW_OFFMKT

union all
SELECT * FROM ABVSDP204.DMAT.Citrus_usr.VW_OFFMKT

GO
