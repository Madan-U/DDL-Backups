-- Object: VIEW dbo.Vw_DPPOA_status
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

 CREATE View  dbo.Vw_DPPOA_status 
 As  
  
 Select * from AGMUBODPL3.DMAT.dbo.Vw_DPPOA_status  
 Union all  
 Select * from  AngelDP5.DMAT.dbo.Vw_DPPOA_status  
  Union all  
 Select * from Angeldp202.DMAT.dbo.Vw_DPPOA_status

GO
