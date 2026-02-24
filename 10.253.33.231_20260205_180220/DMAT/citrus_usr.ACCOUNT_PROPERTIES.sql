-- Object: VIEW citrus_usr.ACCOUNT_PROPERTIES
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


 --ALTER THIS VIEW UNDER SRE-34226



CREATE View [citrus_usr].[ACCOUNT_PROPERTIES]
As
Select * from AGMUBODPL3.DMAT.Citrus_usr.ACCOUNT_PROPERTIES With (Nolock)
Union all
Select * from AngelDP5.DMAT.Citrus_usr.ACCOUNT_PROPERTIES With (Nolock)
Union all
Select * from ANGELDP202.DMAT.Citrus_usr.ACCOUNT_PROPERTIES With (Nolock)
Union all
Select * from ABVSDP203.DMAT.Citrus_usr.ACCOUNT_PROPERTIES With (Nolock)
Union all
Select * from ABVSDP204.DMAT.Citrus_usr.ACCOUNT_PROPERTIES With (Nolock)

GO
