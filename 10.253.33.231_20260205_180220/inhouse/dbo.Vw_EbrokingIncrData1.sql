-- Object: VIEW dbo.Vw_EbrokingIncrData1
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE view [dbo].[Vw_EbrokingIncrData1]    
As     
    
Select * from AGMUBODPL3.inhouse.dbo.Vw_EbrokingIncrData1 With(Nolock)    
union all    
Select * from AngelDP5.inhouse.dbo.Vw_EbrokingIncrData1 With(Nolock)    
union all    
Select * from ANGELDP202.inhouse.dbo.Vw_EbrokingIncrData1 With(Nolock)    
union all    
Select * from ABVSDP203.inhouse.dbo.Vw_EbrokingIncrData1 With(Nolock)   
union all    
Select * from ABVSDP204.inhouse.dbo.Vw_EbrokingIncrData1 With(Nolock)

GO
