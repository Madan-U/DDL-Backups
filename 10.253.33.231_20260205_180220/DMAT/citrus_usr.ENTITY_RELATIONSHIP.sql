-- Object: VIEW citrus_usr.ENTITY_RELATIONSHIP
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


 --ALTER THIS VIEW UNDER SRE-34226


CREATE view [citrus_usr].[ENTITY_RELATIONSHIP]
as 
 
Select * from  AngelDP5.dmat.citrus_usr.ENTITY_RELATIONSHIP with(nolock)
union all
Select * from  AGMUBODPL3.dmat.citrus_usr.ENTITY_RELATIONSHIP with(nolock) 
union all
Select * from  angeldp202.dmat.citrus_usr.ENTITY_RELATIONSHIP with(nolock) 
union all
Select * from  ABVSDP203.dmat.citrus_usr.ENTITY_RELATIONSHIP with(nolock) 
union all
Select * from  ABVSDP204.dmat.citrus_usr.ENTITY_RELATIONSHIP with(nolock)

GO
