-- Object: VIEW citrus_usr.Vw_sett_mst
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


CREATE View [citrus_usr].[Vw_sett_mst]

as

select * from ANGELDEMAT.msajag.dbo.Sett_Mst with(nolock) where Start_date ='apr 24 2020'

GO
