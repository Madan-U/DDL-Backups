-- Object: PROCEDURE dbo.SPX_GETPOAUPDATONFROMKYC_REVISEDPROCESS_PartyCodeWise_Mismatch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



--[SPX_GETPOAUPDATONFROMKYC_REVISEDPROCESS_PartyCodeWise_Mismatch] 'E53975'      
      
CREATE PROC [dbo].[SPX_GETPOAUPDATONFROMKYC_REVISEDPROCESS_PartyCodeWise_Mismatch]                      
@UserId varchar(15)             
AS                      
        
SELECT DISTINCT * INTO #SYNERGY_DATA_FINAL FROM [AbVsKycMIS].KYC.DBO.TBL_DP_MISMATCH With(Nolock)          
WHERE ISNULL(Process_Flag,'N')='P' AND Process_By=@UserId          
--and CONVERT(CHAR(15),Insertion_Date,103)=CONVERT(CHAR(15),GETDATE(),103)     
and isnull(NISE_PARTY_CODE,'')<>''           
        
SELECT a.nise_party_code,a.client_code,a.status,a.ACTIVE_DATE INTO #synergywithstatus FROM       
AngelDP4.Dmat.citrus_usr.Tbl_Client_Master a WITH(NOLOCK)
--AGMUBODPL3.Dmat.citrus_usr.Tbl_Client_Master a WITH(NOLOCK)
--[ABCSOORACLEMDLW].Synergy.dbo.Tbl_Client_Master a WITH(NOLOCK)      
INNER JOIN #SYNERGY_DATA_FINAL b ON a.NISE_PARTY_CODE=b.NISE_PARTY_CODE       
WHERE ISNULL(b.NISE_PARTY_CODE,'')<>''      
--AND ISNULL(NSE,'') NOT IN ('NO','N')       
        
      
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
--AND ISNULL(NSE,'') NOT IN ('NO','N')       
      
      
      
        
update a set Short_Name=b.short_name from         
#SYNERGY_DATA_FINAL a inner join         
AngelNSECM.msajag.dbo.client_details b with(nolock)        
on  a.nise_party_code=b.cl_code        
                
--**********************************CODE START FOR CLIENT4 PROCESS **********************------------------------                    
        
        
         
 update #SYNERGY_DATA_FINAL set nsdlflag='y'        
 from client4 a where nise_party_code=Party_code        
 and DefDp='1' and Depository='nsdl'       
 --AND ISNULL(NSE,'') NOT IN ('NO','N')       
         
 update #SYNERGY_DATA_FINAL set NonAngelCDSLFlag='y'        
 from client4 a where nise_party_code=Party_code        
 and DefDp='1' and Depository='CDSL' and isnull(nsdlflag,'')<>'y' and BankID NOT IN ('12033200','12033201','12033202','12033203', '12033204')        
   --AND ISNULL(NSE,'') NOT IN ('NO','N')       
         
 update #SYNERGY_DATA_FINAL set cdslflag='y'        
 from client4 a where nise_party_code=Party_code        
 and DefDp='1' and Depository='CDSL' and isnull(nsdlflag,'')<>'y' AND ISNULL(NonAngelCDSLFlag,'')<>'y'        
 and BankID in ( '12033200', '12033201','12033202','12033203', '12033204')        
  --AND ISNULL(NSE,'') NOT IN ('NO','N')       
      
        
 update #SYNERGY_DATA_FINAL set CDSlStatusFlag='y'        
 from client4 a where nise_party_code=Party_code        
 and DefDp='1' and Depository='CDSL' and isnull(nsdlflag,'')<>'y' AND ISNULL(NonAngelCDSLFlag,'')<>'y'  and BankID in ('12033200', '12033201','12033202','12033203', '12033204')      
  AND cdslflag='y' AND status='Active'       
  --AND ISNULL(NSE,'') NOT IN ('NO','N')       
        
 -- SELECT * FROM #SYNERGY_DATA_FINAL WHERE CDSlStatusFlag='y'      
         
   -- need to delete other than active      
         
 SELECT NISE_PARTY_CODE,CLIENT_CODE,1 defdp,'CDSL' depository,NSE 
 INTO #tempdeleteinsertfinal 
 FROM #SYNERGY_DATA_FINAL,       
 (      
 SELECT NISE_PARTY_CODE mNISE_PARTY_CODE,MAX(DpActiveDate) AS MDpActiveDate FROM #SYNERGY_DATA_FINAL WHERE NISE_PARTY_CODE IN      
(      
SELECT NISE_PARTY_CODE FROM #SYNERGY_DATA_FINAL       
WHERE ISNULL(CDSlStatusFlag,'')<>'y' AND cdslflag='y'       
--AND ISNULL(NSE,'') NOT IN ('NO','N')       
) AND STATUS='Active' AND CDSlStatusFlag='y'       
--AND ISNULL(NSE,'') NOT IN ('NO','N')       
GROUP BY NISE_PARTY_CODE) f      
WHERE f.MDpActiveDate=DpActiveDate AND nise_party_code=f.mnise_party_code AND STATUS='Active' AND CDSlStatusFlag='y'      
--AND ISNULL(NSE,'') NOT IN ('NO','N')       
      
