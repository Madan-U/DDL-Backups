-- Object: PROCEDURE dbo.SPX_POA_DEACTIVATION_FROM_SYNERGY_TO_BO_LIVE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- SELECT TOP 10 * FROM [196.1.115.199].SYNERGY.DBO.TBL_CLIENT_POA            
CREATE proc [dbo].[SPX_POA_DEACTIVATION_FROM_SYNERGY_TO_BO_LIVE]        
@UserId varchar(15)     
AS            
    
    
           
SELECT DISTINCT * INTO #SYNERGY_DATA_FINAL_DEACTIVATION FROM [MIS].KYC.DBO.TBL_POA_DEACTIVATEDCLIENT      
WHERE ISNULL(Process_Flag,'N')='P' AND Process_By=@UserId     
--ISNULL(Process_Flag,'N')='P' and CONVERT(CHAR(15),Insertion_Date,103)=CONVERT(CHAR(15),GETDATE(),103)         
                
    
            
            
--UPDATE B SET DEF=0        
--FROM   #SYNERGY_DATA_FINAL_DEACTIVATION A INNER JOIN [AngelDemat].BSEDB.DBO.MULTICLTID B           
--ON A.PARTY_CODE=B.PARTY_CODE AND A.CLTDPNO=B.CLTDPNO AND             
--B.DPTYPE = 'CDSL' AND B.DPID = '12033200' AND B.DEF=1                    
            
--UPDATE B  SET DEF=0          
--FROM   #SYNERGY_DATA_FINAL_DEACTIVATION A INNER JOIN [AngelDemat].MSAJAG.DBO.MULTICLTID B           
--ON A.PARTY_CODE=B.PARTY_CODE AND A.CLTDPNO=B.CLTDPNO AND             
--B.DPTYPE = 'CDSL' AND B.DPID = '12033200' AND B.DEF=1          
            
UPDATE B SET DEF=0         
FROM   #SYNERGY_DATA_FINAL_DEACTIVATION A INNER JOIN MULTICLTID B             
ON A.PARTY_CODE=B.PARTY_CODE AND A.CLTDPNO=B.CLTDPNO AND             
B.DPTYPE = 'CDSL' AND B.DPID = '12033200' AND B.DEF=1                     
            
            
--UPDATE B SET DEF=0         
--FROM   #SYNERGY_DATA_FINAL_DEACTIVATION A INNER JOIN [AngelBSECM].BSEDB_AB.DBO.MULTICLTID B             
--ON A.PARTY_CODE=B.PARTY_CODE AND A.CLTDPNO=B.CLTDPNO AND             
--B.DPTYPE = 'CDSL' AND B.DPID = '12033200' AND B.DEF=1                   
            
        
--update [MIS].KYC.DBO.TBL_POA_DEACTIVATEDCLIENT  set Process_Flag='C'         
--where PARTY_CODE in (select PARTY_CODE from #SYNERGY_DATA_FINAL_DEACTIVATION)          
        
      
     
           
 --SELECT TOP 1 * FROM [MIS].KYC.DBO.TBL_POA_DEACTIVATEDCLIENT

GO
