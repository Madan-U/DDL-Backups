-- Object: VIEW dbo.Vw_ISIN_Master
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------




CREATE View [dbo].[Vw_ISIN_Master]
as
 select * from dmat.citrus_usr.Vw_ISIN_Master

 ---select * from TBl_ISIN_MASTER_New with(Nolock)

GO
