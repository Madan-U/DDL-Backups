-- Object: PROCEDURE dbo.SPX_GETPOAUPDATONFROMKYC_REVISEDPROCESS_PartyCodeWise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


    
    
               
--[SPX_GETPOAUPDATONFROMKYC_REVISEDPROCESS_PartyCodeWise]'A13553', '1203320000659175'              
CREATE PROC [dbo].[SPX_GETPOAUPDATONFROMKYC_REVISEDPROCESS_PartyCodeWise] --'E33995'                
@UserId varchar(15)     
AS                
                
    
    
SELECT DISTINCT * INTO #SYNERGY_DATA_FINAL FROM [MIS].KYC.DBO.TBL_NEWDP_POAPROCESS       
WHERE ISNULL(Process_Flag,'N')='P' AND Process_By=@UserId       
and       
nise_party_code in (select Party_code from [MIS].KYC.DBO.TEMP_POADATA      
--WHERE CONVERT(CHAR(15),InsertedDate,103)=CONVERT(CHAR(15),GETDATE(),103)  
  
)      
    
    
    
--**********************************CODE START FOR CLIENT4 PROCESS **********************------------------------                  
  SELECT a.nise_party_code,a.client_code,a.status,a.ACTIVE_DATE INTO #synergywithstatus FROM         

 AGMUBODPL3.DMAT.Citrus_USR.tbl_client_master a WITH(NOLOCK)  
        
INNER JOIN #SYNERGY_DATA_FINAL b ON a.NISE_PARTY_CODE=b.NISE_PARTY_CODE         
AND ISNULL(b.NISE_PARTY_CODE,'')<>''  and PSOURCE='O'    
    
insert into  #synergywithstatus (nise_party_code,client_code,status,ACTIVE_DATE)     
select nise_party_code,client_code,'Active',GETDATE() from #SYNERGY_DATA_FINAL where PSOURCE='T'    
          
        
alter table #SYNERGY_DATA_FINAL add Short_Name varchar(500)          
alter table #SYNERGY_DATA_FINAL add CdslFlag varchar(1)          
alter table #SYNERGY_DATA_FINAL add NSDLFlag varchar(1)          
alter table #SYNERGY_DATA_FINAL add NonAngelCDSLFlag varchar(1)        
alter table #SYNERGY_DATA_FINAL add DpActiveDate DateTime        
        
alter table #SYNERGY_DATA_FINAL add Status varchar(50)         
alter table #SYNERGY_DATA_FINAL add CDSlStatusFlag varchar(2)        
alter table #SYNERGY_DATA_FINAL add CDSlAvailbale varchar(2)          
        
UPDATE #SYNERGY_DATA_FINAL SET STATUS=a.STATUS,DpActiveDate=a.ACTIVE_DATE        
FROM #synergywithstatus a WHERE a.NISE_PARTY_CODE=#SYNERGY_DATA_FINAL.NISE_PARTY_CODE        
AND a.CLIENT_CODE=#SYNERGY_DATA_FINAL.CLIENT_CODE     
--AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
        
        
        
          
update a set Short_Name=b.short_name from           
#SYNERGY_DATA_FINAL a inner join           
AngelNSECM.msajag.dbo.client_details b with(nolock)          
on  a.nise_party_code=b.cl_code          
                  