DELETE FROM client4 WHERE depositOry='CDSL' AND BankID in ('12033200', '12033201','12033202','12033203', '12033204') AND Party_code IN      
 (      
SELECT NISE_PARTY_CODE FROM  #tempdeleteinsertfinal       
--WHERE ISNULL(NSE,'') NOT IN ('NO','N')       
)      
      
INSERT INTO CLIENT4(CL_CODE,PARTY_CODE,INSTRU,BANKID,CLTDPID,DEPOSITORY,DEFDP)              
--SELECT DISTINCT NISE_PARTY_CODE,NISE_PARTY_CODE,'0','12033200',CLIENT_CODE,'CDSL','1' FROM #tempdeleteinsertfinal       
SELECT DISTINCT NISE_PARTY_CODE,NISE_PARTY_CODE,'0',LEFT(ISNULL(CLIENT_CODE, ''), 8),CLIENT_CODE,'CDSL','1' FROM #tempdeleteinsertfinal       
--WHERE ISNULL(NSE,'') NOT IN ('NO','N')        
      
                   
      
      
--INSERT INTO CLIENT4(CL_CODE,PARTY_CODE,INSTRU,BANKID,CLTDPID,DEPOSITORY,DEFDP)          
      
--SELECT DISTINCT NISE_PARTY_CODE,NISE_PARTY_CODE,'0','12033200' ,CLIENT_CODE,'CDSL','1'       
      
DELETE FROM dbo.Client4 WHERE Party_code IN       
(       
SELECT DISTINCT NISE_PARTY_CODE         
FROM #SYNERGY_DATA_FINAL WHERE ISNULL(cdslflag,'')='' AND ISNULL(nsdlflag,'')='' AND ISNULL(NonAngelCDSLFlag,'')=''      
AND STATUS='aCTIVE'      
--AND ISNULL(NSE,'N') NOT in ('NO','N')       
      
) AND DEPOSITORY='CDSL' AND BankID in ('12033200', '12033201','12033202','12033203', '12033204') AND DefDp='0'      
      
      
 SELECT NISE_PARTY_CODE,CLIENT_CODE,1 defdp,'CDSL' depository,NSE 
 INTO #tempinsertfinal_New  FROM #SYNERGY_DATA_FINAL, (      
