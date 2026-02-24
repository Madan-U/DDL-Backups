-- Object: VIEW dbo.Vw_BondData
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------




 --ALTER THIS VIEW UNDER SRE-34226


CREATE view [dbo].[Vw_BondData]
As


Select * from AGMUBODPL3.dMAT.DBO.Vw_BondData
Union all
Select * from AngelDP5.dMAT.DBO.Vw_BondData
Union all
Select * from Angeldp202.dMAT.DBO.Vw_BondData
Union all
Select * from ABVSDP203.dMAT.DBO.Vw_BondData
Union all
Select * from ABVSDP204.dMAT.DBO.Vw_BondData

GO
