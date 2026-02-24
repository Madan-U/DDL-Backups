-- Object: PROCEDURE dbo.DP_FULL_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

      
      
    ---DP_FULL_DATA_TEST 'V62593'  
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
    
  select distinct * INTO #TEMP from   
(  
--select cm_blsavingcd AS Party_code,''AS CltDpNo,''AS DpId,''AS Introducer,''AS DpType,''AS Def,cm_cd   
---from AGMUBODPL3.dmat.citrus_usr.Synergy_Client_Master with (nolock)   
--where (cm_active ='01' OR cm_active='1') and [cm_blsavingcd] IS NOT NULL  
--UNION ALL   
SELECT [Party_code]        
      ,[CltDpNo]        
      ,[DpId]        
      ,[Introducer]        
      ,[DpType]        
      ,[Def]   
      ,cm_cd =(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END)      
       
  FROM  MultiCltId  WITH(NOLOCK)     WHERE PARTY_CODE >=@FROMPARTY AND PARTY_CODE <=@TOPARTY   
UNION ALL      
SELECT [Party_code]        
      ,[CltDpNo]        
      ,[DpId]        
      ,[Introducer]        
      ,[DpType]        
      ,[Def]      
      ,cm_cd =(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END)        
  FROM [AngelBSECM].BSEDB_AB.dbo.MultiCltId  WITH(NOLOCK) WHERE PARTY_CODE >=@FROMPARTY AND PARTY_CODE <=@TOPARTY   )A      
  WHERE PARTY_CODE >=@FROMPARTY AND PARTY_CODE <=@TOPARTY    
  order by PARTY_cODE,[CltDpNo]  
    
 -- SELECT A.*,cm_blsavingcd FROM #TEMP A   
 --LEFT OUTER JOIN   
 -- AGMUBODPL3.dmat.citrus_usr.Synergy_Client_Master B  
 -- ON A.Party_code<>B.cm_blsavingcd  
 -- AND A.CltDpNo<>B.CM_CD  
   
select   cm_blsavingcd,cm_cd,cm_active INTO #TEMP2 from AGMUBODPL3.dmat.citrus_usr.Synergy_Client_Master  
WHERE  
(cm_active ='01' OR cm_active='1') and [cm_blsavingcd] IS NOT NULL AND  
 cm_blsavingcd NOT IN (SELECT Party_code FROM #TEMP) AND  cm_blsavingcd >=@FROMPARTY AND cm_blsavingcd <=@TOPARTY   
   
   
  
  select distinct *  from   
(  
  
SELECT   
 cm_blsavingcd AS Party_code,''AS CltDpNo,''AS DpId,''AS Introducer,''AS DpType,''AS Def,cm_cd  
 FROM #TEMP2 A  
UNION ALL  
SELECT   
 [Party_code]        
      ,[CltDpNo]        
      ,[DpId]        
      ,[Introducer]        
      ,[DpType]        
      ,[Def]      
      ,cm_cd  
      FROM  
#TEMP B    
  
)P  
   
 ORDER BY PARTY_cODE,[CltDpNo]  
  
  
  
SELECT CONVERT(VARCHAR(11),GETDATE(),120) AS PROCESS_DATE

GO
