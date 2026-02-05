-- Object: VIEW citrus_usr.INWARD_SLIP_REG
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


 --ALTER THIS VIEW UNDER SRE-34226


CREATE View [citrus_usr].[INWARD_SLIP_REG]
AS
Select * from AGMUBODPL3.DMAT.Citrus_usr.INWARD_SLIP_REG with(Nolock)
Union all
Select * from AngelDP5.DMAT.Citrus_usr.INWARD_SLIP_REG with(Nolock)
Union all
Select * from ANGELDP202.DMAT.Citrus_usr.INWARD_SLIP_REG with(Nolock)
 Union all
Select * from ABVSDP203.DMAT.Citrus_usr.INWARD_SLIP_REG with(Nolock)
 Union all
Select * from ABVSDP204.DMAT.Citrus_usr.INWARD_SLIP_REG with(Nolock)

GO