SELECT NISE_PARTY_CODE mNISE_PARTY_CODE,MAX(DpActiveDate) AS MDpActiveDate FROM #SYNERGY_DATA_FINAL WHERE       
ISNULL(cdslflag,'')='' AND ISNULL(nsdlflag,'')='' AND ISNULL(NonAngelCDSLFlag,'')=''      
AND STATUS='Active'      
--AND ISNULL(NSE,'N') NOT in ('NO','N')       
GROUP BY NISE_PARTY_CODE) f      
WHERE f.MDpActiveDate=DpActiveDate AND nise_party_code=f.mnise_party_code and ISNULL(cdslflag,'')='' AND       
ISNULL(nsdlflag,'')='' AND ISNULL(NonAngelCDSLFlag,'')=''      
AND STATUS='Active'      
--AND ISNULL(NSE,'N') NOT in ('NO','N')       
      
INSERT INTO dbo.Client4(Cl_code,Party_code,Instru,BankID,Cltdpid,Depository,DefDp)      
--SELECT DISTINCT NISE_PARTY_CODE,NISE_PARTY_CODE,'0','12033200',client_code,'CDSL','1' FROM #tempinsertfinal_New       
SELECT DISTINCT NISE_PARTY_CODE,NISE_PARTY_CODE,'0',LEFT(ISNULL(client_code, ''), 8),client_code,'CDSL','1' FROM #tempinsertfinal_New             
      
             
                  
             
--**********************************CODE END HERE FOR CLIENT4 PROCESS **********************------------------------                    
                    
---------****************************CODE START FOR INSERT AND UPDATE MULTICLTID TABLE***************************----------------                    
        
                    
 --CODE FOR 197 MSAJAG                    
        
        
ALTER TABLE #SYNERGY_DATA_FINAL ADD MultiFlag VARCHAR(1)      
      
ALTER TABLE #SYNERGY_DATA_FINAL ADD DPEXISTS VARCHAR(1)      
       
          
UPDATE #SYNERGY_DATA_FINAL SET DPEXISTS='Y'                     
FROM dbo.MultiCltId A                      
WHERE #SYNERGY_DATA_FINAL.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE))       
AND #SYNERGY_DATA_FINAL.CLIENT_CODE=LTRIM(RTRIM(CLTDPNO))                    
--AND ISNULL(NSE,'N')='Y'       
AND DPID in ('12033200', '12033201','12033202','12033203', '12033204') AND A.DpType='CDSL'          
          
UPDATE #SYNERGY_DATA_FINAL SET MultiFlag='Y'                     
FROM dbo.MultiCltId A                      
WHERE #SYNERGY_DATA_FINAL.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE))       
AND #SYNERGY_DATA_FINAL.CLIENT_CODE=LTRIM(RTRIM(CLTDPNO))                    
--AND ISNULL(NSE,'N')='Y'       
AND DPID in ('12033200', '12033201','12033202','12033203', '12033204') AND STATUS='Active' AND A.DpType='CDSL'                 
      
UPDATE	MULTICLTID 
SET		DEF='1',
		DDPIFLAG = 'Y'                     
FROM	#SYNERGY_DATA_FINAL A                      
WHERE	A.NISE_PARTY_CODE=LTRIM(RTRIM(PARTY_CODE)) AND CLIENT_CODE=LTRIM(RTRIM(CLTDPNO))                    
--AND ISNULL(NSE,'N')='Y'       
AND DPID in ('12033200', '12033201','12033202','12033203', '12033204') AND DEF='0' AND ISNULL(MultiFlag,'')='Y' AND A.DpType='CDSL'       
      
                    
INSERT INTO  MULTICLTID
(
	PARTY_CODE,CLTDPNO,DPID,INTRODUCER,DPTYPE,DEF,
	DDPIFLAG
)       
              
--SELECT DISTINCT NISE_PARTY_CODE,CLIENT_CODE,'12033200',Short_Name,'CDSL','1'       
SELECT DISTINCT NISE_PARTY_CODE,CLIENT_CODE,LEFT(ISNULL(CLIENT_CODE, ''), 8),Short_Name,'CDSL','1','Y'
FROM #SYNERGY_DATA_FINAL 
WHERE ISNULL(MultiFlag,'')=''       
--AND ISNULL(NSE,'N')='Y'     
AND STATUS='Active' and ISNULL(DPEXISTS,'')=''

GO
