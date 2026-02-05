-- Object: VIEW citrus_usr.Vw_sett_mst_BKP_02032023
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


CREATE View [citrus_usr].[Vw_sett_mst_BKP_02032023]

as

select * from [196.1.115.197].msajag.dbo.Sett_Mst with(nolock) where Start_date ='apr 24 2020'

GO
