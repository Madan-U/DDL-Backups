-- Object: PROCEDURE dbo.DP_Hourly_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
CREATE  Proc [dbo].[DP_Hourly_DATA] (@time Datetime )  
  
as  
  
  
-- EXEC DP_Hourly_DATA '2019-12-11 14:00:00'  
  
IF @time is null or @time =''  
   BEGIN   
       
   set  @time = CONVERT(VARCHAR(11),GETDATE(),120)  
     
   END  
  
  
  
  
  
SELECT * INTO #PARTY FROM (  
SELECT DISTINCT PARTY_CODE FROM client_details_trig WHERE UpdateDate >=@time  
UNION ALL  
SELECT DISTINCT PARTY_CODE FROM client_brok_details_trig  WHERE UpdateDate >=@time  
UNION ALL  
SELECT  DISTINCT PARTY_CODE FROM MULTICLTID_TRIG  WHERE UpdDate >=@time )A   
  
  
SELECT DISTINCT * FROM (  
SELECT [Party_code]    
      ,[CltDpNo]    
      ,[DpId]    
      ,[Introducer]    
      ,[DpType]    
      ,[Def]    
       ,cm_cd =(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END)      
  FROM  MultiCltId  WITH(NOLOCK)   WHERE PARTY_cODE IN (SELECT * FROM #PARTY)  
UNION ALL  
SELECT [Party_code]    
      ,[CltDpNo]    
      ,[DpId]    
      ,[Introducer]    
      ,[DpType]    
      ,[Def]    
       ,cm_cd =(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END)      
  FROM [AngelBSECM].BSEDB_AB.dbo.MultiCltId  WITH(NOLOCK) WHERE PARTY_cODE IN (SELECT * FROM #PARTY) )A  
  WHERE PARTY_CODE >'A0001' AND PARTY_CODE <='ZZZZZZZ'  
  ORDER BY PARTY_CODE ,[CltDpNo]  
  
  
SELECT MAX_DATE =MAX(UpdateDate)  FROM (  
SELECT MAX(UpdateDate) UpdateDate FROM client_details_trig WHERE UpdateDate >=@time  
UNION ALL  
SELECT MAX(UpdateDate) UpdateDate FROM client_brok_details_trig  WHERE UpdateDate >=@time  
UNION ALL  
SELECT  MAX(UpdDate) UpdDate  FROM MULTICLTID_TRIG  WHERE UpdDate >=@time )A

GO
