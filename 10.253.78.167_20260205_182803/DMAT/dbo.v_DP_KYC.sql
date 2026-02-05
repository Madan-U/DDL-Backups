-- Object: VIEW dbo.v_DP_KYC
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE VIEW [dbo].[v_DP_KYC]  --with schemabinding        
AS          

--SELECT cm_cd,cm_blsavingcd,cm_opendate,
--cm_poaregdate,cm_name        
--FROM  dbo.Client_master 
--WHERE cm_poaforpayin='y' AND len(cm_cd)>=16 

SELECT T.CLIENT_CODE cm_cd,NISE_PARTY_CODE cm_blsavingcd,ACTIVE_DATE cm_opendate,
POA_DATE_FROM cm_poaregdate,FIRST_HOLD_NAME cm_name        
FROM  dbo.TBL_CLIENT_MASTER T
LEFT OUTER JOIN 
TBL_CLIENT_POA P 
ON T.CLIENT_CODE =P.CLIENT_CODE
AND HOLDER_INDI =1  AND MASTER_POA ='2203320000000014'

GO