--**********************************CODE START FOR CLIENT4 PROCESS **********************------------------------                      
          
          
           
 update #SYNERGY_DATA_FINAL set nsdlflag='y'          
 from client4 a where nise_party_code=Party_code          
 and DefDp='1' and Depository='nsdl'     
 --AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
           
 update #SYNERGY_DATA_FINAL set NonAngelCDSLFlag='y'          
 from client4 a where nise_party_code=Party_code          
 and DefDp='1' and Depository='CDSL' and isnull(nsdlflag,'')<>'y' and BankID<>'12033200'          
 --AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
           
 update #SYNERGY_DATA_FINAL set cdslflag='y'          
 from client4 a where nise_party_code=Party_code          
 and DefDp='1' and Depository='CDSL' and isnull(nsdlflag,'')<>'y' AND ISNULL(NonAngelCDSLFlag,'')<>'y'      
 and BankID='12033200'          
 --AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
        
          
 update #SYNERGY_DATA_FINAL set CDSlStatusFlag='y'          
 from client4 a where nise_party_code=Party_code          
 and DefDp='1' and Depository='CDSL' and isnull(nsdlflag,'')<>'y' AND ISNULL(NonAngelCDSLFlag,'')<>'y'      
 and BankID='12033200'        
  AND cdslflag='y' AND status='Active'     
  --AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
          
 -- SELECT * FROM #SYNERGY_DATA_FINAL WHERE CDSlStatusFlag='y'        
           
   -- need to delete other than active        
           
 SELECT NISE_PARTY_CODE,CLIENT_CODE,1 defdp,'CDSL' depository,NSESEG INTO #tempdeleteinsertfinal     
 FROM #SYNERGY_DATA_FINAL,         
 (        
 SELECT NISE_PARTY_CODE mNISE_PARTY_CODE,MAX(DpActiveDate) AS MDpActiveDate FROM #SYNERGY_DATA_FINAL     
 WHERE NISE_PARTY_CODE IN        
(        
SELECT NISE_PARTY_CODE FROM #SYNERGY_DATA_FINAL         
WHERE ISNULL(CDSlStatusFlag,'')<>'y' AND cdslflag='y' --AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
) AND STATUS='Active' AND CDSlStatusFlag='y' --AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
GROUP BY NISE_PARTY_CODE) f        
WHERE f.MDpActiveDate=DpActiveDate AND nise_party_code=f.mnise_party_code AND STATUS='Active' AND CDSlStatusFlag='y'        
--AND ISNULL(NSESEG,'') NOT IN ('NO','N')         
        
DELETE FROM client4 WHERE depositOry='CDSL' AND BankID='12033200' AND Party_code IN        
 (        
SELECT nise_parTY_CODE FROM  #tempdeleteinsertfinal --where ISNULL(NSESEG,'N') NOT in ('NO','N')        
)        
        
INSERT INTO CLIENT4(CL_CODE,PARTY_CODE,INSTRU,BANKID,CLTDPID,DEPOSITORY,DEFDP)            
        
SELECT DISTINCT NISE_PARTY_CODE,NISE_PARTY_CODE,'0','12033200',CLIENT_CODE,'CDSL','1'              
FROM #tempdeleteinsertfinal          
        
                     
      
        
        
        
DELETE FROM dbo.Client4 WHERE Party_code IN         
(         
SELECT DISTINCT NISE_PARTY_CODE           
FROM #SYNERGY_DATA_FINAL WHERE ISNULL(cdslflag,'')='' AND ISNULL(nsdlflag,'')='' AND ISNULL(NonAngelCDSLFlag,'')=''        
AND STATUS='aCTIVE'        
--AND ISNULL(NSESEG,'N') NOT in ('NO','N')         
        
) AND DEPOSITORY='CDSL' AND BankID='12033200' AND DefDp='0'        
        
        
 SELECT NISE_PARTY_CODE,CLIENT_CODE,1 defdp,'CDSL' depository,NSESEG INTO #tempinsertfinal_New      
 FROM #SYNERGY_DATA_FINAL, (        
SELECT NISE_PARTY_CODE mNISE_PARTY_CODE,MAX(DpActiveDate) AS MDpActiveDate FROM #SYNERGY_DATA_FINAL WHERE         
ISNULL(cdslflag,'')='' AND ISNULL(nsdlflag,'')='' AND ISNULL(NonAngelCDSLFlag,'')=''        
AND STATUS='Active'        
--AND ISNULL(NSESEG,'N') NOT in ('NO','N')         
GROUP BY NISE_PARTY_CODE) f        
WHERE f.MDpActiveDate=DpActiveDate AND nise_party_code=f.mnise_party_code and ISNULL(cdslflag,'')='' AND         
ISNULL(nsdlflag,'')='' AND ISNULL(NonAngelCDSLFlag,'')=''        
AND STATUS='Active'        
--AND ISNULL(NSESEG,'N') NOT in ('NO','N')         
        
INSERT INTO dbo.Client4(Cl_code,Party_code,Instru,BankID,Cltdpid,Depository,DefDp)        
SELECT DISTINCT NISE_PARTY_CODE,NISE_PARTY_CODE,'0','12033200',client_code,'CDSL','1' FROM #tempinsertfinal_New         
        
        
               
                    
               
