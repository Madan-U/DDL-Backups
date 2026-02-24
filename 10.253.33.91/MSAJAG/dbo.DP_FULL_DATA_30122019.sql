-- Object: PROCEDURE dbo.DP_FULL_DATA_30122019
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
CREATE Proc [dbo].[DP_FULL_DATA]   (@PARTY_cODE VARCHAR(11))  
as    
  
DECLARE @FROMPARTY VARCHAR(10),@TOPARTY VARCHAR(10)  
  
IF ( @PARTY_cODE ='' OR  @PARTY_CODE IS NULL)  
  BEGIN   
  
 SET @FROMPARTY='A001'   
 SET @TOPARTY='ZZZZZZZZZZ'  
  
 END   
  ELSE   
   BEGIN   
  SET @FROMPARTY=@PARTY_cODE  
 SET @TOPARTY=@PARTY_cODE  
   END   
  
  select distinct * from 
(
--select cm_blsavingcd AS Party_code,''AS CltDpNo,''AS DpId,''AS Introducer,''AS DpType,''AS Def,cm_cd from [172.31.16.94].dmat.citrus_usr.Synergy_Client_Master with (nolock) 
--where (cm_active ='01' OR cm_active='1') and [cm_blsavingcd] IS NOT NULL
--UNION ALL 
SELECT [Party_code]      
      ,[CltDpNo]      
      ,[DpId]      
      ,[Introducer]      
      ,[DpType]      
      ,[Def] 
      ,cm_cd =(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END)    
     
  FROM  MultiCltId  WITH(NOLOCK)      
UNION ALL    
SELECT [Party_code]      
      ,[CltDpNo]      
      ,[DpId]      
      ,[Introducer]      
      ,[DpType]      
      ,[Def]    
      ,cm_cd =(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END)      
  FROM [196.1.115.201].BSEDB_AB.dbo.MultiCltId  WITH(NOLOCK)  )A    
  WHERE PARTY_CODE >=@FROMPARTY AND PARTY_CODE <=@TOPARTY  
  order by PARTY_cODE,[CltDpNo]
  
   
  
SELECT CONVERT(VARCHAR(11),GETDATE(),120) AS PROCESS_DATE

GO
