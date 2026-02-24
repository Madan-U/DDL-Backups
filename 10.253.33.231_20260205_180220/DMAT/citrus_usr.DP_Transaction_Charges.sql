-- Object: VIEW citrus_usr.DP_Transaction_Charges
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

 --ALTER THIS VIEW UNDER SRE-34226

CREATE View [citrus_usr].[DP_Transaction_Charges]
As
Select * from AngelDP5.DMAT.Citrus_usr.DP_Transaction_Charges With(Nolock)  
UNION ALL
Select  * from AGMUBODPL3.DMAT.Citrus_usr.DP_Transaction_Charges With(Nolock) 
UNION ALL
Select * from ANGELDP202.DMAT.Citrus_usr.DP_Transaction_Charges With(Nolock) 
UNION ALL
Select * from ABVSDP203.DMAT.Citrus_usr.DP_Transaction_Charges With(Nolock) 
UNION ALL
Select * from ABVSDP204.DMAT.Citrus_usr.DP_Transaction_Charges With(Nolock)

GO