--**********************************CODE END HERE FOR CLIENT4 PROCESS **********************------------------------                      
                      
---------****************************CODE START FOR INSERT AND UPDATE MULTICLTID TABLE***************************----------------                      
          
                      
 --CODE FOR 197 MSAJAG                      
ALTER TABLE #SYNERGY_DATA_FINAL ADD MultiFlag VARCHAR(1)    
    
ALTER TABLE #SYNERGY_DATA_FINAL ADD DPEXISTS VARCHAR(1)    
     
        
UPDATE #SYNERGY_DATA_FINAL SET DPEXISTS='Y'                   
FROM dbo.MultiCltId A                    
WHERE #SYNERGY_DATA_FINAL.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE))     
AND #SYNERGY_DATA_FINAL.CLIENT_CODE=LTRIM(RTRIM(CLTDPNO))                  
--AND ISNULL(NSESEG,'N')='Y'     
AND DPID='12033200' AND DpType='CDSL'        
        
UPDATE #SYNERGY_DATA_FINAL SET MultiFlag='Y'                   
FROM dbo.MultiCltId A                    
WHERE #SYNERGY_DATA_FINAL.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE))     
AND #SYNERGY_DATA_FINAL.CLIENT_CODE=LTRIM(RTRIM(CLTDPNO))                  
--AND ISNULL(NSESEG,'N')='Y'     
AND DPID='12033200' AND STATUS='Active' AND DpType='CDSL'               
      
    
UPDATE MULTICLTID SET DEF='1'                   
FROM #SYNERGY_DATA_FINAL A                    
WHERE A.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE)) AND CLIENT_CODE=LTRIM(RTRIM(CLTDPNO))                  
--AND ISNULL(NSESEG,'N')='Y'     
AND DPID='12033200' AND DEF='0' AND ISNULL(MultiFlag,'')='Y' AND DpType='CDSL' and ISNULL(Operate_Ac,'')='Y'    
    
                  
INSERT INTO  MULTICLTID(PARTY_CODE,CLTDPNO,DPID,INTRODUCER,DPTYPE,DEF)     
            
SELECT DISTINCT NISE_PARTY_CODE,CLIENT_CODE,'12033200',Short_Name,'CDSL',    
CASE WHEN ISNULL(Operate_Ac,'')='Y' THEN '1' ELSE '0' END     
    
FROM #SYNERGY_DATA_FINAL WHERE ISNULL(MultiFlag,'')=''     
--AND ISNULL(NSESEG,'N')='Y'     
AND STATUS='Active' and ISNULL(DPEXISTS,'')=''    
                 
    
    
UPDATE #SYNERGY_DATA_FINAL SET AngelNSECMCLIENT4_Msajag='Y'                   
FROM dbo.Client4 A with(nolock)                   
WHERE #SYNERGY_DATA_FINAL.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE))     
AND DefDp='1'     
    
UPDATE #SYNERGY_DATA_FINAL SET AngelNSECMMULTICLTID_Msajag='Y'                   
FROM dbo.MultiCltId A with(nolock)                    
WHERE #SYNERGY_DATA_FINAL.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE))     
AND #SYNERGY_DATA_FINAL.CLIENT_CODE=LTRIM(RTRIM(CLTDPNO))                  
AND DPID='12033200' AND DpType='CDSL' AND Def='1'       
    
    
    
UPDATE N SET AngelNSECMCLIENT4_Msajag=A.AngelNSECMCLIENT4_Msajag                   
FROM  #SYNERGY_DATA_FINAL A inner join [MIS].KYC.DBO.TBL_NEWDP_POAPROCESS N with(nolock)    
on A.NISE_PARTY_CODE=N.NISE_PARTY_CODE and A.CLIENT_CODE=N.CLIENT_CODE    
    
    
UPDATE N SET AngelNSECMMULTICLTID_Msajag=A.AngelNSECMMULTICLTID_Msajag                   
FROM  #SYNERGY_DATA_FINAL A inner join [MIS].KYC.DBO.TBL_NEWDP_POAPROCESS N with(nolock)    
on A.NISE_PARTY_CODE=N.NISE_PARTY_CODE and A.CLIENT_CODE=N.CLIENT_CODE

GO
