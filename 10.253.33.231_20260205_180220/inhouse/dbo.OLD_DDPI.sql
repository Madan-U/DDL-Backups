-- Object: VIEW dbo.OLD_DDPI
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

  
CREATE VIEW [dbo].[OLD_DDPI]  
As  
Select   BOID from AGMUBODPL3.DMAT.Citrus_usr.DPS8_PC5  t where MASTERPOAID='2203320000000749' and not exists   
(select boid from AGMUBODPL3.DMAT.Citrus_usr.DPS8_PC5 S where GPABPAFlg ='M' and t.BOId =s.BOId) and GPABPAFlg ='s'   
and HolderNum ='1'  
union all  
Select   BOID from AngelDP5.DMAT.Citrus_usr.DPS8_PC5  t where MASTERPOAID='2203320100000063' and not exists   
(select boid from AngelDP5.DMAT.Citrus_usr.DPS8_PC5 S where GPABPAFlg ='M' and t.BOId =s.BOId) and GPABPAFlg ='s'   
and HolderNum ='1'  
union all  
Select   BOID from Angeldp202.DMAT.Citrus_usr.DPS8_PC5  t where MASTERPOAID='2203320200000021' and not exists   
(select boid from Angeldp202.DMAT.Citrus_usr.DPS8_PC5 S where GPABPAFlg ='M' and t.BOId =s.BOId) and GPABPAFlg ='s'   
and HolderNum ='1'

GO
